package com.example.dds.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


@Controller 
public class HomeController {
    
    @GetMapping("/")
    public String afficherAcceuil(Model m) {
        
        m.addAttribute("titre", "AlloFraicheur");
        
        return "index";
    }
    
    
    
}
