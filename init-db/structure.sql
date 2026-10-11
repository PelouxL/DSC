
CREATE TABLE adresse (
    id INT PRIMARY KEY,
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
    id INT PRIMARY KEY,
    adresse_id INT NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    telephone VARCHAR(255) UNIQUE NOT NULL,
    note DECIMAL NOT NULL,
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