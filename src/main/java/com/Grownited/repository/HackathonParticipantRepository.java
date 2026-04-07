package com.Grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonParticipantEntity;

@Repository
public interface HackathonParticipantRepository extends JpaRepository<HackathonParticipantEntity, Integer>  {

	boolean existsByHackathonIdAndParticipantId(Integer hackathonId, Integer participantId);

	List<HackathonParticipantEntity> findByHackathonId(Integer hackathonId);

	List<HackathonParticipantEntity> findByParticipantId(Integer participantId);
	
	// HackathonParticipantRepository.java
	@Query("SELECT p.participantId FROM HackathonParticipantEntity p " +
		       "WHERE p.hackathonId = :hackathonId " +
		       "AND p.participantId NOT IN (SELECT m.memberId FROM HackathonTeamMembersEntity m WHERE m.hackathonId = :hackathonId) " +
		       "AND p.participantId NOT IN (SELECT i.invitedUserId FROM HackathonTeamInviteEntity i " +
		       "                            WHERE i.hackathonId = :hackathonId AND i.inviteStatus = 'PENDING')")
		List<Integer> findParticipantIdsNotInAnyTeamAndNoPendingInvite(@Param("hackathonId") Integer hackathonId);
	
	@Query(value = "SELECT DATE_FORMAT(joined_date, '%b %Y') as month, COUNT(*) as count " +
		       "FROM hackathon_participant " +
		       "GROUP BY DATE_FORMAT(joined_date, '%b %Y') " +
		       "ORDER BY MIN(joined_date)", nativeQuery = true)
		List<Object[]> getMonthlyRegistrations();
		
		 // Count all registrations where hackathon belongs to given organizer
	    @Query("SELECT COUNT(hp) FROM HackathonParticipantEntity hp WHERE hp.hackathonId IN (SELECT h.hackathonId FROM HackathonEntity h WHERE h.userId = :organizerId)")
	    Long countRegistrationsByOrganizer(@Param("organizerId") Integer organizerId);

	    // Count registrations per hackathon for the organizer
	    @Query("SELECT hp.hackathonId, COUNT(hp) FROM HackathonParticipantEntity hp WHERE hp.hackathonId IN (SELECT h.hackathonId FROM HackathonEntity h WHERE h.userId = :organizerId) GROUP BY hp.hackathonId")
	    List<Object[]> countRegistrationsGroupByHackathon(@Param("organizerId") Integer organizerId);
	    
	    @Query(value = "SELECT hp.hackathon_id, COUNT(*) FROM hackathon_participant hp " +
	               "WHERE hp.hackathon_id IN (SELECT hackathon_id FROM hackathon WHERE user_id = :organizerId) " +
	               "GROUP BY hp.hackathon_id", nativeQuery = true)
	List<Object[]> countRegistrationsGroupByHackathonNative(@Param("organizerId") Integer organizerId);
	
	
	
	}
		
		

