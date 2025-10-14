package com.nakhandev.ecommercecart.dto.payment;

import java.util.Map;

/**
 * Payment Gateway Response DTO
 */
public class PaymentGatewayResponse {
    private boolean success;
    private String transactionId;
    private String status;
    private String message;
    private String gatewayTransactionId;
    private Map<String, Object> additionalData;

    public PaymentGatewayResponse() {}

    public PaymentGatewayResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public PaymentGatewayResponse(boolean success, String transactionId, String status, String message) {
        this.success = success;
        this.transactionId = transactionId;
        this.status = status;
        this.message = message;
    }

    // Getters and Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getGatewayTransactionId() { return gatewayTransactionId; }
    public void setGatewayTransactionId(String gatewayTransactionId) { this.gatewayTransactionId = gatewayTransactionId; }

    public Map<String, Object> getAdditionalData() { return additionalData; }
    public void setAdditionalData(Map<String, Object> additionalData) { this.additionalData = additionalData; }
}
