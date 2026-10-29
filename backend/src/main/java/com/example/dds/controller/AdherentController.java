package com.example.dds.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@Controller 
public class AdherentController {
 
    @Autowired 
    AdherentRepository adherentRepo;


    @Autowired 
    AdresseRepository adresseRepo;

    @GetMapping("/deconnection")
    public String deconnection(HttpSession session) {
        session.setAttribute("utilisateur", null);
        return "redirect:/";
    }
    

    @GetMapping("/formConnexion")
    public String Connexion() {
        return "connexion";
    }

    @PostMapping("formConnexion")
    public String traiterConnexion(
            @RequestParam String email,
            @RequestParam String mdp,
            Model model,
            HttpSession session) {

        Optional<Adherent> adhereOpt = adherentRepo.findByEmail(email);

        if(adhereOpt.isPresent()){
            Adherent adherent = adhereOpt.get();

            if(adherent.getMdp() != null && adherent.getMdp().equals(mdp)){
                session.setAttribute("utilisateur", adherent);
                return "redirect:/";
            }
        }

        model.addAttribute("error", "Email ou mot de passe incorrect.");
        return "connexion";
    }
    

    @GetMapping("/formInscription")
    public String Inscription() {
        return "inscription";
    }

    @PostMapping("/formInscription")
    public String verifInscription(@ModelAttribute Adherent adherent) {

        adherentRepo.save(adherent);

        return "redirect:/";
    }
    
    
}
