package com.example.dds.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


@Controller 
public class HomeController {
    
    @Autowired 
    AdherentRepository adherentRepo;

    @GetMapping("/")
    public String pageAccueil(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        
        if(userDetails != null){
            String email = userDetails.getUsername();
            Adherent adherent = adherentRepo.findByEmail(email).orElse(null);

            model.addAttribute("utilisateur", adherent);
        }

        model.addAttribute("titre", "AlloFraicheur");
        
        return "index";
    }
    
    
    
}
