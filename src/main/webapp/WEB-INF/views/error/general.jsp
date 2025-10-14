<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Page Title -->
<c:set var="pageTitle" value="${pageTitle}" scope="request"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - E-Shop</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/static/css/custom.css'/>" rel="stylesheet">

    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
        }

        .error-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: none;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .error-icon {
            font-size: 5rem;
            color: #ff6b6b;
            margin-bottom: 1rem;
        }

        .error-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1rem;
        }

        .error-message {
            color: #718096;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        .status-badge {
            background: #ff6b6b;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .helpful-links {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
        }

        .helpful-links h6 {
            color: #2d3748;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .helpful-links a {
            display: block;
            color: #667eea;
            text-decoration: none;
            padding: 0.5rem 0;
            transition: color 0.3s ease;
        }

        .helpful-links a:hover {
            color: #5a67d8;
        }

        .helpful-links i {
            margin-right: 0.5rem;
            width: 16px;
        }

        .error-details {
            background: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
            text-align: left;
        }

        .error-details small {
            color: #744210;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="error-card card p-5 text-center">
                        <!-- Status Badge -->
                        <div class="status-badge">
                            ${status} ${error}
                        </div>

                        <!-- Error Icon -->
                        <div class="error-icon">
                            <c:choose>
                                <c:when test="${status == 403}">
                                    <i class="fas fa-lock"></i>
                                </c:when>
                                <c:when test="${status == 401}">
                                    <i class="fas fa-user-lock"></i>
                                </c:when>
                                <c:when test="${status == 500}">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-exclamation-circle"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Error Details -->
                        <h1 class="error-title">${pageTitle}</h1>
                        <p class="error-message">
                            ${message}
                        </p>

                        <!-- Error Details (for debugging in development) -->
                        <c:if test="${not empty path}">
                            <div class="error-details">
                                <small>
                                    <strong>Path:</strong> ${path}<br>
                                    <strong>Timestamp:</strong> ${timestamp}
                                </small>
                            </div>
                        </c:if>

                        <!-- Action Buttons -->
                        <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                            <a href="<c:url value='/'/>" class="btn btn-primary btn-lg">
                                <i class="fas fa-home me-2"></i>Go Home
                            </a>
                            <button onclick="history.back()" class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-arrow-left me-2"></i>Go Back
                            </button>
                        </div>

                        <!-- Helpful Links -->
                        <div class="helpful-links">
                            <h6><i class="fas fa-lightbulb"></i> Need help?</h6>
                            <a href="<c:url value='/contact'/>">
                                <i class="fas fa-envelope"></i>Contact Support
                            </a>
                            <a href="<c:url value='/help'/>">
                                <i class="fas fa-question-circle"></i>Help Center
                            </a>
                            <a href="javascript:void(0)" onclick="window.location.reload()">
                                <i class="fas fa-redo"></i>Try Again
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
