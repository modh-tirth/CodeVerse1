package com.Grownited.repository;


import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonPrizeEntity;
import com.Grownited.entity.HackathonTeamEntity;

import java.awt.print.Pageable;
import java.time.LocalDate;
import java.util.List;



@Repository
public interface HackathonRepository extends JpaRepository<HackathonEntity, Integer> {
     
	    long countByStatus(String status);
	    
	    
	 
	    
}
