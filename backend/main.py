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
    raise RuntimeError("GEMINI_API_KEY niet gevonden. Maak een .env bestand aan op basis van .env.example.")

genai.configure(api_key=GEMINI_API_KEY)

app = FastAPI(title="Nipt Backend", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Models ---

class AnalyzeRequest(BaseModel):
    subject: str
    leerstof_text: str
    old_test_text: str = ""
    known_already: str = ""

class MustKnowItem(BaseModel):
    titel: str
    status: str  # "must_know"

class Question(BaseModel):
    vraag: str
    opties: list[str]
    juist_antwoord: str

class AnalyzeResponse(BaseModel):
    must_know: list[MustKnowItem]
    can_skip: list[str]
    questions: list[Question]


# --- Prompts ---

TRIAGE_SYSTEM_PROMPT = """Je bent een slimme studiecoach voor middelbare scholieren die ook ondernemen.
Je taak: analyseer de leerstof en bepaal wat echt MOET geweten worden voor de toets,
en wat NIET de moeite waard is om te studeren.

Filosofie: de leerling wil NIPT slagen — minimale inspanning, maximaal resultaat.
Geen perfectie, geen hoge punten. Gewoon slagen.

Regels:
- Als er een oude toets beschikbaar is: baseer je triage STRIKT op het patroon van die leerkracht.
  Wat vroeg hij vorig jaar? Dat zijn de prioriteiten nu.
- Als er geen oude toets is: gebruik algemene vakpatronen (definities, hoofdconcepten, formules die altijd terugkomen).
- Wat de leerling al kent: markeer als lager prioriteit (maar bevestig het kort).
- Geef MAXIMAAL 7 "moet kennen"-items. Wees meedogenloos in wat je weggooijt.
- "Kan je laten liggen": alles wat randinformatie is, zelden gevraagd wordt, of te diep gaat.

Genereer ook 5 oefenvragen over ALLEEN de "moet kennen"-stof.
Elke vraag heeft 4 opties (A, B, C, D) en één juist antwoord.

Antwoord ALTIJD in dit exacte JSON-formaat (geen markdown, geen uitleg erbuiten):
{
  "must_know": [
    {"titel": "...", "status": "must_know"}
  ],
  "can_skip": ["...", "..."],
  "questions": [
    {
      "vraag": "...",
      "opties": ["A. ...", "B. ...", "C. ...", "D. ..."],
      "juist_antwoord": "A. ..."
    }
  ]
}"""


def build_triage_prompt(req: AnalyzeRequest) -> str:
    parts = [f"VAK: {req.subject}", f"\nLEERSTOF:\n{req.leerstof_text}"]
    if req.old_test_text.strip():
        parts.append(f"\nOUDE TOETS VAN DEZE LEERKRACHT:\n{req.old_test_text}")
    else:
        parts.append("\nOUDE TOETS: niet beschikbaar — gebruik algemene vakpatronen.")
    if req.known_already.strip():
        parts.append(f"\nWAT DE LEERLING AL KENT:\n{req.known_already}")
    return "\n".join(parts)


def extract_json(text: str) -> dict:
    """Haal JSON uit de Gemini-respons, ook als er markdown omheen zit."""
    text = text.strip()
    # Verwijder ```json ... ``` blokken
    text = re.sub(r"^```(?:json)?\s*", "", text)
    text = re.sub(r"\s*```$", "", text)
    return json.loads(text)


# --- Endpoints ---

@app.get("/health")
def health():
    return {"status": "ok", "service": "Nipt Backend"}


@app.post("/analyze", response_model=AnalyzeResponse)
def analyze(req: AnalyzeRequest):
    if not req.leerstof_text.strip():
        raise HTTPException(status_code=400, detail="leerstof_text mag niet leeg zijn.")

    # Stap 1: triage met gemini-2.5-flash (slimmere model voor de kern-beslissing)
    triage_model = genai.GenerativeModel(
        model_name="gemini-2.5-flash",
        system_instruction=TRIAGE_SYSTEM_PROMPT,
    )

    prompt = build_triage_prompt(req)

    try:
        response = triage_model.generate_content(prompt)
        raw = response.text
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gemini API fout: {str(e)}")

    try:
        data = extract_json(raw)
    except (json.JSONDecodeError, ValueError) as e:
        raise HTTPException(
            status_code=502,
            detail=f"Kon Gemini-respons niet parsen. Raw: {raw[:300]}",
        )

    # Valideer en zet om naar response-model
    try:
        result = AnalyzeResponse(
            must_know=[MustKnowItem(**item) for item in data.get("must_know", [])],
            can_skip=data.get("can_skip", []),
            questions=[Question(**q) for q in data.get("questions", [])],
        )
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Ongeldige structuur van Gemini: {str(e)}")

    return result
