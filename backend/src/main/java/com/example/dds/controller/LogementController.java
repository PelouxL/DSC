package com.example.dds.controller;

import java.util.Map;
import org.springframework.web.bind.annotation.RequestBody;

import com.example.dds.service.LlmService;
import com.example.dds.service.LogementService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;
import java.util.Optional;

import org.springframework.data.domain.Page;



@Controller 
public class LogementController {

    @Autowired
    private LogementRepository repo;

    @Autowired
    private LlmService llmService;

    @Autowired
    private LogementService logementService;

    // Affiche la page avec le formulaire (déplacé depuis HomeController)
    @GetMapping("/creeLogement")
    public String creeLogement() {
        return "creeLogement";
    }

    // Réceptionne les données quand l'utilisateur clique sur "Valider"
    @PostMapping("/ajouter-logement")
    public String traiterNouveauLogement(@RequestParam("description") String description, Model model) {
        
        Map<String, Object> logement = llmService.analyserLogementViaPython(description);

        model.addAttribute("logement", logement);

        System.out.println("Réponse de Flask et de l'IA : "+logement);
    
        return "formLogement";
    }

    @GetMapping("/logement")
    public String logement(Model model) {
        return logementPage(model, 1);
    }

    @GetMapping("/logement/page/{pageNum}")
    public String logementPage(Model model, @PathVariable int pageNum) {
        if (pageNum < 1) {
            return "redirect:/logement"; // évite le plantage sur /logement/page/0
        }

        Page<Logement> page = logementService.getLogements(pageNum);

        model.addAttribute("currentPage", pageNum);
        model.addAttribute("totalPages", page.getTotalPages());
        model.addAttribute("logements", page.getContent());
        return "logement";
    }

    @GetMapping("/logement/{id}")
    public String afficheCarte(@PathVariable long id, Model m) {
        Optional<Logement> opt = repo.findById(id);
        if (opt.isEmpty()) {
            // we have an old url to a deleted card
            return "redirect:/logement?error=Logement introuvable";
        } else {
            Logement l = opt.get();
            m.addAttribute("logement", l);
            return "detail_logement";
        }
    }

    @PostMapping("/formLogement")
    public String postMethodName(@RequestBody String entity) {
        
        return entity;
    }
}