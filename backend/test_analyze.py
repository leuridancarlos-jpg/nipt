import json, urllib.request, urllib.error
URL = "http://localhost:8000/analyze"
payload = {"subject": "Economie", "leerstof_text": "Wet van vraag en aanbod. Evenwichtsprijs. Prijselasticiteit. Consumentensurplus.", "old_test_text": "", "known_already": ""}
data = json.dumps(payload).encode()
req = urllib.request.Request(URL, data=data, headers={"Content-Type": "application/json"})
try:
    with urllib.request.urlopen(req, timeout=60) as r:
        result = json.loads(r.read())
    print("MOET KENNEN:", [i['titel'] for i in result['must_know']])
    print("KAN LIGGEN:", result['can_skip'])
    print("VRAGEN:", len(result['questions']))
except Exception as e:
    print("FOUT:", e)
