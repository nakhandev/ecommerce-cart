package com.nakhandev.ecommercecart.model;

import javax.persistence.*;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "carts")
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Cart must be associated with a user")
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Min(value = 0, message = "Total items cannot be negative")
    @Column(name = "total_items", nullable = false)
    private Integer totalItems = 0;

    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private List<CartItem> cartItems = new ArrayList<>();

    // Constructors
    public Cart() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Cart(User user) {
        this();
        this.user = user;
    }

    // Lifecycle callbacks
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
        calculateTotals();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Integer getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(Integer totalItems) {
        this.totalItems = totalItems;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<CartItem> getCartItems() {
        return cartItems;
    }

    public void setCartItems(List<CartItem> cartItems) {
        this.cartItems = cartItems;
    }

    // Helper methods
    public void calculateTotals() {
        this.totalItems = 0;
        this.totalAmount = BigDecimal.ZERO;

        if (cartItems != null) {
            for (CartItem item : cartItems) {
                this.totalItems += item.getQuantity();
                this.totalAmount = this.totalAmount.add(item.getSubtotal());
            }
        }
    }

    public void addItem(CartItem cartItem) {
        if (cartItems == null) {
            cartItems = new ArrayList<>();
        }

        // Check if item already exists in cart
        for (CartItem existingItem : cartItems) {
            if (existingItem.getProduct().getId().equals(cartItem.getProduct().getId())) {
                existingItem.setQuantity(existingItem.getQuantity() + cartItem.getQuantity());
                calculateTotals();
                return;
            }
        }

        cartItems.add(cartItem);
        cartItem.setCart(this);
        calculateTotals();
    }

    public void removeItem(Long productId) {
        if (cartItems != null) {
            cartItems.removeIf(item -> item.getProduct().getId().equals(productId));
            calculateTotals();
        }
    }

    public boolean isEmpty() {
        return cartItems == null || cartItems.isEmpty();
    }

    public int getItemCount() {
        return cartItems != null ? cartItems.size() : 0;
    }
}
