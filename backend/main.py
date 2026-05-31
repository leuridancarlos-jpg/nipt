import os
import json
import re
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise RuntimeError("GEMINI_API_KEY niet gevonden.")

genai.configure(api_key=GEMINI_API_KEY)

app = FastAPI(title="Nipt Backend", version="1.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])


class AnalyzeRequest(BaseModel):
    subject: str
    leerstof_text: str
    old_test_text: str = ""
    known_already: str = ""

class MustKnowItem(BaseModel):
    titel: str
    status: str

class Question(BaseModel):
    vraag: str
    opties: list[str]
    juist_antwoord: str

class AnalyzeResponse(BaseModel):
    must_know: list[MustKnowItem]
    can_skip: list[str]
    questions: list[Question]


TRIAGE_SYSTEM_PROMPT = """Je bent een studiecoach voor scholieren die ondernemen. Bepaal wat MOET gekend worden en wat niet.
Filosofie: NIPT slagen - minimale inspanning, maximaal resultaat.
Regels:
- Oude toets aanwezig: baseer triage op patroon van die leerkracht.
- Geen oude toets: gebruik algemene vakpatronen.
- Max 7 must_know items.
- Genereer 5 oefenvragen over alleen must_know stof, elk met 4 opties.
Antwoord ALLEEN in dit JSON-formaat:
{"must_know":[{"titel":"...","status":"must_know"}],"can_skip":["..."],"questions":[{"vraag":"...","opties":["A. ...","B. ...","C. ...","D. ..."],"juist_antwoord":"A. ..."}]}"""


@app.get("/health")
def health():
    return {"status": "ok", "service": "Nipt Backend"}


@app.post("/analyze", response_model=AnalyzeResponse)
def analyze(req: AnalyzeRequest):
    if not req.leerstof_text.strip():
        raise HTTPException(status_code=400, detail="leerstof_text mag niet leeg zijn.")
    parts = [f"VAK: {req.subject}", f"LEERSTOF:\n{req.leerstof_text}"]
    if req.old_test_text.strip():
        parts.append(f"OUDE TOETS:\n{req.old_test_text}")
    if req.known_already.strip():
        parts.append(f"AL GEKEND:\n{req.known_already}")
    try:
        model = genai.GenerativeModel(model_name="gemini-2.5-flash", system_instruction=TRIAGE_SYSTEM_PROMPT)
        raw = model.generate_content("\n".join(parts)).text
    except Exception as e:
        raise HTTPException(status_code=502, detail=str(e))
    text = re.sub(r"^```(?:json)?\s*", "", raw.strip())
    text = re.sub(r"\s*```$", "", text)
    try:
        data = json.loads(text)
        return AnalyzeResponse(
            must_know=[MustKnowItem(**i) for i in data.get("must_know", [])],
            can_skip=data.get("can_skip", []),
            questions=[Question(**q) for q in data.get("questions", [])],
        )
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Parse fout: {e}. Raw: {raw[:200]}")
