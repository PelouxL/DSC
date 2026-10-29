package com.example.dds.controller;

import com.example.dds.service.LlmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    public String traiterNouveauLogement(@RequestParam("description") String description) {
        
        String jsonResultat = llmService.analyserLogementViaPython(description);
        
        System.out.println("Réponse de Flask et de l'IA : " + jsonResultat);
        
        return "redirect:/";
    }
}