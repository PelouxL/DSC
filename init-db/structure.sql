
CREATE TABLE adresse (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    voie VARCHAR(255) NOT NULL,
    code_postal VARCHAR(255) NOT NULL,
    ville VARCHAR(255) NOT NULL
);

CREATE TABLE secteur (
    id INT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE adherent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    adresse_id INT NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    telephone VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(255) NOT NULL,
    note DECIMAL(3,1),
    FOREIGN KEY (adresse_id) REFERENCES adresse(id)
);

CREATE TABLE logement (
    id INT PRIMARY KEY,
    proprietaire_id INT NOT NULL,
    adresse_id INT NOT NULL,
    secteur_id INT NOT NULL,
    type VARCHAR(255) NOT NULL,
    montant_par_nuit INT NOT NULL,
    nb_lit_simple INT NOT NULL,
    nb_lit_double INT NOT NULL,
    garage BOOLEAN,
    piscine BOOLEAN,
    climatisation BOOLEAN,
    chauffage BOOLEAN,
    balcon BOOLEAN,
    FOREIGN KEY (proprietaire_id) REFERENCES adherent(id),
    FOREIGN KEY (adresse_id) REFERENCES adresse(id),
    FOREIGN KEY (secteur_id) REFERENCES secteur(id)
);

CREATE TABLE location (
    id INT PRIMARY KEY,
    id_logement INT NOT NULL,
    id_locataire INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    FOREIGN KEY (id_logement) REFERENCES logement(id),
    FOREIGN KEY (id_locataire) REFERENCES adherent(id)
);

CREATE TABLE facture (
    id INT PRIMARY KEY,
    id_location INT NOT NULL,
    montant INT NOT NULL,
    FOREIGN KEY (id_location) REFERENCES location(id)
);

CREATE TABLE activite (
    id INT PRIMARY KEY,
    id_secteur INT NOT NULL,
    id_adresse INT NOT NULL,
    nom VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    telephone VARCHAR(255) UNIQUE,
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
    parc_enfant BOOLEAN,
    dispositif_sportif BOOLEAN,
    animaux_autorises BOOLEAN,
    point_d_eau BOOLEAN,
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
    prix INT NOT NULL,
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

-- 2. Tables avec dépendances de niveau 1
INSERT INTO adherent (id, adresse_id, prenom, nom, telephone, note) VALUES
(1, 1, 'Jean', 'Dupont', '0601020304', 4.5),
(2, 2, 'Marie', 'Curie', '0605060708', 4.8),
(3, 3, 'Paul', 'Martin', '0609101112', 3.9),
(4, 4, 'Sophie', 'Durand', '0613141516', 5.0);

-- 3. Tables avec dépendances multiples
INSERT INTO logement (id, proprietaire_id, adresse_id, secteur_id, type, montant_par_nuit, nb_lit_simple, nb_lit_double, garage, piscine, climatisation, chauffage, balcon) VALUES
(1, 1, 1, 1, 'Appartement', 80, 0, 1, FALSE, FALSE, TRUE, TRUE, TRUE),
(2, 2, 2, 2, 'Maison', 150, 2, 2, TRUE, FALSE, TRUE, TRUE, FALSE),
(3, 3, 3, 3, 'Villa', 300, 2, 3, TRUE, TRUE, TRUE, TRUE, TRUE);

-- 4. Location et Facturation
INSERT INTO location (id, id_logement, id_locataire, date_debut, date_fin) VALUES
(1, 1, 2, '2026-11-01', '2026-11-05'),
(2, 3, 4, '2026-12-20', '2026-12-27');

INSERT INTO facture (id, id_location, montant) VALUES
(1, 1, 320),
(2, 2, 2100);

-- 5. Activités et Héritage
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