package com.Grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonSubmissionEntity;

@Repository
public interface HackathonSubmissionRepository extends JpaRepository<HackathonSubmissionEntity, Integer> {

	Optional<HackathonSubmissionEntity> findByHackathonIdAndTeamId(Integer hackathonId, Integer teamId);

	List<HackathonSubmissionEntity> findByHackathonIdIn(List<Integer> hackathonIds);

	@Query("SELECT COUNT(DISTINCT s.hackathonSubmissionId) FROM HackathonSubmissionEntity s")
	long countDistinctSubmission();
	/*
	 * @Query("SELECT COUNT(DISTINCT s.submissionId) FROM HackathonSubmissionEntity s"
	 * ) long countDistinctSubmission();
	 */
	@Query("SELECT COUNT(s) FROM HackathonSubmissionEntity s")
	long getTotalSubmissions();

	@Query("SELECT COUNT(DISTINCT s.hackathonSubmissionId) FROM HackathonSubmissionEntity s " +
	       "WHERE EXISTS (SELECT 1 FROM HackathonResultEntity r WHERE r.hackathonId = s.hackathonId AND r.teamId = s.teamId)")
	long getEvaluatedSubmissions();
	
}
