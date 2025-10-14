package com.nakhandev.ecommercecart.validation.annotation;

import com.nakhandev.ecommercecart.validation.validator.ValidCreditCardValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

/**
 * Annotation for credit card number validation
 * Validates format and performs Luhn algorithm check
 */
@Documented
@Constraint(validatedBy = ValidCreditCardValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidCreditCard {

    String message() default "Invalid credit card number";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Supported card types
     */
    enum CardType {
        VISA, MASTERCARD, AMEX, DISCOVER, DINERS_CLUB, JCB, ALL
    }

    /**
     * Card types to accept (default: ALL)
     */
    CardType[] acceptedTypes() default {CardType.ALL};

    /**
     * Whether to perform Luhn algorithm validation
     */
    boolean validateLuhn() default true;
}
