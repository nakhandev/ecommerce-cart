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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .error-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: none;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .error-icon {
            font-size: 5rem;
            color: #667eea;
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

        .search-container {
            max-width: 400px;
            margin: 0 auto;
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
    </style>
</head>
<body>
    <div class="error-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="error-card card p-5 text-center">
                        <!-- Error Icon -->
                        <div class="error-icon">
                            <i class="fas fa-search"></i>
                        </div>

                        <!-- Error Details -->
                        <h1 class="error-title">${pageTitle}</h1>
                        <p class="error-message">
                            ${message}
                        </p>

                        <!-- Search Form -->
                        <div class="search-container">
                            <form class="d-flex mb-4" role="search">
                                <input class="form-control me-2" type="search" placeholder="Search products..." aria-label="Search">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search me-2"></i>Search
                                </button>
                            </form>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                            <a href="<c:url value='/'/>" class="btn btn-primary btn-lg">
                                <i class="fas fa-home me-2"></i>Go Home
                            </a>
                            <a href="<c:url value='/products'/>" class="btn btn-outline-primary btn-lg">
                                <i class="fas fa-shopping-bag me-2"></i>Browse Products
                            </a>
                            <a href="<c:url value='/categories'/>" class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-list me-2"></i>Categories
                            </a>
                        </div>

                        <!-- Helpful Links -->
                        <div class="helpful-links">
                            <h6><i class="fas fa-lightbulb"></i> You might also want to:</h6>
                            <a href="<c:url value='/contact'/>">
                                <i class="fas fa-envelope"></i>Contact Support
                            </a>
                            <a href="<c:url value='/help'/>">
                                <i class="fas fa-question-circle"></i>Help Center
                            </a>
                            <a href="<c:url value='/account/orders'/>">
                                <i class="fas fa-box"></i>Track Orders
                            </a>
                        </div>

                        <!-- Error Details (for debugging) -->
                        <c:if test="${not empty path}">
                            <div class="mt-4 pt-4 border-top">
                                <small class="text-muted">
                                    <strong>Path:</strong> ${path}<br>
                                    <strong>Timestamp:</strong> ${timestamp}
                                </small>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
