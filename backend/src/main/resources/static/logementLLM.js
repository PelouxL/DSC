 document.getElementById("monForm").addEventListener('submit', async function(event) {
            event.preventDefault(); 
            
            const textData = document.getElementById('zoneText').value;
            const divResultat = document.getElementById('resultat');

            divResultat.style.display = "block";
            divResultat.textContent = "Traitement en cours...";

            try {
                const response = await fetch('http://127.0.0.1:5000/traitement', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ texte: textData }) 
                });

                const data = await response.json();
                
                if(data.erreur) {
                    divResultat.textContent = "Erreur : " + data.erreur;
                } else {
                    divResultat.textContent = data.resultat; 
                }
                
            } catch (error) {
                divResultat.textContent = "Erreur de communication avec Python : Vérifiez que app.py est bien lancé.";
                console.error(error);
            }
        });