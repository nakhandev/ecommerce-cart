package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.Cart;
import com.nakhandev.ecommercecart.model.CartItem;
import com.nakhandev.ecommercecart.model.Product;

import java.util.List;
import java.util.Optional;

public interface CartService {

    // Cart management
    Cart createCartForUser(Long userId);

    Optional<Cart> findCartByUserId(Long userId);

    Optional<Cart> findCartByUserIdWithItems(Long userId);

    Cart getOrCreateCartForUser(Long userId);

    void clearCart(Long userId);

    void deleteCart(Long userId);

    // Cart items management
    CartItem addItemToCart(Long userId, Long productId, Integer quantity);

    CartItem updateCartItemQuantity(Long userId, Long productId, Integer quantity);

    void removeCartItem(Long userId, Long productId);

    void clearCartItems(Long userId);

    // Cart item queries
    List<CartItem> getCartItems(Long userId);

    Optional<CartItem> findCartItemByProductId(Long userId, Long productId);

    Integer getCartItemCount(Long userId);

    boolean isCartEmpty(Long userId);

    // Stock validation
    boolean canAddProductToCart(Long productId, Integer quantity);

    List<String> validateCartItems(Long userId);

    // Cart calculations
    void recalculateCartTotals(Long userId);

    // Advanced cart operations
    Cart mergeCarts(Long userId, Cart guestCart);

    CartItem addProductToCart(Long userId, Product product, Integer quantity);

    boolean isProductInCart(Long userId, Long productId);
}
