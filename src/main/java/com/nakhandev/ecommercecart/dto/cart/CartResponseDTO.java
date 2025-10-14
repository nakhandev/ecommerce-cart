package com.nakhandev.ecommercecart.dto.cart;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class CartResponseDTO {

    private Long id;
    private Long userId;
    private String username;
    private Integer totalItems;
    private BigDecimal totalAmount;
    private List<CartItemDTO> items;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    // Constructors
    public CartResponseDTO() {}

    // Static factory method for easy creation from entity
    public static CartResponseDTO fromEntity(com.nakhandev.ecommercecart.model.Cart cart) {
        if (cart == null) {
            return null;
        }

        CartResponseDTO dto = new CartResponseDTO();
        dto.setId(cart.getId());
        dto.setTotalItems(cart.getTotalItems());
        dto.setTotalAmount(cart.getTotalAmount());
        dto.setCreatedAt(cart.getCreatedAt());
        dto.setUpdatedAt(cart.getUpdatedAt());

        // Set user information
        if (cart.getUser() != null) {
            dto.setUserId(cart.getUser().getId());
            dto.setUsername(cart.getUser().getUsername());
        }

        // Convert cart items
        if (cart.getCartItems() != null) {
            List<CartItemDTO> itemDTOs = cart.getCartItems().stream()
                    .map(CartItemDTO::fromEntity)
                    .collect(Collectors.toList());
            dto.setItems(itemDTOs);
        }

        return dto;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public List<CartItemDTO> getItems() {
        return items;
    }

    public void setItems(List<CartItemDTO> items) {
        this.items = items;
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

    // Utility methods
    public boolean isEmpty() {
        return totalItems == null || totalItems == 0;
    }

    public String getDisplayTotalAmount() {
        return String.format("₹%.2f", totalAmount);
    }

    public int getItemCount() {
        return items != null ? items.size() : 0;
    }
}
