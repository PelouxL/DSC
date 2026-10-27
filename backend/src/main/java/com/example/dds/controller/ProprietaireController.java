package com.example.dds.controller;

import com.example.dds.model.Proprietaire;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class ProprietaireController {

    private final JdbcTemplate jdbcTemplate;

    public ProprietaireController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/proprietaires/{id}")
    public String afficherProprietaire(@PathVariable int id, Model model) {
        String sql = """
            SELECT a.id, a.prenom, a.nom, a.telephone, a.note, adr.numero, adr.voie, adr.code_postal, adr.ville
            FROM adherent a
            JOIN adresse adr ON a.adresse_id = adr.id
            WHERE a.id = ?
            AND EXISTS (
                SELECT 1
                FROM logement l
                WHERE l.proprietaire_id = a.id
            )
            """;

        List<Proprietaire> proprietaires = jdbcTemplate.query(
            sql,
            (rs, rowNum) -> new Proprietaire(
                rs.getInt("id"),
                rs.getString("prenom"),
                rs.getString("nom"),
                rs.getString("telephone"),
                rs.getDouble("note"),
                rs.getString("numero"),
                rs.getString("voie"),
                rs.getString("code_postal"),
                rs.getString("ville")
            ),
            id
        );

        if (proprietaires.isEmpty()) {
            return "proprietaire-introuvable";
        }

        model.addAttribute("proprietaire", proprietaires.get(0));
        return "proprietaire";
    }
}
