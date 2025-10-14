package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.exception.BusinessException;
import com.nakhandev.ecommercecart.exception.ValidationException;
import com.nakhandev.ecommercecart.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Service for complex business rule validation
 */
@Service
public class BusinessValidationService {

    private final UserService userService;
    private final ProductService productService;
    private final CartService cartService;
    private final OrderService orderService;

    @Autowired
    public BusinessValidationService(UserService userService,
                                   ProductService productService,
                                   CartService cartService,
                                   OrderService orderService) {
        this.userService = userService;
        this.productService = productService;
        this.cartService = cartService;
        this.orderService = orderService;
    }

    /**
     * Validate user registration business rules
     */
    public List<String> validateUserRegistration(User user) {
        List<String> errors = new ArrayList<>();

        // Check if username is already taken
        if (userService.existsByUsername(user.getUsername())) {
            errors.add("Username is already taken");
        }

        // Check if email is already registered
        if (userService.existsByEmail(user.getEmail())) {
            errors.add("Email is already registered");
        }

        // Validate username format (additional business rules)
        if (user.getUsername().contains("admin") || user.getUsername().contains("root")) {
            errors.add("Username cannot contain reserved words");
        }

        // Validate email domain (business rule - example)
        String emailDomain = user.getEmail().substring(user.getEmail().indexOf("@") + 1);
        if (emailDomain.equals("tempmail.com") || emailDomain.equals("10minutemail.com")) {
            errors.add("Temporary email addresses are not allowed");
        }

        return errors;
    }

    /**
     * Validate order placement business rules
     */
    public List<String> validateOrderPlacement(Long userId, Long cartId) {
        List<String> errors = new ArrayList<>();

        // Check if user exists and is active
        User user = userService.findUserById(userId).orElse(null);
        if (user == null) {
            errors.add("User not found");
        } else if (!user.getIsActive()) {
            errors.add("User account is not active");
        }

        // Validate cart
        if (cartId != null) {
            Cart cart = cartService.findCartByUserId(cartId).orElse(null);
            if (cart == null) {
                errors.add("Cart not found");
            } else {
                // Check cart items
                List<String> cartErrors = cartService.validateCartItems(userId);
                errors.addAll(cartErrors);

                // Check minimum order amount
                if (cart.getTotalAmount().compareTo(new BigDecimal("100")) < 0) {
                    errors.add("Minimum order amount is ₹100");
                }

                // Check maximum order amount (business rule)
                if (cart.getTotalAmount().compareTo(new BigDecimal("100000")) > 0) {
                    errors.add("Maximum order amount is ₹100,000");
                }
            }
        }

        return errors;
    }

    /**
     * Validate product addition to cart
     */
    public List<String> validateProductAddition(Long userId, Long productId, Integer quantity) {
        List<String> errors = new ArrayList<>();

        // Check if product exists and is available
        Product product = productService.findProductById(productId).orElse(null);
        if (product == null) {
            errors.add("Product not found");
        } else {
            // Check if product is active
            if (!product.getIsActive()) {
                errors.add("Product is not available");
            }

            // Check stock availability
            if (!product.isInStock()) {
                errors.add("Product is out of stock");
            } else if (product.getStockQuantity() < quantity) {
                errors.add(String.format("Only %d items available in stock", product.getStockQuantity()));
            }

            // Check quantity limits
            if (quantity > 10) {
                errors.add("Maximum 10 items allowed per product");
            }

            // Business rule: Premium products require minimum quantity
            if (product.getPrice().compareTo(new BigDecimal("5000")) > 0 && quantity < 1) {
                errors.add("Premium products require minimum quantity of 1");
            }
        }

        // Check user cart limits
        List<CartItem> currentCartItems = cartService.getCartItems(userId);
        int totalItemsInCart = currentCartItems.stream().mapToInt(CartItem::getQuantity).sum();

        if (totalItemsInCart + quantity > 50) {
            errors.add("Maximum 50 items allowed in cart");
        }

        return errors;
    }

