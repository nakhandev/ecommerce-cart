<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Categories" scope="request"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : ''}"/> - E-Shop</title>

    <!-- jQuery CDN -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<c:url value='/static/css/custom.css'/>" rel="stylesheet">

    <!-- Favicon -->
    <link href="<c:url value='/static/images/favicon.svg'/>" rel="icon" type="image/svg+xml">

    <style>
        /* Categories page specific styles */
        .categories-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 3rem 0 2rem;
            margin-bottom: 2rem;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }

        .category-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            position: relative;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .category-image {
            position: relative;
            height: 200px;
            overflow: hidden;
        }

        .category-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .category-card:hover .category-image img {
            transform: scale(1.05);
        }

        .category-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(13, 110, 253, 0.8) 0%, rgba(111, 66, 193, 0.8) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .category-card:hover .category-overlay {
            opacity: 1;
        }

        .category-info {
            padding: 1.5rem;
        }

        .category-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .category-name:hover {
            color: #0d6efd;
        }

        .category-description {
            color: #6c757d;
            font-size: 0.9rem;
            line-height: 1.4;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .category-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding: 0.75rem;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.1rem;
            font-weight: 600;
            color: #0d6efd;
            display: block;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .category-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-category {
            flex: 1;
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-view-category {
            background: linear-gradient(135deg, #0d6efd 0%, #6f42c1 100%);
            border: none;
            color: white;
        }

        .btn-view-category:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
            color: white;
        }

        .btn-shop-category {
            background: transparent;
            border: 2px solid #0d6efd;
            color: #0d6efd;
        }

        .btn-shop-category:hover {
            background: #0d6efd;
            color: white;
        }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 3rem;
        }

        .no-categories {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .no-categories i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .search-section {
            background: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .search-form {
            max-width: 600px;
            margin: 0 auto;
        }

        .search-input-group {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 50px;
            overflow: hidden;
        }

        .search-input {
            border: none;
            padding: 1rem 1.5rem;
            font-size: 1rem;
        }

        .search-input:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }

        .search-btn {
            background: linear-gradient(135deg, #0d6efd 0%, #6f42c1 100%);
            border: none;
            padding: 1rem 2rem;
            border-radius: 0 50px 50px 0;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .category-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 1rem;
            }
        }
    </style>
</head>
<body>

<!-- Search Section -->
<section class="search-section">
    <div class="container">
        <form class="search-form" onsubmit="return handleSearch(event)">
            <div class="input-group search-input-group">
                <input type="text" class="form-control search-input" id="searchInput"
                       placeholder="Search categories..." value="${param.query}">
                <button class="btn search-btn" type="submit">
                    <i class="fas fa-search me-2"></i>Search
                </button>
            </div>
        </form>
    </div>
</section>

<!-- Categories Header -->
<section class="categories-header">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1 class="display-5 fw-bold text-center mb-3">Shop by Category</h1>
                <p class="lead text-center text-muted mb-0">
                    Explore our wide range of product categories
                </p>
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<section class="categories-content py-4">
    <div class="container">
        <!-- Categories Container -->
        <div id="categoriesContainer">
            <!-- Categories will be loaded here -->
        </div>

        <!-- Loading Spinner -->
        <div class="loading-spinner" id="loadingSpinner">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2 text-muted">Loading categories...</p>
        </div>

        <!-- No Categories Message -->
        <div class="no-categories" id="noCategories" style="display: none;">
            <i class="fas fa-folder-open"></i>
            <h4>No Categories Found</h4>
            <p>Try adjusting your search criteria.</p>
            <button class="btn btn-primary" onclick="loadCategories()">
                <i class="fas fa-refresh me-2"></i>Show All Categories
            </button>
        </div>
    </div>
</section>

<script>
// Search and category functionality
var currentSearchQuery = '${param.query}';

$(document).ready(function() {
    initializeCategoriesPage();
});

function initializeCategoriesPage() {
    // Load initial categories
    loadCategories();

    // Set up event listeners
    setupEventListeners();
}

function setupEventListeners() {
    // Search form
    $('form').on('submit', handleSearch);
}

function handleSearch(event) {
    event.preventDefault();
    currentSearchQuery = $('#searchInput').val();
    loadCategories();
    return false;
}

function loadCategories() {
    // Show loading spinner
    $('#loadingSpinner').show();
    $('#categoriesContainer').hide();
    $('#noCategories').hide();

    // Build query parameters
    const params = new URLSearchParams();
    if (currentSearchQuery) {
        params.append('searchTerm', currentSearchQuery);
    }

    const apiUrl = '/api/categories' + (params.toString() ? '?' + params.toString() : '');

    $.ajax({
        url: apiUrl,
        type: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                displayCategories(response.data);
            } else {
                showNoCategories();
            }
        },
        error: function(xhr) {
            console.error('Error loading categories:', xhr);
            showNoCategories();
        },
        complete: function() {
            $('#loadingSpinner').hide();
        }
    });
}

function displayCategories(categories) {
    const container = $('#categoriesContainer');

    if (categories.length === 0) {
        showNoCategories();
        return;
    }

    container.empty();

    const categoryHtml = categories.map(function(category) {
        return createCategoryCard(category);
    }).join('');

    container.html(categoryHtml);
    container.show();
}

function createCategoryCard(category) {
    const imageUrl = category.imageUrl || 'https://via.placeholder.com/300x200?text=No+Image';
    const productCount = category.productCount || 0;
    const categoryName = category.name || 'Unnamed Category';
    const categoryDescription = category.description || 'No description available';

    return `
        <div class="category-card">
            <div class="category-image">
                <img src="${imageUrl}" alt="${categoryName}" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                <div class="category-overlay">
                    <div class="text-center text-white">
                        <i class="fas fa-eye fa-2x mb-2"></i>
                        <p class="mb-0">View Category</p>
                    </div>
                </div>
            </div>
            <div class="category-info">
                <h5 class="category-name">
                    <a href="/categories/${category.id || ''}" class="text-decoration-none">${categoryName}</a>
                </h5>
                <p class="category-description">${categoryDescription}</p>

                <div class="category-stats">
                    <div class="stat-item">
                        <span class="stat-number">${productCount}</span>
                        <span class="stat-label">Products</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <i class="fas fa-star text-warning"></i>
                        </span>
                        <span class="stat-label">Featured</span>
                    </div>
                </div>

                <div class="category-actions">
                    <a href="/categories/${category.id || ''}" class="btn btn-view-category btn-category">
                        <i class="fas fa-eye me-1"></i>View
                    </a>
                    <a href="/products?categoryId=${category.id || ''}" class="btn btn-shop-category btn-category">
                        <i class="fas fa-shopping-bag me-1"></i>Shop
                    </a>
                </div>
            </div>
        </div>
    `;
}

function showNoCategories() {
    $('#categoriesContainer').hide();
    $('#noCategories').show();
}
</script>

</body>
</html>
