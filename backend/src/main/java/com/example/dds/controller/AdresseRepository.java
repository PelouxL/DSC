package com.example.dds.controller;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository 
public interface AdresseRepository extends CrudRepository<Adresse, Long> {

    @Override 
    List<Adresse> findAll();


}