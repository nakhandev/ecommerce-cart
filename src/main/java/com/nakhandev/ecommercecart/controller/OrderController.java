package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.controller.common.BaseController;
import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.dto.order.OrderResponseDTO;
import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "*") // Configure appropriately for production
public class OrderController extends BaseController {

    private final OrderService orderService;

    @Autowired
    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    /**
     * Create order from cart (checkout)
     */
    @PostMapping
    public ResponseEntity<ApiResponse<OrderResponseDTO>> createOrder(
            @RequestParam Long userId,
            @RequestParam String shippingAddress,
            @RequestParam(required = false) String billingAddress,
            @RequestParam(required = false) String orderNotes) {

        logControllerEntry("createOrder", userId);

        try {
            // Validate that order can be placed
            if (!orderService.canPlaceOrder(userId)) {
                List<String> errors = orderService.validateOrderForPlacement(userId);
                return createErrorResponse("Cannot place order: " + String.join(", ", errors));
            }

            // Create order from cart
            Order order = orderService.createOrderFromCart(userId, shippingAddress, billingAddress, orderNotes);
            OrderResponseDTO responseDTO = OrderResponseDTO.fromEntity(order);

            logControllerExit("createOrder", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("createOrder", e);
            return createErrorResponse("Failed to create order: " + e.getMessage());
        }
    }

    /**
     * Place order (complete checkout with payment)
     */
    @PostMapping("/place")
    public ResponseEntity<ApiResponse<OrderResponseDTO>> placeOrder(@RequestParam Long userId) {

        logControllerEntry("placeOrder", userId);

        try {
            Order order = orderService.placeOrder(userId);
            OrderResponseDTO responseDTO = OrderResponseDTO.fromEntity(order);

            logControllerExit("placeOrder", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("placeOrder", e);
            return createErrorResponse("Failed to place order: " + e.getMessage());
        }
    }

    /**
     * Get user's orders
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<OrderResponseDTO>>> getUserOrders(
            @RequestParam Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getUserOrders", userId, page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Order> orderPage = orderService.findOrdersByUserId(userId, pageable);

            List<OrderResponseDTO> orderDTOs = orderPage.getContent().stream()
                    .map(OrderResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getUserOrders", orderDTOs);
            return createSuccessResponse(orderDTOs);

        } catch (Exception e) {
            logError("getUserOrders", e);
            return createErrorResponse("Failed to get user orders: " + e.getMessage());
        }
    }

    /**
     * Get order by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<OrderResponseDTO>> getOrderById(@PathVariable Long id) {

        logControllerEntry("getOrderById", id);

        try {
            Optional<Order> orderOpt = orderService.findOrderById(id);
            if (orderOpt.isEmpty()) {
                return createNotFoundResponse("Order not found with ID: " + id);
            }

            OrderResponseDTO responseDTO = OrderResponseDTO.fromEntity(orderOpt.get());
            logControllerExit("getOrderById", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getOrderById", e);
            return createErrorResponse("Failed to get order: " + e.getMessage());
        }
    }

    /**
     * Get order by order number
     */
    @GetMapping("/number/{orderNumber}")
    public ResponseEntity<ApiResponse<OrderResponseDTO>> getOrderByNumber(
            @PathVariable String orderNumber) {

        logControllerEntry("getOrderByNumber", orderNumber);

        try {
            Optional<Order> orderOpt = orderService.findByOrderNumber(orderNumber);
            if (orderOpt.isEmpty()) {
                return createNotFoundResponse("Order not found with number: " + orderNumber);
            }

            OrderResponseDTO responseDTO = OrderResponseDTO.fromEntity(orderOpt.get());
            logControllerExit("getOrderByNumber", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getOrderByNumber", e);
            return createErrorResponse("Failed to get order: " + e.getMessage());
        }
    }

    /**
     * Get orders by status
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<OrderResponseDTO>>> getOrdersByStatus(
            @PathVariable Order.OrderStatus status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getOrdersByStatus", status, page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Order> orderPage = orderService.findOrdersByStatus(status, pageable);

            List<OrderResponseDTO> orderDTOs = orderPage.getContent().stream()
                    .map(OrderResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getOrdersByStatus", orderDTOs);
            return createSuccessResponse(orderDTOs);

        } catch (Exception e) {
            logError("getOrdersByStatus", e);
            return createErrorResponse("Failed to get orders by status: " + e.getMessage());
        }
    }

    /**
     * Update order status (admin only)
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<ApiResponse<OrderResponseDTO>> updateOrderStatus(
            @PathVariable Long id,
            @RequestParam Order.OrderStatus status) {

        logControllerEntry("updateOrderStatus", id, status);

        try {
            Order updatedOrder = orderService.updateOrderStatus(id, status);
            OrderResponseDTO responseDTO = OrderResponseDTO.fromEntity(updatedOrder);

            logControllerExit("updateOrderStatus", responseDTO);
            return createSuccessResponse("Order status updated successfully", responseDTO);

        } catch (Exception e) {
            logError("updateOrderStatus", e);
            return createErrorResponse("Failed to update order status: " + e.getMessage());
        }
    }

    /**
     * Cancel order
     */
    @PutMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<OrderResponseDTO>> cancelOrder(@PathVariable Long id) {

        logControllerEntry("cancelOrder", id);

        try {
            // Check if order can be cancelled
            if (!orderService.canCancelOrder(id)) {
                return createErrorResponse("Order cannot be cancelled");
            }

            Order cancelledOrder = orderService.cancelOrder(id);
            OrderResponseDTO responseDTO = OrderResponseDTO.fromEntity(cancelledOrder);

            logControllerExit("cancelOrder", responseDTO);
            return createSuccessResponse("Order cancelled successfully", responseDTO);

        } catch (Exception e) {
            logError("cancelOrder", e);
            return createErrorResponse("Failed to cancel order: " + e.getMessage());
        }
    }

    /**
     * Search orders
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<OrderResponseDTO>>> searchOrders(
            @RequestParam String searchTerm) {

        logControllerEntry("searchOrders", searchTerm);

        try {
            List<Order> orders = orderService.searchOrders(searchTerm);
            List<OrderResponseDTO> orderDTOs = orders.stream()
                    .map(OrderResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("searchOrders", orderDTOs);
            return createSuccessResponse(orderDTOs);

        } catch (Exception e) {
            logError("searchOrders", e);
            return createErrorResponse("Failed to search orders: " + e.getMessage());
        }
    }

    /**
     * Advanced search orders with filters
     */
    @GetMapping("/search-advanced")
    public ResponseEntity<ApiResponse<List<OrderResponseDTO>>> advancedSearchOrders(
            @RequestParam Long userId,
            @RequestParam(required = false) String searchTerm,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) Double minAmount,
            @RequestParam(required = false) Double maxAmount,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("advancedSearchOrders", userId, searchTerm, status, startDate, endDate, minAmount, maxAmount);

        try {
            List<Order> orders = orderService.advancedSearchOrders(userId, searchTerm, status, startDate, endDate, minAmount, maxAmount, page, size);
            List<OrderResponseDTO> orderDTOs = orders.stream()
                    .map(OrderResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("advancedSearchOrders", orderDTOs);
            return createSuccessResponse(orderDTOs);

        } catch (Exception e) {
            logError("advancedSearchOrders", e);
            return createErrorResponse("Failed to search orders: " + e.getMessage());
        }
    }

    /**
     * Get recent orders for user
     */
    @GetMapping("/recent")
    public ResponseEntity<ApiResponse<List<OrderResponseDTO>>> getRecentOrders(
            @RequestParam Long userId,
            @RequestParam(defaultValue = "5") int limit) {

        logControllerEntry("getRecentOrders", userId, limit);

        try {
            List<Order> orders = orderService.findRecentOrdersByUserId(userId, limit);
            List<OrderResponseDTO> orderDTOs = orders.stream()
                    .map(OrderResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getRecentOrders", orderDTOs);
            return createSuccessResponse(orderDTOs);

        } catch (Exception e) {
            logError("getRecentOrders", e);
            return createErrorResponse("Failed to get recent orders: " + e.getMessage());
        }
    }

    /**
     * Check if order can be placed
     */
    @GetMapping("/can-place")
    public ResponseEntity<ApiResponse<Boolean>> canPlaceOrder(@RequestParam Long userId) {

        logControllerEntry("canPlaceOrder", userId);

        try {
            boolean canPlace = orderService.canPlaceOrder(userId);

            logControllerExit("canPlaceOrder", canPlace);
            return createSuccessResponse(canPlace);

        } catch (Exception e) {
            logError("canPlaceOrder", e);
            return createErrorResponse("Failed to check if order can be placed: " + e.getMessage());
        }
    }

    /**
     * Validate order for placement
     */
    @GetMapping("/validate")
    public ResponseEntity<ApiResponse<List<String>>> validateOrder(@RequestParam Long userId) {

        logControllerEntry("validateOrder", userId);

        try {
            List<String> validationErrors = orderService.validateOrderForPlacement(userId);

            logControllerExit("validateOrder", validationErrors);
            return createSuccessResponse(validationErrors);

        } catch (Exception e) {
            logError("validateOrder", e);
            return createErrorResponse("Failed to validate order: " + e.getMessage());
        }
    }

    /**
     * Get order statistics (admin only)
     */
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<OrderStats>> getOrderStats() {

        logControllerEntry("getOrderStats");

        try {
            long pendingOrders = orderService.countOrdersByStatus(Order.OrderStatus.PENDING);
            long deliveredOrders = orderService.countOrdersByStatus(Order.OrderStatus.DELIVERED);
            long cancelledOrders = orderService.countOrdersByStatus(Order.OrderStatus.CANCELLED);
            java.math.BigDecimal totalSales = orderService.getTotalSalesAmount();
            java.math.BigDecimal averageOrderValue = orderService.getAverageOrderValue();

            OrderStats stats = new OrderStats(pendingOrders, deliveredOrders, cancelledOrders,
                    totalSales, averageOrderValue);

            logControllerExit("getOrderStats", stats);
            return createSuccessResponse(stats);

        } catch (Exception e) {
            logError("getOrderStats", e);
            return createErrorResponse("Failed to get order statistics: " + e.getMessage());
        }
    }

    /**
     * Delete order (admin only)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteOrder(@PathVariable Long id) {

        logControllerEntry("deleteOrder", id);

        try {
            orderService.deleteOrderById(id);

            logControllerExit("deleteOrder", "Order deleted");
            return createSuccessResponse("Order deleted successfully");

        } catch (Exception e) {
            logError("deleteOrder", e);
            return createErrorResponse("Failed to delete order: " + e.getMessage());
        }
    }

    /**
     * Reorder items from an existing order
     */
    @PostMapping("/{id}/reorder")
    public ResponseEntity<ApiResponse<Boolean>> reorderItems(
            @PathVariable Long id,
            @RequestParam Long userId) {

        logControllerEntry("reorderItems", id, userId);

        try {
            // Validate that reorder can be performed
            List<String> validationErrors = orderService.validateReorderItems(userId, id);
            if (!validationErrors.isEmpty()) {
                return createErrorResponse("Cannot reorder items: " + String.join(", ", validationErrors));
            }

            boolean success = orderService.reorderItems(userId, id);

            if (success) {
                logControllerExit("reorderItems", true);
                return createSuccessResponse("Items successfully added to cart", true);
            } else {
                logControllerExit("reorderItems", false);
                return createErrorResponse("Failed to reorder items");
            }

        } catch (Exception e) {
            logError("reorderItems", e);
            return createErrorResponse("Failed to reorder items: " + e.getMessage());
        }
    }

    /**
     * Validate reorder items
     */
    @GetMapping("/{id}/validate-reorder")
    public ResponseEntity<ApiResponse<List<String>>> validateReorderItems(
            @PathVariable Long id,
            @RequestParam Long userId) {

        logControllerEntry("validateReorderItems", id, userId);

        try {
            List<String> validationErrors = orderService.validateReorderItems(userId, id);

            logControllerExit("validateReorderItems", validationErrors);
            return createSuccessResponse(validationErrors);

        } catch (Exception e) {
            logError("validateReorderItems", e);
            return createErrorResponse("Failed to validate reorder: " + e.getMessage());
        }
    }

    // Inner class for order statistics
    public static class OrderStats {
        private long pendingOrders;
        private long deliveredOrders;
        private long cancelledOrders;
        private java.math.BigDecimal totalSales;
        private java.math.BigDecimal averageOrderValue;

        public OrderStats(long pendingOrders, long deliveredOrders, long cancelledOrders,
                         java.math.BigDecimal totalSales, java.math.BigDecimal averageOrderValue) {
            this.pendingOrders = pendingOrders;
            this.deliveredOrders = deliveredOrders;
            this.cancelledOrders = cancelledOrders;
            this.totalSales = totalSales;
            this.averageOrderValue = averageOrderValue;
        }

        // Getters
        public long getPendingOrders() { return pendingOrders; }
        public long getDeliveredOrders() { return deliveredOrders; }
        public long getCancelledOrders() { return cancelledOrders; }
        public java.math.BigDecimal getTotalSales() { return totalSales; }
        public java.math.BigDecimal getAverageOrderValue() { return averageOrderValue; }
        public String getDisplayTotalSales() { return String.format("₹%.2f", totalSales); }
        public String getDisplayAverageOrderValue() { return String.format("₹%.2f", averageOrderValue); }
    }
}
