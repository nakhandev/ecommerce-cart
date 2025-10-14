package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.controller.common.BaseController;
import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.dto.payment.PaymentSummaryDTO;
import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.model.Payment;
import com.nakhandev.ecommercecart.service.OrderService;
import com.nakhandev.ecommercecart.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*") // Configure appropriately for production
public class PaymentController extends BaseController {

    private final PaymentService paymentService;
    private final OrderService orderService;

    @Autowired
    public PaymentController(PaymentService paymentService, OrderService orderService) {
        this.paymentService = paymentService;
        this.orderService = orderService;
    }

    /**
     * Process payment for order
     */
    @PostMapping("/process")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> processPayment(
            @RequestParam Long orderId,
            @RequestParam String paymentMethod) {

        logControllerEntry("processPayment", orderId, paymentMethod);

        try {
            // Get order from database first
            Optional<Order> orderOpt = orderService.findOrderById(orderId);
            if (orderOpt.isEmpty()) {
                return createNotFoundResponse("Order not found with ID: " + orderId);
            }

            Payment payment = paymentService.processPayment(orderOpt.get(), paymentMethod);
            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(payment);

            logControllerExit("processPayment", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("processPayment", e);
            return createErrorResponse("Failed to process payment: " + e.getMessage());
        }
    }

    /**
     * Get payment by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> getPaymentById(@PathVariable Long id) {

        logControllerEntry("getPaymentById", id);

        try {
            Optional<Payment> paymentOpt = paymentService.findPaymentById(id);
            if (paymentOpt.isEmpty()) {
                return createNotFoundResponse("Payment not found with ID: " + id);
            }

            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(paymentOpt.get());
            logControllerExit("getPaymentById", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getPaymentById", e);
            return createErrorResponse("Failed to get payment: " + e.getMessage());
        }
    }

    /**
     * Get payment by transaction ID
     */
    @GetMapping("/transaction/{transactionId}")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> getPaymentByTransactionId(
            @PathVariable String transactionId) {

        logControllerEntry("getPaymentByTransactionId", transactionId);

        try {
            Optional<Payment> paymentOpt = paymentService.findByTransactionId(transactionId);
            if (paymentOpt.isEmpty()) {
                return createNotFoundResponse("Payment not found with transaction ID: " + transactionId);
            }

            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(paymentOpt.get());
            logControllerExit("getPaymentByTransactionId", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getPaymentByTransactionId", e);
            return createErrorResponse("Failed to get payment: " + e.getMessage());
        }
    }

    /**
     * Get payment by order ID
     */
    @GetMapping("/order/{orderId}")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> getPaymentByOrderId(@PathVariable Long orderId) {

        logControllerEntry("getPaymentByOrderId", orderId);

        try {
            Optional<Payment> paymentOpt = paymentService.findByOrderId(orderId);
            if (paymentOpt.isEmpty()) {
                return createNotFoundResponse("Payment not found for order ID: " + orderId);
            }

            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(paymentOpt.get());
            logControllerExit("getPaymentByOrderId", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getPaymentByOrderId", e);
            return createErrorResponse("Failed to get payment: " + e.getMessage());
        }
    }

    /**
     * Get payments by status
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<PaymentSummaryDTO>>> getPaymentsByStatus(
            @PathVariable Payment.PaymentStatus status) {

        logControllerEntry("getPaymentsByStatus", status);

        try {
            List<Payment> payments = paymentService.findByStatus(status);
            List<PaymentSummaryDTO> paymentDTOs = payments.stream()
                    .map(PaymentSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getPaymentsByStatus", paymentDTOs);
            return createSuccessResponse(paymentDTOs);

        } catch (Exception e) {
            logError("getPaymentsByStatus", e);
            return createErrorResponse("Failed to get payments by status: " + e.getMessage());
        }
    }

    /**
     * Get payments by method
     */
    @GetMapping("/method/{method}")
    public ResponseEntity<ApiResponse<List<PaymentSummaryDTO>>> getPaymentsByMethod(
            @PathVariable String method) {

        logControllerEntry("getPaymentsByMethod", method);

        try {
            List<Payment> payments = paymentService.findByPaymentMethod(method);
            List<PaymentSummaryDTO> paymentDTOs = payments.stream()
                    .map(PaymentSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getPaymentsByMethod", paymentDTOs);
            return createSuccessResponse(paymentDTOs);

        } catch (Exception e) {
            logError("getPaymentsByMethod", e);
            return createErrorResponse("Failed to get payments by method: " + e.getMessage());
        }
    }

    /**
     * Get payments by user ID
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<List<PaymentSummaryDTO>>> getPaymentsByUserId(
            @PathVariable Long userId) {

        logControllerEntry("getPaymentsByUserId", userId);

        try {
            List<Payment> payments = paymentService.findByUserId(userId);
            List<PaymentSummaryDTO> paymentDTOs = payments.stream()
                    .map(PaymentSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getPaymentsByUserId", paymentDTOs);
            return createSuccessResponse(paymentDTOs);

        } catch (Exception e) {
            logError("getPaymentsByUserId", e);
            return createErrorResponse("Failed to get payments by user: " + e.getMessage());
        }
    }

    /**
     * Search payments
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<PaymentSummaryDTO>>> searchPayments(
            @RequestParam String searchTerm) {

        logControllerEntry("searchPayments", searchTerm);

        try {
            List<Payment> payments = paymentService.searchPayments(searchTerm);
            List<PaymentSummaryDTO> paymentDTOs = payments.stream()
                    .map(PaymentSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("searchPayments", paymentDTOs);
            return createSuccessResponse(paymentDTOs);

        } catch (Exception e) {
            logError("searchPayments", e);
            return createErrorResponse("Failed to search payments: " + e.getMessage());
        }
    }

    /**
     * Update payment status (admin only)
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> updatePaymentStatus(
            @PathVariable Long id,
            @RequestParam Payment.PaymentStatus status) {

        logControllerEntry("updatePaymentStatus", id, status);

        try {
            Payment updatedPayment = paymentService.updatePaymentStatus(id, status);
            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(updatedPayment);

            logControllerExit("updatePaymentStatus", responseDTO);
            return createSuccessResponse("Payment status updated successfully", responseDTO);

        } catch (Exception e) {
            logError("updatePaymentStatus", e);
            return createErrorResponse("Failed to update payment status: " + e.getMessage());
        }
    }

    /**
     * Mark payment as completed (admin only)
     */
    @PutMapping("/{id}/complete")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> markPaymentAsCompleted(@PathVariable Long id) {

        logControllerEntry("markPaymentAsCompleted", id);

        try {
            Payment completedPayment = paymentService.markPaymentAsCompleted(id);
            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(completedPayment);

            logControllerExit("markPaymentAsCompleted", responseDTO);
            return createSuccessResponse("Payment marked as completed", responseDTO);

        } catch (Exception e) {
            logError("markPaymentAsCompleted", e);
            return createErrorResponse("Failed to mark payment as completed: " + e.getMessage());
        }
    }

    /**
     * Mark payment as failed (admin only)
     */
    @PutMapping("/{id}/fail")
    public ResponseEntity<ApiResponse<PaymentSummaryDTO>> markPaymentAsFailed(
            @PathVariable Long id,
            @RequestParam String reason) {

        logControllerEntry("markPaymentAsFailed", id, reason);

        try {
            Payment failedPayment = paymentService.markPaymentAsFailed(id, reason);
            PaymentSummaryDTO responseDTO = PaymentSummaryDTO.fromEntity(failedPayment);

            logControllerExit("markPaymentAsFailed", responseDTO);
            return createSuccessResponse("Payment marked as failed", responseDTO);

        } catch (Exception e) {
            logError("markPaymentAsFailed", e);
            return createErrorResponse("Failed to mark payment as failed: " + e.getMessage());
        }
    }

    /**
     * Get payment statistics (admin only)
     */
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<PaymentStats>> getPaymentStats() {

        logControllerEntry("getPaymentStats");

        try {
            long completedPayments = paymentService.countPaymentsByStatus(Payment.PaymentStatus.COMPLETED);
            long failedPayments = paymentService.countPaymentsByStatus(Payment.PaymentStatus.FAILED);
            long pendingPayments = paymentService.countPaymentsByStatus(Payment.PaymentStatus.PENDING);
            BigDecimal totalAmount = paymentService.getTotalPaymentAmount();
            BigDecimal averageAmount = paymentService.getAveragePaymentAmount();

            PaymentStats stats = new PaymentStats(completedPayments, failedPayments, pendingPayments,
                    totalAmount, averageAmount);

            logControllerExit("getPaymentStats", stats);
            return createSuccessResponse(stats);

        } catch (Exception e) {
            logError("getPaymentStats", e);
            return createErrorResponse("Failed to get payment statistics: " + e.getMessage());
        }
    }

    /**
     * Get all payments (admin only)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<PaymentSummaryDTO>>> getAllPayments() {

        logControllerEntry("getAllPayments");

        try {
            List<Payment> payments = paymentService.findAllPayments();
            List<PaymentSummaryDTO> paymentDTOs = payments.stream()
                    .map(PaymentSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getAllPayments", paymentDTOs);
            return createSuccessResponse(paymentDTOs);

        } catch (Exception e) {
            logError("getAllPayments", e);
            return createErrorResponse("Failed to get payments: " + e.getMessage());
        }
    }

    // Inner class for payment statistics
    public static class PaymentStats {
        private long completedPayments;
        private long failedPayments;
        private long pendingPayments;
        private BigDecimal totalAmount;
        private BigDecimal averageAmount;

        public PaymentStats(long completedPayments, long failedPayments, long pendingPayments,
                           BigDecimal totalAmount, BigDecimal averageAmount) {
            this.completedPayments = completedPayments;
            this.failedPayments = failedPayments;
            this.pendingPayments = pendingPayments;
            this.totalAmount = totalAmount;
            this.averageAmount = averageAmount;
        }

        // Getters
        public long getCompletedPayments() { return completedPayments; }
        public long getFailedPayments() { return failedPayments; }
        public long getPendingPayments() { return pendingPayments; }
        public BigDecimal getTotalAmount() { return totalAmount; }
        public BigDecimal getAverageAmount() { return averageAmount; }
        public String getDisplayTotalAmount() { return String.format("₹%.2f", totalAmount); }
        public String getDisplayAverageAmount() { return String.format("₹%.2f", averageAmount); }
    }
}
