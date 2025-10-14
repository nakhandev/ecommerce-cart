package com.nakhandev.ecommercecart.exception;

/**
 * Base exception class for all e-commerce related exceptions
 */
public abstract class EcommerceException extends RuntimeException {

    private final String errorCode;
    private final Object[] parameters;

    protected EcommerceException(String errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.parameters = new Object[0];
    }

    protected EcommerceException(String errorCode, String message, Object... parameters) {
        super(message);
        this.errorCode = errorCode;
        this.parameters = parameters != null ? parameters.clone() : new Object[0];
    }

    protected EcommerceException(String errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.parameters = new Object[0];
    }

    protected EcommerceException(String errorCode, String message, Throwable cause, Object... parameters) {
        super(message, cause);
        this.errorCode = errorCode;
        this.parameters = parameters != null ? parameters.clone() : new Object[0];
    }

    public String getErrorCode() {
        return errorCode;
    }

    public Object[] getParameters() {
        return parameters.clone();
    }

    /**
     * Get user-friendly error message
     */
    public String getUserMessage() {
        return getMessage();
    }

    /**
     * Get detailed error message for logging
     */
    public String getDetailedMessage() {
        return String.format("Error Code: %s, Message: %s", errorCode, getMessage());
    }
}
