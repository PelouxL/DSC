
        // ----- Widget météo (Open-Meteo, sans clé API) -----
        const codesMeteo = {
            0:['☀️','Ciel dégagé'], 1:['🌤️','Peu nuageux'], 2:['⛅','Partiellement nuageux'], 3:['☁️','Couvert'],
            45:['🌫️','Brouillard'], 48:['🌫️','Brouillard givrant'],
            51:['🌦️','Bruine légère'], 53:['🌦️','Bruine'], 55:['🌧️','Bruine forte'],
            61:['🌧️','Pluie faible'], 63:['🌧️','Pluie'], 65:['🌧️','Forte pluie'],
            71:['🌨️','Neige faible'], 73:['🌨️','Neige'], 75:['❄️','Forte neige'],
            80:['🌦️','Averses'], 81:['🌧️','Averses'], 82:['⛈️','Fortes averses'],
            95:['⛈️','Orage'], 96:['⛈️','Orage et grêle'], 99:['⛈️','Orage et grêle']
        };
        const icone = c => (codesMeteo[c] || ['🌡️','—']);

    
        let meteoAffichee = false;

        function afficherSecours(raison) {
            if (meteoAffichee) return;
            meteoAffichee = true;
            console.warn('Météo :', raison);
            document.getElementById('meteoActuelle').innerHTML = `
                <div class="flex h-20 w-20 shrink-0 items-center justify-center rounded-full bg-emerald-50 text-5xl">🌊</div>
                <div class="text-slate-600">
                    <p class="font-semibold text-emerald-800">Prévisions momentanément indisponibles</p>
                    <a href="https://meteofrance.com/previsions-meteo-france/boulogne-sur-mer/62200" target="_blank" rel="noopener"
                       class="mt-1 inline-block text-sm font-semibold text-emerald-700 hover:underline">Voir la météo sur Météo-France →</a>
                </div>`;
            document.getElementById('meteoJours').innerHTML = '';
            document.getElementById('majMeteo').textContent = 'hors ligne';
        }

        // Au bout de 6 s on arrête d'afficher « chargement »
        setTimeout(() => afficherSecours('délai dépassé (requête bloquée ou réseau lent)'), 6000);

        const urlMeteo = 'https://api.open-meteo.com/v1/forecast?latitude=50.7264&longitude=1.6147'
            + '&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code'
            + '&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FParis&forecast_days=5';

        fetch(urlMeteo)
            .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
            .then(d => {
                if (meteoAffichee) return;
                meteoAffichee = true;
                const c = d.current, [ic, desc] = icone(c.weather_code);
                document.getElementById('meteoActuelle').innerHTML = `
                    <div class="flex h-20 w-20 shrink-0 items-center justify-center rounded-full bg-emerald-50 text-5xl">${ic}</div>
                    <div>
                        <p class="text-4xl font-extrabold text-emerald-700">${Math.round(c.temperature_2m)}°C</p>
                        <p class="text-slate-600">${desc}</p>
                        <p class="mt-1 text-xs text-slate-500">Ressenti ${Math.round(c.apparent_temperature)}° · Vent ${Math.round(c.wind_speed_10m)} km/h · Humidité ${c.relative_humidity_2m}%</p>
                    </div>`;
                document.getElementById('meteoJours').innerHTML = d.daily.time.map((t, i) => {
                    const jour = i === 0 ? 'Auj.' : new Date(t + 'T12:00').toLocaleDateString('fr-FR', { weekday: 'short' });
                    return `<div class="rounded-2xl bg-emerald-50 py-3">
                        <p class="text-xs font-semibold uppercase text-slate-500">${jour}</p>
                        <p class="my-1 text-2xl">${icone(d.daily.weather_code[i])[0]}</p>
                        <p class="text-sm"><b class="text-slate-800">${Math.round(d.daily.temperature_2m_max[i])}°</b> <span class="text-slate-400">${Math.round(d.daily.temperature_2m_min[i])}°</span></p>
                    </div>`;
                }).join('');
                document.getElementById('majMeteo').textContent = 'mis à jour à ' + new Date().toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
            })
            .catch(err => afficherSecours(err));

        // ----- Historique météo (archives Open-Meteo) -----
        const ANNEES = [2021, 2022, 2023, 2024, 2025];
        const MOIS = ['Janv.', 'Févr.', 'Mars', 'Avr.', 'Mai', 'Juin', 'Juil.', 'Août', 'Sept.', 'Oct.', 'Nov.', 'Déc.'];
        const villes = {
            boulogne: { nom: 'Boulogne-sur-Mer', lat: 50.7264, lon: 1.6147, couleur: '#059669' }, // emerald-600 (couleur du site)
            paris:    { nom: 'Paris',            lat: 48.8566, lon: 2.3522, couleur: '#94a3b8' }  // slate-400 (neutre)
        };

        const urlArchive = v => 'https://archive-api.open-meteo.com/v1/archive'
            + `?latitude=${v.lat}&longitude=${v.lon}`
            + `&start_date=${ANNEES[0]}-01-01&end_date=${ANNEES[ANNEES.length - 1]}-12-31`
            + '&daily=temperature_2m_max&timezone=Europe%2FParis';

        // Transforme les données journalières en { "2023": [12 moyennes mensuelles], ... } + jours > 30 °C
        function analyser(d) {
            const somme = {}, nb = {}, chaleur = {};
            d.daily.time.forEach((date, i) => {
                const t = d.daily.temperature_2m_max[i];
                if (t === null) return;
                const annee = date.slice(0, 4), mois = +date.slice(5, 7) - 1;
                somme[annee] ??= Array(12).fill(0); nb[annee] ??= Array(12).fill(0);
                somme[annee][mois] += t; nb[annee][mois]++;
                chaleur[annee] = (chaleur[annee] || 0) + (t > 30 ? 1 : 0);
            });
            const parAnnee = {};
            for (const a in somme) parAnnee[a] = somme[a].map((s, m) => nb[a][m] ? s / nb[a][m] : null);
            parAnnee.moyenne = MOIS.map((_, m) => {
                const vals = ANNEES.map(a => parAnnee[a]?.[m]).filter(v => v != null);
                return vals.length ? vals.reduce((x, y) => x + y, 0) / vals.length : null;
            });
            return { parAnnee, chaleur };
        }

        let graphique, donnees = {};

        function dessiner(choix) {
            const series = Object.entries(villes).map(([cle, v]) => ({
                label: v.nom,
                data: donnees[cle].parAnnee[choix].map(x => x == null ? null : Math.round(x * 10) / 10),
                borderColor: v.couleur, backgroundColor: v.couleur,
                borderWidth: 3, tension: 0.35, pointRadius: 3
            }));
            if (graphique) { graphique.data.datasets = series; return graphique.update(); }
            graphique = new Chart(document.getElementById('histoGraph'), {
                type: 'line',
                data: { labels: MOIS, datasets: series },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: { tooltip: { callbacks: { label: c => `${c.dataset.label} : ${c.parsed.y} °C` } } },
                    scales: { y: { title: { display: true, text: '°C' }, grid: { color: '#e2e8f0' } }, x: { grid: { display: false } } }
                }
            });
        }

        function afficherChaleur() {
            document.getElementById('histoChaleur').innerHTML = ANNEES.map(a => `
                <div class="rounded-2xl bg-emerald-50 p-3">
                    <p class="font-semibold text-slate-500">${a}</p>
                    <p class="mt-1"><span class="font-bold" style="color:${villes.boulogne.couleur}">${donnees.boulogne.chaleur[a] ?? 0} j</span> à Boulogne</p>
                    <p><span class="font-bold text-slate-500">${donnees.paris.chaleur[a] ?? 0} j</span> à Paris</p>
                </div>`).join('');
        }

        const selectAnnee = document.getElementById('histoAnnee');
        ANNEES.forEach(a => selectAnnee.insertAdjacentHTML('beforeend', `<option value="${a}">${a}</option>`));
        selectAnnee.addEventListener('change', () => dessiner(selectAnnee.value));

        Promise.all(Object.entries(villes).map(([cle, v]) =>
            fetch(urlArchive(v))
                .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
                .then(d => { donnees[cle] = analyser(d); })
        ))
            .then(() => {
                if (typeof Chart === 'undefined') throw new Error('Chart.js non chargé');
                dessiner('moyenne');
                afficherChaleur();
                document.getElementById('histoStatut').textContent = `${ANNEES[0]}–${ANNEES[ANNEES.length - 1]}, source Open-Meteo`;
            })
            .catch(err => {
                console.warn('Historique :', err);
                document.getElementById('histoStatut').textContent = 'données indisponibles (connexion requise)';
            });
  