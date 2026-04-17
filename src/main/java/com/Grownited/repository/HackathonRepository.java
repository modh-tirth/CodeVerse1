package com.Grownited.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonEntity;


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
	    	
	    	List<HackathonEntity> findByUserId(Integer userId);
	    	    @Query("SELECT h FROM HackathonEntity h WHERE " +
	    	           "(:search IS NULL OR LOWER(h.title) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(h.location) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
	    	           "(:status IS NULL OR h.status = :status) AND " +
	    	           "(:payment IS NULL OR h.payment = :payment) AND " +
	    	           "(:eventType IS NULL OR h.eventType = :eventType)")
	    	    Page<HackathonEntity> findAllWithFilters(@Param("search") String search,
	    	                                             @Param("status") String status,
	    	                                             @Param("payment") String payment,
	    	                                             @Param("eventType") String eventType,
	    	                                             org.springframework.data.domain.Pageable pageable);
	    	    
	    	    @Query("SELECT h FROM HackathonEntity h WHERE h.userId = :userId " +
	    	    	       "AND (:search IS NULL OR LOWER(h.title) LIKE LOWER(CONCAT('%', :search, '%')) " +
	    	    	       "OR LOWER(h.location) LIKE LOWER(CONCAT('%', :search, '%'))) " +
	    	    	       "AND (:status IS NULL OR h.status = :status) " +
	    	    	       "AND (:payment IS NULL OR h.payment = :payment) " +
	    	    	       "AND (:eventType IS NULL OR h.eventType = :eventType)")
	    	    	Page<HackathonEntity> findByUserIdAndFilters(@Param("userId") Integer userId,
	    	    	                                             @Param("search") String search,
	    	    	                                             @Param("status") String status,
	    	    	                                             @Param("payment") String payment,
	    	    	                                             @Param("eventType") String eventType,
	    	    	                                             org.springframework.data.domain.Pageable pageable);
	   
				// New method that returns only IDs
			    @Query("SELECT h.hackathonId FROM HackathonEntity h WHERE h.userId = :userId")
			    List<Integer> findIdsByUserId(@Param("userId") Integer userId);
}
	 
	    

