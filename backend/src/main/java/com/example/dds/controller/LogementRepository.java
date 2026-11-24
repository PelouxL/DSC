package com.example.dds.controller;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;

@Repository 
public interface LogementRepository extends JpaRepository<Logement, Long> {

}