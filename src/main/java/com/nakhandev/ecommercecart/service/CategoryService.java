package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface CategoryService {

    // Basic CRUD operations
    Category saveCategory(Category category);

    Optional<Category> findCategoryById(Long id);

    List<Category> findAllCategories();

    Page<Category> findAllCategories(Pageable pageable);

    void deleteCategoryById(Long id);

    // Category lookup methods
    Optional<Category> findByName(String name);

    boolean existsByName(String name);

    // Active categories
    List<Category> findAllActiveCategories();

    List<Category> findAllActiveOrderByDisplayOrder();

    // Category management
    Category activateCategory(Long id);

    Category deactivateCategory(Long id);

    // Analytics
    long countActiveCategories();

    // Search
    List<Category> searchCategories(String searchTerm);

    // Validation methods
    boolean isValidCategoryData(Category category);

    List<String> validateCategoryForCreation(Category category);
}
