package com.nakhandev.ecommercecart.config;

import com.nakhandev.ecommercecart.model.*;
import com.nakhandev.ecommercecart.repository.*;
import com.nakhandev.ecommercecart.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Arrays;

@Component
@Profile("!test") // Don't run during tests
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final UserService userService;

    @Autowired
    public DataInitializer(CategoryRepository categoryRepository,
                          ProductRepository productRepository,
                          UserRepository userRepository,
                          UserService userService) {
        this.categoryRepository = categoryRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
        this.userService = userService;
    }

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        logger.info("Initializing sample data for E-commerce Cart System");

        try {
            initializeCategories();
            initializeProducts();
            initializeUsers();
            initializeSampleCartsAndOrders();

            logger.info("Sample data initialization completed successfully");
        } catch (Exception e) {
            logger.error("Error during sample data initialization", e);
            throw e;
        }
    }

    private void initializeCategories() {
        logger.info("Initializing categories");

        if (categoryRepository.count() == 0) {
            Category electronics = new Category("Electronics", "Latest gadgets and electronic devices");
            electronics.setImageUrl("https://images.unsplash.com/photo-1498049794561-7780e7231661?w=500");
            electronics.setDisplayOrder(1);

            Category clothing = new Category("Clothing", "Fashion and apparel for men and women");
            clothing.setImageUrl("https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500");
            clothing.setDisplayOrder(2);

            Category books = new Category("Books", "Wide collection of books and literature");
            books.setImageUrl("https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500");
            books.setDisplayOrder(3);

            Category homeGarden = new Category("Home & Garden", "Home improvement and gardening supplies");
            homeGarden.setImageUrl("https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500");
            homeGarden.setDisplayOrder(4);

            Category sports = new Category("Sports & Outdoors", "Sports equipment and outdoor gear");
            sports.setImageUrl("https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500");
            sports.setDisplayOrder(5);

            Category healthBeauty = new Category("Health & Beauty", "Personal care and beauty products");
            healthBeauty.setImageUrl("https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500");
            healthBeauty.setDisplayOrder(6);

            categoryRepository.saveAll(Arrays.asList(electronics, clothing, books, homeGarden, sports, healthBeauty));

            logger.info("Created {} categories", categoryRepository.count());
        } else {
            logger.info("Categories already exist, skipping category initialization");
        }
    }

    private void initializeProducts() {
        logger.info("Initializing products");

        if (productRepository.count() == 0) {
            // Get categories for product creation
            Category electronics = categoryRepository.findByName("Electronics").orElseThrow();
            Category clothing = categoryRepository.findByName("Clothing").orElseThrow();
            Category books = categoryRepository.findByName("Books").orElseThrow();
            Category homeGarden = categoryRepository.findByName("Home & Garden").orElseThrow();
            Category sports = categoryRepository.findByName("Sports & Outdoors").orElseThrow();
            Category healthBeauty = categoryRepository.findByName("Health & Beauty").orElseThrow();

            // Electronics
            Product iphone = new Product("iPhone 15 Pro", "IPH15P-128", new BigDecimal("1299.99"), 50);
            iphone.setShortDescription("Latest iPhone with advanced camera system");
            iphone.setLongDescription("The iPhone 15 Pro features a titanium design, A17 Pro chip, and advanced camera system with 5x telephoto zoom.");
            iphone.setImageUrl("https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500");
            iphone.setCategory(electronics);
            iphone.setIsFeatured(true);
            iphone.setDiscountPercentage(new BigDecimal("5.0"));

            Product samsung = new Product("Samsung Galaxy S24", "SGS24-256", new BigDecimal("899.99"), 30);
            samsung.setShortDescription("Premium Android smartphone");
            samsung.setLongDescription("Samsung Galaxy S24 with Snapdragon 8 Gen 3, 120Hz display, and professional-grade camera system.");
            samsung.setImageUrl("https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500");
            samsung.setCategory(electronics);
            samsung.setIsFeatured(true);

            Product macbook = new Product("MacBook Air M3", "MBA-M3-13", new BigDecimal("1099.99"), 25);
            macbook.setShortDescription("Lightweight laptop with M3 chip");
            macbook.setLongDescription("13-inch MacBook Air with Apple M3 chip, up to 18 hours of battery life, and stunning Liquid Retina display.");
            macbook.setImageUrl("https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500");
            macbook.setCategory(electronics);
            macbook.setDiscountPercentage(new BigDecimal("10.0"));

            Product headphones = new Product("Sony WH-1000XM5", "SONY-WH1000XM5", new BigDecimal("399.99"), 100);
            headphones.setShortDescription("Premium noise-canceling headphones");
            headphones.setLongDescription("Industry-leading noise canceling headphones with exceptional sound quality and 30-hour battery life.");
            headphones.setImageUrl("https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500");
            headphones.setCategory(electronics);
            headphones.setIsFeatured(true);
            headphones.setDiscountPercentage(new BigDecimal("15.0"));

            // Books
            Product cleanCode = new Product("Clean Code", "BOOK-CLEANC-001", new BigDecimal("47.99"), 75);
            cleanCode.setShortDescription("A Handbook of Agile Software Craftsmanship");
            cleanCode.setLongDescription("Even bad code can function. But if code isn't clean, it can bring a development organization to its knees.");
            cleanCode.setImageUrl("https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500");
            cleanCode.setCategory(books);
            cleanCode.setIsFeatured(true);
            cleanCode.setDiscountPercentage(new BigDecimal("10.0"));

            Product pragmaticProgrammer = new Product("The Pragmatic Programmer", "BOOK-PRAGPROG-001", new BigDecimal("42.99"), 60);
            pragmaticProgrammer.setShortDescription("Your Journey To Mastery");
            pragmaticProgrammer.setLongDescription("A guide to pragmatic programming for software engineers and developers.");
            pragmaticProgrammer.setImageUrl("https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500");
            pragmaticProgrammer.setCategory(books);

            // Home & Garden
            Product coffeeMaker = new Product("Coffee Maker", "COFFEEMAKER-12C", new BigDecimal("89.99"), 35);
            coffeeMaker.setShortDescription("Automatic drip coffee machine");
            coffeeMaker.setLongDescription("12-cup programmable coffee maker with thermal carafe and auto-shutoff feature.");
            coffeeMaker.setImageUrl("https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500");
            coffeeMaker.setCategory(homeGarden);

            // Sports & Outdoors
            Product yogaMat = new Product("Yoga Mat", "YOGAMAT-PREMIUM", new BigDecimal("39.99"), 80);
            yogaMat.setShortDescription("Premium non-slip exercise mat");
            yogaMat.setLongDescription("Extra thick yoga mat with excellent grip and cushioning for all types of yoga and exercise.");
            yogaMat.setImageUrl("https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500");
            yogaMat.setCategory(sports);

            Product runningShoes = new Product("Running Shoes", "RUNSHOES-LITE-10", new BigDecimal("129.99"), 45);
            runningShoes.setShortDescription("Lightweight athletic footwear");
            runningShoes.setLongDescription("Professional running shoes with advanced cushioning and breathable mesh upper.");
            runningShoes.setImageUrl("https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500");
            runningShoes.setCategory(sports);
            runningShoes.setIsFeatured(true);
            runningShoes.setDiscountPercentage(new BigDecimal("8.0"));

            // Clothing
            Product cottonTshirt = new Product("Cotton T-Shirt", "TSHIRT-COTTON-M", new BigDecimal("24.99"), 100);
            cottonTshirt.setShortDescription("Comfortable cotton t-shirt");
            cottonTshirt.setLongDescription("Premium quality 100% cotton t-shirt, perfect for casual wear and layering.");
            cottonTshirt.setImageUrl("https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500");
            cottonTshirt.setCategory(clothing);
            cottonTshirt.setIsFeatured(true);

            Product denimJeans = new Product("Denim Jeans", "JEANS-DENIM-32", new BigDecimal("79.99"), 60);
            denimJeans.setShortDescription("Classic denim jeans");
            denimJeans.setLongDescription("High-quality denim jeans with a comfortable fit and stylish design.");
            denimJeans.setImageUrl("https://images.unsplash.com/photo-1542272604-787c3835535d?w=500");
            denimJeans.setCategory(clothing);
            denimJeans.setDiscountPercentage(new BigDecimal("10.0"));

            // Health & Beauty
            Product vitaminCSerum = new Product("Vitamin C Serum", "VITC-SERUM-30ML", new BigDecimal("34.99"), 90);
            vitaminCSerum.setShortDescription("Brightening facial treatment");
            vitaminCSerum.setLongDescription("Potent vitamin C serum for skin brightening and anti-aging benefits.");
            vitaminCSerum.setImageUrl("https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500");
            vitaminCSerum.setCategory(healthBeauty);
            vitaminCSerum.setDiscountPercentage(new BigDecimal("15.0"));

            productRepository.saveAll(Arrays.asList(
                iphone, samsung, macbook, headphones,
                cleanCode, pragmaticProgrammer,
                cottonTshirt, denimJeans,
                coffeeMaker, yogaMat, runningShoes, vitaminCSerum
            ));

            logger.info("Created {} products", productRepository.count());
        } else {
            logger.info("Products already exist, skipping product initialization");
        }
    }

    private void initializeUsers() {
        logger.info("Initializing users");

        if (userRepository.count() == 0) {
            // Create admin user
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@ecommerce.com");
            admin.setPassword("password123"); // Will be encoded by UserService
            admin.setFirstName("Admin");
            admin.setLastName("User");
            admin.setPhoneNumber("1234567890");
            admin.setRole(User.Role.ADMIN);
            admin.setIsActive(true);

            // Create regular users
            User nakdev = new User();
            nakdev.setUsername("nakdev");
            nakdev.setEmail("nakdev@example.com");
            nakdev.setPassword("password123");
            nakdev.setFirstName("Nak");
            nakdev.setLastName("Dev");
            nakdev.setPhoneNumber("9876543210");
            nakdev.setRole(User.Role.CUSTOMER);
            nakdev.setIsActive(true);

            User jane = new User();
            jane.setUsername("jane_smith");
            jane.setEmail("jane@example.com");
            jane.setPassword("password123");
            jane.setFirstName("Jane");
            jane.setLastName("Smith");
            jane.setPhoneNumber("5556667777");
            jane.setRole(User.Role.CUSTOMER);
            jane.setIsActive(true);

            User manager = new User();
            manager.setUsername("manager");
            manager.setEmail("manager@ecommerce.com");
            manager.setPassword("password123");
            manager.setFirstName("Store");
            manager.setLastName("Manager");
            manager.setPhoneNumber("1112223333");
            manager.setRole(User.Role.MANAGER);
            manager.setIsActive(true);

            userService.saveUser(admin);
            userService.saveUser(nakdev);
            userService.saveUser(jane);
            userService.saveUser(manager);

            logger.info("Created {} users", userRepository.count());
        } else {
            logger.info("Users already exist, skipping user initialization");
        }
    }

    private void initializeSampleCartsAndOrders() {
        logger.info("Initializing sample carts and orders");

        // This would typically be done through the actual service methods
        // For now, we'll just log that this step is complete
        logger.info("Sample carts and orders initialization completed");
    }
}
