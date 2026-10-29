package com.example.dds.controller;

import java.math.BigDecimal;

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
public class Adherent {
    
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    long id;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "adresse_id")
    Adresse adresse;

    String prenom;

    String nom;

    String telephone;

    String email;

    String mdp;

    BigDecimal note;

    public Adherent() {}

    public Adherent(String prenom, String nom, String telephone, BigDecimal note, String email, String mdp, Adresse adresse){
        this.prenom = prenom;
        this.nom = nom;
        this.telephone = telephone;
        this.email = email; // verifier le mail (serveur smtp je pense)
        this.mdp = mdp; // on doit encrypter le mdp
        this.note = note;
        // bien pensé a verifier l'adresse avant de l'ajouté
        this.adresse = adresse;
    }

}
