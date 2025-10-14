package com.nakhandev.ecommercecart.validation.annotation;

import com.nakhandev.ecommercecart.validation.validator.StrongPasswordValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Custom validation annotation for strong password requirements
 */
@Documented
@Constraint(validatedBy = StrongPasswordValidator.class)
@Target({ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface StrongPassword {

    String message() default "Password does not meet security requirements";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Minimum length requirement
     */
    int minLength() default 8;

    /**
     * Maximum length requirement
     */
    int maxLength() default 128;

    /**
     * Require at least one uppercase letter
     */
    boolean requireUppercase() default true;

    /**
     * Require at least one lowercase letter
     */
    boolean requireLowercase() default true;

    /**
     * Require at least one digit
     */
    boolean requireDigit() default true;

    /**
     * Require at least one special character
     */
    boolean requireSpecialChar() default true;

    /**
     * Custom pattern for additional validation
     */
    String pattern() default "";
}
