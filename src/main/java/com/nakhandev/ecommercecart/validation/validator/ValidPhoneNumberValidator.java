package com.nakhandev.ecommercecart.validation.validator;

import com.nakhandev.ecommercecart.validation.annotation.ValidPhoneNumber;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.regex.Pattern;

/**
 * Validator for phone number format validation
 */
public class ValidPhoneNumberValidator implements ConstraintValidator<ValidPhoneNumber, String> {

    private ValidPhoneNumber annotation;
    private Pattern phonePattern;

    @Override
    public void initialize(ValidPhoneNumber constraintAnnotation) {
        this.annotation = constraintAnnotation;

        String pattern = buildPhonePattern();
        this.phonePattern = Pattern.compile(pattern);
    }

    @Override
    public boolean isValid(String phoneNumber, ConstraintValidatorContext context) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return true; // Let @NotNull handle null validation
        }

        // Remove all non-digit characters for validation
        String digitsOnly = phoneNumber.replaceAll("\\D", "");

        // Check length constraints
        if (digitsOnly.length() < 10 || digitsOnly.length() > 15) {
            return false;
        }

        // Validate against pattern
        return phonePattern.matcher(phoneNumber).matches();
    }

    private String buildPhonePattern() {
        StringBuilder pattern = new StringBuilder();

        if (annotation.requireCountryCode()) {
            pattern.append("^(\\+\\d{1,4})?\\s*");
        } else {
            pattern.append("^(?:\\+\\d{1,4}\\s*)?");
        }

        if (annotation.mobileOnly()) {
            // Mobile number pattern
            pattern.append("^[6-9]\\d{9}$");
        } else if (annotation.allowLandline()) {
            // Indian phone number pattern (mobile + landline)
            pattern.append("^(?:[6-9]\\d{9}|[1-5]\\d{7,8})$");
        } else {
            // Mobile only pattern
            pattern.append("^[6-9]\\d{9}$");
        }

        return pattern.toString();
    }
}
