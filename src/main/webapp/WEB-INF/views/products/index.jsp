<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Products" scope="request"/>
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
        /* Products page specific styles */
        .products-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 3rem 0 2rem;
            margin-bottom: 2rem;
        }

        .filter-sidebar {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 2rem;
        }

        .filter-title {
            font-weight: 600;
            color: #0d6efd;
            margin-bottom: 1rem;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 0.5rem;
        }

        .category-item {
            padding: 0.5rem 0;
            border-bottom: 1px solid #f8f9fa;
            transition: all 0.3s ease;
        }

        .category-item:last-child {
            border-bottom: none;
        }

        .category-item:hover {
            background-color: #f8f9fa;
            margin: 0 -0.5rem;
            padding: 0.5rem;
            border-radius: 6px;
        }

        .category-link {
            color: #6c757d;
            text-decoration: none;
            font-weight: 500;
            display: block;
            transition: color 0.3s ease;
        }

        .category-link:hover,
        .category-link.active {
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

        .pagination-wrapper {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
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

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
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

            .filter-sidebar {
                position: static;
                margin-bottom: 2rem;
            }

            .btn-action {
                min-width: 100%;
                margin-bottom: 0.5rem;
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
                       placeholder="Search for products..." value="${param.query}">
                <button class="btn search-btn" type="submit">
                    <i class="fas fa-search me-2"></i>Search
                </button>
            </div>
        </form>
    </div>
</section>

<!-- Products Header -->
<section class="products-header">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1 class="display-5 fw-bold text-center mb-3">Our Products</h1>
                <p class="lead text-center text-muted mb-0">
                    Discover amazing products at unbeatable prices
                </p>
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<section class="products-content py-4">
    <div class="container">
        <div class="row">
            <!-- Filter Sidebar -->
            <div class="col-lg-3 col-xl-2">
                <div class="filter-sidebar">
                    <h5 class="filter-title">
                        <i class="fas fa-filter me-2"></i>Filters
                    </h5>

                    <!-- Categories Filter -->
                    <div class="categories-filter mb-4">
                        <h6 class="fw-semibold mb-3">Categories</h6>
                        <div id="categoriesList">
                            <div class="category-item">
                                <a href="#" class="category-link active" data-category="">
                                    <i class="fas fa-th-large me-2"></i>All Categories
                                </a>
                            </div>
                            <!-- Categories will be loaded here -->
                        </div>
                    </div>

                    <!-- Price Range Filter -->
                    <div class="price-filter mb-4">
                        <h6 class="fw-semibold mb-3">Price Range</h6>
                        <div class="price-range-inputs">
                            <div class="input-group input-group-sm mb-2">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" id="minPrice" placeholder="Min" min="0">
                            </div>
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" id="maxPrice" placeholder="Max" min="0">
                            </div>
                            <button class="btn btn-outline-primary btn-sm w-100 mt-2" onclick="applyPriceFilter()">
                                Apply
                            </button>
                        </div>
                    </div>

                    <!-- Special Filters -->
                    <div class="special-filters">
                        <h6 class="fw-semibold mb-3">Special</h6>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="featuredOnly">
                            <label class="form-check-label" for="featuredOnly">
                                Featured Products
                            </label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="onSaleOnly">
                            <label class="form-check-label" for="onSaleOnly">
                                On Sale
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="inStockOnly">
                            <label class="form-check-label" for="inStockOnly">
                                In Stock Only
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="col-lg-9 col-xl-10">
                <!-- Results Info -->
                <div class="results-info d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <span class="text-muted" id="resultsCount">Loading products...</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <label for="sortSelect" class="form-label mb-0 text-muted">Sort by:</label>
                        <select class="form-select form-select-sm" id="sortSelect" style="width: auto;">
                            <option value="name">Name</option>
                            <option value="price_asc">Price: Low to High</option>
                            <option value="price_desc">Price: High to Low</option>
                            <option value="newest">Newest</option>
                        </select>
                    </div>
                </div>

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
                    <p>Try adjusting your search criteria or browse all products.</p>
                    <button class="btn btn-primary" onclick="loadProducts()">
                        <i class="fas fa-refresh me-2"></i>Show All Products
                    </button>
                </div>

                <!-- Pagination -->
                <div class="pagination-wrapper" id="paginationWrapper" style="display: none;">
                    <nav aria-label="Products pagination">
                        <ul class="pagination justify-content-center" id="pagination">
                            <!-- Pagination will be generated here -->
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Define current user ID using JSP -->
<c:choose>
    <c:when test="${not empty sessionScope.user}">
        <c:set var="currentUserId" value="${sessionScope.user.id}" scope="request"/>
    </c:when>
    <c:otherwise>
        <c:set var="currentUserId" value="null" scope="request"/>
    </c:otherwise>
</c:choose>

<script>
// Define current user ID using JSP variable
var currentUserId = '<c:out value="${currentUserId}" escapeXml="false"/>';
var currentPage = 0;
var currentSearchQuery = '${param.query}';
var currentCategoryId = '';
var currentFilters = {};

// Initialize page when document is ready
$(document).ready(function() {
    initializeProductsPage();
});

function initializeProductsPage() {
    // Load categories for filter sidebar
    loadCategories();

    // Load initial products
    loadProducts();

    // Set up event listeners
    setupEventListeners();

    // Initialize cart functionality
    initializeCartFeatures();
}

function setupEventListeners() {
    // Sort dropdown change
    $('#sortSelect').on('change', function() {
        loadProducts();
    });

    // Filter checkboxes
    $('#featuredOnly, #onSaleOnly, #inStockOnly').on('change', function() {
        loadProducts();
    });

    // Search form
    $('form').on('submit', handleSearch);
}

function handleSearch(event) {
    event.preventDefault();
    currentSearchQuery = $('#searchInput').val();
    currentPage = 0;
    loadProducts();
    return false;
}

function loadCategories() {
    $.ajax({
        url: '/api/categories',
        type: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                displayCategories(response.data);
            }
        },
        error: function() {
            console.error('Error loading categories');
        }
    });
}

function displayCategories(categories) {
    const container = $('#categoriesList');

    categories.forEach(function(category) {
        const categoryItem = `
            <div class="category-item">
                <a href="#" class="category-link" data-category="${category.id}">
                    <i class="fas fa-tag me-2"></i>${category.name}
                </a>
            </div>
        `;
        container.append(categoryItem);
    });

    // Category click handlers
    $('.category-link').on('click', function(e) {
        e.preventDefault();
        $('.category-link').removeClass('active');
        $(this).addClass('active');
        currentCategoryId = $(this).data('category');
        currentPage = 0;
        loadProducts();
    });
}

function applyPriceFilter() {
    currentPage = 0;
    loadProducts();
}

function loadProducts() {
    // Show loading spinner
    $('#loadingSpinner').show();
    $('#productsContainer').hide();
    $('#noProducts').hide();

    // Collect current filters
    currentFilters = {
        query: currentSearchQuery,
        categoryId: currentCategoryId,
        sortBy: $('#sortSelect').val(),
        featuredOnly: $('#featuredOnly').is(':checked'),
        onSaleOnly: $('#onSaleOnly').is(':checked'),
        inStockOnly: $('#inStockOnly').is(':checked'),
        minPrice: $('#minPrice').val(),
        maxPrice: $('#maxPrice').val(),
        page: currentPage,
        size: 12
    };

    // Build query parameters
    const params = new URLSearchParams();
    Object.keys(currentFilters).forEach(key => {
        if (currentFilters[key] !== '' && currentFilters[key] !== null && currentFilters[key] !== undefined) {
            params.append(key, currentFilters[key]);
        }
    });

    // Determine API endpoint
    let apiUrl = '/api/products';
    if (currentSearchQuery) {
        apiUrl += '/search?' + params.toString();
    } else if (currentCategoryId) {
        apiUrl += '/category/' + currentCategoryId + '?' + params.toString();
    } else if (currentFilters.featuredOnly) {
        apiUrl += '/featured?' + params.toString();
    } else if (currentFilters.onSaleOnly) {
        apiUrl += '/sale?' + params.toString();
    } else {
        apiUrl += '?' + params.toString();
    }

    $.ajax({
        url: apiUrl,
        type: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                displayProducts(response.data);
                updateResultsCount(response.data.length);
            } else {
                showNoProducts();
            }
        },
        error: function(xhr) {
            console.error('Error loading products:', xhr);
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
    const discountBadge = product.discountPercentage > 0 ?
        `<span class="badge bg-danger position-absolute top-0 start-0 m-2">
            -${product.discountPercentage}%
        </span>` : '';

    const featuredBadge = product.isFeatured ?
        '<span class="badge bg-primary position-absolute top-0 end-0 m-2">Featured</span>' : '';

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
                ${discountBadge}
                ${featuredBadge}
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

function updateResultsCount(count) {
    var productText = count === 1 ? 'product' : 'products';
    $('#resultsCount').text('Showing ' + count + ' ' + productText);
}

function showNoProducts() {
    $('#productsContainer').hide();
    $('#noProducts').show();
    $('#resultsCount').text('No products found');
}

function initializeCartFeatures() {
    // Load initial cart state
    updateCartBadge();

    // Set up periodic cart updates
    setInterval(updateCartBadge, 15000);
}

function addToCart(productId, quantity) {
    const userId = getCurrentUserId();

    // Show loading state
    const button = event.target;
    const originalText = button.innerHTML;
    button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Adding...';
    button.disabled = true;

    $.ajax({
        url: '/api/cart/items',
        type: 'POST',
        data: {
            userId: userId,
            productId: productId,
            quantity: quantity
        },
        success: function(response) {
            if (response.success) {
                // Show success message
                showCartAlert('Product added to cart!', 'success');

                // Update cart badge and dropdown
                updateCartBadge();
                loadCartDropdown();

                // Add visual feedback animation
                addCartAnimation(button);
            } else {
                showCartAlert('Failed to add product to cart: ' + (response.message || 'Unknown error'), 'danger');
            }
        },
        error: function(xhr) {
            let errorMessage = 'Error adding product to cart';
            if (xhr.responseJSON && xhr.responseJSON.message) {
                errorMessage = xhr.responseJSON.message;
            }
            showCartAlert(errorMessage, 'danger');
        },
        complete: function() {
            // Restore button state
            button.innerHTML = originalText;
            button.disabled = false;
        }
    });
}

function addCartAnimation(button) {
    // Add a subtle animation to indicate success
    $(button).addClass('btn-success').removeClass('btn-primary');
    setTimeout(() => {
        $(button).addClass('btn-primary').removeClass('btn-success');
    }, 1000);
}

function getCurrentUserId() {
    if (currentUserId !== null && currentUserId !== 'null') {
        return currentUserId;
    } else {
        // For guest users, use session ID or generate guest ID
        return getGuestUserId();
    }
}

function getGuestUserId() {
    // Generate or retrieve guest user ID from session
    let guestId = sessionStorage.getItem('guestUserId');
    if (!guestId) {
        guestId = 'guest_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        sessionStorage.setItem('guestUserId', guestId);
    }
    return guestId;
}

function updateCartBadge() {
    const userId = getCurrentUserId();

    $.ajax({
        url: '/api/cart/count',
        type: 'GET',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                $('.cart-badge').text(response.data);
            }
        },
        error: function() {
            console.error('Error updating cart badge');
        }
    });
}

function showCartAlert(message, type) {
    // Create a floating alert
    const alertHtml = `
        <div class="alert alert-${type} alert-dismissible fade show cart-alert"
             style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 300px;">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;

    // Remove existing cart alerts
    $('.cart-alert').remove();

    // Add new alert
    $('body').append(alertHtml);

    // Auto-hide after 3 seconds
    setTimeout(() => $('.cart-alert').fadeOut(), 3000);
}
</script>

<style>
.cart-alert {
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
</style>

</body>
</html>
