# Nipt — Minimale studie-app voor jonge ondernemers

> Doe het minimum om te slagen. Ga terug naar je business.

---

## Projectstructuur

```
nipt/
├── backend/          ← Python FastAPI + Gemini AI
│   ├── main.py
│   ├── requirements.txt
│   ├── .env.example
│   └── test_analyze.py
└── app/              ← Flutter (Android/iOS)
    └── (Fase 2)
```

---

## Fase 1 — Backend starten

### Vereisten
- Python 3.11+
- Een Google Gemini API-sleutel (gratis via https://aistudio.google.com)

### Stap 1 — Installeer dependencies

```bash
cd backend
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Stap 2 — Maak je .env bestand

```bash
cp .env.example .env
# Open .env en vul je GEMINI_API_KEY in
```

### Stap 3 — Start de backend

```bash
uvicorn main:app --reload
```

De backend draait nu op `http://localhost:8000`.

### Stap 4 — Test of alles werkt

**Optie A — Health check (browser of curl):**
```bash
curl http://localhost:8000/health
# Verwacht: {"status":"ok","service":"Nipt Backend"}
```

**Optie B — Volledige AI-test:**
```bash
python test_analyze.py
```

Dit stuurt een echt verzoek naar Gemini en toont:
- Wat je MOET kennen
- Wat je kan laten liggen
- 5 oefenvragen

**Optie C — Interactieve API-docs:**
Open `http://localhost:8000/docs` in je browser — FastAPI genereert automatisch een testinterface.

---

## API

### `GET /health`
Geeft `{"status": "ok"}` terug. Gebruik dit om te checken of de server draait.

### `POST /analyze`

**Request body:**
```json
{
  "subject": "Economie",
  "leerstof_text": "...",
  "old_test_text": "",
  "known_already": ""
}
```

**Response:**
```json
{
  "must_know": [
    {"titel": "Wet van vraag en aanbod", "status": "must_know"}
  ],
  "can_skip": ["Deadweight loss", "Producentensurplus"],
  "questions": [
    {
      "vraag": "Wat is de evenwichtsprijs?",
      "opties": ["A. ...", "B. ...", "C. ...", "D. ..."],
      "juist_antwoord": "A. ..."
    }
  ]
}
```
