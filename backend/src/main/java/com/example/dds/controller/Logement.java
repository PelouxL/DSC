package com.example.dds.controller;

import jakarta.persistence.CascadeType;
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
    String type;
    Integer montantParNuit;
    Integer nbLitSimple;
    Integer nbLitDouble;
    Boolean garage;
    Boolean piscine;
    Boolean climatisation;
    Boolean chauffage;
    Boolean balcon;

    public Logement() {}

    public Logement(Adherent proprietaire, Adresse adresse, Long secteurId, String type, Integer montantParNuit,
                    Integer nbLitSimple, Integer nbLitDouble, Boolean garage, Boolean piscine,
                    Boolean climatisation, Boolean chauffage, Boolean balcon){

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