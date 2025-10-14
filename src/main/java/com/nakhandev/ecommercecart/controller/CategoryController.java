package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.controller.common.BaseController;
import com.nakhandev.ecommercecart.dto.category.CategoryResponseDTO;
import com.nakhandev.ecommercecart.dto.category.CategorySummaryDTO;
import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.model.Category;
import com.nakhandev.ecommercecart.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/categories")
@CrossOrigin(origins = "*") // Configure appropriately for production
public class CategoryController extends BaseController {

    private final CategoryService categoryService;

    @Autowired
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    /**
     * Get all categories
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<CategorySummaryDTO>>> getAllCategories(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getAllCategories", page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Category> categoryPage = categoryService.findAllCategories(pageable);

            List<CategorySummaryDTO> categoryDTOs = categoryPage.getContent().stream()
                    .map(CategorySummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getAllCategories", categoryDTOs);
            return createSuccessResponse(categoryDTOs);

        } catch (Exception e) {
            logError("getAllCategories", e);
            return createErrorResponse("Failed to get categories: " + e.getMessage());
        }
    }

    /**
     * Get category by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryResponseDTO>> getCategoryById(@PathVariable Long id) {

        logControllerEntry("getCategoryById", id);

        try {
            Optional<Category> categoryOpt = categoryService.findCategoryById(id);
            if (categoryOpt.isEmpty()) {
                return createNotFoundResponse("Category not found with ID: " + id);
            }

            CategoryResponseDTO responseDTO = CategoryResponseDTO.fromEntity(categoryOpt.get());
            logControllerExit("getCategoryById", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getCategoryById", e);
            return createErrorResponse("Failed to get category: " + e.getMessage());
        }
    }

    /**
     * Get category by name
     */
    @GetMapping("/name/{name}")
    public ResponseEntity<ApiResponse<CategoryResponseDTO>> getCategoryByName(@PathVariable String name) {

        logControllerEntry("getCategoryByName", name);

        try {
            Optional<Category> categoryOpt = categoryService.findByName(name);
            if (categoryOpt.isEmpty()) {
                return createNotFoundResponse("Category not found with name: " + name);
            }

            CategoryResponseDTO responseDTO = CategoryResponseDTO.fromEntity(categoryOpt.get());
            logControllerExit("getCategoryByName", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getCategoryByName", e);
            return createErrorResponse("Failed to get category: " + e.getMessage());
        }
    }

    /**
     * Get active categories
     */
    @GetMapping("/active")
    public ResponseEntity<ApiResponse<List<CategorySummaryDTO>>> getActiveCategories() {

        logControllerEntry("getActiveCategories");

        try {
            List<Category> categories = categoryService.findAllActiveCategories();
            List<CategorySummaryDTO> categoryDTOs = categories.stream()
                    .map(CategorySummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getActiveCategories", categoryDTOs);
            return createSuccessResponse(categoryDTOs);

        } catch (Exception e) {
            logError("getActiveCategories", e);
            return createErrorResponse("Failed to get active categories: " + e.getMessage());
        }
    }

    /**
     * Search categories
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<CategorySummaryDTO>>> searchCategories(
            @RequestParam String searchTerm) {

        logControllerEntry("searchCategories", searchTerm);

        try {
            List<Category> categories = categoryService.searchCategories(searchTerm);
            List<CategorySummaryDTO> categoryDTOs = categories.stream()
                    .map(CategorySummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("searchCategories", categoryDTOs);
            return createSuccessResponse(categoryDTOs);

        } catch (Exception e) {
            logError("searchCategories", e);
            return createErrorResponse("Failed to search categories: " + e.getMessage());
        }
    }

    /**
     * Create new category (admin only)
     */
    @PostMapping
    public ResponseEntity<ApiResponse<CategoryResponseDTO>> createCategory(
            @Valid @RequestBody Category category) {

        logControllerEntry("createCategory", category.getName());

        try {
            // Validate category data
            List<String> validationErrors = categoryService.validateCategoryForCreation(category);
            if (!validationErrors.isEmpty()) {
                return createErrorResponse("Validation failed: " + String.join(", ", validationErrors));
            }

            Category savedCategory = categoryService.saveCategory(category);
            CategoryResponseDTO responseDTO = CategoryResponseDTO.fromEntity(savedCategory);

            logControllerExit("createCategory", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("createCategory", e);
            return createErrorResponse("Failed to create category: " + e.getMessage());
        }
    }

    /**
     * Update category (admin only)
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryResponseDTO>> updateCategory(
            @PathVariable Long id,
            @Valid @RequestBody Category category) {

        logControllerEntry("updateCategory", id);

        try {
            Optional<Category> existingCategoryOpt = categoryService.findCategoryById(id);
            if (existingCategoryOpt.isEmpty()) {
                return createNotFoundResponse("Category not found with ID: " + id);
            }

            Category existingCategory = existingCategoryOpt.get();
            existingCategory.setName(category.getName());
            existingCategory.setDescription(category.getDescription());
            existingCategory.setImageUrl(category.getImageUrl());
            existingCategory.setDisplayOrder(category.getDisplayOrder());

            Category updatedCategory = categoryService.saveCategory(existingCategory);
            CategoryResponseDTO responseDTO = CategoryResponseDTO.fromEntity(updatedCategory);

            logControllerExit("updateCategory", responseDTO);
            return createSuccessResponse("Category updated successfully", responseDTO);

        } catch (Exception e) {
            logError("updateCategory", e);
            return createErrorResponse("Failed to update category: " + e.getMessage());
        }
    }

    /**
     * Delete category (admin only)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(@PathVariable Long id) {

        logControllerEntry("deleteCategory", id);

        try {
            categoryService.deleteCategoryById(id);

            logControllerExit("deleteCategory", "Category deleted");
            return createSuccessResponse("Category deleted successfully");

        } catch (Exception e) {
            logError("deleteCategory", e);
            return createErrorResponse("Failed to delete category: " + e.getMessage());
        }
    }

    /**
     * Activate category (admin only)
     */
    @PutMapping("/{id}/activate")
    public ResponseEntity<ApiResponse<CategoryResponseDTO>> activateCategory(@PathVariable Long id) {

        logControllerEntry("activateCategory", id);

        try {
            Category activatedCategory = categoryService.activateCategory(id);
            CategoryResponseDTO responseDTO = CategoryResponseDTO.fromEntity(activatedCategory);

            logControllerExit("activateCategory", responseDTO);
            return createSuccessResponse("Category activated successfully", responseDTO);

        } catch (Exception e) {
            logError("activateCategory", e);
            return createErrorResponse("Failed to activate category: " + e.getMessage());
        }
    }

    /**
     * Deactivate category (admin only)
     */
    @PutMapping("/{id}/deactivate")
    public ResponseEntity<ApiResponse<CategoryResponseDTO>> deactivateCategory(@PathVariable Long id) {

        logControllerEntry("deactivateCategory", id);

        try {
            Category deactivatedCategory = categoryService.deactivateCategory(id);
            CategoryResponseDTO responseDTO = CategoryResponseDTO.fromEntity(deactivatedCategory);

            logControllerExit("deactivateCategory", responseDTO);
            return createSuccessResponse("Category deactivated successfully", responseDTO);

        } catch (Exception e) {
            logError("deactivateCategory", e);
            return createErrorResponse("Failed to deactivate category: " + e.getMessage());
        }
    }

    /**
     * Get category statistics (admin only)
     */
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<CategoryStats>> getCategoryStats() {

        logControllerEntry("getCategoryStats");

        try {
            long activeCategories = categoryService.countActiveCategories();
            long totalCategories = categoryService.findAllCategories().size();

            CategoryStats stats = new CategoryStats(totalCategories, activeCategories);

            logControllerExit("getCategoryStats", stats);
            return createSuccessResponse(stats);

        } catch (Exception e) {
            logError("getCategoryStats", e);
            return createErrorResponse("Failed to get category statistics: " + e.getMessage());
        }
    }

    // Inner class for category statistics
    public static class CategoryStats {
        private long totalCategories;
        private long activeCategories;

        public CategoryStats(long totalCategories, long activeCategories) {
            this.totalCategories = totalCategories;
            this.activeCategories = activeCategories;
        }

        // Getters
        public long getTotalCategories() { return totalCategories; }
        public long getActiveCategories() { return activeCategories; }
        public long getInactiveCategories() { return totalCategories - activeCategories; }
    }
}
