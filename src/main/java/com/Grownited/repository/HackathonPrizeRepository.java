package com.Grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.HackathonPrizeEntity;

@Repository
public interface HackathonPrizeRepository extends JpaRepository<HackathonPrizeEntity, Integer> {

	//@Query("SELECT p FROM HackathonPrizeEntity p WHERE p.hackathon_id = :hId")
	//List<HackathonPrizeEntity> findByHackathonId(@Param("hId") Integer hId);
	
	List<HackathonPrizeEntity> findByHackathonId(Integer hackathonId);

	List<HackathonPrizeEntity> findByHackathonIdOrderByHackathonPrizeIdAsc(Integer hackathonId);



}