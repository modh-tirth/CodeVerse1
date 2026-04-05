package com.Grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonTeamEntity;

@Repository
public interface HackathonTeamRepository extends JpaRepository<HackathonTeamEntity, Integer> {
	//List<HackathonTeamEntity> findByTeamLeaderId(Integer teamLeaderId);
	//Optional<HackathonTeamEntity> findByHackathonIdAndTeamLeaderId(Integer hackathonId, Integer teamLeaderId);
	
	boolean existsByHackathonIdAndTeamLeaderId(Integer hackathonId, Integer teamLeaderId);

	long countByHackathonId(Integer hackathonId);

	Optional<HackathonTeamEntity> findFirstByHackathonIdAndTeamLeaderId(Integer hackathonId, Integer teamLeaderId);

	List<HackathonTeamEntity> findByHackathonId(Integer hackathonId);

	List<HackathonTeamEntity> findByTeamLeaderId(Integer teamLeaderId);
	
	@Query(value = "SELECT team_size, COUNT(*) FROM (" +
		       "  SELECT team_id, COUNT(member_id) as team_size FROM hackathon_team_members " +
		       "  GROUP BY team_id" +
		       ") AS sizes GROUP BY team_size ORDER BY team_size", nativeQuery = true)
		List<Object[]> getTeamSizeDistribution();
	
}
