package com.example.dds.service;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class LlmService {

    public Map<String, Object> analyserLogementViaPython(String description) {
        RestTemplate restTemplate = new RestTemplate();

        String url = "http://localhost:5000/traitement";

        // 1. Préparer les données au format attendu par Flask : {"texte": "..."}
        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("texte", description);

        // 2. Préparer les en-têtes (Dire qu'on envoie du JSON)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, String>> request = new HttpEntity<>(requestBody, headers);

        try {
            // 4. Envoyer la requête POST vers Flask
            ResponseEntity<Map<String, Object>> response =
                restTemplate.exchange(
                url,
                HttpMethod.POST,
                request,
                new ParameterizedTypeReference<Map<String, Object>>() {}
            );
            
            // 5. Récupérer et renvoyer le JSON généré par l'IA
            Map<String, Object> body = response.getBody();
            if (body != null && body.containsKey("resultat")) {
                return (Map<String, Object>) body.get("resultat");
            }
        } catch (Exception e) {
            System.err.println("Erreur de communication avec l'API Python : " + e.getMessage());
        }

        return new HashMap<>(); // Retourne un JSON vide en cas d'erreur
    }
}