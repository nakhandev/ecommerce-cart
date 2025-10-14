<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Header -->
<header class="header">
    <!-- Top Bar -->
    <div class="top-bar bg-dark text-light py-2">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <span class="me-3"><i class="fas fa-phone me-1"></i> +1 (555) 123-4567</span>
                    <span><i class="fas fa-envelope me-1"></i> support@ecommerce.com</span>
                </div>
                <div class="col-md-6 text-end">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <span class="me-3">Welcome, ${sessionScope.user.firstName}!</span>
                            <a href="<c:url value='/auth/profile'/>" class="text-light me-2">
                                <i class="fas fa-user me-1"></i>Profile
                            </a>
                            <a href="<c:url value='/auth/logout'/>" class="text-light">
                                <i class="fas fa-sign-out-alt me-1"></i>Logout
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/auth/login'/>" class="text-light me-2">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                            <a href="<c:url value='/auth/register'/>" class="text-light">
                                <i class="fas fa-user-plus me-1"></i>Register
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <!-- Logo -->
            <a class="navbar-brand d-flex align-items-center" href="<c:url value='/'/>">
                <i class="fas fa-shopping-cart text-primary me-2 fs-4"></i>
                <span class="fw-bold text-primary">E-Shop</span>
            </a>

            <!-- Mobile Menu Toggle -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Navigation Menu -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link ${pageTitle == 'Home' ? 'active' : ''}"
                           href="<c:url value='/'/>">
                            <i class="fas fa-home me-1"></i>Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageTitle == 'Products' ? 'active' : ''}"
                           href="<c:url value='/products'/>">
                            <i class="fas fa-th-large me-1"></i>Products
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-list me-1"></i>Categories
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="<c:url value='/categories'/>">All Categories</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<c:url value='/categories/1'/>">Electronics</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/categories/2'/>">Clothing</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/categories/3'/>">Books</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/categories/4'/>">Home & Garden</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/categories/5'/>">Sports</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/categories/6'/>">Health & Beauty</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/contact'/>">
                            <i class="fas fa-phone me-1"></i>Contact
                        </a>
                    </li>
                </ul>

                <!-- Enhanced Search Bar -->
                <div class="d-flex me-3 search-container">
                    <form class="d-flex" action="<c:url value='/products/search'/>" method="get">
                        <div class="input-group input-group-ecommerce">
                            <input class="form-control form-ecommerce" type="search" name="query"
                                   placeholder="Search products..." aria-label="Search" autocomplete="off">
                            <button class="btn btn-ecommerce btn-ecommerce-primary" type="submit">
                                <i class="fas fa-search me-1"></i>Search
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Cart & User Actions -->
                <div class="d-flex align-items-center">
                    <!-- Shopping Cart -->
                    <div class="dropdown me-3">
                        <button class="btn btn-outline-secondary position-relative" type="button" data-bs-toggle="dropdown" id="cartDropdownBtn">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-primary cart-badge">0</span>
                        </button>
                        <div class="dropdown-menu dropdown-menu-end cart-dropdown" id="cartDropdown">
                            <div id="cartDropdownContent">
                                <!-- Cart content will be loaded here via AJAX -->
                            </div>
                        </div>
                    </div>

                    <!-- User Menu -->
                    <c:if test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user me-1"></i>${sessionScope.user.firstName}
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="<c:url value='/profile'/>">
                                    <i class="fas fa-user-edit me-2"></i>Profile
                                </a></li>
                                <li><a class="dropdown-item" href="<c:url value='/orders'/>">
                                    <i class="fas fa-shopping-bag me-2"></i>My Orders
                                </a></li>
                                <!-- Admin Access -->
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="<c:url value='/admin/dashboard'/>">
                                        <i class="fas fa-cog me-2"></i>Admin Panel
                                    </a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<c:url value='/auth/logout'/>">
                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                                </a></li>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </nav>
</header>

<script>
$(document).ready(function() {
    // Load cart dropdown on page load
    loadCartDropdown();

    // Refresh cart dropdown every 10 seconds
    setInterval(loadCartDropdown, 10000);

    // Add click handlers for cart dropdown
    $('#cartDropdownBtn').click(function() {
        // Ensure cart is loaded when dropdown is opened
        if (!$('#cartDropdownContent').hasClass('loaded')) {
            loadCartDropdown();
        }
    });
});

