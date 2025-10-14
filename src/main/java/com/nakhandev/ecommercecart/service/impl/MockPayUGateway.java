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
 * Mock PayU Payment Gateway Implementation
 * Simulates PayU payment gateway behavior for testing
 */
@Service("payuGateway")
public class MockPayUGateway implements PaymentGatewayService {

    private static final Logger logger = LoggerFactory.getLogger(MockPayUGateway.class);
    private static final Random random = new Random();

    @Override
    public PaymentGatewayResponse processPayment(PaymentGatewayRequest request) {
        logger.info("Processing payment via Mock PayU Gateway for order: {}", request.getOrder().getOrderNumber());

        try {
            // Simulate API call delay (PayU is typically faster)
            Thread.sleep(1000 + random.nextInt(800));

            // Validate request
            if (!validatePaymentRequest(request)) {
                return new PaymentGatewayResponse(false, "Invalid payment request");
            }

            // Generate mock transaction ID
            String transactionId = generatePayUTransactionId();
            String gatewayTransactionId = "payu_" + System.currentTimeMillis();

            // Simulate different payment scenarios
            PaymentScenario scenario = determinePaymentScenario(request);

            switch (scenario) {
                case SUCCESS:
                    return createSuccessResponse(transactionId, gatewayTransactionId, request);

                case UPI_FAILED:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "UPI transaction failed. Please try again or use a different payment method.");

                case NET_BANKING_ERROR:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Net banking session expired. Please try again.");

                case WALLET_INSUFFICIENT:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Insufficient balance in your wallet.");

                case CVV_MISMATCH:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Card verification failed. Please check your CVV and try again.");

                case EXPIRED_CARD:
                    return new PaymentGatewayResponse(false, transactionId, "failed",
                        "Your card has expired. Please use a different card.");

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
            Thread.sleep(150 + random.nextInt(200));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Mock status response
        Map<String, Object> statusData = new HashMap<>();
        statusData.put("pg_type", "UPI");
        statusData.put("bank_ref_num", "123456789");
        statusData.put("bankcode", "UTIB");

        PaymentGatewayResponse response = new PaymentGatewayResponse(true, transactionId, "success", "Payment completed");
        response.setAdditionalData(statusData);

        return response;
    }

    @Override
    public PaymentGatewayResponse refundPayment(String transactionId, BigDecimal amount) {
        logger.info("Processing refund for transaction: {} amount: {}", transactionId, amount);

        try {
            Thread.sleep(800 + random.nextInt(400));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 95% success rate for refunds (higher than Razorpay)
        if (random.nextInt(100) < 95) {
            Map<String, Object> refundData = new HashMap<>();
            refundData.put("refund_id", "payu_rfnd_" + System.currentTimeMillis());
            refundData.put("amount", amount);
            refundData.put("currency", "INR");
            refundData.put("status", "refunded");

            PaymentGatewayResponse response = new PaymentGatewayResponse(true, "Refund processed successfully");
            response.setAdditionalData(refundData);
            return response;
        } else {
            return new PaymentGatewayResponse(false, "Refund processing failed - insufficient balance");
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

        // PayU specific validations
        String method = request.getPaymentMethod();
        if ("UPI".equals(method) && request.getAdditionalData() != null) {
            String upiId = (String) request.getAdditionalData().get("upiId");
            if (upiId == null || !upiId.contains("@")) {
                return false;
            }
        }

        return true;
    }

    @Override
    public String getGatewayName() {
        return "MOCK_PAYU";
    }

    @Override
    public boolean isAvailable() {
        // Simulate 98% uptime (higher than Razorpay)
        return random.nextInt(100) < 98;
    }

    private PaymentGatewayResponse createSuccessResponse(String transactionId, String gatewayTransactionId, PaymentGatewayRequest request) {
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("payu_payment_id", gatewayTransactionId);
        responseData.put("method", request.getPaymentMethod());
        responseData.put("amount", request.getAmount());
        responseData.put("currency", request.getCurrency());
        responseData.put("status", "success");
        responseData.put("txn_datetime", System.currentTimeMillis() / 1000);
        responseData.put("hash", generateMockHash());

        PaymentGatewayResponse response = new PaymentGatewayResponse(true, transactionId, "completed", "Payment successful");
        response.setGatewayTransactionId(gatewayTransactionId);
        response.setAdditionalData(responseData);

        return response;
    }

    private String generatePayUTransactionId() {
        return "TXN-" + System.currentTimeMillis() + "-" + String.format("%06d", random.nextInt(1000000));
    }

    private String generateMockHash() {
        return "mock_hash_" + System.currentTimeMillis();
    }

    private PaymentScenario determinePaymentScenario(PaymentGatewayRequest request) {
        // Simulate different failure scenarios based on payment method and amount
        String method = request.getPaymentMethod();
        BigDecimal amount = request.getAmount();

        // UPI payments occasionally fail
        if ("UPI".equals(method)) {
            int rand = random.nextInt(100);
            if (rand < 8) return PaymentScenario.UPI_FAILED;
            if (rand < 12) return PaymentScenario.NETWORK_ERROR;
        }

        // Net banking has specific failure scenarios
        if ("NET_BANKING".equals(method)) {
            int rand = random.nextInt(100);
            if (rand < 6) return PaymentScenario.NET_BANKING_ERROR;
            if (rand < 10) return PaymentScenario.NETWORK_ERROR;
        }

        // Wallet payments
        if ("WALLET".equals(method)) {
            int rand = random.nextInt(100);
            if (rand < 7) return PaymentScenario.WALLET_INSUFFICIENT;
        }

        // Card payments
        if ("CARD".equals(method)) {
            int rand = random.nextInt(100);
            if (rand < 4) return PaymentScenario.CVV_MISMATCH;
            if (rand < 8) return PaymentScenario.EXPIRED_CARD;
            if (rand < 12) return PaymentScenario.NETWORK_ERROR;
        }

        // Very high amounts occasionally fail
        if (amount.compareTo(new BigDecimal(10000)) > 0) {
            if (random.nextInt(100) < 30) {
                return PaymentScenario.INSUFFICIENT_FUNDS;
            }
        }

        // Random failures for comprehensive testing
        int rand = random.nextInt(1000);
        if (rand < 60) return PaymentScenario.SUCCESS;
        if (rand < 65) return PaymentScenario.UPI_FAILED;
        if (rand < 70) return PaymentScenario.NET_BANKING_ERROR;
        if (rand < 75) return PaymentScenario.WALLET_INSUFFICIENT;
        if (rand < 80) return PaymentScenario.CVV_MISMATCH;
        if (rand < 85) return PaymentScenario.EXPIRED_CARD;
        if (rand < 90) return PaymentScenario.NETWORK_ERROR;

        return PaymentScenario.SUCCESS;
    }

    private enum PaymentScenario {
        SUCCESS,
        UPI_FAILED,
        NET_BANKING_ERROR,
        WALLET_INSUFFICIENT,
        CVV_MISMATCH,
        EXPIRED_CARD,
        NETWORK_ERROR,
        INSUFFICIENT_FUNDS
    }
}
