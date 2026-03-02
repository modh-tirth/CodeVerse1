package com.Grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonEntity;

@Repository
public interface HackathonRepository extends JpaRepository<HackathonEntity, Integer> {
     
	   //Optional<HackathonEntity> 
	    long countByStatus(String status);
}
