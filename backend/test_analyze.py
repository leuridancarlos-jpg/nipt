"""
Snel testscript voor de /analyze endpoint.
Gebruik: python test_analyze.py
Zorg dat de backend draait op http://localhost:8000
"""
import json
import urllib.request
import urllib.error

URL = "http://localhost:8000/analyze"

payload = {
    "subject": "Economie",
    "leerstof_text": (
        "Hoofdstuk 3: Vraag en aanbod\n"
        "- Wet van vraag: als prijs stijgt, daalt de gevraagde hoeveelheid (ceteris paribus).\n"
        "- Wet van aanbod: als prijs stijgt, stijgt de aangeboden hoeveelheid.\n"
        "- Evenwichtsprijs: de prijs waarbij vraag = aanbod.\n"
        "- Verschuivingen van de vraagcurve: inkomen, smaak, prijzen verwante goederen.\n"
        "- Complementaire goederen: goederen die samen gebruikt worden (auto + benzine).\n"
        "- Substitutiegoederen: goederen die elkaar vervangen (boter vs margarine).\n"
        "- Prijselasticiteit van de vraag: % verandering hoeveelheid / % verandering prijs.\n"
        "- Elastisch: |e| > 1. Inelastisch: |e| < 1.\n"
        "- Consumentensurplus: het verschil tussen de betalingsbereidheid en de werkelijke prijs.\n"
        "- Producentensurplus: het verschil tussen de verkoopprijs en de minimumprijs van de producent.\n"
        "- Overheidsinterventie: maximumprijs, minimumprijs, subsidies, belastingen.\n"
        "- Deadweight loss: welvaartsverlies door marktverstoringen.\n"
    ),
    "old_test_text": (
        "Vraag 1: Wat is de wet van vraag? (4 punten)\n"
        "Vraag 2: Bereken de prijselasticiteit als de prijs stijgt van €10 naar €12 "
        "en de hoeveelheid daalt van 100 naar 80. (6 punten)\n"
        "Vraag 3: Geef een voorbeeld van complementaire goederen. (2 punten)\n"
        "Vraag 4: Wat is consumentensurplus? (4 punten)\n"
    ),
    "known_already": "Ik ken de wet van vraag en aanbod al goed.",
}

data = json.dumps(payload).encode("utf-8")
req = urllib.request.Request(URL, data=data, headers={"Content-Type": "application/json"})

try:
    with urllib.request.urlopen(req, timeout=60) as resp:
        result = json.loads(resp.read())

    print("✅ /analyze werkt!\n")
    print("=== MOET KENNEN ===")
    for item in result["must_know"]:
        print(f"  • {item['titel']}")

    print("\n=== KAN JE LATEN LIGGEN ===")
    for item in result["can_skip"]:
        print(f"  ✗ {item}")

    print("\n=== OEFENVRAGEN ===")
    for i, q in enumerate(result["questions"], 1):
        print(f"\nVraag {i}: {q['vraag']}")
        for opt in q["opties"]:
            print(f"  {opt}")
        print(f"  → Juist: {q['juist_antwoord']}")

except urllib.error.URLError as e:
    print(f"❌ Kan backend niet bereiken: {e}")
    print("   Zorg dat de backend draait: uvicorn main:app --reload")
except Exception as e:
    print(f"❌ Fout: {e}")
