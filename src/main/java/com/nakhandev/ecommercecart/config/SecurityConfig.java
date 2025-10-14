package com.nakhandev.ecommercecart.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Disable CSRF for API testing
            .csrf(csrf -> csrf.disable())

            // Allow public access to web pages, API endpoints, and static resources for testing
            .authorizeHttpRequests(authz -> authz
                .antMatchers("/").permitAll()
                .antMatchers("/products").permitAll()
                .antMatchers("/products/**").permitAll()
                .antMatchers("/categories").permitAll()
                .antMatchers("/categories/**").permitAll()
                .antMatchers("/cart").permitAll()
                .antMatchers("/checkout").permitAll()
                .antMatchers("/checkout/**").permitAll()
                .antMatchers("/orders").permitAll()
                .antMatchers("/orders/**").permitAll()
                .antMatchers("/admin/**").permitAll()
                .antMatchers("/profile").permitAll()
                .antMatchers("/login").permitAll()
                .antMatchers("/register").permitAll()
                .antMatchers("/about").permitAll()
                .antMatchers("/contact").permitAll()
                .antMatchers("/api/**").permitAll()
                .antMatchers("/actuator/health").permitAll()
                .antMatchers("/actuator/**").permitAll()
                .antMatchers("/static/**").permitAll()
                .antMatchers("/css/**").permitAll()
                .antMatchers("/js/**").permitAll()
                .antMatchers("/images/**").permitAll()
                .antMatchers("/favicon.ico").permitAll()
                .anyRequest().authenticated()
            )

            // Use servlet sessions for web application
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
            );

        return http.build();
    }
}
