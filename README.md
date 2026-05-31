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
