package com.nakhandev.ecommercecart.dto.category;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class CategorySummaryDTO {

    private Long id;
    private String name;
    private String description;
    private String imageUrl;
    private Integer productCount;

    // Constructors
    public CategorySummaryDTO() {}

    // Static factory method for easy creation from entity
    public static CategorySummaryDTO fromEntity(com.nakhandev.ecommercecart.model.Category category) {
        if (category == null) {
            return null;
        }

        CategorySummaryDTO dto = new CategorySummaryDTO();
        dto.setId(category.getId());
        dto.setName(category.getName());
        dto.setDescription(category.getDescription());
        dto.setImageUrl(category.getImageUrl());
        dto.setProductCount(category.getProductCount());

        return dto;
    }

    // Static factory method with custom product count
    public static CategorySummaryDTO fromEntityWithProductCount(com.nakhandev.ecommercecart.model.Category category, int productCount) {
        CategorySummaryDTO dto = fromEntity(category);
        if (dto != null) {
            dto.setProductCount(productCount);
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getProductCount() {
        return productCount;
    }

    public void setProductCount(Integer productCount) {
        this.productCount = productCount;
    }

    // Utility methods
    public boolean hasProducts() {
        return productCount != null && productCount > 0;
    }

    public String getDisplayProductCount() {
        if (productCount == null) {
            return "0 products";
        }
        return productCount == 1 ? "1 product" : productCount + " products";
    }
}