    /**
     * Validate payment processing
     */
    public List<String> validatePaymentProcessing(Long orderId, String paymentMethod) {
        List<String> errors = new ArrayList<>();

        // Find order
        Order order = orderService.findOrderById(orderId).orElse(null);
        if (order == null) {
            errors.add("Order not found");
        } else {
            // Check order status
            if (order.getStatus() != Order.OrderStatus.PENDING) {
                errors.add("Order is not in valid state for payment");
            }

            // Check payment method
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                errors.add("Payment method is required");
            } else {
                // Validate payment method based on order amount
                if (order.getTotalAmount().compareTo(new BigDecimal("50000")) > 0 &&
                    "COD".equals(paymentMethod)) {
                    errors.add("Cash on Delivery is not available for orders above ₹50,000");
                }
            }

            // Check order amount limits
            if (order.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
                errors.add("Invalid order amount");
            }

            if (order.getTotalAmount().compareTo(new BigDecimal("200000")) > 0) {
                errors.add("Order amount exceeds maximum limit");
            }
        }

        return errors;
    }

    /**
     * Validate order cancellation
     */
    public List<String> validateOrderCancellation(Long orderId) {
        List<String> errors = new ArrayList<>();

        Order order = orderService.findOrderById(orderId).orElse(null);
        if (order == null) {
            errors.add("Order not found");
        } else {
            // Check if order can be cancelled based on status
            if (!order.canBeCancelled()) {
                errors.add("Order cannot be cancelled in current status");
            }

            // Check if order is too old to cancel (business rule: 24 hours)
            if (order.getOrderDate().isBefore(LocalDateTime.now().minusHours(24))) {
                errors.add("Order cannot be cancelled after 24 hours");
            }

            // Check if payment is already processed
            if (order.getPayment() != null && order.getPayment().isSuccessful()) {
                errors.add("Cannot cancel order with completed payment");
            }
        }

        return errors;
    }

    /**
     * Validate product update (admin operations)
     */
    public List<String> validateProductUpdate(Product product) {
        List<String> errors = new ArrayList<>();

        // Check if product name is unique (check existing products with same name)
        List<Product> productsWithSameName = productService.searchProducts(product.getName());
        boolean nameExists = productsWithSameName.stream()
                .anyMatch(p -> !p.getId().equals(product.getId()) &&
                              p.getName().equalsIgnoreCase(product.getName()));

        if (nameExists) {
            errors.add("Product name already exists");
        }

        // Validate price ranges
        if (product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Product price must be greater than zero");
        }

        if (product.getPrice().compareTo(new BigDecimal("1000000")) > 0) {
            errors.add("Product price cannot exceed ₹10,00,000");
        }

        // Validate discount percentage
        if (product.getDiscountPercentage().compareTo(BigDecimal.ZERO) < 0 ||
            product.getDiscountPercentage().compareTo(BigDecimal.valueOf(90)) > 0) {
            errors.add("Discount percentage must be between 0% and 90%");
        }

        // Validate stock quantity
        if (product.getStockQuantity() < 0) {
            errors.add("Stock quantity cannot be negative");
        }

        if (product.getStockQuantity() > 10000) {
            errors.add("Stock quantity cannot exceed 10,000 units");
        }

        return errors;
    }

    /**
     * Validate business operation with exception throwing
     */
    public void validateOrThrow(String operation, List<String> errors) {
        if (!errors.isEmpty()) {
            String errorMessage = String.format("Validation failed for %s: %s",
                  operation, String.join(", ", errors));
            throw new ValidationException(errorMessage, errors);
        }
    }

    /**
     * Validate business rule with exception throwing
     */
    public void validateBusinessRule(boolean condition, String errorMessage) {
        if (!condition) {
            throw new BusinessException(errorMessage);
        }
    }

    /**
     * Validate business rule with formatted message
     */
    public void validateBusinessRule(boolean condition, String errorMessage, Object... parameters) {
        if (!condition) {
            String formattedMessage = String.format(errorMessage, parameters);
            throw new BusinessException(formattedMessage, parameters);
        }
    }
}
