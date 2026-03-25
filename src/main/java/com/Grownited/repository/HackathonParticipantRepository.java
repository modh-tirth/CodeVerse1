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
}
