package com.nakhandev.ecommercecart.validation.util;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class for generating user-friendly error messages
 * Provides contextual help and actionable guidance
 */
@Component
public class ErrorMessageUtil {

    private final MessageSource messageSource;

    // Common error patterns and their user-friendly messages
    private static final Map<String, String> ERROR_MESSAGE_MAP = new HashMap<>();

    static {
        // Validation errors
        ERROR_MESSAGE_MAP.put("required", "This field is required. Please provide a value.");
        ERROR_MESSAGE_MAP.put("email", "Please enter a valid email address (e.g., user@example.com).");
        ERROR_MESSAGE_MAP.put("minlength", "Please enter at least {0} characters.");
        ERROR_MESSAGE_MAP.put("maxlength", "Please enter no more than {0} characters.");
        ERROR_MESSAGE_MAP.put("pattern", "Please check the format and try again.");
        ERROR_MESSAGE_MAP.put("numeric", "Please enter a valid number.");
        ERROR_MESSAGE_MAP.put("phone", "Please enter a valid phone number (e.g., +91-9876543210).");
        ERROR_MESSAGE_MAP.put("password", "Password must contain at least 8 characters with uppercase, lowercase, number, and special character.");

        // Business errors
        ERROR_MESSAGE_MAP.put("insufficient_stock", "Sorry, this item is currently out of stock or not available in the requested quantity.");
        ERROR_MESSAGE_MAP.put("payment_failed", "Payment could not be processed. Please check your payment details and try again.");
        ERROR_MESSAGE_MAP.put("order_not_found", "Order not found. Please check your order number and try again.");
        ERROR_MESSAGE_MAP.put("user_not_found", "Account not found. Please check your credentials or register a new account.");
        ERROR_MESSAGE_MAP.put("duplicate_email", "An account with this email already exists. Please use a different email or try logging in.");
        ERROR_MESSAGE_MAP.put("duplicate_username", "This username is already taken. Please choose a different username.");
        ERROR_MESSAGE_MAP.put("weak_password", "Password is too weak. Please choose a stronger password with at least 8 characters including uppercase, lowercase, numbers, and special characters.");
        ERROR_MESSAGE_MAP.put("invalid_credentials", "Invalid email or password. Please check your credentials and try again.");
        ERROR_MESSAGE_MAP.put("account_locked", "Your account has been temporarily locked due to multiple failed login attempts. Please try again later or contact support.");
        ERROR_MESSAGE_MAP.put("session_expired", "Your session has expired. Please log in again to continue.");
        ERROR_MESSAGE_MAP.put("rate_limit", "Too many requests. Please wait a moment before trying again.");
        ERROR_MESSAGE_MAP.put("unauthorized", "You don't have permission to perform this action. Please contact support if you believe this is an error.");
        ERROR_MESSAGE_MAP.put("forbidden", "Access to this resource is restricted. Please contact support if you need access.");
        ERROR_MESSAGE_MAP.put("network_error", "Network connection error. Please check your internet connection and try again.");
        ERROR_MESSAGE_MAP.put("server_error", "Something went wrong on our end. Please try again in a few moments or contact support if the problem persists.");
    }

    public ErrorMessageUtil(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    /**
     * Get user-friendly error message for a given error code
     */
    public String getErrorMessage(String errorCode) {
        return getErrorMessage(errorCode, null, null);
    }

    /**
     * Get user-friendly error message with parameters
     */
    public String getErrorMessage(String errorCode, Object[] parameters) {
        return getErrorMessage(errorCode, parameters, null);
    }

    /**
     * Get user-friendly error message with parameters and locale
     */
    public String getErrorMessage(String errorCode, Object[] parameters, Locale locale) {
        // Try to get localized message first
        if (messageSource != null) {
            try {
                Locale targetLocale = locale != null ? locale : LocaleContextHolder.getLocale();
                String localizedMessage = messageSource.getMessage(errorCode, parameters, targetLocale);
                if (localizedMessage != null && !localizedMessage.equals(errorCode)) {
                    return localizedMessage;
                }
            } catch (Exception e) {
                // Fall back to default messages
            }
        }

        // Fall back to predefined messages
        String message = ERROR_MESSAGE_MAP.get(errorCode.toLowerCase());
        if (message != null) {
            if (parameters != null && parameters.length > 0) {
                return formatMessage(message, parameters);
            }
            return message;
        }

        // Default fallback message
        return "An error occurred. Please try again or contact support if the problem persists.";
    }

    /**
     * Get contextual help for an error
     */
    public String getContextualHelp(String errorCode, String fieldName) {
        String help = "";

        switch (errorCode.toLowerCase()) {
            case "required":
                help = String.format("The %s field cannot be left empty.", fieldName);
                break;
            case "email":
                help = "Enter a complete email address with @ symbol and domain name.";
                break;
            case "minlength":
                help = String.format("Make sure %s has enough characters.", fieldName);
                break;
            case "maxlength":
                help = String.format("Shorten %s to fit the character limit.", fieldName);
                break;
            case "pattern":
                help = String.format("Check the format requirements for %s.", fieldName);
                break;
            case "password":
                help = "Use a mix of uppercase letters, lowercase letters, numbers, and special characters.";
                break;
            case "phone":
                help = "Include country code and ensure all digits are correct.";
                break;
            case "duplicate_email":
                help = "Try logging in instead, or use a different email address.";
                break;
            case "weak_password":
                help = "Try adding numbers, symbols, and mixing uppercase/lowercase letters.";
                break;
            case "payment_failed":
                help = "Check your card details, billing address, and ensure sufficient funds.";
                break;
            case "insufficient_stock":
                help = "Try reducing the quantity or check back later for restocking.";
                break;
        }

        return help;
    }

    /**
     * Format error message with parameters
     */
    private String formatMessage(String message, Object[] parameters) {
        String formatted = message;

        for (int i = 0; i < parameters.length; i++) {
            String placeholder = "\\{" + i + "\\}";
            formatted = formatted.replaceAll(placeholder, String.valueOf(parameters[i]));
        }

        return formatted;
    }

    /**
     * Extract field name from error message or use provided field name
     */
    public String extractFieldName(String errorMessage, String defaultFieldName) {
        // Try to extract field name from common patterns
        Pattern pattern = Pattern.compile("field\\s+['\"]([^'\"]+)['\"]");
        Matcher matcher = pattern.matcher(errorMessage.toLowerCase());

        if (matcher.find()) {
            return matcher.group(1);
        }

        return defaultFieldName != null ? defaultFieldName : "Field";
    }

    /**
     * Create a comprehensive error response with message and help
     */
    public ErrorResponse createErrorResponse(String errorCode, String fieldName) {
        String message = getErrorMessage(errorCode);
        String help = getContextualHelp(errorCode, fieldName);

        return new ErrorResponse(message, help, errorCode);
    }

    /**
     * Inner class for structured error responses
     */
    public static class ErrorResponse {
        private final String message;
        private final String help;
        private final String errorCode;
        private final long timestamp;

        public ErrorResponse(String message, String help, String errorCode) {
            this.message = message;
            this.help = help;
            this.errorCode = errorCode;
            this.timestamp = System.currentTimeMillis();
        }

        public String getMessage() { return message; }
        public String getHelp() { return help; }
        public String getErrorCode() { return errorCode; }
        public long getTimestamp() { return timestamp; }

        public Map<String, Object> toMap() {
            Map<String, Object> map = new HashMap<>();
            map.put("message", message);
            map.put("help", help);
            map.put("errorCode", errorCode);
            map.put("timestamp", timestamp);
            return map;
        }
    }
}
