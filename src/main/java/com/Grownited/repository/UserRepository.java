package com.Grownited.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.UserEntity;
import java.util.List;


@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {

	Optional<UserEntity>  findByEmail(String email);
	
	List<UserEntity> findByRole(String role);
	
	long countByRole(String role);

	/*
	 * @Query("SELECT CONCAT(u.firstName, ' ', u.lastName) AS name, COUNT(hj.hackathonId) AS count "
	 * + "FROM UserEntity u JOIN HackathonJudgeEntity hj ON u.userId = hj.userId " +
	 * "GROUP BY u.userId ORDER BY count DESC") List<Object[]> getJudgeWorkload();
	 */

}
