package com.nakhandev.ecommercecart.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Configure static resource handling for JSP application
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/", "file:src/main/webapp/static/")
                .setCachePeriod(3600);

        // Additional resource mappings for better compatibility
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/", "file:src/main/webapp/static/css/");

        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/", "file:src/main/webapp/static/js/");

        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/", "file:src/main/webapp/static/images/");

        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("classpath:/static/images/", "file:src/main/webapp/static/images/");
    }
}
