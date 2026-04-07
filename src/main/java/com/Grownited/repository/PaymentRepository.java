package com.Grownited.repository;

import com.Grownited.entity.PaymentEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<PaymentEntity, Integer> {
    Optional<PaymentEntity> findByHackathonIdAndUserIdAndPaymentStatus(Integer hackathonId, Integer userId, String status);

	long countByPaymentStatus(String string);

	/*
	 * @Query("SELECT TO_CHAR(p.paymentDate, 'Mon YYYY'), SUM(p.amount) " +
	 * "FROM PaymentEntity p WHERE p.paymentStatus = 'SUCCESS' GROUP BY TO_CHAR(p.paymentDate, 'Mon YYYY')"
	 * ) List<Object[]> getMonthlyRevenue();
	 */
	@Query(value = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month, SUM(amount) " +
		       "FROM payments WHERE payment_status = 'SUCCESS' " +
		       "GROUP BY DATE_FORMAT(payment_date, '%b %Y') ORDER BY MIN(payment_date)", nativeQuery = true)
		List<Object[]> getMonthlyRevenue();
		
		   @Query("SELECT SUM(p.amount) FROM PaymentEntity p WHERE p.paymentStatus = 'SUCCESS' AND p.hackathonId IN (SELECT h.hackathonId FROM HackathonEntity h WHERE h.userId = :organizerId)")
		    Double sumSuccessfulPaymentsByOrganizer(@Param("organizerId") Integer organizerId);
		   
		   
}