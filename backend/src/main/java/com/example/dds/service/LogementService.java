package com.example.dds.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dds.controller.Logement;
import com.example.dds.controller.LogementRepository;

@Service
public class LogementService {

    @Autowired
    LogementRepository logementRepo;

    public List<Logement> getLogements() {
        return logementRepo.findAll();
    }
}