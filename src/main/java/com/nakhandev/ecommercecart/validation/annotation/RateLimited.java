package com.nakhandev.ecommercecart.validation.annotation;

import com.nakhandev.ecommercecart.validation.validator.RateLimitedValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

/**
 * Annotation for rate limiting validation
 * Prevents abuse by limiting the frequency of operations
 */
@Documented
@Constraint(validatedBy = RateLimitedValidator.class)
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface RateLimited {

    String message() default "Rate limit exceeded. Please try again later.";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Maximum number of requests allowed
     */
    int maxRequests() default 10;

    /**
     * Time window in seconds
     */
    int windowSeconds() default 60;

    /**
     * Key strategy for rate limiting
     */
    KeyStrategy keyStrategy() default KeyStrategy.IP_ADDRESS;

    /**
     * Custom key prefix for Redis/cache storage
     */
    String keyPrefix() default "rate_limit";

    enum KeyStrategy {
        IP_ADDRESS,      // Use client IP address
        USER_ID,         // Use authenticated user ID
        SESSION_ID,      // Use session ID
        API_KEY,         // Use API key
        CUSTOM           // Use custom implementation
    }
}
