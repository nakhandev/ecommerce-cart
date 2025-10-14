package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.*;
import com.nakhandev.ecommercecart.repository.OrderRepository;
import com.nakhandev.ecommercecart.service.CartService;
import com.nakhandev.ecommercecart.service.OrderService;
import com.nakhandev.ecommercecart.service.PaymentService;
import com.nakhandev.ecommercecart.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    private static final Logger logger = LoggerFactory.getLogger(OrderServiceImpl.class);

    private final OrderRepository orderRepository;
    private final CartService cartService;
    private final PaymentService paymentService;
    private final ProductService productService;

    @Autowired
    public OrderServiceImpl(OrderRepository orderRepository,
                           CartService cartService,
                           PaymentService paymentService,
                           ProductService productService) {
        this.orderRepository = orderRepository;
        this.cartService = cartService;
        this.paymentService = paymentService;
        this.productService = productService;
    }

    @Override
    public Order saveOrder(Order order) {
        logger.info("Saving order: {}", order.getOrderNumber());
        Order savedOrder = orderRepository.save(order);
        logger.info("Order saved successfully with ID: {}", savedOrder.getId());
        return savedOrder;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Order> findOrderById(Long id) {
        logger.debug("Finding order by ID: {}", id);
        return orderRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findAllOrders() {
        logger.debug("Finding all orders");
        return orderRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Order> findAllOrders(Pageable pageable) {
        logger.debug("Finding all orders with pagination");
        return orderRepository.findAll(pageable);
    }

    @Override
    public void deleteOrderById(Long id) {
        logger.info("Deleting order with ID: {}", id);
        orderRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Order> findByOrderNumber(String orderNumber) {
        logger.debug("Finding order by number: {}", orderNumber);
        return orderRepository.findByOrderNumber(orderNumber);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByUserId(Long userId) {
        logger.debug("Finding orders by user ID: {}", userId);
        return orderRepository.findByUserIdOrderByOrderDateDesc(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Order> findOrdersByUserId(Long userId, Pageable pageable) {
        logger.debug("Finding orders by user ID: {} with pagination", userId);
        return orderRepository.findByUserIdOrderByOrderDateDesc(userId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByUserIdWithItems(Long userId) {
        logger.debug("Finding orders with items by user ID: {}", userId);
        return orderRepository.findByUserIdWithItems(userId);
    }

    @Override
    public Order updateOrderStatus(Long orderId, Order.OrderStatus status) {
        logger.info("Updating order {} status to {}", orderId, status);

        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.setStatus(status);
            return orderRepository.save(order);
        }

        throw new RuntimeException("Order not found with ID: " + orderId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByStatus(Order.OrderStatus status) {
        logger.debug("Finding orders by status: {}", status);
        return orderRepository.findByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Order> findOrdersByStatus(Order.OrderStatus status, Pageable pageable) {
        logger.debug("Finding orders by status: {} with pagination", status);
        return orderRepository.findByStatus(status, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByUserIdAndStatus(Long userId, Order.OrderStatus status) {
        logger.debug("Finding orders by user ID: {} and status: {}", userId, status);
        return orderRepository.findByUserIdAndStatus(userId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        logger.debug("Finding orders by date range: {} to {}", startDate, endDate);
        return orderRepository.findByOrderDateBetween(startDate, endDate);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByMinAmount(BigDecimal minAmount) {
        logger.debug("Finding orders by minimum amount: {}", minAmount);
        return orderRepository.findByTotalAmountGreaterThanEqual(minAmount);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> searchOrders(String searchTerm) {
        logger.debug("Searching orders with term: {}", searchTerm);
        return orderRepository.searchOrders(searchTerm);
    }

    @Override
    public Order createOrderFromCart(Long userId, String shippingAddress, String billingAddress, String orderNotes) {
        logger.info("Creating order from cart for user: {}", userId);

        // Get user's cart with items
        Optional<Cart> cartOpt = cartService.findCartByUserIdWithItems(userId);
        if (cartOpt.isEmpty() || cartOpt.get().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Cart cart = cartOpt.get();

        // Validate cart items before creating order
        List<String> validationErrors = cartService.validateCartItems(userId);
        if (!validationErrors.isEmpty()) {
            throw new RuntimeException("Cart validation failed: " + String.join(", ", validationErrors));
        }

        // Create order from cart
        User user = new User();
        user.setId(userId);

        Order order = new Order(user);
        order.setShippingAddress(shippingAddress);
        order.setBillingAddress(billingAddress != null ? billingAddress : shippingAddress);
        order.setOrderNotes(orderNotes);

        // Convert cart items to order items
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cart.getCartItems()) {
            OrderItem orderItem = new OrderItem(order, cartItem.getProduct(), cartItem.getQuantity());
            orderItems.add(orderItem);
        }

        order.setOrderItems(orderItems);
        order.calculateTotals();

        // Calculate tax (18% GST)
        BigDecimal taxAmount = order.getTotalAmount().multiply(new BigDecimal("0.18"));
        order.setTaxAmount(taxAmount);

        // Add shipping cost (free shipping for orders above ₹1000)
        BigDecimal shippingAmount = order.getTotalAmount().compareTo(new BigDecimal("1000")) >= 0 ?
                BigDecimal.ZERO : new BigDecimal("50");
        order.setShippingAmount(shippingAmount);

        order.calculateTotals();

        Order savedOrder = orderRepository.save(order);
        logger.info("Order created successfully with number: {}", savedOrder.getOrderNumber());

        return savedOrder;
    }

    @Override
    public Order placeOrder(Long userId) {
        logger.info("Placing order for user: {}", userId);

        // Validate that order can be placed
        if (!canPlaceOrder(userId)) {
            List<String> errors = validateOrderForPlacement(userId);
            throw new RuntimeException("Cannot place order: " + String.join(", ", errors));
        }

        // Create order from cart
        Order order = createOrderFromCart(userId, "Shipping address not provided", "Billing address not provided", null);

        // Process payment
        try {
            Payment payment = processPayment(order.getId(), "CREDIT_CARD");
            order.setPayment(payment);
            order.setStatus(Order.OrderStatus.CONFIRMED);

            // Update product stock
            for (OrderItem item : order.getOrderItems()) {
                Product product = item.getProduct();
                int newStock = product.getStockQuantity() - item.getQuantity();
                productService.updateStock(product.getId(), newStock);
            }

            // Clear user's cart after successful order
            cartService.clearCart(userId);

            Order savedOrder = orderRepository.save(order);
            logger.info("Order placed successfully with number: {}", savedOrder.getOrderNumber());

            return savedOrder;

        } catch (Exception e) {
            logger.error("Failed to place order: {}", e.getMessage());
            // Update order status to failed
            order.setStatus(Order.OrderStatus.CANCELLED);
            orderRepository.save(order);
            throw new RuntimeException("Failed to place order: " + e.getMessage());
        }
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canPlaceOrder(Long userId) {
        List<String> errors = validateOrderForPlacement(userId);
        return errors.isEmpty();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validateOrderForPlacement(Long userId) {
        List<String> errors = new ArrayList<>();

        // Check if cart exists and is not empty
        Optional<Cart> cartOpt = cartService.findCartByUserId(userId);
        if (cartOpt.isEmpty()) {
            errors.add("Cart not found");
            return errors;
        }

        if (cartOpt.get().isEmpty()) {
            errors.add("Cart is empty");
            return errors;
        }

        // Validate cart items
        errors.addAll(cartService.validateCartItems(userId));

        return errors;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> advancedSearchOrders(Long userId, String searchTerm, String status, String startDate, String endDate, Double minAmount, Double maxAmount, int page, int size) {
        logger.debug("Advanced search orders for user: {} with filters - searchTerm: {}, status: {}, dateRange: {} to {}, amountRange: {} to {}",
                userId, searchTerm, status, startDate, endDate, minAmount, maxAmount);

        // Start with user's orders
        List<Order> orders = orderRepository.findByUserIdOrderByOrderDateDesc(userId);

        // Apply filters
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String lowerSearchTerm = searchTerm.toLowerCase();
            orders = orders.stream()
                    .filter(order ->
                        order.getOrderNumber().toLowerCase().contains(lowerSearchTerm) ||
                        (order.getOrderItems() != null && order.getOrderItems().stream()
                            .anyMatch(item -> item.getProduct().getName().toLowerCase().contains(lowerSearchTerm)))
                    )
                    .collect(java.util.stream.Collectors.toList());
        }

        if (status != null && !status.trim().isEmpty()) {
            try {
                Order.OrderStatus orderStatus = Order.OrderStatus.valueOf(status.toUpperCase());
                orders = orders.stream()
                        .filter(order -> order.getStatus() == orderStatus)
                        .collect(java.util.stream.Collectors.toList());
            } catch (IllegalArgumentException e) {
                logger.warn("Invalid status filter: {}", status);
            }
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            try {
                LocalDateTime start = LocalDateTime.parse(startDate + "T00:00:00");
                orders = orders.stream()
                        .filter(order -> order.getOrderDate().isAfter(start) || order.getOrderDate().isEqual(start))
                        .collect(java.util.stream.Collectors.toList());
            } catch (Exception e) {
                logger.warn("Invalid start date format: {}", startDate);
            }
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            try {
                LocalDateTime end = LocalDateTime.parse(endDate + "T23:59:59");
                orders = orders.stream()
                        .filter(order -> order.getOrderDate().isBefore(end) || order.getOrderDate().isEqual(end))
                        .collect(java.util.stream.Collectors.toList());
            } catch (Exception e) {
                logger.warn("Invalid end date format: {}", endDate);
            }
        }

        if (minAmount != null) {
            BigDecimal min = BigDecimal.valueOf(minAmount);
            orders = orders.stream()
                    .filter(order -> order.getTotalAmount().compareTo(min) >= 0)
                    .collect(java.util.stream.Collectors.toList());
        }

        if (maxAmount != null) {
            BigDecimal max = BigDecimal.valueOf(maxAmount);
            orders = orders.stream()
                    .filter(order -> order.getTotalAmount().compareTo(max) <= 0)
                    .collect(java.util.stream.Collectors.toList());
        }

        // Apply pagination
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, orders.size());

        if (startIndex >= orders.size()) {
            return new ArrayList<>();
        }

        return orders.subList(startIndex, endIndex);
    }

    @Override
    public Order cancelOrder(Long orderId) {
        logger.info("Cancelling order: {}", orderId);

        if (!canCancelOrder(orderId)) {
            throw new RuntimeException("Order cannot be cancelled");
        }

        Order order = updateOrderStatus(orderId, Order.OrderStatus.CANCELLED);

        // If payment was completed, mark for refund
        if (order.getPayment() != null && order.getPayment().isSuccessful()) {
            // Here you would typically initiate a refund process
            logger.info("Order cancelled - payment refund may be required");
        }

        // Restore product stock
        for (OrderItem item : order.getOrderItems()) {
            Product product = item.getProduct();
            int restoredStock = product.getStockQuantity() + item.getQuantity();
            productService.updateStock(product.getId(), restoredStock);
        }

        logger.info("Order cancelled successfully");
        return order;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canCancelOrder(Long orderId) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        return orderOpt.map(Order::canBeCancelled).orElse(false);
    }

    @Override
    @Transactional(readOnly = true)
    public long countOrdersByStatus(Order.OrderStatus status) {
        return orderRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public long countOrdersByUserId(Long userId) {
        return orderRepository.countByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalSalesAmount() {
        BigDecimal total = orderRepository.getTotalSalesAmount();
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalSalesAmountBetween(LocalDateTime startDate, LocalDateTime endDate) {
        BigDecimal total = orderRepository.getTotalSalesAmountBetween(startDate, endDate);
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getAverageOrderValue() {
        BigDecimal average = orderRepository.getAverageOrderValue();
        return average != null ? average : BigDecimal.ZERO;
    }

    @Override
    public Payment processPayment(Long orderId, String paymentMethod) {
        logger.info("Processing payment for order: {} with method: {}", orderId, paymentMethod);

        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            throw new RuntimeException("Order not found with ID: " + orderId);
        }

        Order order = orderOpt.get();
        return paymentService.processPayment(order, paymentMethod);
    }

    @Override
    public Order updateOrderWithPayment(Long orderId, Payment payment) {
        logger.info("Updating order {} with payment {}", orderId, payment.getTransactionId());

        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.setPayment(payment);

            // Update order status based on payment status
            if (payment.isSuccessful()) {
                order.setStatus(Order.OrderStatus.CONFIRMED);
            } else if (payment.isFailed()) {
                order.setStatus(Order.OrderStatus.CANCELLED);
            }

            return orderRepository.save(order);
        }

        throw new RuntimeException("Order not found with ID: " + orderId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findRecentOrdersByUserId(Long userId, int limit) {
        logger.debug("Finding recent {} orders for user: {}", limit, userId);
        List<Order> orders = orderRepository.findByUserIdOrderByOrderDateDesc(userId);

        if (orders.size() > limit) {
            return orders.subList(0, limit);
        }

        return orders;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Order> findOrdersByUserIdOrderByDateDesc(Long userId, Pageable pageable) {
        logger.debug("Finding orders for user: {} ordered by date desc with pagination", userId);
        return orderRepository.findByUserIdOrderByOrderDateDescPaginated(userId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersByPaymentStatus(Payment.PaymentStatus paymentStatus) {
        logger.debug("Finding orders by payment status: {}", paymentStatus);
        return orderRepository.findByPaymentStatus(paymentStatus);
    }

    @Override
    public boolean reorderItems(Long userId, Long orderId) {
        logger.info("Reordering items for user: {} from order: {}", userId, orderId);

        // Validate reorder items first
        List<String> validationErrors = validateReorderItems(userId, orderId);
        if (!validationErrors.isEmpty()) {
            logger.error("Reorder validation failed: {}", String.join(", ", validationErrors));
            return false;
        }

        try {
            // Get the original order with items
            Optional<Order> originalOrderOpt = orderRepository.findByIdWithItems(orderId);
            if (originalOrderOpt.isEmpty()) {
                logger.error("Original order not found with ID: {}", orderId);
                return false;
            }

            Order originalOrder = originalOrderOpt.get();

            // Verify the order belongs to the user
            if (!originalOrder.getUser().getId().equals(userId)) {
                logger.error("Order {} does not belong to user {}", orderId, userId);
                return false;
            }

            // Add items from original order to cart
            for (OrderItem orderItem : originalOrder.getOrderItems()) {
                Product product = orderItem.getProduct();

                // Check if product is still available
                if (product.getStockQuantity() <= 0) {
                    logger.warn("Product {} is out of stock, skipping", product.getId());
                    continue;
                }

                // Add to cart (this will handle duplicates by updating quantity)
                cartService.addItemToCart(userId, product.getId(), orderItem.getQuantity());
            }

            logger.info("Successfully reordered items from order {} to user {} cart", orderId, userId);
            return true;

        } catch (Exception e) {
            logger.error("Failed to reorder items: {}", e.getMessage());
            return false;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validateReorderItems(Long userId, Long orderId) {
        List<String> errors = new ArrayList<>();

        // Check if order exists
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            errors.add("Original order not found");
            return errors;
        }

        Order order = orderOpt.get();

        // Check if order belongs to user
        if (!order.getUser().getId().equals(userId)) {
            errors.add("Order does not belong to user");
            return errors;
        }

        // Check if order can be reordered (only delivered orders)
        if (order.getStatus() != Order.OrderStatus.DELIVERED) {
            errors.add("Only delivered orders can be reordered");
            return errors;
        }

        // Check if order has items
        if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
            errors.add("Order has no items to reorder");
            return errors;
        }

        // Validate each item
        for (OrderItem item : order.getOrderItems()) {
            Product product = item.getProduct();

            // Check if product still exists
            if (product == null) {
                errors.add("Product no longer exists for item: " + item.getId());
                continue;
            }

            // Check if product is still available
            if (product.getStockQuantity() <= 0) {
                errors.add("Product '" + product.getName() + "' is currently out of stock");
            }

            // Check if product is still active
            if (!product.getIsActive()) {
                errors.add("Product '" + product.getName() + "' is no longer available");
            }
        }

        return errors;
    }
}
