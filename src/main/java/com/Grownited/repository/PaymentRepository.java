package com.Grownited.repository;

import com.Grownited.entity.PaymentEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<PaymentEntity, Integer> {
    Optional<PaymentEntity> findByHackathonIdAndUserIdAndPaymentStatus(Integer hackathonId, Integer userId, String status);
}