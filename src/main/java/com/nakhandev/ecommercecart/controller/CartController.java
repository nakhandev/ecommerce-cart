package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.controller.common.BaseController;
import com.nakhandev.ecommercecart.dto.cart.CartItemDTO;
import com.nakhandev.ecommercecart.dto.cart.CartResponseDTO;
import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.model.Cart;
import com.nakhandev.ecommercecart.model.CartItem;
import com.nakhandev.ecommercecart.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/cart")
@CrossOrigin(origins = "*") // Configure appropriately for production
public class CartController extends BaseController {

    private final CartService cartService;

    @Autowired
    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    /**
     * Get user's cart
     */
    @GetMapping
    public ResponseEntity<ApiResponse<CartResponseDTO>> getCart(@RequestParam Long userId) {

        logControllerEntry("getCart", userId);

        try {
            Optional<Cart> cartOpt = cartService.findCartByUserIdWithItems(userId);

            if (cartOpt.isEmpty()) {
                // Return empty cart structure
                CartResponseDTO emptyCart = new CartResponseDTO();
                emptyCart.setUserId(userId);
                emptyCart.setTotalItems(0);
                emptyCart.setTotalAmount(java.math.BigDecimal.ZERO);
                emptyCart.setItems(List.of());

                logControllerExit("getCart", "Empty cart");
                return createSuccessResponse(emptyCart);
            }

            CartResponseDTO responseDTO = CartResponseDTO.fromEntity(cartOpt.get());
            logControllerExit("getCart", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getCart", e);
            return createErrorResponse("Failed to get cart: " + e.getMessage());
        }
    }

    /**
     * Add item to cart
     */
    @PostMapping("/items")
    public ResponseEntity<ApiResponse<CartItemDTO>> addItemToCart(
            @RequestParam Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {

        logControllerEntry("addItemToCart", userId, productId, quantity);

        try {
            // Validate quantity
            if (quantity <= 0) {
                return createErrorResponse("Quantity must be greater than 0");
            }

            // Check if product can be added to cart
            if (!cartService.canAddProductToCart(productId, quantity)) {
                return createErrorResponse("Product is not available in requested quantity");
            }

            CartItem cartItem = cartService.addItemToCart(userId, productId, quantity);
            CartItemDTO responseDTO = CartItemDTO.fromEntity(cartItem);

            logControllerExit("addItemToCart", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("addItemToCart", e);
            return createErrorResponse("Failed to add item to cart: " + e.getMessage());
        }
    }

    /**
     * Update cart item quantity
     */
    @PutMapping("/items/{productId}")
    public ResponseEntity<ApiResponse<CartItemDTO>> updateCartItemQuantity(
            @RequestParam Long userId,
            @PathVariable Long productId,
            @RequestParam Integer quantity) {

        logControllerEntry("updateCartItemQuantity", userId, productId, quantity);

        try {
            // Validate quantity
            if (quantity < 0) {
                return createErrorResponse("Quantity cannot be negative");
            }

            CartItem updatedItem;
            if (quantity == 0) {
                // Remove item if quantity is 0
                cartService.removeCartItem(userId, productId);
                return createSuccessResponse("Item removed from cart");
            } else {
                // Update quantity
                updatedItem = cartService.updateCartItemQuantity(userId, productId, quantity);
            }

            CartItemDTO responseDTO = CartItemDTO.fromEntity(updatedItem);

            logControllerExit("updateCartItemQuantity", responseDTO);
            return createSuccessResponse("Cart item quantity updated", responseDTO);

        } catch (Exception e) {
            logError("updateCartItemQuantity", e);
            return createErrorResponse("Failed to update cart item: " + e.getMessage());
        }
    }

    /**
     * Remove item from cart
     */
    @DeleteMapping("/items/{productId}")
    public ResponseEntity<ApiResponse<Void>> removeCartItem(
            @RequestParam Long userId,
            @PathVariable Long productId) {

        logControllerEntry("removeCartItem", userId, productId);

        try {
            cartService.removeCartItem(userId, productId);

            logControllerExit("removeCartItem", "Item removed");
            return createSuccessResponse("Item removed from cart successfully");

        } catch (Exception e) {
            logError("removeCartItem", e);
            return createErrorResponse("Failed to remove item from cart: " + e.getMessage());
        }
    }

    /**
     * Clear entire cart
     */
    @DeleteMapping
    public ResponseEntity<ApiResponse<Void>> clearCart(@RequestParam Long userId) {

        logControllerEntry("clearCart", userId);

        try {
            cartService.clearCart(userId);

            logControllerExit("clearCart", "Cart cleared");
            return createSuccessResponse("Cart cleared successfully");

        } catch (Exception e) {
            logError("clearCart", e);
            return createErrorResponse("Failed to clear cart: " + e.getMessage());
        }
    }

    /**
     * Get cart items
     */
    @GetMapping("/items")
    public ResponseEntity<ApiResponse<List<CartItemDTO>>> getCartItems(@RequestParam Long userId) {

        logControllerEntry("getCartItems", userId);

        try {
            List<CartItem> cartItems = cartService.getCartItems(userId);
            List<CartItemDTO> itemDTOs = cartItems.stream()
                    .map(CartItemDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getCartItems", itemDTOs);
            return createSuccessResponse(itemDTOs);

        } catch (Exception e) {
            logError("getCartItems", e);
            return createErrorResponse("Failed to get cart items: " + e.getMessage());
        }
    }

    /**
     * Get cart item count
     */
    @GetMapping("/count")
    public ResponseEntity<ApiResponse<Integer>> getCartItemCount(@RequestParam Long userId) {

        logControllerEntry("getCartItemCount", userId);

        try {
            int itemCount = cartService.getCartItemCount(userId);

            logControllerExit("getCartItemCount", itemCount);
            return createSuccessResponse(itemCount);

        } catch (Exception e) {
            logError("getCartItemCount", e);
            return createErrorResponse("Failed to get cart item count: " + e.getMessage());
        }
    }

    /**
     * Check if cart is empty
     */
    @GetMapping("/empty")
    public ResponseEntity<ApiResponse<Boolean>> isCartEmpty(@RequestParam Long userId) {

        logControllerEntry("isCartEmpty", userId);

        try {
            boolean isEmpty = cartService.isCartEmpty(userId);

            logControllerExit("isCartEmpty", isEmpty);
            return createSuccessResponse(isEmpty);

        } catch (Exception e) {
            logError("isCartEmpty", e);
            return createErrorResponse("Failed to check cart status: " + e.getMessage());
        }
    }

    /**
     * Validate cart items (check stock availability)
     */
    @GetMapping("/validate")
    public ResponseEntity<ApiResponse<List<String>>> validateCart(@RequestParam Long userId) {

        logControllerEntry("validateCart", userId);

        try {
            List<String> validationErrors = cartService.validateCartItems(userId);

            logControllerExit("validateCart", validationErrors);
            return createSuccessResponse(validationErrors);

        } catch (Exception e) {
            logError("validateCart", e);
            return createErrorResponse("Failed to validate cart: " + e.getMessage());
        }
    }

    /**
     * Recalculate cart totals
     */
    @PostMapping("/recalculate")
    public ResponseEntity<ApiResponse<CartResponseDTO>> recalculateCart(@RequestParam Long userId) {

        logControllerEntry("recalculateCart", userId);

        try {
            cartService.recalculateCartTotals(userId);

            // Return updated cart
            Optional<Cart> cartOpt = cartService.findCartByUserIdWithItems(userId);
            CartResponseDTO responseDTO = cartOpt.map(CartResponseDTO::fromEntity).orElse(null);

            logControllerExit("recalculateCart", responseDTO);
            return createSuccessResponse("Cart recalculated successfully", responseDTO);

        } catch (Exception e) {
            logError("recalculateCart", e);
            return createErrorResponse("Failed to recalculate cart: " + e.getMessage());
        }
    }

    /**
     * Check if product is in cart
     */
    @GetMapping("/contains/{productId}")
    public ResponseEntity<ApiResponse<Boolean>> isProductInCart(
            @RequestParam Long userId,
            @PathVariable Long productId) {

        logControllerEntry("isProductInCart", userId, productId);

        try {
            boolean contains = cartService.isProductInCart(userId, productId);

            logControllerExit("isProductInCart", contains);
            return createSuccessResponse(contains);

        } catch (Exception e) {
            logError("isProductInCart", e);
            return createErrorResponse("Failed to check if product is in cart: " + e.getMessage());
        }
    }

    /**
     * Get cart summary (for quick overview)
     */
    @GetMapping("/summary")
    public ResponseEntity<ApiResponse<CartSummary>> getCartSummary(@RequestParam Long userId) {

        logControllerEntry("getCartSummary", userId);

        try {
            Optional<Cart> cartOpt = cartService.findCartByUserId(userId);

            if (cartOpt.isEmpty()) {
                CartSummary summary = new CartSummary(0, java.math.BigDecimal.ZERO, 0);
                logControllerExit("getCartSummary", summary);
                return createSuccessResponse(summary);
            }

            Cart cart = cartOpt.get();
            CartSummary summary = new CartSummary(
                    cart.getTotalItems(),
                    cart.getTotalAmount(),
                    cart.getItemCount()
            );

            logControllerExit("getCartSummary", summary);
            return createSuccessResponse(summary);

        } catch (Exception e) {
            logError("getCartSummary", e);
            return createErrorResponse("Failed to get cart summary: " + e.getMessage());
        }
    }

    // Inner class for cart summary
    public static class CartSummary {
        private int totalItems;
        private java.math.BigDecimal totalAmount;
        private int itemCount;

        public CartSummary(int totalItems, java.math.BigDecimal totalAmount, int itemCount) {
            this.totalItems = totalItems;
            this.totalAmount = totalAmount;
            this.itemCount = itemCount;
        }

        // Getters
        public int getTotalItems() { return totalItems; }
        public java.math.BigDecimal getTotalAmount() { return totalAmount; }
        public int getItemCount() { return itemCount; }
        public String getDisplayTotalAmount() { return String.format("₹%.2f", totalAmount); }
    }
}
