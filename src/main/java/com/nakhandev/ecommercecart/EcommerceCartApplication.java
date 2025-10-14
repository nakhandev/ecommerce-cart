package com.nakhandev.ecommercecart;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EntityScan("com.nakhandev.ecommercecart.model")
@EnableJpaRepositories("com.nakhandev.ecommercecart.repository")
@EnableAsync
public class EcommerceCartApplication {

    private static final Logger logger = LoggerFactory.getLogger(EcommerceCartApplication.class);

    public static void main(String[] args) {
        logger.info("Starting E-commerce Cart System v1.0.0");

        try {
            SpringApplication.run(EcommerceCartApplication.class, args);
            logger.info("E-commerce Cart System started successfully!");
            logger.info("Application is running on: http://localhost:8080");
            logger.info("Database will be automatically configured and sample data loaded");
        } catch (Exception e) {
            logger.error("Failed to start E-commerce Cart System", e);
            System.exit(1);
        }
    }
}
