package com.nakhandev.ecommercecart.validation.validator;

import com.nakhandev.ecommercecart.validation.annotation.RateLimited;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.time.Instant;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Validator for @RateLimited annotation
 * Implements in-memory rate limiting with sliding window
 */
@Component
public class RateLimitedValidator implements ConstraintValidator<RateLimited, Object> {

    private static final Logger logger = LoggerFactory.getLogger(RateLimitedValidator.class);

    @Autowired
    private HttpServletRequest request;

    // In-memory storage for rate limiting (in production, use Redis)
    private static final ConcurrentHashMap<String, RequestWindow> requestCounts = new ConcurrentHashMap<>();

    private int maxRequests;
    private int windowSeconds;
    private RateLimited.KeyStrategy keyStrategy;
    private String keyPrefix;

    @Override
    public void initialize(RateLimited constraintAnnotation) {
        this.maxRequests = constraintAnnotation.maxRequests();
        this.windowSeconds = constraintAnnotation.windowSeconds();
        this.keyStrategy = constraintAnnotation.keyStrategy();
        this.keyPrefix = constraintAnnotation.keyPrefix();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext context) {
        try {
            String key = generateKey();
            String rateLimitKey = keyPrefix + ":" + key;

            RequestWindow window = requestCounts.computeIfAbsent(rateLimitKey,
                k -> new RequestWindow(windowSeconds));

            // Clean old requests outside the window
            window.clean(Instant.now());

            // Check if limit exceeded
            if (window.getCount() >= maxRequests) {
                addConstraintViolation(context, String.format(
                    "Rate limit exceeded. Maximum %d requests per %d seconds allowed.",
                    maxRequests, windowSeconds));
                return false;
            }

            // Record this request
            window.recordRequest(Instant.now());

            return true;

        } catch (Exception e) {
            logger.error("Error during rate limiting validation", e);
            // Fail open - allow request if rate limiting fails
            return true;
        }
    }

    private String generateKey() {
        switch (keyStrategy) {
            case IP_ADDRESS:
                return getClientIpAddress();

            case USER_ID:
                // In a real application, get from security context
                return "anonymous";

            case SESSION_ID:
                return request.getSession(false) != null ?
                    request.getSession().getId() : "no_session";

            case API_KEY:
                // Get from request headers
                String apiKey = request.getHeader("X-API-Key");
                return apiKey != null ? apiKey : "no_api_key";

            case CUSTOM:
                // Custom implementation - combine IP and user agent
                return getClientIpAddress() + ":" + request.getHeader("User-Agent");

            default:
                return getClientIpAddress();
        }
    }

    private String getClientIpAddress() {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }

        return request.getRemoteAddr();
    }

    private void addConstraintViolation(ConstraintValidatorContext context, String message) {
        context.disableDefaultConstraintViolation();
        context.buildConstraintViolationWithTemplate(message).addConstraintViolation();
    }

    /**
     * Inner class to track requests in a sliding window
     */
    private static class RequestWindow {
        private final int windowSeconds;
        private final ConcurrentHashMap<Long, AtomicInteger> requestsBySecond;

        public RequestWindow(int windowSeconds) {
            this.windowSeconds = windowSeconds;
            this.requestsBySecond = new ConcurrentHashMap<>();
        }

        public void recordRequest(Instant now) {
            long second = now.getEpochSecond();
            requestsBySecond.computeIfAbsent(second, k -> new AtomicInteger(0)).incrementAndGet();
        }

        public int getCount() {
            return requestsBySecond.values().stream()
                .mapToInt(AtomicInteger::get)
                .sum();
        }

        public void clean(Instant now) {
            long currentSecond = now.getEpochSecond();
            long cutoffSecond = currentSecond - windowSeconds;

            // Remove old entries
            requestsBySecond.entrySet().removeIf(entry -> entry.getKey() < cutoffSecond);
        }
    }
}
