package com.Grownited.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonTeamInviteEntity;

@Repository
public interface HackathonTeamInviteRepository extends JpaRepository<HackathonTeamInviteEntity, Integer> {

	List<HackathonTeamInviteEntity> findByTeamIdOrderByHackathonTeamInviteIdDesc(Integer teamId);

	boolean existsByTeamIdAndInvitedUserIdAndInviteStatus(Integer teamId, Integer invitedUserId, String inviteStatus);

	boolean existsByTeamIdAndInvitedEmailAndInviteStatus(Integer teamId, String invitedEmail, String inviteStatus);

	boolean existsByHackathonIdAndInvitedUserIdAndInviteStatus(Integer hackathonId, Integer invitedUserId, String inviteStatus);

	Optional<HackathonTeamInviteEntity> findFirstByHackathonIdAndInvitedUserIdAndInviteStatus(Integer hackathonId,
			Integer invitedUserId, String inviteStatus);

	long countByTeamIdAndInviteStatus(Integer teamId, String inviteStatus);

	// HackathonTeamInviteRepository.java
	List<HackathonTeamInviteEntity> findByTeamIdAndInviteTypeAndInviteStatus(Integer teamId, String inviteType, String inviteStatus);

	void deleteByHackathonIdAndInvitedUserIdAndInviteStatus(Integer hackathonId, Integer userId, String string);
	
	List<HackathonTeamInviteEntity> findByTeamIdAndInviteStatusNotOrderByHackathonTeamInviteIdDesc(Integer teamId, String status);
	Optional<HackathonTeamInviteEntity>
	findFirstByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteTypeIn(
	    Integer hackathonId,
	    Integer userId,
	    String status,
	    List<String> inviteTypes);
	
	Optional<HackathonTeamInviteEntity>
	findFirstByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteType(
	    Integer hackathonId,
	    Integer invitedUserId,
	    String inviteStatus,
	    String inviteType
	);

	List<HackathonTeamInviteEntity> findByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteTypeIn(Integer hackathonId,
			Integer userId, String string, List<String> of);
	// Check if a specific type of pending request exists
	boolean existsByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteType(
	    Integer hackathonId, Integer invitedUserId, String inviteStatus, String inviteType);

	// Get pending requests made by a participant (type REQUEST)
	List<HackathonTeamInviteEntity> findByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteType(
	    Integer hackathonId, Integer invitedUserId, String inviteStatus, String inviteType);


	List<HackathonTeamInviteEntity> findByHackathonIdAndInviteStatus(Integer hackathonId, String inviteStatus);

	Optional<HackathonTeamInviteEntity> findFirstByHackathonIdAndInvitedEmailAndInviteStatus(
		    Integer hackathonId, String invitedEmail, String inviteStatus);

}
