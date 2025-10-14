package com.nakhandev.ecommercecart.validation.util;

import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;

import java.util.regex.Pattern;

/**
 * Utility class for input sanitization and validation
 */
public class InputSanitizer {

    // XSS patterns to detect
    private static final Pattern[] XSS_PATTERNS = {
        Pattern.compile("<script[^>]*>.*?</script>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL),
        Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
        Pattern.compile("on\\w+\\s*=", Pattern.CASE_INSENSITIVE),
        Pattern.compile("<iframe[^>]*>.*?</iframe>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL),
        Pattern.compile("<object[^>]*>.*?</object>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL),
        Pattern.compile("<embed[^>]*>", Pattern.CASE_INSENSITIVE),
        Pattern.compile("<link[^>]*>", Pattern.CASE_INSENSITIVE),
        Pattern.compile("<meta[^>]*>", Pattern.CASE_INSENSITIVE)
    };

    // SQL injection patterns
    private static final Pattern[] SQL_INJECTION_PATTERNS = {
        Pattern.compile("('|(\\-\\-)|(;)|(\\||\\*)|(union)|(select)|(insert)|(update)|(delete)|(drop)|(create)|(alter)|(exec)|(execute)|(declare)|(cast)|(set)|(char)|(nchar)|(varchar)|(nvarchar))", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\b(union|select|insert|update|delete|drop|create|alter|exec|execute|declare|cast|set|char|nchar|varchar|nvarchar)\\b", Pattern.CASE_INSENSITIVE)
    };

    /**
     * Sanitize string input for XSS protection
     */
    public static String sanitizeHtml(String input) {
        if (!StringUtils.hasText(input)) {
            return input;
        }

        // First, check for obvious XSS patterns
        String sanitized = input;
        for (Pattern pattern : XSS_PATTERNS) {
            if (pattern.matcher(sanitized).find()) {
                throw new SecurityException("Potentially malicious content detected in input");
            }
        }

        // HTML encode the input
        sanitized = HtmlUtils.htmlEscape(sanitized);

        // Remove null bytes
        sanitized = sanitized.replace("\0", "");

        return sanitized.trim();
    }

    /**
     * Sanitize string input for general text (allows basic HTML if needed)
     */
    public static String sanitizeText(String input, boolean allowBasicHtml) {
        if (!StringUtils.hasText(input)) {
            return input;
        }

        String sanitized = input;

        if (allowBasicHtml) {
            // Allow only safe HTML tags
            sanitized = sanitized.replaceAll("(?i)<(?!/?(b|i|u|strong|em|br)\\s*/?)[^>]*>", "");
        } else {
            // Remove all HTML tags
            sanitized = sanitized.replaceAll("<[^>]*>", "");
        }

        // Check for XSS patterns
        for (Pattern pattern : XSS_PATTERNS) {
            if (pattern.matcher(sanitized).find()) {
                throw new SecurityException("Potentially malicious content detected in input");
            }
        }

        return sanitized.trim();
    }

    /**
     * Check for SQL injection patterns
     */
    public static boolean containsSqlInjection(String input) {
        if (!StringUtils.hasText(input)) {
            return false;
        }

        for (Pattern pattern : SQL_INJECTION_PATTERNS) {
            if (pattern.matcher(input).find()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Sanitize filename for file upload
     */
    public static String sanitizeFilename(String filename) {
        if (!StringUtils.hasText(filename)) {
            return filename;
        }

        // Remove path traversal attempts
        filename = filename.replaceAll("\\.\\./", "");
        filename = filename.replaceAll("\\.\\\\", "");

        // Remove dangerous characters
        filename = filename.replaceAll("[<>:\"/\\\\|?*]", "");

        // Limit length
        if (filename.length() > 255) {
            filename = filename.substring(0, 255);
        }

        return filename.trim();
    }

    /**
     * Validate and sanitize phone number
     */
    public static String sanitizePhoneNumber(String phoneNumber) {
        if (!StringUtils.hasText(phoneNumber)) {
            return phoneNumber;
        }

        // Remove all non-digit characters except + and -
        String sanitized = phoneNumber.replaceAll("[^+0-9-]", "");

        // Validate format (basic check)
        if (sanitized.length() < 10 || sanitized.length() > 15) {
            throw new IllegalArgumentException("Invalid phone number format");
        }

        return sanitized;
    }

    /**
     * Validate and sanitize email
     */
    public static String sanitizeEmail(String email) {
        if (!StringUtils.hasText(email)) {
            return email;
        }

        // Basic email format validation
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            throw new IllegalArgumentException("Invalid email format");
        }

        // Check for suspicious patterns
        if (email.contains("..") || email.startsWith(".") || email.endsWith(".")) {
            throw new IllegalArgumentException("Invalid email format");
        }

        return email.toLowerCase().trim();
    }

    /**
     * Sanitize numeric input
     */
    public static String sanitizeNumeric(String input) {
        if (!StringUtils.hasText(input)) {
            return input;
        }

        // Remove all non-digit characters
        return input.replaceAll("[^0-9]", "");
    }

    /**
     * Check if input contains only alphanumeric characters and safe symbols
     */
    public static boolean isAlphanumeric(String input) {
        if (!StringUtils.hasText(input)) {
            return false;
        }

        return input.matches("^[a-zA-Z0-9_-]+$");
    }

    /**
     * Validate input length
     */
    public static void validateLength(String input, int minLength, int maxLength, String fieldName) {
        if (StringUtils.hasText(input)) {
            if (input.length() < minLength) {
                throw new IllegalArgumentException(String.format("%s must be at least %d characters long", fieldName, minLength));
            }
            if (input.length() > maxLength) {
                throw new IllegalArgumentException(String.format("%s must not exceed %d characters", fieldName, maxLength));
            }
        }
    }

    /**
     * Custom Security Exception for validation
     */
    public static class SecurityException extends RuntimeException {
        public SecurityException(String message) {
            super(message);
        }
    }
}
