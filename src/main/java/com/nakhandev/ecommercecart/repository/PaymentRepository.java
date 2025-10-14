package com.nakhandev.ecommercecart.repository;

import com.nakhandev.ecommercecart.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    Optional<Payment> findByTransactionId(String transactionId);

    Optional<Payment> findByOrderId(Long orderId);

    List<Payment> findByStatus(Payment.PaymentStatus status);

    List<Payment> findByPaymentMethod(String paymentMethod);

    @Query("SELECT p FROM Payment p WHERE p.order.user.id = :userId ORDER BY p.createdAt DESC")
    List<Payment> findByUserId(@Param("userId") Long userId);

    @Query("SELECT p FROM Payment p WHERE p.status = :status AND p.createdAt BETWEEN :startDate AND :endDate")
    List<Payment> findByStatusAndDateRange(@Param("status") Payment.PaymentStatus status,
                                         @Param("startDate") LocalDateTime startDate,
                                         @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.status = :status")
    long countByStatus(@Param("status") Payment.PaymentStatus status);

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'COMPLETED'")
    BigDecimal getTotalPaymentAmount();

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'COMPLETED' AND p.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal getTotalPaymentAmountBetween(@Param("startDate") LocalDateTime startDate,
                                          @Param("endDate") LocalDateTime endDate);

    @Query("SELECT AVG(p.amount) FROM Payment p WHERE p.status = 'COMPLETED'")
    BigDecimal getAveragePaymentAmount();

    @Query("SELECT p FROM Payment p WHERE p.transactionId LIKE %:searchTerm% OR p.order.orderNumber LIKE %:searchTerm%")
    List<Payment> searchPayments(@Param("searchTerm") String searchTerm);

    @Query("SELECT p FROM Payment p WHERE p.amount >= :minAmount")
    List<Payment> findByAmountGreaterThanEqual(@Param("minAmount") BigDecimal minAmount);

    @Query("SELECT p FROM Payment p WHERE p.paymentMethod = :method AND p.status = :status")
    List<Payment> findByPaymentMethodAndStatus(@Param("method") String method,
                                             @Param("status") Payment.PaymentStatus status);

    boolean existsByTransactionId(String transactionId);

    boolean existsByOrderId(Long orderId);
}
