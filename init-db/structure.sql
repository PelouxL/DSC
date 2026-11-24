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

/* Ancienne table
CREATE TABLE logement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proprietaire_id INT NOT NULL,
    adresse_id INT NOT NULL,
    secteur_id INT NOT NULL,
    type VARCHAR(255) NOT NULL,
    montant_par_nuit INT NOT NULL CHECK (montant_par_nuit > 0),
    nb_lit_simple INT NOT NULL DEFAULT 0 CHECK (nb_lit_simple >= 0),
    nb_lit_double INT NOT NULL DEFAULT 0 CHECK (nb_lit_double >= 0),
    garage BOOLEAN DEFAULT FALSE,
    piscine BOOLEAN DEFAULT FALSE,
    climatisation BOOLEAN DEFAULT FALSE,
    chauffage BOOLEAN DEFAULT FALSE,
    balcon BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (proprietaire_id) REFERENCES adherent(id),
    FOREIGN KEY (adresse_id) REFERENCES adresse(id),
    FOREIGN KEY (secteur_id) REFERENCES secteur(id)
);
*/

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

-- 3. Logements (3 initiaux + 30 ajoutés)
INSERT INTO logement (id, proprietaire_id, adresse_id, secteur_id, type, montant_par_nuit, nb_lit_simple, nb_lit_double, garage, piscine, climatisation, chauffage, balcon) VALUES
(1, 1, 1, 1, 'Appartement', 80, 0, 1, FALSE, FALSE, TRUE, TRUE, TRUE),
(2, 2, 2, 2, 'Maison', 150, 2, 2, TRUE, FALSE, TRUE, TRUE, FALSE),
(3, 3, 3, 3, 'Villa', 300, 2, 3, TRUE, TRUE, TRUE, TRUE, TRUE),
(4, 4, 4, 1, 'Appartement', 95, 1, 1, FALSE, FALSE, TRUE, TRUE, TRUE),
(5, 1, 5, 3, 'Maison', 180, 2, 2, TRUE, FALSE, FALSE, TRUE, TRUE),
(6, 2, 1, 1, 'Studio', 65, 0, 1, FALSE, FALSE, TRUE, TRUE, FALSE),
(7, 3, 2, 2, 'Villa', 340, 3, 3, TRUE, TRUE, TRUE, TRUE, TRUE),
(8, 4, 3, 3, 'Appartement', 110, 2, 1, FALSE, FALSE, TRUE, TRUE, TRUE),
(9, 1, 4, 1, 'Maison', 165, 1, 2, TRUE, FALSE, TRUE, TRUE, FALSE),
(10, 2, 5, 3, 'Villa', 290, 2, 2, TRUE, TRUE, FALSE, TRUE, TRUE),
(11, 3, 1, 1, 'Studio', 70, 2, 0, FALSE, FALSE, FALSE, TRUE, FALSE),
(12, 4, 2, 2, 'Appartement', 90, 1, 1, FALSE, FALSE, TRUE, TRUE, FALSE),
(13, 1, 3, 3, 'Maison', 210, 2, 3, TRUE, FALSE, TRUE, TRUE, TRUE),
(14, 2, 4, 1, 'Appartement', 105, 0, 2, FALSE, FALSE, TRUE, TRUE, TRUE),
(15, 3, 5, 3, 'Villa', 380, 4, 3, TRUE, TRUE, TRUE, TRUE, TRUE),
(16, 4, 1, 1, 'Studio', 60, 1, 0, FALSE, FALSE, FALSE, TRUE, FALSE),
(17, 1, 2, 2, 'Maison', 145, 3, 1, TRUE, FALSE, FALSE, TRUE, FALSE),
(18, 2, 3, 3, 'Appartement', 125, 1, 2, TRUE, FALSE, TRUE, TRUE, TRUE),
(19, 3, 4, 1, 'Appartement', 85, 2, 0, FALSE, FALSE, TRUE, TRUE, FALSE),
(20, 4, 5, 3, 'Maison', 225, 1, 3, TRUE, TRUE, TRUE, TRUE, TRUE),
(21, 1, 1, 1, 'Studio', 75, 0, 1, FALSE, FALSE, TRUE, TRUE, FALSE),
(22, 2, 2, 2, 'Villa', 275, 2, 2, TRUE, TRUE, TRUE, TRUE, FALSE),
(23, 3, 3, 3, 'Appartement', 130, 2, 1, FALSE, FALSE, TRUE, TRUE, TRUE),
(24, 4, 4, 1, 'Maison', 155, 2, 2, FALSE, FALSE, TRUE, TRUE, TRUE),
(25, 1, 5, 3, 'Appartement', 115, 1, 1, TRUE, FALSE, FALSE, TRUE, TRUE),
(26, 2, 1, 1, 'Villa', 310, 3, 2, TRUE, TRUE, TRUE, TRUE, TRUE),
(27, 3, 2, 2, 'Studio', 55, 1, 0, FALSE, FALSE, FALSE, TRUE, FALSE),
(28, 4, 3, 3, 'Maison', 195, 2, 2, TRUE, FALSE, TRUE, TRUE, TRUE),
(29, 1, 4, 1, 'Appartement', 98, 1, 1, FALSE, FALSE, TRUE, TRUE, FALSE),
(30, 2, 5, 3, 'Villa', 360, 2, 4, TRUE, TRUE, TRUE, TRUE, TRUE),
(31, 3, 1, 1, 'Maison', 170, 3, 1, TRUE, FALSE, TRUE, TRUE, FALSE),
(32, 4, 2, 2, 'Appartement', 88, 0, 1, FALSE, FALSE, FALSE, TRUE, TRUE),
(33, 1, 3, 3, 'Villa', 325, 2, 3, TRUE, TRUE, TRUE, TRUE, TRUE);

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