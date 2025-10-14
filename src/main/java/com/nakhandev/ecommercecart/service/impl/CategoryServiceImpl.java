package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.Category;
import com.nakhandev.ecommercecart.repository.CategoryRepository;
import com.nakhandev.ecommercecart.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolation;
import javax.validation.Validator;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    private static final Logger logger = LoggerFactory.getLogger(CategoryServiceImpl.class);

    private final CategoryRepository categoryRepository;
    private final Validator validator;

    @Autowired
    public CategoryServiceImpl(CategoryRepository categoryRepository, Validator validator) {
        this.categoryRepository = categoryRepository;
        this.validator = validator;
    }

    @Override
    public Category saveCategory(Category category) {
        logger.info("Saving category: {}", category.getName());

        // Validate category data
        if (!isValidCategoryData(category)) {
            throw new IllegalArgumentException("Invalid category data");
        }

        Category savedCategory = categoryRepository.save(category);
        logger.info("Category saved successfully with ID: {}", savedCategory.getId());
        return savedCategory;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Category> findCategoryById(Long id) {
        logger.debug("Finding category by ID: {}", id);
        return categoryRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> findAllCategories() {
        logger.debug("Finding all categories");
        return categoryRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Category> findAllCategories(Pageable pageable) {
        logger.debug("Finding all categories with pagination");
        return categoryRepository.findAll(pageable);
    }

    @Override
    public void deleteCategoryById(Long id) {
        logger.info("Deleting category with ID: {}", id);
        categoryRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Category> findByName(String name) {
        logger.debug("Finding category by name: {}", name);
        return categoryRepository.findByName(name);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByName(String name) {
        return categoryRepository.existsByName(name);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> findAllActiveCategories() {
        logger.debug("Finding all active categories");
        return categoryRepository.findAllActiveOrderByDisplayOrder();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> findAllActiveOrderByDisplayOrder() {
        logger.debug("Finding all active categories ordered by display order");
        return categoryRepository.findAllActiveOrderByDisplayOrder();
    }

    @Override
    public Category activateCategory(Long id) {
        logger.info("Activating category with ID: {}", id);
        Optional<Category> categoryOpt = categoryRepository.findById(id);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();
            category.setIsActive(true);
            return categoryRepository.save(category);
        }
        throw new RuntimeException("Category not found with ID: " + id);
    }

    @Override
    public Category deactivateCategory(Long id) {
        logger.info("Deactivating category with ID: {}", id);
        Optional<Category> categoryOpt = categoryRepository.findById(id);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();
            category.setIsActive(false);
            return categoryRepository.save(category);
        }
        throw new RuntimeException("Category not found with ID: " + id);
    }

    @Override
    @Transactional(readOnly = true)
    public long countActiveCategories() {
        // This would need a custom query in the repository
        // For now, we'll use the basic findAll and count
        return findAllActiveCategories().size();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> searchCategories(String searchTerm) {
        logger.debug("Searching categories with term: {}", searchTerm);
        return categoryRepository.findActiveByNameContaining(searchTerm);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isValidCategoryData(Category category) {
        Set<ConstraintViolation<Category>> violations = validator.validate(category);
        return violations.isEmpty();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validateCategoryForCreation(Category category) {
        List<String> errors = new ArrayList<>();

        // Check if name already exists
        if (existsByName(category.getName())) {
            errors.add("Category name is already in use");
        }

        // Validate category data using Bean Validation
        Set<ConstraintViolation<Category>> violations = validator.validate(category);
        for (ConstraintViolation<Category> violation : violations) {
            errors.add(violation.getMessage());
        }

        return errors;
    }
}
