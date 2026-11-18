package com.example.dds.controller;

import com.example.dds.service.LlmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

@Controller 
public class LogementController {

    @Autowired
    private LlmService llmService;

    // Affiche la page avec le formulaire (déplacé depuis HomeController)
    @GetMapping("/creeLogement") 
    public String creeLogement() {
        return "creeLogement";
    }

    // Réceptionne les données quand l'utilisateur clique sur "Valider"
    @PostMapping("/ajouter-logement")
    public String traiterNouveauLogement(@RequestParam("description") String description, Model model) {
        
        String s = llmService.analyserLogementViaPython(description);

        try {
            // String to json
            ObjectMapper mapper = new ObjectMapper();
            JsonNode logement = mapper.readTree(s);
            
            // Création du paquet à récupérer sur le formulaire du logement
            model.addAttribute("logement", logement);
        } catch (Exception e) {
            model.addAttribute("erreur", "Erreur lors de la lecture du JSON : " + e.getMessage());
        }

        System.out.println("Réponse de Flask et de l'IA : "+s);
    
        return "formLogement";
    }
}