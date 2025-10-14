package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.dto.product.ProductSummaryDTO;
import com.nakhandev.ecommercecart.model.Product;
import com.nakhandev.ecommercecart.model.Category;
import com.nakhandev.ecommercecart.service.ProductService;
import com.nakhandev.ecommercecart.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/")
public class HomeController {

    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    /**
     * Main page - serves the home page with featured products
     */
    @GetMapping("/")
    public String home(Model model) {
        logger.info("Serving home page");

        try {
            // Get featured products for the home page using the service directly
            List<Product> featuredProductEntities = productService.findFeaturedProducts();
            List<ProductSummaryDTO> featuredProducts = featuredProductEntities.stream()
                    .map(ProductSummaryDTO::fromEntity)
                    .collect(java.util.stream.Collectors.toList());
            model.addAttribute("featuredProducts", featuredProducts);

            logger.info("Home page loaded successfully with {} featured products", featuredProducts.size());
            return "public/index";
        } catch (Exception e) {
            logger.error("Error loading home page", e);
            model.addAttribute("error", "Unable to load featured products");
            return "public/index";
        }
    }

    /**
     * Products page
     */
    @GetMapping("/products")
    public String products(Model model) {
        logger.info("Serving products page");
        return "products/index";
    }

    /**
     * Product detail page
     */
    @GetMapping("/products/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        logger.info("Serving product detail page for product ID: {}", id);
        model.addAttribute("productId", id);
        return "products/detail";
    }

    /**
     * Categories page
     */
    @GetMapping("/categories")
    public String categories(Model model) {
        logger.info("Serving categories page");
        return "categories/index";
    }

    /**
     * Category detail page
     */
    @GetMapping("/categories/{id}")
    public String categoryDetail(@PathVariable Long id, Model model) {
        logger.info("Serving category detail page for category ID: {}", id);

        try {
            // Get category from API
            Optional<Category> categoryOpt = categoryService.findCategoryById(id);
            if (categoryOpt.isEmpty()) {
                logger.warn("Category not found with ID: {}", id);
                return "error/404";
            }

            Category category = categoryOpt.get();
            model.addAttribute("category", category);

            logger.info("Category detail page loaded successfully for category: {}", category.getName());
            return "categories/detail";

        } catch (Exception e) {
            logger.error("Error loading category detail page for ID: " + id, e);
            model.addAttribute("error", "Unable to load category details");
            return "error/general";
        }
    }

    /**
     * Cart page
     */
    @GetMapping("/cart")
    public String cart(Model model) {
        logger.info("Serving cart page");
        return "cart/index";
    }

    /**
     * Checkout page
     */
    @GetMapping("/checkout")
    public String checkout(Model model) {
        logger.info("Serving checkout page");
        return "checkout/index";
    }

    /**
     * Checkout payment page
     */
    @GetMapping("/checkout/payment")
    public String checkoutPayment(Model model) {
        logger.info("Serving checkout payment page");
        return "checkout/payment";
    }

    /**
     * Checkout confirmation page
     */
    @GetMapping("/checkout/confirmation")
    public String checkoutConfirmation(Model model) {
        logger.info("Serving checkout confirmation page");
        return "checkout/confirmation";
    }

    /**
     * Orders page
     */
    @GetMapping("/orders")
    public String orders(Model model) {
        logger.info("Serving orders page");
        return "orders/index";
    }

    /**
     * Admin dashboard
     */
    @GetMapping("/admin")
    public String adminDashboard(Model model) {
        logger.info("Serving admin dashboard");
        return "admin/dashboard";
    }

    /**
     * Admin products management
     */
    @GetMapping("/admin/products")
    public String adminProducts(Model model) {
        logger.info("Serving admin products page");
        return "admin/products/index";
    }

    /**
     * Admin product create
     */
    @GetMapping("/admin/products/create")
    public String adminProductCreate(Model model) {
        logger.info("Serving admin product create page");
        return "admin/products/create";
    }

    /**
     * Admin product edit
     */
    @GetMapping("/admin/products/edit/{id}")
    public String adminProductEdit(@PathVariable Long id, Model model) {
        logger.info("Serving admin product edit page for product ID: {}", id);
        model.addAttribute("productId", id);
        return "admin/products/edit";
    }

    /**
     * Admin product view
     */
    @GetMapping("/admin/products/view/{id}")
    public String adminProductView(@PathVariable Long id, Model model) {
        logger.info("Serving admin product view page for product ID: {}", id);
        model.addAttribute("productId", id);
        return "admin/products/view";
    }

    /**
     * User profile page
     */
    @GetMapping("/profile")
    public String profile(Model model) {
        logger.info("Serving user profile page");
        return "user/profile";
    }

    /**
     * Login page
     */
    @GetMapping("/login")
    public String login(Model model) {
        logger.info("Serving login page");
        return "auth/login";
    }

    /**
     * Registration page
     */
    @GetMapping("/register")
    public String register(Model model) {
        logger.info("Serving registration page");
        return "auth/register";
    }

    /**
     * About page
     */
    @GetMapping("/about")
    public String about(Model model) {
        logger.info("Serving about page");
        return "public/about";
    }

    /**
     * Contact page
     */
    @GetMapping("/contact")
    public String contact(Model model) {
        logger.info("Serving contact page");
        return "public/contact";
    }

    /**
     * Help page
     */
    @GetMapping("/help")
    public String help(Model model) {
        logger.info("Serving help page");
        return "public/help";
    }

    /**
     * User account orders page
     */
    @GetMapping("/account/orders")
    public String accountOrders(Model model) {
        logger.info("Serving account orders page");
        return "account/orders";
    }
}
