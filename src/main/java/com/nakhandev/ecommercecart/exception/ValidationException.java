package com.nakhandev.ecommercecart.exception;

import java.util.List;

/**
 * Exception thrown when input validation fails
 */
public class ValidationException extends EcommerceException {

    private final List<String> validationErrors;

    public ValidationException(String message) {
        super("VALIDATION_FAILED", message);
        this.validationErrors = List.of(message);
    }

    public ValidationException(String message, List<String> validationErrors) {
        super("VALIDATION_FAILED", message);
        this.validationErrors = validationErrors != null ? List.copyOf(validationErrors) : List.of(message);
    }

    public ValidationException(String message, Throwable cause) {
        super("VALIDATION_FAILED", message, cause);
        this.validationErrors = List.of(message);
    }

    public List<String> getValidationErrors() {
        return validationErrors;
    }

    @Override
    public String getUserMessage() {
        if (validationErrors.size() == 1) {
            return validationErrors.get(0);
        } else {
            return "Multiple validation errors occurred: " + String.join(", ", validationErrors);
        }
    }

    // Specific validation exception types
    public static class InvalidEmailException extends ValidationException {
        public InvalidEmailException(String email) {
            super(String.format("Invalid email format: %s", email));
        }
    }

    public static class PasswordMismatchException extends ValidationException {
        public PasswordMismatchException() {
            super("Password confirmation does not match");
        }
    }

    public static class WeakPasswordException extends ValidationException {
        public WeakPasswordException(String reason) {
            super(String.format("Password is too weak: %s", reason));
        }
    }

    public static class InvalidPhoneNumberException extends ValidationException {
        public InvalidPhoneNumberException(String phoneNumber) {
            super(String.format("Invalid phone number format: %s", phoneNumber));
        }
    }

    public static class RequiredFieldException extends ValidationException {
        public RequiredFieldException(String fieldName) {
            super(String.format("Field '%s' is required", fieldName));
        }
    }

    public static class InvalidFormatException extends ValidationException {
        public InvalidFormatException(String fieldName, String expectedFormat) {
            super(String.format("Field '%s' has invalid format. Expected: %s", fieldName, expectedFormat));
        }
    }
}
