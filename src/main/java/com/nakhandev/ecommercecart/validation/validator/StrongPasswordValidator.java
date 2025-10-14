package com.nakhandev.ecommercecart.validation.validator;

import com.nakhandev.ecommercecart.validation.annotation.StrongPassword;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Validator for strong password requirements
 */
public class StrongPasswordValidator implements ConstraintValidator<StrongPassword, String> {

    private StrongPassword annotation;

    @Override
    public void initialize(StrongPassword constraintAnnotation) {
        this.annotation = constraintAnnotation;
    }

    @Override
    public boolean isValid(String password, ConstraintValidatorContext context) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }

        List<String> errors = new ArrayList<>();

        // Check length
        if (password.length() < annotation.minLength()) {
            errors.add("Password must be at least " + annotation.minLength() + " characters long");
        }

        if (password.length() > annotation.maxLength()) {
            errors.add("Password must not exceed " + annotation.maxLength() + " characters");
        }

        // Check uppercase requirement
        if (annotation.requireUppercase() && !Pattern.compile("[A-Z]").matcher(password).find()) {
            errors.add("Password must contain at least one uppercase letter");
        }

        // Check lowercase requirement
        if (annotation.requireLowercase() && !Pattern.compile("[a-z]").matcher(password).find()) {
            errors.add("Password must contain at least one lowercase letter");
        }

        // Check digit requirement
        if (annotation.requireDigit() && !Pattern.compile("[0-9]").matcher(password).find()) {
            errors.add("Password must contain at least one digit");
        }

        // Check special character requirement
        if (annotation.requireSpecialChar() && !Pattern.compile("[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]").matcher(password).find()) {
            errors.add("Password must contain at least one special character");
        }

        // Check custom pattern if provided
        if (!annotation.pattern().isEmpty() && !Pattern.compile(annotation.pattern()).matcher(password).matches()) {
            errors.add("Password does not match required pattern");
        }

        if (!errors.isEmpty()) {
            context.disableDefaultConstraintViolation();
            errors.forEach(error -> context.buildConstraintViolationWithTemplate(error).addConstraintViolation());
            return false;
        }

        return true;
    }
}
