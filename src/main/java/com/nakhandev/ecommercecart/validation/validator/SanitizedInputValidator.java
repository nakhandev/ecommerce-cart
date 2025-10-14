package com.nakhandev.ecommercecart.validation.validator;

import com.nakhandev.ecommercecart.validation.annotation.SanitizedInput;
import com.nakhandev.ecommercecart.validation.util.InputSanitizer;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * Validator for @SanitizedInput annotation
 * Validates and sanitizes input to prevent XSS and injection attacks
 */
public class SanitizedInputValidator implements ConstraintValidator<SanitizedInput, String> {

    private boolean allowBasicHtml;
    private int maxLength;
    private int minLength;
    private boolean checkSqlInjection;
    private String fieldName;

    @Override
    public void initialize(SanitizedInput constraintAnnotation) {
        this.allowBasicHtml = constraintAnnotation.allowBasicHtml();
        this.maxLength = constraintAnnotation.maxLength();
        this.minLength = constraintAnnotation.minLength();
        this.checkSqlInjection = constraintAnnotation.checkSqlInjection();
        this.fieldName = constraintAnnotation.fieldName();
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        // Null values are valid (use @NotNull for required fields)
        if (value == null) {
            return true;
        }

        try {
            // Validate length constraints
            if (value.length() < minLength) {
                addConstraintViolation(context, String.format("%s must be at least %d characters long",
                    fieldName.isEmpty() ? "Field" : fieldName, minLength));
                return false;
            }

            if (value.length() > maxLength) {
                addConstraintViolation(context, String.format("%s must not exceed %d characters",
                    fieldName.isEmpty() ? "Field" : fieldName, maxLength));
                return false;
            }

            // Check for SQL injection if enabled
            if (checkSqlInjection && InputSanitizer.containsSqlInjection(value)) {
                addConstraintViolation(context, "Input contains potentially unsafe content");
                return false;
            }

            // Try to sanitize the input - if it throws SecurityException, it's invalid
            try {
                if (allowBasicHtml) {
                    InputSanitizer.sanitizeText(value, true);
                } else {
                    InputSanitizer.sanitizeHtml(value);
                }
            } catch (InputSanitizer.SecurityException e) {
                addConstraintViolation(context, e.getMessage());
                return false;
            }

            return true;

        } catch (Exception e) {
            addConstraintViolation(context, "Input validation failed: " + e.getMessage());
            return false;
        }
    }

    private void addConstraintViolation(ConstraintValidatorContext context, String message) {
        context.disableDefaultConstraintViolation();
        context.buildConstraintViolationWithTemplate(message).addConstraintViolation();
    }
}
