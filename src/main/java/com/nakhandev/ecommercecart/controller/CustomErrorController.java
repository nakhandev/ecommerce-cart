package com.nakhandev.ecommercecart.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

/**
 * Custom error controller to handle error pages and override Spring Boot's default whitelabel error page
 */
@Controller
public class CustomErrorController implements ErrorController {

    private static final Logger logger = LoggerFactory.getLogger(ErrorController.class);
    private static final String ERROR_PATH = "/error";

    @RequestMapping(ERROR_PATH)
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Object message = request.getAttribute(RequestDispatcher.ERROR_MESSAGE);
        Object exception = request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
        Object path = request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);

        logger.error("Error occurred - Status: {}, Message: {}, Path: {}, Exception: {}",
                    status, message, path, exception);

        // Determine HTTP status code
        HttpStatus httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
        if (status != null) {
            try {
                int statusCode = Integer.parseInt(status.toString());
                httpStatus = HttpStatus.valueOf(statusCode);
            } catch (Exception e) {
                logger.warn("Invalid status code: {}", status);
            }
        }

        // Add error details to model
        model.addAttribute("status", httpStatus.value());
        model.addAttribute("error", httpStatus.getReasonPhrase());
        model.addAttribute("message", message != null ? message.toString() : "An unexpected error occurred");
        model.addAttribute("path", path != null ? path.toString() : request.getRequestURI());
        model.addAttribute("timestamp", java.time.Instant.now());

        // Set page title based on error type
        String pageTitle = "Error";
        switch (httpStatus) {
            case NOT_FOUND:
                pageTitle = "Page Not Found";
                break;
            case FORBIDDEN:
                pageTitle = "Access Denied";
                break;
            case UNAUTHORIZED:
                pageTitle = "Authentication Required";
                break;
            case INTERNAL_SERVER_ERROR:
                pageTitle = "Server Error";
                break;
            default:
                pageTitle = "Error";
        }
        model.addAttribute("pageTitle", pageTitle);

        // Return appropriate error view based on status code
        return getErrorView(httpStatus);
    }

    /**
     * Determine which error view to return based on HTTP status
     */
    private String getErrorView(HttpStatus status) {
        switch (status) {
            case NOT_FOUND:
                return "error/404";
            case FORBIDDEN:
                return "error/403";
            case UNAUTHORIZED:
                return "error/401";
            case BAD_REQUEST:
                return "error/400";
            case INTERNAL_SERVER_ERROR:
            case BAD_GATEWAY:
            case SERVICE_UNAVAILABLE:
                return "error/500";
            default:
                return "error/general";
        }
    }

    /**
     * Returns the path that triggers this error controller
     */
    public String getErrorPath() {
        return ERROR_PATH;
    }
}
