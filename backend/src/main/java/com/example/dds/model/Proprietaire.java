package com.example.dds.model;

public record Proprietaire(
    int id,
    String prenom,
    String nom,
    String telephone,
    double note,
    String numero,
    String voie,
    String codePostal,
    String ville
) {
}