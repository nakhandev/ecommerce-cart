package com.nakhandev.ecommercecart.validation.annotation;

import com.nakhandev.ecommercecart.validation.validator.ValidPhoneNumberValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Custom validation annotation for phone number validation
 */
@Documented
@Constraint(validatedBy = ValidPhoneNumberValidator.class)
@Target({ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidPhoneNumber {

    String message() default "Invalid phone number format";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Allowed country codes (empty means all are allowed)
     */
    String[] countryCodes() default {};

    /**
     * Require country code in the number
     */
    boolean requireCountryCode() default false;

    /**
     * Allow landline numbers
     */
    boolean allowLandline() default true;

    /**
     * Allow mobile numbers only
     */
    boolean mobileOnly() default false;
}
