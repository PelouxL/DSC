package com.example.dds.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dds.controller.Logement;
import com.example.dds.controller.LogementRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

@Service
public class LogementService {

    @Autowired
    LogementRepository logementRepo;

    public List<Logement> getLogements() {
        return logementRepo.findAll();
    }

    public Page<Logement> getLogements(int pageNum) {
        int nb_element_page = 10;
        Pageable pagination = PageRequest.of(pageNum - 1, nb_element_page, Sort.by("id"));
        return logementRepo.findAll(pagination);
    }

}