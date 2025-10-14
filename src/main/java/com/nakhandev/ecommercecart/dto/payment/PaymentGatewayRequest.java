package com.nakhandev.ecommercecart.dto.payment;

import com.nakhandev.ecommercecart.model.Order;

import java.math.BigDecimal;
import java.util.Map;

/**
 * Payment Gateway Request DTO
 */
public class PaymentGatewayRequest {
    private Order order;
    private String paymentMethod;
    private BigDecimal amount;
    private String currency;
    private Map<String, Object> additionalData;

    public PaymentGatewayRequest() {}

    public PaymentGatewayRequest(Order order, String paymentMethod, BigDecimal amount) {
        this.order = order;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
        this.currency = "INR";
    }

    // Getters and Setters
    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public Map<String, Object> getAdditionalData() { return additionalData; }
    public void setAdditionalData(Map<String, Object> additionalData) { this.additionalData = additionalData; }
}
