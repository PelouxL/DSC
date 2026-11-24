CREATE TABLE adresse (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    voie VARCHAR(255) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    ville VARCHAR(255) NOT NULL
);

CREATE TABLE secteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE adherent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    adresse_id INT NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(255) NOT NULL,
    note DECIMAL(3,1) CHECK (note >= 0 AND note <= 5),
    FOREIGN KEY (adresse_id) REFERENCES adresse(id)
);

-- ATTENTION PAS DE DESCRIPTION
CREATE TABLE logement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    proprietaire_id INT NOT NULL,
    adresse_id INT NOT NULL,
    secteur_id INT NOT NULL,
    nom VARCHAR(255),
    type VARCHAR(100),
    montant_par_nuit INT,

    -- Capacité et surfaces
    nb_lits_simples INT,
    nb_lits_doubles INT,
    nb_etages INT,
    surface_habitable INT,
    surface_totale INT,
    
    -- Piscine (aplatissement du tuple prefixItems [boolean, boolean, enum, enum])
    piscine_presence BOOLEAN,
    piscine_couverte BOOLEAN,
    piscine_type ENUM('creusee', 'semi-enteree', 'gonflable'),
    piscine_nettoyage ENUM('chlore', 'brome', 'sel'),
    
    -- Équipements et confort
    climatisation ENUM('fixe', 'mobile'),
    chauffage ENUM('electrique', 'gaz', 'fioul', 'pompe a chaleur', 'bois', 'collectif', 'geothermie'),
    salle_de_bain_et_wc_separes BOOLEAN,
    television BOOLEAN,
    wifi BOOLEAN,
    
    -- Garage (aplatissement du tuple prefixItems [boolean, integer])
    garage_presence BOOLEAN,
    garage_hauteur INT,
    
    -- Extérieur et accès
    distance_route INT,
    balcon BOOLEAN,
    exposition VARCHAR(255),
    animaux_autorises BOOLEAN,
    amenagement_personne_a_mobilite_reduite BOOLEAN,

    -- Clés étrangères
    FOREIGN KEY (proprietaire_id) REFERENCES adherent(id),
    FOREIGN KEY (adresse_id) REFERENCES adresse(id),
    FOREIGN KEY (secteur_id) REFERENCES secteur(id)
);

CREATE TABLE activite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_secteur INT NOT NULL,
    id_adresse INT NOT NULL,
    nom VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    telephone VARCHAR(20) UNIQUE,
    horaires VARCHAR(255),
    FOREIGN KEY (id_secteur) REFERENCES secteur(id),
    FOREIGN KEY (id_adresse) REFERENCES adresse(id)
);

CREATE TABLE sport (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES activite(id)
);

CREATE TABLE parc (
    id INT PRIMARY KEY,
    parc_enfant BOOLEAN DEFAULT FALSE,
    dispositif_sportif BOOLEAN DEFAULT FALSE,
    animaux_autorises BOOLEAN DEFAULT FALSE,
    point_d_eau BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id) REFERENCES activite(id)
);

CREATE TABLE magasin (
    id INT PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    FOREIGN KEY (id) REFERENCES activite(id)
);

CREATE TABLE evenement (
    id INT PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    prix INT NOT NULL CHECK (prix >= 0),
    CHECK (date_fin >= date_debut),
    FOREIGN KEY (id) REFERENCES activite(id)
);

-- 1. Tables indépendantes
INSERT INTO adresse (id, numero, voie, code_postal, ville) VALUES
(1, 10, 'Rue de la Plage', '83000', 'Borgnes-sur-Mer'),
(2, 25, 'Avenue des Mouettes', '83000', 'Borgnes-sur-Mer'),
(3, 5, 'Boulevard de la Mer', '83000', 'Borgnes-sur-Mer'),
(4, 12, 'Place du Vieux Port', '83000', 'Borgnes-sur-Mer'),
(5, 8, 'Chemin du Phare', '83000', 'Borgnes-sur-Mer');

INSERT INTO secteur (id, nom) VALUES
(1, 'Le Port'),
(2, 'Centre-Bourg'),
(3, 'Front de mer');

