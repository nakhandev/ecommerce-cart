package com.nakhandev.ecommercecart.validation.validator;

import com.nakhandev.ecommercecart.validation.annotation.ValidCreditCard;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Validator for @ValidCreditCard annotation
 * Validates credit card number format and performs Luhn algorithm check
 */
public class ValidCreditCardValidator implements ConstraintValidator<ValidCreditCard, String> {

    private Set<ValidCreditCard.CardType> acceptedTypes;
    private boolean validateLuhn;

    @Override
    public void initialize(ValidCreditCard constraintAnnotation) {
        this.acceptedTypes = new HashSet<>(Arrays.asList(constraintAnnotation.acceptedTypes()));
        this.validateLuhn = constraintAnnotation.validateLuhn();
    }

    @Override
    public boolean isValid(String cardNumber, ConstraintValidatorContext context) {
        // Null values are valid (use @NotNull for required fields)
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return true;
        }

        // Remove spaces and dashes
        String cleanNumber = cardNumber.replaceAll("[\\s-]", "");

        // Basic format validation
        if (!cleanNumber.matches("\\d{13,19}")) {
            addConstraintViolation(context, "Credit card number must contain only digits and be 13-19 characters long");
            return false;
        }

        // Determine card type
        ValidCreditCard.CardType detectedType = detectCardType(cleanNumber);
        if (detectedType == null) {
            addConstraintViolation(context, "Unsupported credit card type");
            return false;
        }

        // Check if card type is accepted
        if (!acceptedTypes.contains(ValidCreditCard.CardType.ALL) && !acceptedTypes.contains(detectedType)) {
            addConstraintViolation(context, "Credit card type not accepted");
            return false;
        }

        // Perform Luhn algorithm validation if enabled
        if (validateLuhn && !isValidLuhn(cleanNumber)) {
            addConstraintViolation(context, "Invalid credit card number");
            return false;
        }

        return true;
    }

    private ValidCreditCard.CardType detectCardType(String cardNumber) {
        // Visa: starts with 4, length 13, 16, or 19
        if (cardNumber.startsWith("4") &&
            (cardNumber.length() == 13 || cardNumber.length() == 16 || cardNumber.length() == 19)) {
            return ValidCreditCard.CardType.VISA;
        }

        // Mastercard: starts with 51-55 or 2221-2720, length 16
        if (cardNumber.length() == 16) {
            if (cardNumber.startsWith("5") &&
                cardNumber.charAt(1) >= '1' && cardNumber.charAt(1) <= '5') {
                return ValidCreditCard.CardType.MASTERCARD;
            }
            if (cardNumber.startsWith("2") &&
                cardNumber.charAt(1) == '2' &&
                cardNumber.charAt(2) >= '2' && cardNumber.charAt(2) <= '7') {
                return ValidCreditCard.CardType.MASTERCARD;
            }
        }

        // American Express: starts with 34 or 37, length 15
        if (cardNumber.startsWith("3") &&
            (cardNumber.charAt(1) == '4' || cardNumber.charAt(1) == '7') &&
            cardNumber.length() == 15) {
            return ValidCreditCard.CardType.AMEX;
        }

        // Discover: starts with 6011, 622126-622925, 644-649, or 65, length 16
        if (cardNumber.length() == 16) {
            if (cardNumber.startsWith("6011") ||
                (cardNumber.startsWith("622") &&
                 Integer.parseInt(cardNumber.substring(3, 6)) >= 126 &&
                 Integer.parseInt(cardNumber.substring(3, 6)) <= 925) ||
                (cardNumber.startsWith("64") &&
                 cardNumber.charAt(2) >= '4' && cardNumber.charAt(2) <= '9') ||
                cardNumber.startsWith("65")) {
                return ValidCreditCard.CardType.DISCOVER;
            }
        }

        // Diners Club: starts with 300-305, 36, or 38, length 14
        if (cardNumber.length() == 14) {
            if (cardNumber.startsWith("30") &&
                cardNumber.charAt(2) >= '0' && cardNumber.charAt(2) <= '5') {
                return ValidCreditCard.CardType.DINERS_CLUB;
            }
            if (cardNumber.startsWith("36") || cardNumber.startsWith("38")) {
                return ValidCreditCard.CardType.DINERS_CLUB;
            }
        }

        // JCB: starts with 35, length 16
        if (cardNumber.startsWith("35") && cardNumber.length() == 16) {
            return ValidCreditCard.CardType.JCB;
        }

        return null; // Unknown card type
    }

    private boolean isValidLuhn(String cardNumber) {
        int sum = 0;
        boolean alternate = false;

        // Process digits from right to left
        for (int i = cardNumber.length() - 1; i >= 0; i--) {
            int digit = Character.getNumericValue(cardNumber.charAt(i));

            if (alternate) {
                digit *= 2;
                if (digit > 9) {
                    digit = (digit % 10) + 1;
                }
            }

            sum += digit;
            alternate = !alternate;
        }

        return (sum % 10) == 0;
    }

    private void addConstraintViolation(ConstraintValidatorContext context, String message) {
        context.disableDefaultConstraintViolation();
        context.buildConstraintViolationWithTemplate(message).addConstraintViolation();
    }
}
