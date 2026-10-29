package com.example.dds.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;




@Controller 
public class AdherentController {
 
    @Autowired 
    AdherentRepository adherentRepo;


    @Autowired 
    AdresseRepository adresseRepo;

    @GetMapping("/formConnexion")
    public String Connexion() {
        return "connexion";
    }

    @GetMapping("/formInscription")
    public String Inscription() {
        return "inscription";
    }

    @PostMapping("/formInscription")
    public String postMethodName(@ModelAttribute Adherent adherent) {

        adherentRepo.save(adherent);

        return "redirect:/";
    }
    
    
}
