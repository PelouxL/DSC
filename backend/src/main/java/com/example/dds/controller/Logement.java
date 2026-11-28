package com.example.dds.controller;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;

@Entity
@Data
public class Logement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    long id;

    @ManyToOne
    @JoinColumn(name = "proprietaire_id")
    Adherent proprietaire;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "adresse_id")
    Adresse adresse;

    Long secteurId;
    String nom;
    String type;
    Integer montantParNuit;

    // --- Capacité et surfaces ---
    @Column(name = "nb_lits_simples")
    Integer nbLitSimple;

    @Column(name = "nb_lits_doubles")
    Integer nbLitDouble;

    Integer nbEtages;
    Integer surfaceHabitable;
    Integer surfaceTotale;

    // --- Piscine ---
    @Column(name = "piscine_presence")
    Boolean piscine;

    Boolean piscineCouverte;
    String piscineType;        
    String piscineNettoyage;  

    // --- Équipements et confort ---
    String climatisation;      
    String chauffage;          
    Boolean salleDeBainEtWcSepares;
    Boolean television;
    Boolean wifi;

    // --- Garage ---
    @Column(name = "garage_presence")
    Boolean garage;

    Integer garageHauteur;

    // --- Extérieur et accès ---
    Integer distanceRoute;
    Boolean balcon;
    String exposition;
    Boolean animauxAutorises;
    Boolean amenagementPersonneAMobiliteReduite;

    public Logement() {}

    public Logement(Adherent proprietaire, Adresse adresse, Long secteurId, String type, Integer montantParNuit,
                    Integer nbLitSimple, Integer nbLitDouble, Boolean garage, Boolean piscine,
                    String climatisation, String chauffage, Boolean balcon) {
        this.proprietaire = proprietaire;
        this.adresse = adresse;
        this.secteurId = secteurId;
        this.type = type;
        this.montantParNuit = montantParNuit;
        this.nbLitSimple = nbLitSimple;
        this.nbLitDouble = nbLitDouble;
        this.garage = garage;
        this.piscine = piscine;
        this.climatisation = climatisation;
        this.chauffage = chauffage;
        this.balcon = balcon;
    }
}