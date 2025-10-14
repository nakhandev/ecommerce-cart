package com.nakhandev.ecommercecart.dto.product;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.math.BigDecimal;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductSummaryDTO {

    private Long id;
    private String name;
    private String shortDescription;
    private String sku;
    private BigDecimal price;
    private BigDecimal discountedPrice;
    private String imageUrl;
    private Boolean isFeatured;
    private BigDecimal discountPercentage;
    private String categoryName;

    // Constructors
    public ProductSummaryDTO() {}

    // Static factory method for easy creation from entity
    public static ProductSummaryDTO fromEntity(com.nakhandev.ecommercecart.model.Product product) {
        if (product == null) {
            return null;
        }

        ProductSummaryDTO dto = new ProductSummaryDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setShortDescription(product.getShortDescription());
        dto.setSku(product.getSku());
        dto.setPrice(product.getPrice());
        dto.setDiscountedPrice(product.getDiscountedPrice());
        dto.setImageUrl(product.getImageUrl());
        dto.setIsFeatured(product.getIsFeatured());
        dto.setDiscountPercentage(product.getDiscountPercentage());

        // Set category information
        if (product.getCategory() != null) {
            dto.setCategoryName(product.getCategory().getName());
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscountedPrice() {
        return discountedPrice;
    }

    public void setDiscountedPrice(BigDecimal discountedPrice) {
        this.discountedPrice = discountedPrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getIsFeatured() {
        return isFeatured;
    }

    public void setIsFeatured(Boolean isFeatured) {
        this.isFeatured = isFeatured;
    }

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(BigDecimal discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    // Utility methods
    public boolean isOnSale() {
        return discountPercentage != null && discountPercentage.compareTo(BigDecimal.ZERO) > 0;
    }

    public String getDisplayPrice() {
        return String.format("₹%.2f", getDiscountedPrice());
    }

    public String getOriginalPriceDisplay() {
        return String.format("₹%.2f", price);
    }

    public String getDiscountedPriceDisplay() {
        return String.format("₹%.2f", discountedPrice);
    }
}
