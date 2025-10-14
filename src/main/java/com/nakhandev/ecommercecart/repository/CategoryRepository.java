package com.nakhandev.ecommercecart.repository;

import com.nakhandev.ecommercecart.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    Optional<Category> findByName(String name);

    boolean existsByName(String name);

    @Query("SELECT c FROM Category c WHERE c.isActive = true ORDER BY c.displayOrder ASC, c.name ASC")
    List<Category> findAllActiveOrderByDisplayOrder();

    @Query("SELECT c FROM Category c WHERE c.isActive = true AND c.name LIKE %:searchTerm%")
    List<Category> findActiveByNameContaining(@org.springframework.data.repository.query.Param("searchTerm") String searchTerm);

    @Query("SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId")
    long countProductsByCategoryId(@org.springframework.data.repository.query.Param("categoryId") Long categoryId);

    @Query("SELECT c FROM Category c LEFT JOIN FETCH c.products WHERE c.id = :id")
    Optional<Category> findByIdWithProducts(@org.springframework.data.repository.query.Param("id") Long id);
}