function loadCartDropdown() {
    const userId = getCurrentUserId();

    $.ajax({
        url: '/api/cart',
        type: 'GET',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                renderCartDropdown(response.data);
                updateCartBadge();
            }
        },
        error: function() {
            console.error('Error loading cart dropdown');
        }
    });
}

function renderCartDropdown(cart) {
    let html = '';

    if (!cart || !cart.items || cart.items.length === 0) {
        html = `
            <div class="dropdown-item text-center text-muted">
                <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                <div>Your cart is empty</div>
                <a href="/products" class="btn btn-primary btn-sm mt-2">Start Shopping</a>
            </div>
        `;
    } else {
        // Cart header
        html += '<h6 class="dropdown-header">Shopping Cart (' + cart.totalItems + ' items)</h6>';

        // Cart items (show max 3)
        cart.items.forEach(function(item, index) {
            if (index < 3) {
                const discountedPrice = item.productDiscountedPrice || item.unitPrice;
                const hasDiscount = item.productDiscountPercentage > 0;

                html += `
                    <div class="dropdown-item">
                        <div class="d-flex align-items-center">
                            <img src="${item.productImageUrl || '/static/images/products/no-image.png'}"
                                 alt="${item.productName}" class="cart-item-image me-2" style="width: 40px; height: 40px;">
                            <div class="flex-grow-1">
                                <div class="fw-bold small">${item.productName}</div>
                                <small class="text-muted">${item.quantity} × ₹${discountedPrice.toFixed(2)}</small>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold small">₹${item.subtotal.toFixed(2)}</div>
                                <button class="btn btn-sm btn-outline-danger mt-1" onclick="removeFromCartDropdown(${item.productId})">
                                    <i class="fas fa-trash fa-xs"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            }
        });

        // Show "and X more" if there are more items
        if (cart.items.length > 3) {
            html += `
                <div class="dropdown-item text-center">
                    <small class="text-muted">and ${cart.items.length - 3} more items...</small>
                </div>
            `;
        }

        // Cart footer with totals and actions
        html += `
            <div class="dropdown-divider"></div>
            <div class="dropdown-item">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <strong>Total: ₹${cart.totalAmount.toFixed(2)}</strong>
                </div>
                <div class="d-grid gap-1">
                    <a href="/cart" class="btn btn-primary btn-sm">
                        <i class="fas fa-shopping-cart me-1"></i>View Cart
                    </a>
                    <a href="${getCurrentUserId() !== 'guest' ? '/checkout' : '#'}" class="btn btn-success btn-sm"
                       ${getCurrentUserId() === 'guest' ? 'onclick="showLoginPrompt()"' : ''}>
                        <i class="fas fa-credit-card me-1"></i>Checkout
                    </a>
                </div>
            </div>
        `;
    }

    $('#cartDropdownContent').html(html).addClass('loaded');
}

function removeFromCartDropdown(productId) {
    const userId = getCurrentUserId();

    $.ajax({
        url: `/api/cart/items/${productId}`,
        type: 'DELETE',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                loadCartDropdown(); // Refresh dropdown
                showCartAlert('Item removed from cart', 'success');
            } else {
                showCartAlert('Failed to remove item', 'danger');
            }
        },
        error: function() {
            showCartAlert('Error removing item', 'danger');
        }
    });
}

function showCartAlert(message, type) {
    // Create a small alert that appears near the cart dropdown
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

function getCurrentUserId() {
    // Check if user is logged in
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            return '${sessionScope.user.id}';
        </c:when>
        <c:otherwise>
            // For guest users, use session ID or generate guest ID
            return getGuestUserId();
        </c:otherwise>
    </c:choose>
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
        }
    });
}

function showLoginPrompt() {
    // Show login modal or redirect to login page
    window.location.href = '/auth/login?redirect=/checkout';
}
</script>

<style>
.cart-item-image {
    object-fit: cover;
    border-radius: 4px;
}

.cart-dropdown {
    min-width: 350px;
    max-height: 500px;
    overflow-y: auto;
}

.cart-alert {
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.top-bar {
    font-size: 0.875rem;
}

.dropdown-item {
    padding: 0.5rem 1rem;
}

.dropdown-item:last-child {
    padding-bottom: 1rem;
}
</style>
