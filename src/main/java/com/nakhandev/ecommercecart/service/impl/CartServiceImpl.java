package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.*;
import com.nakhandev.ecommercecart.repository.CartRepository;
import com.nakhandev.ecommercecart.service.CartService;
import com.nakhandev.ecommercecart.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CartServiceImpl implements CartService {

    private static final Logger logger = LoggerFactory.getLogger(CartServiceImpl.class);

    private final CartRepository cartRepository;
    private final ProductService productService;

    @Autowired
    public CartServiceImpl(CartRepository cartRepository, ProductService productService) {
        this.cartRepository = cartRepository;
        this.productService = productService;
    }

    @Override
    public Cart createCartForUser(Long userId) {
        logger.info("Creating cart for user: {}", userId);

        // Check if user already has a cart
        if (cartRepository.existsByUserId(userId)) {
            throw new RuntimeException("User already has a cart");
        }

        User user = new User();
        user.setId(userId);

        Cart cart = new Cart(user);
        Cart savedCart = cartRepository.save(cart);

        logger.info("Cart created successfully with ID: {}", savedCart.getId());
        return savedCart;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Cart> findCartByUserId(Long userId) {
        logger.debug("Finding cart for user: {}", userId);
        return cartRepository.findByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Cart> findCartByUserIdWithItems(Long userId) {
        logger.debug("Finding cart with items for user: {}", userId);
        return cartRepository.findByUserIdWithItems(userId);
    }

    @Override
    public Cart getOrCreateCartForUser(Long userId) {
        logger.debug("Getting or creating cart for user: {}", userId);

        Optional<Cart> existingCart = cartRepository.findByUserId(userId);
        if (existingCart.isPresent()) {
            return existingCart.get();
        }

        return createCartForUser(userId);
    }

    @Override
    public void clearCart(Long userId) {
        logger.info("Clearing cart for user: {}", userId);

        Optional<Cart> cartOpt = cartRepository.findByUserId(userId);
        if (cartOpt.isPresent()) {
            Cart cart = cartOpt.get();
            cart.getCartItems().clear();
            cart.calculateTotals();
            cartRepository.save(cart);
        }
    }

    @Override
    public void deleteCart(Long userId) {
        logger.info("Deleting cart for user: {}", userId);
        cartRepository.deleteByUserId(userId);
    }

    @Override
    public CartItem addItemToCart(Long userId, Long productId, Integer quantity) {
        logger.info("Adding item to cart - User: {}, Product: {}, Quantity: {}", userId, productId, quantity);

        // Validate inputs
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }

        // Get or create cart
        Cart cart = getOrCreateCartForUser(userId);

        // Get product
        Product product = productService.findProductById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found with ID: " + productId));

        // Check if product is active and in stock
        if (!product.getIsActive()) {
            throw new RuntimeException("Product is not available");
        }

        if (!product.isInStock()) {
            throw new RuntimeException("Product is out of stock");
        }

        if (product.getStockQuantity() < quantity) {
            throw new RuntimeException("Insufficient stock. Available: " + product.getStockQuantity());
        }

        // Check if item already exists in cart
        Optional<CartItem> existingItem = findCartItemByProductId(userId, productId);

        if (existingItem.isPresent()) {
            // Update existing item quantity
            return updateCartItemQuantity(userId, productId, existingItem.get().getQuantity() + quantity);
        } else {
            // Create new cart item
            CartItem cartItem = new CartItem(cart, product, quantity);
            cart.getCartItems().add(cartItem);
            cart.calculateTotals();
            cartRepository.save(cart);

            logger.info("Item added to cart successfully");
            return cartItem;
        }
    }

    @Override
    public CartItem updateCartItemQuantity(Long userId, Long productId, Integer quantity) {
        logger.info("Updating cart item quantity - User: {}, Product: {}, New Quantity: {}", userId, productId, quantity);

        if (quantity <= 0) {
            removeCartItem(userId, productId);
            return null;
        }

        Cart cart = getOrCreateCartForUser(userId);
        Product product = productService.findProductById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found with ID: " + productId));

        // Check stock availability
        if (product.getStockQuantity() < quantity) {
            throw new RuntimeException("Insufficient stock. Available: " + product.getStockQuantity());
        }

        // Find and update cart item
        for (CartItem item : cart.getCartItems()) {
            if (item.getProduct().getId().equals(productId)) {
                item.setQuantity(quantity);
                item.updateUnitPrice();
                cart.calculateTotals();
                cartRepository.save(cart);

                logger.info("Cart item quantity updated successfully");
                return item;
            }
        }

        throw new RuntimeException("Product not found in cart");
    }

    @Override
    public void removeCartItem(Long userId, Long productId) {
        logger.info("Removing item from cart - User: {}, Product: {}", userId, productId);

        Cart cart = getOrCreateCartForUser(userId);

        boolean removed = cart.getCartItems().removeIf(item -> item.getProduct().getId().equals(productId));

        if (!removed) {
            throw new RuntimeException("Product not found in cart");
        }

        cart.calculateTotals();
        cartRepository.save(cart);

        logger.info("Item removed from cart successfully");
    }

    @Override
    public void clearCartItems(Long userId) {
        logger.info("Clearing all cart items for user: {}", userId);

        Optional<Cart> cartOpt = cartRepository.findByUserId(userId);
        if (cartOpt.isPresent()) {
            Cart cart = cartOpt.get();
            cart.getCartItems().clear();
            cart.calculateTotals();
            cartRepository.save(cart);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<CartItem> getCartItems(Long userId) {
        Optional<Cart> cartOpt = cartRepository.findByUserIdWithItems(userId);
        return cartOpt.map(Cart::getCartItems).orElse(new ArrayList<>());
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<CartItem> findCartItemByProductId(Long userId, Long productId) {
        List<CartItem> cartItems = getCartItems(userId);
        return cartItems.stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst();
    }

    @Override
    @Transactional(readOnly = true)
    public Integer getCartItemCount(Long userId) {
        Optional<Cart> cartOpt = cartRepository.findByUserId(userId);
        return cartOpt.map(Cart::getTotalItems).orElse(0);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isCartEmpty(Long userId) {
        return getCartItemCount(userId) == 0;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canAddProductToCart(Long productId, Integer quantity) {
        Optional<Product> productOpt = productService.findProductById(productId);
        if (productOpt.isEmpty()) {
            return false;
        }

        Product product = productOpt.get();
        return product.getIsActive() && product.isInStock() && product.getStockQuantity() >= quantity;
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validateCartItems(Long userId) {
        List<String> errors = new ArrayList<>();
        List<CartItem> cartItems = getCartItems(userId);

        for (CartItem item : cartItems) {
            Product product = item.getProduct();

            if (!product.getIsActive()) {
                errors.add("Product '" + product.getName() + "' is no longer available");
            }

            if (!product.isInStock()) {
                errors.add("Product '" + product.getName() + "' is out of stock");
            }

            if (product.getStockQuantity() < item.getQuantity()) {
                errors.add("Insufficient stock for '" + product.getName() +
                          "'. Available: " + product.getStockQuantity() +
                          ", Requested: " + item.getQuantity());
            }
        }

        return errors;
    }

    @Override
    public void recalculateCartTotals(Long userId) {
        logger.info("Recalculating cart totals for user: {}", userId);

        Optional<Cart> cartOpt = cartRepository.findByUserIdWithItems(userId);
        if (cartOpt.isPresent()) {
            Cart cart = cartOpt.get();
            cart.calculateTotals();
            cartRepository.save(cart);
        }
    }

    @Override
    public Cart mergeCarts(Long userId, Cart guestCart) {
        logger.info("Merging guest cart into user cart for user: {}", userId);

        if (guestCart == null || guestCart.isEmpty()) {
            return getOrCreateCartForUser(userId);
        }

        Cart userCart = getOrCreateCartForUser(userId);

        // Add guest cart items to user cart
        for (CartItem guestItem : guestCart.getCartItems()) {
            try {
                addItemToCart(userId, guestItem.getProduct().getId(), guestItem.getQuantity());
            } catch (Exception e) {
                logger.warn("Failed to merge item: {}", guestItem.getProduct().getName());
            }
        }

        return userCart;
    }

    @Override
    public CartItem addProductToCart(Long userId, Product product, Integer quantity) {
        return addItemToCart(userId, product.getId(), quantity);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isProductInCart(Long userId, Long productId) {
        return findCartItemByProductId(userId, productId).isPresent();
    }
}
