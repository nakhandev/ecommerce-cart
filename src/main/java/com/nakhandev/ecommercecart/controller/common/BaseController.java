package com.nakhandev.ecommercecart.controller.common;

import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.dto.common.PagedResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

public abstract class BaseController {

    protected static final Logger logger = LoggerFactory.getLogger(BaseController.class);

    /**
     * Create a successful response with data
     */
    protected <T> ResponseEntity<ApiResponse<T>> createSuccessResponse(T data) {
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    /**
     * Create a successful response with message and data
     */
    protected <T> ResponseEntity<ApiResponse<T>> createSuccessResponse(String message, T data) {
        return ResponseEntity.ok(ApiResponse.success(message, data));
    }

    /**
     * Create a successful response with only message
     */
    protected <T> ResponseEntity<ApiResponse<T>> createSuccessResponse(String message) {
        return ResponseEntity.ok(ApiResponse.success(message));
    }

    /**
     * Create an error response
     */
    protected <T> ResponseEntity<ApiResponse<T>> createErrorResponse(String message) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(message));
    }

    /**
     * Create an error response with specific status
     */
    protected <T> ResponseEntity<ApiResponse<T>> createErrorResponse(String message, HttpStatus status) {
        return ResponseEntity.status(status)
                .body(ApiResponse.error(message, status.value()));
    }

    /**
     * Create a not found response
     */
    protected <T> ResponseEntity<ApiResponse<T>> createNotFoundResponse(String message) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error(message, HttpStatus.NOT_FOUND.value()));
    }

    /**
     * Create an unauthorized response
     */
    protected <T> ResponseEntity<ApiResponse<T>> createUnauthorizedResponse(String message) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ApiResponse.error(message, HttpStatus.UNAUTHORIZED.value()));
    }

    /**
     * Create a forbidden response
     */
    protected <T> ResponseEntity<ApiResponse<T>> createForbiddenResponse(String message) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ApiResponse.error(message, HttpStatus.FORBIDDEN.value()));
    }

    /**
     * Create a paginated response
     */
    protected <T> ResponseEntity<ApiResponse<PagedResponse<T>>> createPagedResponse(
            Page<T> page, List<T> content) {
        PagedResponse<T> pagedResponse = new PagedResponse<>(
                content, page.getNumber(), page.getSize(), page.getTotalElements());

        return ResponseEntity.ok(ApiResponse.success(pagedResponse));
    }

    /**
     * Create a created response (for POST operations)
     */
    protected <T> ResponseEntity<ApiResponse<T>> createCreatedResponse(T data) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Resource created successfully", data));
    }

    /**
     * Create an accepted response (for async operations)
     */
    protected <T> ResponseEntity<ApiResponse<T>> createAcceptedResponse(String message) {
        return ResponseEntity.status(HttpStatus.ACCEPTED)
                .body(ApiResponse.success(message));
    }

    /**
     * Log controller entry
     */
    protected void logControllerEntry(String methodName, Object... params) {
        logger.debug("Entering {} with params: {}", methodName, params);
    }

    /**
     * Log controller exit
     */
    protected void logControllerExit(String methodName, Object result) {
        logger.debug("Exiting {} with result: {}", methodName, result);
    }

    /**
     * Log error
     */
    protected void logError(String methodName, Exception e) {
        logger.error("Error in {}: {}", methodName, e.getMessage(), e);
    }
}
