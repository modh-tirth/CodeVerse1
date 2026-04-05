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

	    @Query("SELECT DISTINCT h.userType FROM HackathonEntity h WHERE h.userType IS NOT NULL")
		List<String> findDistinctUserType();
	    
	    @Query(value = "SELECT h.title, COUNT(hp.participant_id) as participant_count " +
	    	       "FROM hackathon h " +
	    	       "LEFT JOIN hackathon_participant hp ON h.hackathon_id = hp.hackathon_id " +
	    	       "GROUP BY h.hackathon_id " +
	    	       "ORDER BY participant_count DESC " +
	    	       "LIMIT 5", nativeQuery = true)
	    	List<Object[]> getTopHackathonsByParticipants(); 
	 
	    
}
