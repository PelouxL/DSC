package com.example.dds.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.dds.secu.AdherentService;

import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;


@Controller 
public class AdherentController {
 
    private final AdherentService adherentService;


    @Autowired 
    AdherentRepository adherentRepo;

    @Autowired 
    AdresseRepository adresseRepo;

    AdherentController(AdherentService adherentService) {
        this.adherentService = adherentService;
    }

    /*
    @GetMapping("/deconnection")
    public String deconnection(HttpSession session, Model model) {
        if(model.getAttribute("utilisateur") != null){
           model.setAttribute("utilisateur", null);
        }
        return "redirect:/";
    }
    */

    @GetMapping("/formConnexion")
    public String Connexion() {
        return "connexion";
    }

    /* alors APPAREMENT le webSecu le fait tout seul DE LA MAGIE
    @PostMapping("formConnexion")
    public String traiterConnexion(
            @RequestParam String email,
            @RequestParam String mdp,
            Model model,
            HttpSession session) {

        Optional<Adherent> adhereOpt = adherentRepo.findByEmail(email);

        if(adhereOpt.isPresent()){
            Adherent adherent = adhereOpt.get();

            if(adherent.getMdp() != null && AdherentService.getCom){
                session.setAttribute("utilisateur", adherent);
                return "redirect:/";
            }
        }

        model.addAttribute("error", "Email ou mot de passe incorrect.");
        return "connexion";
    }
    */

    @GetMapping("/formInscription")
    public String Inscription() {
        return "inscription";
    }

    @PostMapping("/formInscription")
    public String verifInscription(@ModelAttribute Adherent adherent, Model model) {

        if (adherentRepo.existsByEmail(adherent.getEmail())) {
            model.addAttribute("error", "Cet email est déjà associé à un compte.");
        return "inscription";
    }

        adherentService.setComputingDerivedPassword(adherent, adherent.getMdp());

        adherentRepo.save(adherent);

        return "redirect:/formConnexion";
    }
    
    
}
