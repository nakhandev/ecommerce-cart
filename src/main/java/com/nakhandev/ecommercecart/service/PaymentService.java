package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.model.Payment;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface PaymentService {

    // Payment processing
    Payment processPayment(Order order, String paymentMethod);

    Payment processPaymentWithAmount(Order order, String paymentMethod, BigDecimal amount);

    // Payment retrieval
    Optional<Payment> findPaymentById(Long id);

    Optional<Payment> findByTransactionId(String transactionId);

    Optional<Payment> findByOrderId(Long orderId);

    List<Payment> findAllPayments();

    // Payment filtering
    List<Payment> findByStatus(Payment.PaymentStatus status);

    List<Payment> findByPaymentMethod(String paymentMethod);

    List<Payment> findByUserId(Long userId);

    // Payment status management
    Payment updatePaymentStatus(Long paymentId, Payment.PaymentStatus status);

    Payment markPaymentAsCompleted(Long paymentId);

    Payment markPaymentAsFailed(Long paymentId, String reason);

    // Payment validation
    boolean validatePayment(Payment payment);

    List<String> validatePaymentForProcessing(Order order, String paymentMethod);

    // Analytics
    long countPaymentsByStatus(Payment.PaymentStatus status);

    BigDecimal getTotalPaymentAmount();

    BigDecimal getTotalPaymentAmountBetween(java.time.LocalDateTime startDate, java.time.LocalDateTime endDate);

    BigDecimal getAveragePaymentAmount();

    // Payment search
    List<Payment> searchPayments(String searchTerm);

    // Mock payment gateway methods (for prototype)
    Payment simulatePayment(Order order, String paymentMethod);

    boolean simulatePaymentSuccess();

    String generateMockTransactionId();
}