-- 2. Adhérents
INSERT INTO adherent (id, adresse_id, prenom, nom, telephone, email, mdp, note) VALUES
(1, 1, 'Jean', 'Dupont', '0601020304', 'jean.dupont@exemple.fr', 'mdp_hash_1', 4.5),
(2, 2, 'Marie', 'Curie', '0605060708', 'marie.curie@exemple.fr', 'mdp_hash_2', 4.8),
(3, 3, 'Paul', 'Martin', '0609101112', 'paul.martin@exemple.fr', 'mdp_hash_3', 3.9),
(4, 4, 'Sophie', 'Durand', '0613141516', 'sophie.durand@exemple.fr', 'mdp_hash_4', 5.0);

-- 3. Logements (30 ajoutés)
INSERT INTO logement (
    proprietaire_id, adresse_id, secteur_id, nom, type, montant_par_nuit,
    nb_lits_simples, nb_lits_doubles, nb_etages, surface_habitable, surface_totale,
    piscine_presence, piscine_couverte, piscine_type, piscine_nettoyage,
    climatisation, chauffage, salle_de_bain_et_wc_separes, television, wifi,
    garage_presence, garage_hauteur, distance_route, balcon, exposition,
    animaux_autorises, amenagement_personne_a_mobilite_reduite
) VALUES
(1, 1, 1, 'Appartement du Port', 'Appartement', 85, 0, 1, 1, 45, 50, FALSE, NULL, NULL, NULL, 'fixe', 'electrique', TRUE, TRUE, TRUE, FALSE, NULL, 15, TRUE, 'Sud', FALSE, TRUE),
(2, 2, 2, 'Maison des Mouettes', 'Maison', 150, 2, 2, 2, 110, 350, FALSE, NULL, NULL, NULL, 'mobile', 'gaz', TRUE, TRUE, TRUE, TRUE, 210, 30, FALSE, 'Sud-Ouest', TRUE, FALSE),
(3, 3, 3, 'Villa Mer Azur', 'Maison', 320, 2, 3, 2, 180, 800, TRUE, FALSE, 'creusee', 'sel', 'fixe', 'pompe a chaleur', TRUE, TRUE, TRUE, TRUE, 240, 50, TRUE, 'Sud, Ouest', TRUE, TRUE),
(4, 4, 1, 'Studio Centre Historique', 'Appartement', 60, 0, 1, 1, 28, 28, FALSE, NULL, NULL, NULL, NULL, 'electrique', FALSE, TRUE, TRUE, FALSE, NULL, 5, FALSE, 'Est', FALSE, FALSE),
(1, 2, 2, 'Pavillon des Pins', 'Maison', 190, 3, 2, 1, 125, 500, TRUE, TRUE, 'creusee', 'chlore', 'fixe', 'geothermie', TRUE, TRUE, TRUE, TRUE, 220, 40, FALSE, 'Sud-Est', TRUE, TRUE),
(2, 3, 3, 'Loft Industriel', 'Appartement', 130, 1, 2, 2, 95, 105, FALSE, NULL, NULL, NULL, 'fixe', 'collectif', TRUE, TRUE, TRUE, TRUE, 200, 10, TRUE, 'Ouest', FALSE, FALSE),
(3, 4, 1, 'Chalet du Lac', 'Maison', 210, 4, 2, 2, 135, 600, FALSE, NULL, NULL, NULL, NULL, 'bois', TRUE, TRUE, FALSE, TRUE, 250, 100, TRUE, 'Sud', TRUE, FALSE),
(4, 1, 2, 'Résidence Les Oliviers', 'Appartement', 95, 2, 1, 1, 65, 72, TRUE, FALSE, 'creusee', 'brome', 'mobile', 'electrique', TRUE, TRUE, TRUE, FALSE, NULL, 25, TRUE, 'Sud, Est', FALSE, TRUE),
(1, 3, 3, 'Maison de Campagne', 'Maison', 140, 2, 2, 2, 115, 1200, TRUE, FALSE, 'semi-enteree', 'chlore', NULL, 'fioul', FALSE, TRUE, TRUE, TRUE, 230, 80, FALSE, 'Nord-Est, Sud-Ouest', TRUE, FALSE),
(2, 4, 1, 'Duplex Vue Panoramique', 'Appartement', 175, 1, 2, 2, 105, 120, FALSE, NULL, NULL, NULL, 'fixe', 'pompe a chaleur', TRUE, TRUE, TRUE, TRUE, 210, 20, TRUE, 'Sud-Ouest', FALSE, FALSE),
(3, 1, 2, 'Bungalow Les Flots', 'Maison', 110, 2, 1, 1, 55, 200, TRUE, FALSE, 'gonflable', 'chlore', 'mobile', 'electrique', FALSE, FALSE, TRUE, FALSE, NULL, 35, FALSE, 'Ouest', TRUE, TRUE),
(4, 2, 3, 'Hôtel Particulier', 'Maison', 450, 4, 4, 3, 280, 950, TRUE, TRUE, 'creusee', 'sel', 'fixe', 'gaz', TRUE, TRUE, TRUE, TRUE, 260, 15, TRUE, 'Nord, Sud, Est, Ouest', TRUE, TRUE),
(1, 4, 1, 'T2 Cosy Gare', 'Appartement', 70, 0, 1, 1, 40, 43, FALSE, NULL, NULL, NULL, NULL, 'collectif', FALSE, TRUE, TRUE, FALSE, NULL, 8, TRUE, 'Nord-Ouest', FALSE, FALSE),
(2, 1, 2, 'Villa Soleil Levant', 'Maison', 280, 2, 3, 2, 160, 700, TRUE, FALSE, 'creusee', 'brome', 'fixe', 'pompe a chaleur', TRUE, TRUE, TRUE, TRUE, 235, 60, TRUE, 'Est, Sud', FALSE, TRUE),
(3, 2, 3, 'Appartement Familial Parc', 'Appartement', 120, 3, 1, 1, 88, 95, FALSE, NULL, NULL, NULL, 'mobile', 'gaz', TRUE, TRUE, TRUE, TRUE, 195, 30, TRUE, 'Sud', TRUE, TRUE),
(4, 3, 1, 'Longère Rénovée', 'Maison', 230, 4, 3, 2, 195, 1500, TRUE, TRUE, 'semi-enteree', 'sel', NULL, 'bois', TRUE, TRUE, TRUE, TRUE, 270, 150, FALSE, 'Sud-Est', TRUE, FALSE),
(1, 1, 3, 'Penthouse Terrasse', 'Appartement', 310, 1, 2, 1, 130, 180, FALSE, NULL, NULL, NULL, 'fixe', 'pompe a chaleur', TRUE, TRUE, TRUE, TRUE, 215, 25, TRUE, 'Sud, Ouest', FALSE, TRUE),
(2, 2, 1, 'Petite Maison de Pêcheur', 'Maison', 90, 1, 1, 2, 50, 65, FALSE, NULL, NULL, NULL, NULL, 'electrique', FALSE, TRUE, FALSE, FALSE, NULL, 12, FALSE, 'Ouest', TRUE, FALSE),
(3, 3, 2, 'Domaine des Vignes', 'Maison', 360, 3, 4, 2, 220, 2500, TRUE, FALSE, 'creusee', 'sel', 'fixe', 'geothermie', TRUE, TRUE, TRUE, TRUE, 250, 200, TRUE, 'Sud, Est, Ouest', TRUE, TRUE),
(4, 4, 3, 'Studio Étudiant Calme', 'Appartement', 50, 1, 0, 1, 22, 22, FALSE, NULL, NULL, NULL, NULL, 'collectif', FALSE, FALSE, TRUE, FALSE, NULL, 40, FALSE, 'Nord', FALSE, FALSE),
(1, 2, 1, 'Maison Contemporaine', 'Maison', 260, 2, 3, 2, 155, 620, TRUE, TRUE, 'creusee', 'chlore', 'fixe', 'pompe a chaleur', TRUE, TRUE, TRUE, TRUE, 225, 45, TRUE, 'Sud-Ouest', FALSE, TRUE),
(2, 3, 2, 'T3 Lumineux', 'Appartement', 105, 1, 1, 1, 70, 76, FALSE, NULL, NULL, NULL, 'mobile', 'gaz', TRUE, TRUE, TRUE, FALSE, NULL, 18, TRUE, 'Est', TRUE, FALSE),
(3, 4, 3, 'Gîte de la Forêt', 'Maison', 135, 3, 1, 1, 85, 900, TRUE, FALSE, 'gonflable', 'brome', NULL, 'bois', TRUE, FALSE, TRUE, TRUE, 240, 300, FALSE, 'Sud-Est', TRUE, FALSE),
(4, 1, 1, 'Appartement Standing', 'Appartement', 165, 2, 2, 1, 98, 108, FALSE, NULL, NULL, NULL, 'fixe', 'electrique', TRUE, TRUE, TRUE, TRUE, 205, 15, TRUE, 'Sud', FALSE, TRUE),
(1, 3, 2, 'Villa Méditerranée', 'Maison', 390, 2, 4, 2, 210, 1100, TRUE, FALSE, 'creusee', 'sel', 'fixe', 'pompe a chaleur', TRUE, TRUE, TRUE, TRUE, 230, 70, TRUE, 'Sud, Est', TRUE, TRUE),
(2, 4, 3, 'Maison Mitoyenne Jardin', 'Maison', 125, 2, 1, 2, 82, 180, TRUE, FALSE, 'semi-enteree', 'chlore', 'mobile', 'gaz', TRUE, TRUE, TRUE, FALSE, NULL, 22, FALSE, 'Ouest', TRUE, FALSE),
(3, 1, 1, 'T1 Bis Mezzanine', 'Appartement', 75, 1, 1, 2, 38, 38, FALSE, NULL, NULL, NULL, NULL, 'electrique', FALSE, TRUE, TRUE, FALSE, NULL, 10, FALSE, 'Nord-Est', FALSE, FALSE),
(4, 2, 2, 'Mas Provençal', 'Maison', 340, 4, 3, 2, 200, 1800, TRUE, TRUE, 'creusee', 'brome', 'fixe', 'fioul', TRUE, TRUE, TRUE, TRUE, 245, 120, TRUE, 'Sud', TRUE, FALSE),
(1, 4, 3, 'Appartement Rez-de-Jardin', 'Appartement', 115, 0, 2, 1, 74, 130, FALSE, NULL, NULL, NULL, 'fixe', 'collectif', TRUE, TRUE, TRUE, TRUE, 200, 35, FALSE, 'Sud-Ouest', TRUE, TRUE),
(2, 1, 1, 'Belle Demeure Familiale', 'Maison', 275, 3, 3, 3, 190, 750, TRUE, FALSE, 'creusee', 'chlore', 'fixe', 'geothermie', TRUE, TRUE, TRUE, TRUE, 235, 55, TRUE, 'Sud-Est, Sud-Ouest', FALSE, TRUE);

-- 4. Activités et Héritage
INSERT INTO activite (id, id_secteur, id_adresse, nom, description, telephone, horaires) VALUES
(1, 1, 1, 'Club Nautique', 'Location de voiliers et paddle', '0401020304', '08:00 - 20:00'),
(2, 2, 2, 'Parc Botanique des Dunes', 'Parc ombragé avec vue sur mer', NULL, '06:00 - 22:00'),
(3, 1, 4, 'Boulangerie du Port', 'Pains et spécialités locales', '0405060708', '07:00 - 19:30'),
(4, 3, 3, 'Festival de la Mer', 'Concerts en plein air sur la plage', '0409101112', '18:00 - 23:59');

INSERT INTO sport (id) VALUES
(1);

INSERT INTO parc (id, parc_enfant, dispositif_sportif, animaux_autorises, point_d_eau) VALUES
(2, TRUE, FALSE, FALSE, TRUE);

INSERT INTO magasin (id, type) VALUES
(3, 'Alimentation');

INSERT INTO evenement (id, type, date_debut, date_fin, prix) VALUES
(4, 'Musique', '2026-07-10', '2026-07-15', 25);