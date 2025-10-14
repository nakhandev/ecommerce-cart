package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface ProductService {

    // Basic CRUD operations
    Product saveProduct(Product product);

    Optional<Product> findProductById(Long id);

    List<Product> findAllProducts();

    Page<Product> findAllProducts(Pageable pageable);

    void deleteProductById(Long id);

    // Product lookup methods
    Optional<Product> findBySku(String sku);

    boolean existsBySku(String sku);

    // Active products
    List<Product> findAllActiveProducts();

    Page<Product> findAllActiveProducts(Pageable pageable);

    // Category-based queries
    List<Product> findByCategoryId(Long categoryId);

    Page<Product> findByCategoryId(Long categoryId, Pageable pageable);

    List<Product> findByCategoryIds(List<Long> categoryIds);

    // Featured products
    List<Product> findFeaturedProducts();

    Page<Product> findFeaturedProducts(Pageable pageable);

    // Search and filter methods
    List<Product> searchProducts(String searchTerm);

    Page<Product> searchProducts(String searchTerm, Pageable pageable);

    List<Product> findByPriceRange(BigDecimal minPrice, BigDecimal maxPrice);

    List<Product> findInStockProducts();

    List<Product> findLowStockProducts(Integer threshold);

    List<Product> findOnSaleProducts();

    Page<Product> findOnSaleProducts(Pageable pageable);

    // Product management
    Product activateProduct(Long id);

    Product deactivateProduct(Long id);

    Product setProductFeatured(Long id, boolean featured);

    Product updateStock(Long id, Integer newStock);

    boolean isStockAvailable(Long productId, Integer requestedQuantity);

    // Analytics and reporting
    long countActiveProducts();

    long countLowStockProducts(Integer threshold);

    BigDecimal getMinPrice();

    BigDecimal getMaxPrice();

    BigDecimal getAveragePrice();

    // Product relationships
    Optional<Product> findByIdWithCategory(Long id);

    List<Product> findProductsPurchasedByUser(Long userId);

    // Validation methods
    boolean isValidProductData(Product product);

    List<String> validateProductForCreation(Product product);
}
