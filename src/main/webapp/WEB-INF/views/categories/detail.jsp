<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="${category.name} - Category" scope="request"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : ''}"/> - E-Shop</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<c:url value='/static/css/custom.css'/>" rel="stylesheet">

    <!-- Favicon -->
    <link href="<c:url value='/static/images/favicon.svg'/>" rel="icon" type="image/svg+xml">

    <style>
        /* Category detail page specific styles */
        .category-detail-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 3rem 0;
            margin-bottom: 2rem;
        }

        .category-hero {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .category-hero-image {
            height: 300px;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .category-hero-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .category-hero-title {
            font-size: 2rem;
            font-weight: 700;
            color: #212529;
            margin-bottom: 1rem;
        }

        .category-hero-description {
            color: #6c757d;
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .category-meta {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .meta-icon {
            color: #0d6efd;
            font-size: 1.2rem;
        }

        .meta-text {
            font-weight: 500;
            color: #495057;
        }

        .category-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn-category-action {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-shop-now {
            background: linear-gradient(135deg, #0d6efd 0%, #6f42c1 100%);
            border: none;
            color: white;
        }

        .btn-shop-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
            color: white;
        }

        .btn-all-categories {
            background: transparent;
            border: 2px solid #0d6efd;
            color: #0d6efd;
        }

        .btn-all-categories:hover {
            background: #0d6efd;
            color: white;
        }

        .products-section {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: #0d6efd;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }

        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .product-image {
            position: relative;
            height: 200px;
            overflow: hidden;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image img {
            transform: scale(1.05);
        }

        .product-info {
            padding: 1.5rem;
        }

        .product-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .product-title:hover {
            color: #0d6efd;
        }

        .product-description {
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

        .product-price {
            margin-bottom: 1rem;
        }

        .price-original {
            text-decoration: line-through;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .price-discounted {
            font-size: 1.2rem;
            font-weight: 700;
            color: #dc3545;
        }

        .price-regular {
            font-size: 1.2rem;
            font-weight: 700;
            color: #0d6efd;
        }

        .product-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-action {
            flex: 1;
            min-width: calc(50% - 0.25rem);
            padding: 0.5rem 0.75rem;
            font-size: 0.9rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-add-cart {
            background: linear-gradient(135deg, #0d6efd 0%, #6f42c1 100%);
            border: none;
            color: white;
        }

        .btn-add-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
        }

        .btn-view {
            background: transparent;
            border: 2px solid #0d6efd;
            color: #0d6efd;
        }

        .btn-view:hover {
            background: #0d6efd;
            color: white;
        }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 3rem;
        }

        .no-products {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .no-products i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 1rem;
            }

            .category-meta {
                flex-direction: column;
                gap: 1rem;
            }

            .category-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<!-- Category Detail Header -->
<section class="category-detail-header">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/">Home</a></li>
                <li class="breadcrumb-item"><a href="/categories">Categories</a></li>
                <li class="breadcrumb-item active" aria-current="page">${category.name}</li>
            </ol>
        </nav>
    </div>
</section>

<!-- Main Content -->
<section class="category-detail-content py-4">
    <div class="container">
        <!-- Category Hero Section -->
        <div class="category-hero">
            <div class="row">
                <div class="col-lg-8">
                    <div class="category-hero-image">
                        <img src="${category.imageUrl}" alt="${category.name}" onerror="this.src='https://via.placeholder.com/600x300?text=No+Image'">
                    </div>
                </div>
                <div class="col-lg-4">
                    <h1 class="category-hero-title">${category.name}</h1>
                    <p class="category-hero-description">${category.description}</p>

                    <div class="category-meta">
                        <div class="meta-item">
                            <i class="fas fa-boxes meta-icon"></i>
                            <span class="meta-text" id="productCount">Loading...</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-calendar meta-icon"></i>
                            <span class="meta-text">Active Category</span>
                        </div>
                    </div>

                    <div class="category-actions">
                        <a href="/products?categoryId=${category.id}" class="btn-category-action btn-shop-now">
                            <i class="fas fa-shopping-bag"></i>
                            Shop Now
                        </a>
                        <a href="/categories" class="btn-category-action btn-all-categories">
                            <i class="fas fa-th-large"></i>
                            All Categories
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Section -->
        <div class="products-section">
            <h2 class="section-title">
                <i class="fas fa-box"></i>
                Products in ${category.name}
            </h2>

            <!-- Products Container -->
            <div id="productsContainer">
                <!-- Products will be loaded here -->
            </div>

            <!-- Loading Spinner -->
            <div class="loading-spinner" id="loadingSpinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="mt-2 text-muted">Loading products...</p>
            </div>

            <!-- No Products Message -->
            <div class="no-products" id="noProducts" style="display: none;">
                <i class="fas fa-box-open"></i>
                <h4>No Products Found</h4>
                <p>This category doesn't have any products yet.</p>
                <a href="/categories" class="btn btn-primary">
                    <i class="fas fa-arrow-left me-2"></i>Browse Other Categories
                </a>
            </div>
        </div>
    </div>
</section>

<script>
// Category detail page functionality
var categoryId = '<c:out value="${category.id}" escapeXml="false"/>';
var currentPage = 0;

$(document).ready(function() {
    initializeCategoryDetailPage();
});

function initializeCategoryDetailPage() {
    // Load category products
    loadCategoryProducts();

    // Set up event listeners
    setupEventListeners();
}

function setupEventListeners() {
    // Add any additional event listeners here if needed
}

function loadCategoryProducts() {
    // Show loading spinner
    $('#loadingSpinner').show();
    $('#productsContainer').hide();
    $('#noProducts').hide();

    // Build query parameters
    const params = new URLSearchParams();
    params.append('page', currentPage);
    params.append('size', 12);

    const apiUrl = '/api/products/category/' + categoryId + '?' + params.toString();

    $.ajax({
        url: apiUrl,
        type: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                displayProducts(response.data);
                updateProductCount(response.data.length);
            } else {
                showNoProducts();
            }
        },
        error: function(xhr) {
            console.error('Error loading category products:', xhr);
            showNoProducts();
        },
        complete: function() {
            $('#loadingSpinner').hide();
        }
    });
}

function displayProducts(products) {
    const container = $('#productsContainer');

    if (products.length === 0) {
        showNoProducts();
        return;
    }

    container.empty();

    const productHtml = products.map(function(product) {
        return createProductCard(product);
    }).join('');

    container.html(productHtml);
    container.show();
}

function createProductCard(product) {
    const imageUrl = product.imageUrl || 'https://via.placeholder.com/300x200?text=No+Image';

    const priceHtml = product.discountPercentage > 0 ?
        `<div class="product-price">
            <span class="price-original me-2">₹${product.price}</span>
            <span class="price-discounted">₹${product.discountedPrice || product.price}</span>
        </div>` :
        `<div class="product-price">
            <span class="price-regular">₹${product.price}</span>
        </div>`;

    return `
        <div class="product-card">
            <div class="product-image">
                <img src="${imageUrl}" alt="${product.name}" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
            </div>
            <div class="product-info">
                <h5 class="product-title">
                    <a href="/products/${product.id}" class="text-decoration-none">${product.name}</a>
                </h5>
                <p class="product-description">${product.shortDescription}</p>
                ${priceHtml}
                <div class="product-actions">
                    <a href="/products/${product.id}" class="btn btn-view btn-action">
                        <i class="fas fa-eye me-1"></i>View
                    </a>
                    <button class="btn btn-add-cart btn-action" onclick="addToCart('${product.id}', 1)">
                        <i class="fas fa-shopping-cart me-1"></i>Add
                    </button>
                </div>
            </div>
        </div>
    `;
}

function updateProductCount(count) {
    $('#productCount').text(count + ' products');
}

function showNoProducts() {
    $('#productsContainer').hide();
    $('#noProducts').show();
    $('#productCount').text('0 products');
}

// Include cart functionality from the products page
function addToCart(productId, quantity) {
    // This would need the same cart functionality as the products page
    console.log('Adding to cart:', productId, quantity);
    // For now, just show a message
    alert('Cart functionality would be implemented here');
}
</script>

</body>
</html>
