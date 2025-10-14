package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.model.Payment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface OrderService {

    // Basic CRUD operations
    Order saveOrder(Order order);

    Optional<Order> findOrderById(Long id);

    List<Order> findAllOrders();

    Page<Order> findAllOrders(Pageable pageable);

    void deleteOrderById(Long id);

    // Order lookup methods
    Optional<Order> findByOrderNumber(String orderNumber);

    List<Order> findOrdersByUserId(Long userId);

    Page<Order> findOrdersByUserId(Long userId, Pageable pageable);

    List<Order> findOrdersByUserIdWithItems(Long userId);

    // Order status management
    Order updateOrderStatus(Long orderId, Order.OrderStatus status);

    List<Order> findOrdersByStatus(Order.OrderStatus status);

    Page<Order> findOrdersByStatus(Order.OrderStatus status, Pageable pageable);

    List<Order> findOrdersByUserIdAndStatus(Long userId, Order.OrderStatus status);

    // Order filtering and search
    List<Order> findOrdersByDateRange(LocalDateTime startDate, LocalDateTime endDate);

    List<Order> findOrdersByMinAmount(BigDecimal minAmount);

    List<Order> searchOrders(String searchTerm);

    // Order creation and checkout
    Order createOrderFromCart(Long userId, String shippingAddress, String billingAddress, String orderNotes);

    Order placeOrder(Long userId);

    boolean canPlaceOrder(Long userId);

    List<String> validateOrderForPlacement(Long userId);

    // Order cancellation and returns
    Order cancelOrder(Long orderId);

    boolean canCancelOrder(Long orderId);

    // Analytics and reporting
    long countOrdersByStatus(Order.OrderStatus status);

    long countOrdersByUserId(Long userId);

    BigDecimal getTotalSalesAmount();

    BigDecimal getTotalSalesAmountBetween(LocalDateTime startDate, LocalDateTime endDate);

    BigDecimal getAverageOrderValue();

    // Payment integration
    Payment processPayment(Long orderId, String paymentMethod);

    Order updateOrderWithPayment(Long orderId, Payment payment);

    // Advanced order operations
    List<Order> findRecentOrdersByUserId(Long userId, int limit);

    Page<Order> findOrdersByUserIdOrderByDateDesc(Long userId, Pageable pageable);

    List<Order> findOrdersByPaymentStatus(Payment.PaymentStatus paymentStatus);

    // Reorder functionality
    boolean reorderItems(Long userId, Long orderId);

    List<String> validateReorderItems(Long userId, Long orderId);

    // Advanced search functionality
    List<Order> advancedSearchOrders(Long userId, String searchTerm, String status, String startDate, String endDate, Double minAmount, Double maxAmount, int page, int size);
}
