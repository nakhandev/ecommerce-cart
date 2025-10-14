package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.model.Payment;
import com.nakhandev.ecommercecart.repository.PaymentRepository;
import com.nakhandev.ecommercecart.service.PaymentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
@Transactional
public class PaymentServiceImpl implements PaymentService {

    private static final Logger logger = LoggerFactory.getLogger(PaymentServiceImpl.class);
    private static final Random random = new Random();

    private final PaymentRepository paymentRepository;

    @Autowired
    public PaymentServiceImpl(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    @Override
    public Payment processPayment(Order order, String paymentMethod) {
        logger.info("Processing payment for order: {} with method: {}", order.getOrderNumber(), paymentMethod);

        // Validate payment
        List<String> validationErrors = validatePaymentForProcessing(order, paymentMethod);
        if (!validationErrors.isEmpty()) {
            throw new RuntimeException("Payment validation failed: " + String.join(", ", validationErrors));
        }

        // For prototype, we'll simulate payment processing
        return simulatePayment(order, paymentMethod);
    }

    @Override
    public Payment processPaymentWithAmount(Order order, String paymentMethod, BigDecimal amount) {
        logger.info("Processing payment for order: {} with method: {} and amount: {}",
                   order.getOrderNumber(), paymentMethod, amount);

        // Create payment with specified amount
        Payment payment = new Payment(order, paymentMethod, amount);

        // For prototype, simulate payment
        return simulatePaymentProcessing(payment);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Payment> findPaymentById(Long id) {
        logger.debug("Finding payment by ID: {}", id);
        return paymentRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Payment> findByTransactionId(String transactionId) {
        logger.debug("Finding payment by transaction ID: {}", transactionId);
        return paymentRepository.findByTransactionId(transactionId);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Payment> findByOrderId(Long orderId) {
        logger.debug("Finding payment by order ID: {}", orderId);
        return paymentRepository.findByOrderId(orderId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> findAllPayments() {
        logger.debug("Finding all payments");
        return paymentRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> findByStatus(Payment.PaymentStatus status) {
        logger.debug("Finding payments by status: {}", status);
        return paymentRepository.findByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> findByPaymentMethod(String paymentMethod) {
        logger.debug("Finding payments by method: {}", paymentMethod);
        return paymentRepository.findByPaymentMethod(paymentMethod);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> findByUserId(Long userId) {
        logger.debug("Finding payments by user ID: {}", userId);
        return paymentRepository.findByUserId(userId);
    }

    @Override
    public Payment updatePaymentStatus(Long paymentId, Payment.PaymentStatus status) {
        logger.info("Updating payment {} status to {}", paymentId, status);

        Optional<Payment> paymentOpt = paymentRepository.findById(paymentId);
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            payment.setStatus(status);

            if (status == Payment.PaymentStatus.COMPLETED) {
                payment.setPaymentDate(LocalDateTime.now());
            }

            return paymentRepository.save(payment);
        }

        throw new RuntimeException("Payment not found with ID: " + paymentId);
    }

    @Override
    public Payment markPaymentAsCompleted(Long paymentId) {
        return updatePaymentStatus(paymentId, Payment.PaymentStatus.COMPLETED);
    }

    @Override
    public Payment markPaymentAsFailed(Long paymentId, String reason) {
        logger.info("Marking payment {} as failed with reason: {}", paymentId, reason);

        Optional<Payment> paymentOpt = paymentRepository.findById(paymentId);
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            payment.setStatus(Payment.PaymentStatus.FAILED);
            payment.setFailureReason(reason);
            return paymentRepository.save(payment);
        }

        throw new RuntimeException("Payment not found with ID: " + paymentId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean validatePayment(Payment payment) {
        if (payment == null) {
            return false;
        }

        if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        if (payment.getPaymentMethod() == null || payment.getPaymentMethod().trim().isEmpty()) {
            return false;
        }

        if (payment.getOrder() == null) {
            return false;
        }

        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validatePaymentForProcessing(Order order, String paymentMethod) {
        List<String> errors = new ArrayList<>();

        if (order == null) {
            errors.add("Order is required");
            return errors;
        }

        if (order.getTotalAmount() == null || order.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Order amount must be greater than zero");
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            errors.add("Payment method is required");
        }

        // Check if order already has a successful payment
        if (order.getPayment() != null && order.getPayment().isSuccessful()) {
            errors.add("Order already has a successful payment");
        }

        return errors;
    }

    @Override
    @Transactional(readOnly = true)
    public long countPaymentsByStatus(Payment.PaymentStatus status) {
        return paymentRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalPaymentAmount() {
        BigDecimal total = paymentRepository.getTotalPaymentAmount();
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalPaymentAmountBetween(LocalDateTime startDate, LocalDateTime endDate) {
        BigDecimal total = paymentRepository.getTotalPaymentAmountBetween(startDate, endDate);
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getAveragePaymentAmount() {
        BigDecimal average = paymentRepository.getAveragePaymentAmount();
        return average != null ? average : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> searchPayments(String searchTerm) {
        logger.debug("Searching payments with term: {}", searchTerm);
        return paymentRepository.searchPayments(searchTerm);
    }

    @Override
    public Payment simulatePayment(Order order, String paymentMethod) {
        logger.info("Simulating payment for order: {} with method: {}", order.getOrderNumber(), paymentMethod);

        // Create payment record
        Payment payment = new Payment(order, paymentMethod, order.getTotalAmount());

        // Simulate payment processing
        return simulatePaymentProcessing(payment);
    }

    @Override
    public boolean simulatePaymentSuccess() {
        // Simulate 95% success rate for prototype
        return random.nextInt(100) < 95;
    }

    @Override
    public String generateMockTransactionId() {
        return "MOCK-" + System.currentTimeMillis() + "-" + random.nextInt(1000);
    }

    /**
     * Simulates payment processing for prototype
     */
    private Payment simulatePaymentProcessing(Payment payment) {
        logger.info("Simulating payment processing for transaction: {}", payment.getTransactionId());

        try {
            // Simulate processing delay
            Thread.sleep(1000 + random.nextInt(2000));

            // Simulate payment success/failure
            boolean success = simulatePaymentSuccess();

            if (success) {
                payment.setStatus(Payment.PaymentStatus.COMPLETED);
                payment.setPaymentDate(LocalDateTime.now());
                payment.setGatewayResponse("Payment processed successfully");
                logger.info("Payment completed successfully: {}", payment.getTransactionId());
            } else {
                payment.setStatus(Payment.PaymentStatus.FAILED);
                payment.setFailureReason("Simulated payment failure for testing");
                logger.info("Payment failed: {}", payment.getTransactionId());
            }

            return paymentRepository.save(payment);

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            payment.setStatus(Payment.PaymentStatus.FAILED);
            payment.setFailureReason("Payment processing interrupted");
            return paymentRepository.save(payment);
        }
    }
}
