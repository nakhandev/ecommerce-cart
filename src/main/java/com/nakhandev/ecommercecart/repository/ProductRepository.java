package com.nakhandev.ecommercecart.repository;

import com.nakhandev.ecommercecart.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Optional<Product> findBySku(String sku);

    boolean existsBySku(String sku);

    @Query("SELECT p FROM Product p WHERE p.isActive = true")
    List<Product> findAllActive();

    @Query("SELECT p FROM Product p WHERE p.isActive = true")
    Page<Product> findAllActive(Pageable pageable);

    @Query("SELECT p FROM Product p WHERE p.category.id = :categoryId AND p.isActive = true")
    List<Product> findByCategoryIdAndActive(@Param("categoryId") Long categoryId);

    @Query("SELECT p FROM Product p WHERE p.category.id = :categoryId AND p.isActive = true")
    Page<Product> findByCategoryIdAndActive(@Param("categoryId") Long categoryId, Pageable pageable);

    @Query("SELECT p FROM Product p WHERE p.isFeatured = true AND p.isActive = true")
    List<Product> findFeaturedProducts();

    @Query("SELECT p FROM Product p WHERE p.isFeatured = true AND p.isActive = true")
    Page<Product> findFeaturedProducts(Pageable pageable);

    @Query("SELECT p FROM Product p WHERE p.name LIKE %:searchTerm% AND p.isActive = true")
    List<Product> findByNameContainingAndActive(@Param("searchTerm") String searchTerm);

    @Query("SELECT p FROM Product p WHERE p.name LIKE %:searchTerm% AND p.isActive = true")
    Page<Product> findByNameContainingAndActive(@Param("searchTerm") String searchTerm, Pageable pageable);

    @Query("SELECT p FROM Product p WHERE p.price BETWEEN :minPrice AND :maxPrice AND p.isActive = true")
    List<Product> findByPriceBetweenAndActive(@Param("minPrice") BigDecimal minPrice, @Param("maxPrice") BigDecimal maxPrice);

    @Query("SELECT p FROM Product p WHERE p.stockQuantity > 0 AND p.isActive = true")
    List<Product> findInStockProducts();

    @Query("SELECT p FROM Product p WHERE p.stockQuantity <= :threshold AND p.isActive = true")
    List<Product> findLowStockProducts(@Param("threshold") Integer threshold);

    @Query("SELECT p FROM Product p WHERE p.discountPercentage > 0 AND p.isActive = true")
    List<Product> findOnSaleProducts();

    @Query("SELECT p FROM Product p WHERE p.discountPercentage > 0 AND p.isActive = true")
    Page<Product> findOnSaleProducts(Pageable pageable);

    @Query("SELECT COUNT(p) FROM Product p WHERE p.isActive = true")
    long countActiveProducts();

    @Query("SELECT COUNT(p) FROM Product p WHERE p.stockQuantity <= :threshold AND p.isActive = true")
    long countLowStockProducts(@Param("threshold") Integer threshold);

    @Query("SELECT MIN(p.price) FROM Product p WHERE p.isActive = true")
    BigDecimal findMinPrice();

    @Query("SELECT MAX(p.price) FROM Product p WHERE p.isActive = true")
    BigDecimal findMaxPrice();

    @Query("SELECT AVG(p.price) FROM Product p WHERE p.isActive = true")
    BigDecimal findAveragePrice();

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.category WHERE p.id = :id")
    Optional<Product> findByIdWithCategory(@Param("id") Long id);

    @Query("SELECT p FROM Product p WHERE p.category.id IN :categoryIds AND p.isActive = true")
    List<Product> findByCategoryIdsAndActive(@Param("categoryIds") List<Long> categoryIds);

    @Query("SELECT DISTINCT p FROM Product p JOIN p.orderItems oi WHERE oi.order.user.id = :userId")
    List<Product> findProductsPurchasedByUser(@Param("userId") Long userId);
}
