from flask import Flask, request, jsonify
from flask_cors import CORS
from curl_cffi import requests

app = Flask(__name__)
CORS(app)

@app.route('/traitement', methods=['POST'])
def traitement():
    donnees = request.json
    texte_logement = donnees.get('texte', '')

    api_key = "97410d75-fbfc-4ba8-a805-368fc0489a33"
    base_url = "https://llm.ilaas.fr/v1"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "User-Agent": "Application-Logement-Local/1.0"
    }

    try:
        response = requests.get(f"{base_url}/models", headers=headers, impersonate="chrome", timeout=10)
        models = response.json()
        model_name = models['data'][0]['id']

        payload = {
            "model": model_name,
            "messages": [
                {
                    "role": "system", 
                    "content": "Analyse le texte et renvoie uniquement un JSON au format: {'chambres': int, 'climatisation': bool, 'piscine': bool, 'garage':bool, 'surface': int}. Ignore les informations inutiles."
                },
                {
                    "role": "user", 
                    "content": texte_logement
                }
            ],
            "stream": False,
            "max_tokens": 150
        }

        print("--- ÉTAPE 2 : Envoi du texte à l'IA ---", flush=True)
        response = requests.post(f"{base_url}/chat/completions", headers=headers, json=payload)
        result = response.json()

        reponse_ia = result['choices'][0]['message']['content']
        print(f"--- ÉTAPE 3 : Succès ! Réponse : {reponse_ia} ---", flush=True)
        return jsonify({"resultat": reponse_ia})

    except Exception as e:
        return jsonify({"erreur": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)