package com.nakhandev.ecommercecart.validation.annotation;

import com.nakhandev.ecommercecart.validation.validator.SanitizedInputValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

/**
 * Annotation for input sanitization validation
 * Ensures input is safe from XSS and injection attacks
 */
@Documented
@Constraint(validatedBy = SanitizedInputValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface SanitizedInput {

    String message() default "Input contains potentially unsafe content";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Whether to allow basic HTML tags (b, i, u, strong, em, br)
     */
    boolean allowBasicHtml() default false;

    /**
     * Maximum allowed length
     */
    int maxLength() default Integer.MAX_VALUE;

    /**
     * Minimum allowed length
     */
    int minLength() default 0;

    /**
     * Whether to check for SQL injection patterns
     */
    boolean checkSqlInjection() default true;

    /**
     * Field name for error messages
     */
    String fieldName() default "";
}
