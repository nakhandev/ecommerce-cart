package com.nakhandev.ecommercecart.exception;

/**
 * Exception thrown when a requested resource is not found
 */
public class ResourceNotFoundException extends EcommerceException {

    public ResourceNotFoundException(String resourceType, Object identifier) {
        super("RESOURCE_NOT_FOUND",
              String.format("%s not found with identifier: %s", resourceType, identifier),
              resourceType, identifier);
    }

    public ResourceNotFoundException(String message) {
        super("RESOURCE_NOT_FOUND", message);
    }

    public ResourceNotFoundException(String message, Throwable cause) {
        super("RESOURCE_NOT_FOUND", message, cause);
    }

    // Specific resource not found exceptions
    public static class UserNotFoundException extends ResourceNotFoundException {
        public UserNotFoundException(Long userId) {
            super("User", userId);
        }

        public UserNotFoundException(String username) {
            super("User with username: " + username);
        }
    }

    public static class ProductNotFoundException extends ResourceNotFoundException {
        public ProductNotFoundException(Long productId) {
            super("Product", productId);
        }

        public ProductNotFoundException(String productName) {
            super("Product with name: " + productName);
        }
    }

    public static class OrderNotFoundException extends ResourceNotFoundException {
        public OrderNotFoundException(Long orderId) {
            super("Order", orderId);
        }

        public OrderNotFoundException(String orderNumber) {
            super("Order with number: " + orderNumber);
        }
    }

    public static class CartNotFoundException extends ResourceNotFoundException {
        public CartNotFoundException(Long userId) {
            super("Cart for user", userId);
        }
    }

    public static class CategoryNotFoundException extends ResourceNotFoundException {
        public CategoryNotFoundException(Long categoryId) {
            super("Category", categoryId);
        }

        public CategoryNotFoundException(String categoryName) {
            super("Category with name: " + categoryName);
        }
    }

    public static class PaymentNotFoundException extends ResourceNotFoundException {
        public PaymentNotFoundException(Long paymentId) {
            super("Payment", paymentId);
        }

        public PaymentNotFoundException(String transactionId) {
            super("Payment with transaction ID: " + transactionId);
        }
    }
}
