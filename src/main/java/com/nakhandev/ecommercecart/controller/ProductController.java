package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.controller.common.BaseController;
import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.dto.product.ProductResponseDTO;
import com.nakhandev.ecommercecart.dto.product.ProductSummaryDTO;
import com.nakhandev.ecommercecart.model.Product;
import com.nakhandev.ecommercecart.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*") // Configure appropriately for production
public class ProductController extends BaseController {

    private final ProductService productService;

    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    /**
     * Get all products with pagination
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> getAllProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getAllProducts", page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Product> productPage = productService.findAllActiveProducts(pageable);

            List<ProductSummaryDTO> productDTOs = productPage.getContent().stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getAllProducts", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("getAllProducts", e);
            return createErrorResponse("Failed to get products: " + e.getMessage());
        }
    }

    /**
     * Get product by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponseDTO>> getProductById(@PathVariable Long id) {

        logControllerEntry("getProductById", id);

        try {
            Optional<Product> productOpt = productService.findProductById(id);
            if (productOpt.isEmpty()) {
                return createNotFoundResponse("Product not found with ID: " + id);
            }

            ProductResponseDTO responseDTO = ProductResponseDTO.fromEntity(productOpt.get());
            logControllerExit("getProductById", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getProductById", e);
            return createErrorResponse("Failed to get product: " + e.getMessage());
        }
    }

    /**
     * Search products by name
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> searchProducts(
            @RequestParam String query,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("searchProducts", query, page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Product> productPage = productService.searchProducts(query, pageable);

            List<ProductSummaryDTO> productDTOs = productPage.getContent().stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("searchProducts", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("searchProducts", e);
            return createErrorResponse("Failed to search products: " + e.getMessage());
        }
    }

    /**
     * Get products by category
     */
    @GetMapping("/category/{categoryId}")
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> getProductsByCategory(
            @PathVariable Long categoryId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getProductsByCategory", categoryId, page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Product> productPage = productService.findByCategoryId(categoryId, pageable);

            List<ProductSummaryDTO> productDTOs = productPage.getContent().stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getProductsByCategory", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("getProductsByCategory", e);
            return createErrorResponse("Failed to get products by category: " + e.getMessage());
        }
    }

    /**
     * Get featured products
     */
    @GetMapping("/featured")
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> getFeaturedProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getFeaturedProducts", page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Product> productPage = productService.findFeaturedProducts(pageable);

            List<ProductSummaryDTO> productDTOs = productPage.getContent().stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getFeaturedProducts", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("getFeaturedProducts", e);
            return createErrorResponse("Failed to get featured products: " + e.getMessage());
        }
    }

    /**
     * Get products on sale
     */
    @GetMapping("/sale")
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> getSaleProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getSaleProducts", page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Product> productPage = productService.findOnSaleProducts(pageable);

            List<ProductSummaryDTO> productDTOs = productPage.getContent().stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getSaleProducts", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("getSaleProducts", e);
            return createErrorResponse("Failed to get sale products: " + e.getMessage());
        }
    }

    /**
     * Get products by price range
     */
    @GetMapping("/price-range")
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> getProductsByPriceRange(
            @RequestParam BigDecimal minPrice,
            @RequestParam BigDecimal maxPrice) {

        logControllerEntry("getProductsByPriceRange", minPrice, maxPrice);

        try {
            List<Product> products = productService.findByPriceRange(minPrice, maxPrice);
            List<ProductSummaryDTO> productDTOs = products.stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getProductsByPriceRange", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("getProductsByPriceRange", e);
            return createErrorResponse("Failed to get products by price range: " + e.getMessage());
        }
    }

    /**
     * Get in-stock products
     */
    @GetMapping("/in-stock")
    public ResponseEntity<ApiResponse<List<ProductSummaryDTO>>> getInStockProducts() {

        logControllerEntry("getInStockProducts");

        try {
            List<Product> products = productService.findInStockProducts();
            List<ProductSummaryDTO> productDTOs = products.stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("getInStockProducts", productDTOs);
            return createSuccessResponse(productDTOs);

        } catch (Exception e) {
            logError("getInStockProducts", e);
            return createErrorResponse("Failed to get in-stock products: " + e.getMessage());
        }
    }

    /**
     * Create new product (admin only)
     */
    @PostMapping
    public ResponseEntity<ApiResponse<ProductResponseDTO>> createProduct(
            @Valid @RequestBody Product product) {

        logControllerEntry("createProduct", product.getName());

        try {
            // Validate product data
            List<String> validationErrors = productService.validateProductForCreation(product);
            if (!validationErrors.isEmpty()) {
                return createErrorResponse("Validation failed: " + String.join(", ", validationErrors));
            }

            Product savedProduct = productService.saveProduct(product);
            ProductResponseDTO responseDTO = ProductResponseDTO.fromEntity(savedProduct);

            logControllerExit("createProduct", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("createProduct", e);
            return createErrorResponse("Failed to create product: " + e.getMessage());
        }
    }

    /**
     * Update product (admin only)
     */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponseDTO>> updateProduct(
            @PathVariable Long id,
            @Valid @RequestBody Product product) {

        logControllerEntry("updateProduct", id);

        try {
            Optional<Product> existingProductOpt = productService.findProductById(id);
            if (existingProductOpt.isEmpty()) {
                return createNotFoundResponse("Product not found with ID: " + id);
            }

            Product existingProduct = existingProductOpt.get();
            existingProduct.setName(product.getName());
            existingProduct.setShortDescription(product.getShortDescription());
            existingProduct.setLongDescription(product.getLongDescription());
            existingProduct.setPrice(product.getPrice());
            existingProduct.setStockQuantity(product.getStockQuantity());
            existingProduct.setImageUrl(product.getImageUrl());
            existingProduct.setDiscountPercentage(product.getDiscountPercentage());

            // Update category if provided
            if (product.getCategory() != null) {
                existingProduct.setCategory(product.getCategory());
            }

            Product updatedProduct = productService.saveProduct(existingProduct);
            ProductResponseDTO responseDTO = ProductResponseDTO.fromEntity(updatedProduct);

            logControllerExit("updateProduct", responseDTO);
            return createSuccessResponse("Product updated successfully", responseDTO);

        } catch (Exception e) {
            logError("updateProduct", e);
            return createErrorResponse("Failed to update product: " + e.getMessage());
        }
    }

    /**
     * Delete product (admin only)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteProduct(@PathVariable Long id) {

        logControllerEntry("deleteProduct", id);

        try {
            productService.deleteProductById(id);

            logControllerExit("deleteProduct", "Product deleted");
            return createSuccessResponse("Product deleted successfully");

        } catch (Exception e) {
            logError("deleteProduct", e);
            return createErrorResponse("Failed to delete product: " + e.getMessage());
        }
    }

    /**
     * Update product stock (admin only)
     */
    @PutMapping("/{id}/stock")
    public ResponseEntity<ApiResponse<ProductResponseDTO>> updateProductStock(
            @PathVariable Long id,
            @RequestParam Integer stockQuantity) {

        logControllerEntry("updateProductStock", id, stockQuantity);

        try {
            Product updatedProduct = productService.updateStock(id, stockQuantity);
            ProductResponseDTO responseDTO = ProductResponseDTO.fromEntity(updatedProduct);

            logControllerExit("updateProductStock", responseDTO);
            return createSuccessResponse("Product stock updated successfully", responseDTO);

        } catch (Exception e) {
            logError("updateProductStock", e);
            return createErrorResponse("Failed to update product stock: " + e.getMessage());
        }
    }

    /**
     * Set product as featured (admin only)
     */
    @PutMapping("/{id}/featured")
    public ResponseEntity<ApiResponse<ProductResponseDTO>> setProductFeatured(
            @PathVariable Long id,
            @RequestParam boolean featured) {

        logControllerEntry("setProductFeatured", id, featured);

        try {
            Product updatedProduct = productService.setProductFeatured(id, featured);
            ProductResponseDTO responseDTO = ProductResponseDTO.fromEntity(updatedProduct);

            String message = featured ? "Product set as featured" : "Product removed from featured";
            logControllerExit("setProductFeatured", responseDTO);
            return createSuccessResponse(message, responseDTO);

        } catch (Exception e) {
            logError("setProductFeatured", e);
            return createErrorResponse("Failed to update product featured status: " + e.getMessage());
        }
    }

    /**
     * Get product statistics (admin only)
     */
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<ProductStats>> getProductStats() {

        logControllerEntry("getProductStats");

        try {
            long activeProducts = productService.countActiveProducts();
            long lowStockProducts = productService.countLowStockProducts(5);
            BigDecimal minPrice = productService.getMinPrice();
            BigDecimal maxPrice = productService.getMaxPrice();
            BigDecimal avgPrice = productService.getAveragePrice();

            ProductStats stats = new ProductStats(activeProducts, lowStockProducts,
                    minPrice, maxPrice, avgPrice);

            logControllerExit("getProductStats", stats);
            return createSuccessResponse(stats);

        } catch (Exception e) {
            logError("getProductStats", e);
            return createErrorResponse("Failed to get product statistics: " + e.getMessage());
        }
    }

    /**
     * Check if product is available in requested quantity
     */
    @GetMapping("/{id}/availability")
    public ResponseEntity<ApiResponse<Boolean>> checkProductAvailability(
            @PathVariable Long id,
            @RequestParam Integer quantity) {

        logControllerEntry("checkProductAvailability", id, quantity);

        try {
            boolean available = productService.isStockAvailable(id, quantity);

            logControllerExit("checkProductAvailability", available);
            return createSuccessResponse(available);

        } catch (Exception e) {
            logError("checkProductAvailability", e);
            return createErrorResponse("Failed to check product availability: " + e.getMessage());
        }
    }

    // Inner class for product statistics
    public static class ProductStats {
        private long activeProducts;
        private long lowStockProducts;
        private BigDecimal minPrice;
        private BigDecimal maxPrice;
        private BigDecimal averagePrice;

        public ProductStats(long activeProducts, long lowStockProducts,
                           BigDecimal minPrice, BigDecimal maxPrice, BigDecimal averagePrice) {
            this.activeProducts = activeProducts;
            this.lowStockProducts = lowStockProducts;
            this.minPrice = minPrice;
            this.maxPrice = maxPrice;
            this.averagePrice = averagePrice;
        }

        // Getters
        public long getActiveProducts() { return activeProducts; }
        public long getLowStockProducts() { return lowStockProducts; }
        public BigDecimal getMinPrice() { return minPrice; }
        public BigDecimal getMaxPrice() { return maxPrice; }
        public BigDecimal getAveragePrice() { return averagePrice; }
    }
}
