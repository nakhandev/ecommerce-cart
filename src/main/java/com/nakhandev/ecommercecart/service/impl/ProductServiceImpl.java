package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.Product;
import com.nakhandev.ecommercecart.repository.ProductRepository;
import com.nakhandev.ecommercecart.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolation;
import javax.validation.Validator;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    private static final Logger logger = LoggerFactory.getLogger(ProductServiceImpl.class);

    private final ProductRepository productRepository;
    private final Validator validator;

    @Autowired
    public ProductServiceImpl(ProductRepository productRepository, Validator validator) {
        this.productRepository = productRepository;
        this.validator = validator;
    }

    @Override
    public Product saveProduct(Product product) {
        logger.info("Saving product: {} (SKU: {})", product.getName(), product.getSku());

        // Validate product data
        if (!isValidProductData(product)) {
            throw new IllegalArgumentException("Invalid product data");
        }

        Product savedProduct = productRepository.save(product);
        logger.info("Product saved successfully with ID: {}", savedProduct.getId());
        return savedProduct;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> findProductById(Long id) {
        logger.debug("Finding product by ID: {}", id);
        return productRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findAllProducts() {
        logger.debug("Finding all products");
        return productRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findAllProducts(Pageable pageable) {
        logger.debug("Finding all products with pagination");
        return productRepository.findAll(pageable);
    }

    @Override
    public void deleteProductById(Long id) {
        logger.info("Deleting product with ID: {}", id);
        productRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> findBySku(String sku) {
        logger.debug("Finding product by SKU: {}", sku);
        return productRepository.findBySku(sku);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsBySku(String sku) {
        return productRepository.existsBySku(sku);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findAllActiveProducts() {
        logger.debug("Finding all active products");
        return productRepository.findAllActive();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findAllActiveProducts(Pageable pageable) {
        logger.debug("Finding all active products with pagination");
        return productRepository.findAllActive(pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findByCategoryId(Long categoryId) {
        logger.debug("Finding products by category ID: {}", categoryId);
        return productRepository.findByCategoryIdAndActive(categoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findByCategoryId(Long categoryId, Pageable pageable) {
        logger.debug("Finding products by category ID: {} with pagination", categoryId);
        return productRepository.findByCategoryIdAndActive(categoryId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findByCategoryIds(List<Long> categoryIds) {
        logger.debug("Finding products by category IDs: {}", categoryIds);
        return productRepository.findByCategoryIdsAndActive(categoryIds);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findFeaturedProducts() {
        logger.debug("Finding featured products");
        return productRepository.findFeaturedProducts();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findFeaturedProducts(Pageable pageable) {
        logger.debug("Finding featured products with pagination");
        return productRepository.findFeaturedProducts(pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> searchProducts(String searchTerm) {
        logger.debug("Searching products with term: {}", searchTerm);
        return productRepository.findByNameContainingAndActive(searchTerm);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> searchProducts(String searchTerm, Pageable pageable) {
        logger.debug("Searching products with term: {} and pagination", searchTerm);
        return productRepository.findByNameContainingAndActive(searchTerm, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        logger.debug("Finding products by price range: {} - {}", minPrice, maxPrice);
        return productRepository.findByPriceBetweenAndActive(minPrice, maxPrice);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findInStockProducts() {
        logger.debug("Finding in-stock products");
        return productRepository.findInStockProducts();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findLowStockProducts(Integer threshold) {
        logger.debug("Finding low stock products with threshold: {}", threshold);
        return productRepository.findLowStockProducts(threshold);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findOnSaleProducts() {
        logger.debug("Finding products on sale");
        return productRepository.findOnSaleProducts();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findOnSaleProducts(Pageable pageable) {
        logger.debug("Finding products on sale with pagination");
        return productRepository.findOnSaleProducts(pageable);
    }

    @Override
    public Product activateProduct(Long id) {
        logger.info("Activating product with ID: {}", id);
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setIsActive(true);
            return productRepository.save(product);
        }
        throw new RuntimeException("Product not found with ID: " + id);
    }

    @Override
    public Product deactivateProduct(Long id) {
        logger.info("Deactivating product with ID: {}", id);
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setIsActive(false);
            return productRepository.save(product);
        }
        throw new RuntimeException("Product not found with ID: " + id);
    }

    @Override
    public Product setProductFeatured(Long id, boolean featured) {
        logger.info("Setting product {} as featured: {}", id, featured);
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setIsFeatured(featured);
            return productRepository.save(product);
        }
        throw new RuntimeException("Product not found with ID: " + id);
    }

    @Override
    public Product updateStock(Long id, Integer newStock) {
        logger.info("Updating stock for product {} to {}", id, newStock);
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setStockQuantity(newStock);
            return productRepository.save(product);
        }
        throw new RuntimeException("Product not found with ID: " + id);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isStockAvailable(Long productId, Integer requestedQuantity) {
        Optional<Product> productOpt = productRepository.findById(productId);
        return productOpt.map(product -> product.isInStock() && product.getStockQuantity() >= requestedQuantity).orElse(false);
    }

    @Override
    @Transactional(readOnly = true)
    public long countActiveProducts() {
        return productRepository.countActiveProducts();
    }

    @Override
    @Transactional(readOnly = true)
    public long countLowStockProducts(Integer threshold) {
        return productRepository.countLowStockProducts(threshold);
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getMinPrice() {
        BigDecimal minPrice = productRepository.findMinPrice();
        return minPrice != null ? minPrice : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getMaxPrice() {
        BigDecimal maxPrice = productRepository.findMaxPrice();
        return maxPrice != null ? maxPrice : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getAveragePrice() {
        BigDecimal avgPrice = productRepository.findAveragePrice();
        return avgPrice != null ? avgPrice : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> findByIdWithCategory(Long id) {
        logger.debug("Finding product by ID with category: {}", id);
        return productRepository.findByIdWithCategory(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findProductsPurchasedByUser(Long userId) {
        logger.debug("Finding products purchased by user: {}", userId);
        return productRepository.findProductsPurchasedByUser(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isValidProductData(Product product) {
        Set<ConstraintViolation<Product>> violations = validator.validate(product);
        return violations.isEmpty();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validateProductForCreation(Product product) {
        List<String> errors = new ArrayList<>();

        // Check if SKU already exists
        if (existsBySku(product.getSku())) {
            errors.add("SKU is already in use");
        }

        // Validate product data using Bean Validation
        Set<ConstraintViolation<Product>> violations = validator.validate(product);
        for (ConstraintViolation<Product> violation : violations) {
            errors.add(violation.getMessage());
        }

        return errors;
    }
}
