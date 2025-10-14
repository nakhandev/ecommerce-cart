package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.dto.payment.PaymentGatewayRequest;
import com.nakhandev.ecommercecart.dto.payment.PaymentGatewayResponse;

import java.math.BigDecimal;

/**
 * Payment Gateway Service Interface
 * Provides abstraction for different payment gateway providers
 */
public interface PaymentGatewayService {

    /**
     * Process payment through the gateway
     */
    PaymentGatewayResponse processPayment(PaymentGatewayRequest request);

    /**
     * Get payment status from gateway
     */
    PaymentGatewayResponse getPaymentStatus(String transactionId);

    /**
     * Refund payment through gateway
     */
    PaymentGatewayResponse refundPayment(String transactionId, BigDecimal amount);

    /**
     * Validate payment request
     */
    boolean validatePaymentRequest(PaymentGatewayRequest request);

    /**
     * Get gateway name
     */
    String getGatewayName();

    /**
     * Check if gateway is available
     */
    boolean isAvailable();
}
