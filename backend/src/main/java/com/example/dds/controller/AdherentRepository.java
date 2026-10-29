package com.example.dds.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository 
public interface AdherentRepository extends CrudRepository<Adherent, Long> {
    
    @Override 
    List<Adherent> findAll();
    Optional<Adherent> findByEmail(String email);

    Boolean existsByEmail(String email);

}
