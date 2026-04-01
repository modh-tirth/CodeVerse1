package com.Grownited.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonTeamMembersEntity;

@Repository
public interface HackathonTeamMembersRepository extends JpaRepository<HackathonTeamMembersEntity, Integer>{
	
	//List<HackathonTeamMembersEntity> findByMemberId(Integer memberId);
	//Optional<HackathonTeamMembersEntity> findByHackathonIdAndMemberId(Integer hackathonId, Integer memberId);
	
	boolean existsByHackathonIdAndMemberId(Integer hackathonId, Integer memberId);

	Optional<HackathonTeamMembersEntity> findFirstByHackathonIdAndMemberId(Integer hackathonId, Integer memberId);

	Optional<HackathonTeamMembersEntity> findFirstByTeamIdAndMemberId(Integer teamId, Integer memberId);

	List<HackathonTeamMembersEntity> findByTeamIdOrderByHackathonTeamMemberIdAsc(Integer teamId);

	List<HackathonTeamMembersEntity> findByMemberId(Integer memberId);

	long countByTeamId(Integer teamId);

	Collection<HackathonEntity> findByTeamId(Integer teamId);
	List<HackathonTeamMembersEntity> findByHackathonId(Integer hackathonId);
}
