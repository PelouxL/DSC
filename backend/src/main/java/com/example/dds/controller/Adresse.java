package com.example.dds.controller;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity 
@Data 
public class Adresse {
    
    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    long id;

    Integer numero;

    String voie;

    @Column(name = "code_postal")
    String codePostal;

    String ville;

    public Adresse() {}

    public Adresse(Integer numero, String voie, String codePostal, String ville){
        this.numero = numero;
        this.voie = voie;
        this.codePostal = codePostal;
        this.ville = ville;
    }
}
