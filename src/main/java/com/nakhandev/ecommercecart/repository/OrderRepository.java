package com.nakhandev.ecommercecart.repository;

import com.nakhandev.ecommercecart.model.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    Optional<Order> findByOrderNumber(String orderNumber);

    List<Order> findByUserIdOrderByOrderDateDesc(Long userId);

    @Query("SELECT o FROM Order o LEFT JOIN FETCH o.orderItems WHERE o.user.id = :userId ORDER BY o.orderDate DESC")
    List<Order> findByUserIdWithItems(@Param("userId") Long userId);

    Page<Order> findByUserIdOrderByOrderDateDesc(@Param("userId") Long userId, Pageable pageable);

    @Query("SELECT o FROM Order o WHERE o.status = :status")
    List<Order> findByStatus(@Param("status") Order.OrderStatus status);

    @Query("SELECT o FROM Order o WHERE o.status = :status")
    Page<Order> findByStatus(@Param("status") Order.OrderStatus status, Pageable pageable);

    @Query("SELECT o FROM Order o WHERE o.user.id = :userId AND o.status = :status")
    List<Order> findByUserIdAndStatus(@Param("userId") Long userId, @Param("status") Order.OrderStatus status);

    @Query("SELECT o FROM Order o WHERE o.orderDate BETWEEN :startDate AND :endDate")
    List<Order> findByOrderDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT o FROM Order o WHERE o.totalAmount >= :minAmount")
    List<Order> findByTotalAmountGreaterThanEqual(@Param("minAmount") BigDecimal minAmount);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.status = :status")
    long countByStatus(@Param("status") Order.OrderStatus status);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.user.id = :userId")
    long countByUserId(@Param("userId") Long userId);

    @Query("SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = 'DELIVERED'")
    BigDecimal getTotalSalesAmount();

    @Query("SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = 'DELIVERED' AND o.orderDate BETWEEN :startDate AND :endDate")
    BigDecimal getTotalSalesAmountBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT AVG(o.totalAmount) FROM Order o WHERE o.status = 'DELIVERED'")
    BigDecimal getAverageOrderValue();

    @Query("SELECT o FROM Order o WHERE o.orderNumber LIKE %:searchTerm% OR o.user.firstName LIKE %:searchTerm% OR o.user.lastName LIKE %:searchTerm%")
    List<Order> searchOrders(@Param("searchTerm") String searchTerm);

    @Query("SELECT o FROM Order o WHERE o.user.id = :userId ORDER BY o.orderDate DESC")
    Page<Order> findByUserIdOrderByOrderDateDescPaginated(@Param("userId") Long userId, Pageable pageable);

    @Query("SELECT DISTINCT o FROM Order o JOIN o.payment p WHERE p.status = :paymentStatus")
    List<Order> findByPaymentStatus(@Param("paymentStatus") com.nakhandev.ecommercecart.model.Payment.PaymentStatus paymentStatus);

    @Query("SELECT o FROM Order o LEFT JOIN FETCH o.orderItems WHERE o.id = :id")
    Optional<Order> findByIdWithItems(@Param("id") Long id);
}
