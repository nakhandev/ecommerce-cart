package com.nakhandev.ecommercecart.exception;

/**
 * Exception thrown when business rules are violated
 */
public class BusinessException extends EcommerceException {

    public BusinessException(String message) {
        super("BUSINESS_RULE_VIOLATION", message);
    }

    public BusinessException(String message, Object... parameters) {
        super("BUSINESS_RULE_VIOLATION", message, parameters);
    }

    public BusinessException(String message, Throwable cause) {
        super("BUSINESS_RULE_VIOLATION", message, cause);
    }

    // Specific business exception types
    public static class InsufficientStockException extends BusinessException {
        public InsufficientStockException(String productName, int requested, int available) {
            super(String.format("Insufficient stock for product '%s'. Requested: %d, Available: %d",
                  productName, requested, available), productName, requested, available);
        }
    }

    public static class ProductNotAvailableException extends BusinessException {
        public ProductNotAvailableException(String productName) {
            super(String.format("Product '%s' is not available", productName), productName);
        }
    }

    public static class InvalidOrderStateException extends BusinessException {
        public InvalidOrderStateException(String orderNumber, String currentState) {
            super(String.format("Order %s is in invalid state '%s' for this operation",
                  orderNumber, currentState), orderNumber, currentState);
        }
    }

    public static class PaymentProcessingException extends BusinessException {
        public PaymentProcessingException(String message) {
            super("Payment processing failed: " + message, message);
        }

        public PaymentProcessingException(String message, Throwable cause) {
            super("Payment processing failed: " + message, cause, message);
        }
    }

    public static class CartValidationException extends BusinessException {
        public CartValidationException(String message) {
            super("Cart validation failed: " + message, message);
        }
    }
}
