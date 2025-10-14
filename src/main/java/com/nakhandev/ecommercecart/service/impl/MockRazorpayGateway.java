package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.dto.payment.PaymentGatewayRequest;
import com.nakhandev.ecommercecart.dto.payment.PaymentGatewayResponse;
import com.nakhandev.ecommercecart.service.PaymentGatewayService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * Mock Razorpay Payment Gateway Implementation
 * Simulates Razorpay payment gateway behavior for testing
 */
@Service("razorpayGateway")
public class MockRazorpayGateway implements PaymentGatewayService {

    private static final Logger logger = LoggerFactory.getLogger(MockRazorpayGateway.class);
    private static final Random random = new Random();

    @Override
    public PaymentGatewayResponse processPayment(PaymentGatewayRequest request) {
        logger.info("Processing payment via Mock Razorpay Gateway for order: {}", request.getOrder().getOrderNumber());

        try {
            // Simulate API call delay
            Thread.sleep(1500 + random.nextInt(1000));

            // Validate request
            if (!validatePaymentRequest(request)) {
                return new PaymentGatewayResponse(false, "Invalid payment request");
            }

            // Generate mock transaction ID
            String transactionId = generateRazorpayTransactionId();
            String gatewayTransactionId = "rzp_" + System.currentTimeMillis();

            // Simulate different payment scenarios
            PaymentScenario scenario = determinePaymentScenario(request);

            switch (scenario) {
                case SUCCESS:
                    return createSuccessResponse(transactionId, gatewayTransactionId, request);

                case CARD_DECLINED:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Your card was declined. Please try a different payment method.");

                case INSUFFICIENT_FUNDS:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Insufficient funds in your account.");

                case NETWORK_ERROR:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Network error occurred. Please check your connection and try again.");

                case TIMEOUT:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Payment request timed out. Please try again.");

                default:
                    return createSuccessResponse(transactionId, gatewayTransactionId, request);
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return new PaymentGatewayResponse(false, "Payment processing interrupted");
        }
    }

    @Override
    public PaymentGatewayResponse getPaymentStatus(String transactionId) {
        logger.debug("Getting payment status for transaction: {}", transactionId);

        // Simulate API call
        try {
            Thread.sleep(200 + random.nextInt(300));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Mock status response
        Map<String, Object> statusData = new HashMap<>();
        statusData.put("method", "card");
        statusData.put("amount", 1000);
        statusData.put("currency", "INR");

        PaymentGatewayResponse response = new PaymentGatewayResponse(true, transactionId, "paid", "Payment completed");
        response.setAdditionalData(statusData);

        return response;
    }

    @Override
    public PaymentGatewayResponse refundPayment(String transactionId, BigDecimal amount) {
        logger.info("Processing refund for transaction: {} amount: {}", transactionId, amount);

        try {
            Thread.sleep(1000 + random.nextInt(500));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 90% success rate for refunds
        if (random.nextInt(100) < 90) {
            Map<String, Object> refundData = new HashMap<>();
            refundData.put("refund_id", "rfnd_" + System.currentTimeMillis());
            refundData.put("amount", amount);
            refundData.put("currency", "INR");

            PaymentGatewayResponse response = new PaymentGatewayResponse(true, "Refund processed successfully");
            response.setAdditionalData(refundData);
            return response;
        } else {
            return new PaymentGatewayResponse(false, "Refund processing failed");
        }
    }

    @Override
    public boolean validatePaymentRequest(PaymentGatewayRequest request) {
        if (request == null || request.getOrder() == null) {
            return false;
        }

        if (request.getAmount() == null || request.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        if (request.getPaymentMethod() == null || request.getPaymentMethod().trim().isEmpty()) {
            return false;
        }

        return true;
    }

    @Override
    public String getGatewayName() {
        return "MOCK_RAZORPAY";
    }

    @Override
    public boolean isAvailable() {
        // Simulate 99% uptime
        return random.nextInt(100) < 99;
    }

    private PaymentGatewayResponse createSuccessResponse(String transactionId, String gatewayTransactionId, PaymentGatewayRequest request) {
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("razorpay_payment_id", gatewayTransactionId);
        responseData.put("method", request.getPaymentMethod());
        responseData.put("amount", request.getAmount().multiply(new BigDecimal(100))); // Razorpay uses paise
        responseData.put("currency", request.getCurrency());
        responseData.put("status", "captured");
        responseData.put("created_at", System.currentTimeMillis() / 1000);

        PaymentGatewayResponse response = new PaymentGatewayResponse(true, transactionId, "completed", "Payment successful");
        response.setGatewayTransactionId(gatewayTransactionId);
        response.setAdditionalData(responseData);

        return response;
    }

    private String generateRazorpayTransactionId() {
        return "TXN-" + System.currentTimeMillis() + "-" + String.format("%04d", random.nextInt(10000));
    }

    private PaymentScenario determinePaymentScenario(PaymentGatewayRequest request) {
        // Simulate different failure scenarios based on payment method and amount
        String method = request.getPaymentMethod();
        BigDecimal amount = request.getAmount();

        // Card payments have higher failure rate for testing
        if ("CARD".equals(method)) {
            int rand = random.nextInt(100);
            if (rand < 5) return PaymentScenario.CARD_DECLINED;
            if (rand < 10) return PaymentScenario.INSUFFICIENT_FUNDS;
            if (rand < 12) return PaymentScenario.NETWORK_ERROR;
        }

        // High amounts occasionally fail
        if (amount.compareTo(new BigDecimal(5000)) > 0) {
            if (random.nextInt(100) < 20) {
                return PaymentScenario.INSUFFICIENT_FUNDS;
            }
        }

        // Random failures for testing
        int rand = random.nextInt(1000);
        if (rand < 50) return PaymentScenario.SUCCESS;
        if (rand < 60) return PaymentScenario.CARD_DECLINED;
        if (rand < 70) return PaymentScenario.INSUFFICIENT_FUNDS;
        if (rand < 75) return PaymentScenario.NETWORK_ERROR;
        if (rand < 80) return PaymentScenario.TIMEOUT;

        return PaymentScenario.SUCCESS;
    }

    private enum PaymentScenario {
        SUCCESS,
        CARD_DECLINED,
        INSUFFICIENT_FUNDS,
        NETWORK_ERROR,
        TIMEOUT
    }
}
