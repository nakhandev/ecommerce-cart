package com.nakhandev.ecommercecart.exception;

/**
 * Exception thrown when security violations occur
 */
public class SecurityException extends EcommerceException {

    public SecurityException(String message) {
        super("SECURITY_VIOLATION", message);
    }

    public SecurityException(String message, Object... parameters) {
        super("SECURITY_VIOLATION", message, parameters);
    }

    public SecurityException(String message, Throwable cause) {
        super("SECURITY_VIOLATION", message, cause);
    }

    // Specific security exception types
    public static class UnauthorizedAccessException extends SecurityException {
        public UnauthorizedAccessException(String resource) {
            super(String.format("Unauthorized access to resource: %s", resource), resource);
        }

        public UnauthorizedAccessException(String resource, String username) {
            super(String.format("User '%s' is not authorized to access resource: %s", username, resource),
                  resource, username);
        }
    }

    public static class ForbiddenOperationException extends SecurityException {
        public ForbiddenOperationException(String operation) {
            super(String.format("Forbidden operation: %s", operation), operation);
        }

        public ForbiddenOperationException(String operation, String reason) {
            super(String.format("Forbidden operation '%s': %s", operation, reason), operation, reason);
        }
    }

    public static class InvalidTokenException extends SecurityException {
        public InvalidTokenException(String token) {
            super("Invalid or expired token provided");
        }
    }

    public static class SessionExpiredException extends SecurityException {
        public SessionExpiredException() {
            super("User session has expired. Please login again.");
        }
    }

    public static class InsufficientPermissionsException extends SecurityException {
        public InsufficientPermissionsException(String requiredRole) {
            super(String.format("Insufficient permissions. Required role: %s", requiredRole), requiredRole);
        }

        public InsufficientPermissionsException(String requiredRole, String userRole) {
            super(String.format("Insufficient permissions. Required: %s, Current: %s",
                  requiredRole, userRole), requiredRole, userRole);
        }
    }

    public static class SuspiciousActivityException extends SecurityException {
        public SuspiciousActivityException(String activity) {
            super(String.format("Suspicious activity detected: %s", activity), activity);
        }
    }

    public static class RateLimitExceededException extends SecurityException {
        public RateLimitExceededException(String endpoint) {
            super(String.format("Rate limit exceeded for endpoint: %s", endpoint), endpoint);
        }

        public RateLimitExceededException(String endpoint, int limit, int windowSeconds) {
            super(String.format("Rate limit exceeded for endpoint: %s (Limit: %d per %d seconds)",
                  endpoint, limit, windowSeconds), endpoint, limit, windowSeconds);
        }
    }
}
