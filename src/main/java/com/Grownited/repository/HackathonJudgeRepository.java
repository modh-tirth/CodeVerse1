package com.Grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonJudgeEntity;

@Repository
public interface HackathonJudgeRepository extends JpaRepository<HackathonJudgeEntity, Integer>  {
	
	List<HackathonJudgeEntity> findByHackathonId(Integer hackathonId);

	List<HackathonJudgeEntity> findByUserId(Integer userId);

	boolean existsByHackathonIdAndUserId(Integer hackathonId, Integer userId);
	
	@Query(value = "SELECT u.first_name, u.last_name, COUNT(hj.hackathon_id) as workload " +
		       "FROM users u JOIN hackathon_judge hj ON u.user_id = hj.user_id " +
		       "WHERE u.role = 'judge' " +
		       "GROUP BY u.user_id ORDER BY workload DESC LIMIT 10", nativeQuery = true)
		List<Object[]> getJudgeWorkload();

}
