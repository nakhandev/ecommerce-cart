<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Home" scope="request"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : ''}"/>E-Shop</title>

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
        /* Additional custom styles for the landing page */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 60vh;
            position: relative;
            overflow: hidden;
        }

        .hero-bg-pattern {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image:
                radial-gradient(circle at 20% 80%, rgba(255,255,255,0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255,255,255,0.05) 0%, transparent 50%);
            opacity: 0.3;
        }

        .section-title {
            color: #0d6efd;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .btn-ecommerce {
            border-radius: 12px;
            font-weight: 600;
            padding: 0.75rem 2rem;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-ecommerce-primary {
            background: linear-gradient(135deg, #0d6efd 0%, #6f42c1 100%);
            color: white;
        }

        .btn-ecommerce-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(13, 110, 253, 0.3);
        }

        .btn-ecommerce-outline {
            border: 2px solid #0d6efd;
            color: #0d6efd;
            background: transparent;
        }

        .btn-ecommerce-outline:hover {
            background: #0d6efd;
            color: white;
            transform: translateY(-2px);
        }

        .category-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .product-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: white;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .feature-card {
            padding: 2rem 1rem;
            border-radius: 12px;
            transition: transform 0.3s ease;
            text-align: center;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .trust-indicators {
            margin-top: 2rem;
        }

        .trust-indicators .d-flex {
            gap: 1.5rem;
        }

        /* Animation classes */
        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes bounce {
            0%, 20%, 53%, 80%, 100% { transform: translate3d(0,0,0); }
            40%, 43% { transform: translate3d(0, -30px, 0); }
            70% { transform: translate3d(0, -15px, 0); }
            90% { transform: translate3d(0, -4px, 0); }
        }

        .animate-slide-left {
            animation: slideInLeft 0.8s ease-out;
        }

        .animate-slide-right {
            animation: slideInRight 0.8s ease-out;
        }

        .animate-bounce {
            animation: bounce 2s infinite;
        }

        .floating-card {
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        /* Responsive improvements */
        @media (max-width: 768px) {
            .hero-section {
                text-align: center;
                padding: 3rem 0;
                min-height: 50vh;
            }

            .hero-section .display-4 {
                font-size: 2rem;
            }

            .trust-indicators .d-flex {
                justify-content: center;
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>

<!-- Enhanced Hero Section -->
<section class="hero-section bg-gradient-primary text-white py-5 position-relative overflow-hidden">
    <div class="container position-relative">
        <div class="row align-items-center min-vh-75">
            <div class="col-lg-6 animate-slide-left">
                <div class="hero-content">
                    <h1 class="display-3 fw-bold mb-4 lh-1">Welcome to E-Shop</h1>
                    <p class="lead mb-4 opacity-90 lh-base">
                        Discover amazing products at unbeatable prices. From electronics to fashion,
                        we have everything you need for modern living.
                    </p>
                    <div class="hero-buttons d-flex flex-wrap gap-3">
                        <a href="<c:url value='/products'/>" class="btn btn-ecommerce btn-ecommerce-primary btn-lg px-4 py-3">
                            <i class="fas fa-shopping-bag me-2"></i>Shop Now
                        </a>
                        <a href="<c:url value='/categories'/>" class="btn btn-ecommerce btn-ecommerce-outline btn-lg px-4 py-3">
                            <i class="fas fa-list me-2"></i>Browse Categories
                        </a>
                    </div>

                    <!-- Trust Indicators -->
                    <div class="trust-indicators mt-5 d-flex flex-wrap gap-4 align-items-center">
                        <div class="d-flex align-items-center gap-2">
                            <i class="fas fa-shield-alt text-success fs-5"></i>
                            <span class="small opacity-75">Secure Shopping</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="fas fa-truck text-info fs-5"></i>
                            <span class="small opacity-75">Free Delivery</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="fas fa-undo text-warning fs-5"></i>
                            <span class="small opacity-75">Easy Returns</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 animate-slide-right">
                <div class="hero-image-container position-relative">
                    <img src="https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=600&h=400&fit=crop"
                         alt="Shopping" class="img-fluid rounded-4 shadow-lg w-100">
                    <div class="hero-image-overlay position-absolute top-0 start-0 w-100 h-100 rounded-4"></div>

                    <!-- Floating Cards -->
                    <div class="floating-card position-absolute top-0 end-0 bg-white rounded-3 shadow-lg p-3 animate-bounce"
                         style="animation-delay: 1s; width: 120px;">
                        <div class="text-center">
                            <i class="fas fa-star text-warning fs-6"></i>
                            <small class="d-block fw-semibold text-primary">4.9/5</small>
                            <small class="text-muted">Rating</small>
                        </div>
                    </div>

                    <div class="floating-card position-absolute bottom-0 start-0 bg-white rounded-3 shadow-lg p-3 animate-pulse"
                         style="animation-delay: 2s; width: 140px;">
                        <div class="text-center">
                            <i class="fas fa-users text-info fs-6"></i>
                            <small class="d-block fw-semibold text-primary">10K+</small>
                            <small class="text-muted">Happy Customers</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Background Pattern -->
    <div class="hero-bg-pattern position-absolute top-0 start-0 w-100 h-100 opacity-10"></div>
</section>

<!-- Featured Categories -->
<section class="featured-categories py-5">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center mb-5">
                <h2 class="section-title">Shop by Category</h2>
                <p class="text-muted">Find exactly what you're looking for</p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Electronics -->
            <div class="col-lg-4 col-md-6">
                <div class="category-card">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400&h=250&fit=crop"
                             alt="Electronics" class="img-fluid">
                        <div class="category-overlay">
                            <a href="<c:url value='/categories/1'/>" class="btn btn-primary">Shop Electronics</a>
                        </div>
                    </div>
                    <div class="category-info p-3">
                        <h5 class="mb-2">Electronics</h5>
                        <p class="text-muted mb-0">Latest gadgets and tech innovations</p>
                    </div>
                </div>
            </div>

            <!-- Clothing -->
            <div class="col-lg-4 col-md-6">
                <div class="category-card">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=250&fit=crop"
                             alt="Clothing" class="img-fluid">
                        <div class="category-overlay">
                            <a href="<c:url value='/categories/2'/>" class="btn btn-primary">Shop Clothing</a>
                        </div>
                    </div>
                    <div class="category-info p-3">
                        <h5 class="mb-2">Clothing</h5>
                        <p class="text-muted mb-0">Fashion for every occasion</p>
                    </div>
                </div>
            </div>

            <!-- Books -->
            <div class="col-lg-4 col-md-6">
                <div class="category-card">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=250&fit=crop"
                             alt="Books" class="img-fluid">
                        <div class="category-overlay">
                            <a href="<c:url value='/categories/3'/>" class="btn btn-primary">Shop Books</a>
                        </div>
                    </div>
                    <div class="category-info p-3">
                        <h5 class="mb-2">Books</h5>
                        <p class="text-muted mb-0">Knowledge and entertainment</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Featured Products -->
<section class="featured-products py-5 bg-light">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center mb-5">
                <h2 class="section-title">Featured Products</h2>
                <p class="text-muted">Hand-picked products just for you</p>
            </div>
        </div>

        <div class="row g-4">
            <c:forEach var="product" items="${featuredProducts}" varStatus="loop">
                <c:if test="${loop.index < 8}">
                    <div class="col-lg-3 col-md-6">
                        <div class="product-card h-100">
                            <div class="product-image">
                                <img src="${product.imageUrl}" alt="${product.name}" class="img-fluid">
                                <c:if test="${product.isFeatured}">
                                    <span class="badge bg-primary position-absolute top-0 end-0 m-2">Featured</span>
                                </c:if>
                                <c:if test="${product.discountPercentage > 0}">
                                    <span class="badge bg-danger position-absolute top-0 start-0 m-2">
                                        -${product.discountPercentage}%
                                    </span>
                                </c:if>
                            </div>
                            <div class="product-info p-3">
                                <h6 class="product-title mb-2">${product.name}</h6>
                                <p class="product-description text-muted small mb-2">
                                    ${product.shortDescription}
                                </p>
                                <div class="product-price mb-3">
                                    <c:choose>
                                        <c:when test="${product.discountPercentage > 0 && not empty product.discountedPrice}">
                                            <span class="text-decoration-line-through text-muted me-2">
                                                ₹${product.price}
                                            </span>
                                            <span class="fw-bold text-primary">₹${product.discountedPrice}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fw-bold text-primary">₹${product.price}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-actions">
                                    <a href="<c:url value='/products/${product.id}'/>"
                                       class="btn btn-outline-primary btn-sm me-2">
                                        <i class="fas fa-eye me-1"></i>View
                                    </a>
                                    <button class="btn btn-primary btn-sm" onclick="addToCart('${product.id}', 1)">
                                        <i class="fas fa-shopping-cart me-1"></i>Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <div class="row mt-4">
            <div class="col-12 text-center">
                <a href="<c:url value='/products'/>" class="btn btn-outline-primary btn-lg">
                    View All Products <i class="fas fa-arrow-right ms-2"></i>
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon mb-3">
                        <i class="fas fa-truck fa-3x text-primary"></i>
                    </div>
                    <h6 class="fw-bold">Free Shipping</h6>
                    <p class="text-muted">Free delivery on orders above ₹1000</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon mb-3">
                        <i class="fas fa-undo fa-3x text-primary"></i>
                    </div>
                    <h6 class="fw-bold">Easy Returns</h6>
                    <p class="text-muted">30-day hassle-free return policy</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon mb-3">
                        <i class="fas fa-shield-alt fa-3x text-primary"></i>
                    </div>
                    <h6 class="fw-bold">Secure Payment</h6>
                    <p class="text-muted">100% secure payment processing</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon mb-3">
                        <i class="fas fa-headset fa-3x text-primary"></i>
                    </div>
                    <h6 class="fw-bold">24/7 Support</h6>
                    <p class="text-muted">Round-the-clock customer support</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Newsletter Section -->
<section class="newsletter-section py-5 bg-primary text-white">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 text-center">
                <h3 class="mb-3">Stay Updated</h3>
                <p class="mb-4">Subscribe to our newsletter for exclusive deals and new product updates.</p>
                <form class="d-flex justify-content-center" onsubmit="return ECommerceApp.newsletter.subscribe(this)">
                    <input type="email" class="form-control me-2" placeholder="Enter your email"
                           style="max-width: 300px;" required>
                    <button type="submit" class="btn btn-ecommerce btn-ecommerce-primary">Subscribe</button>
                </form>
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

$(document).ready(function() {
    // Initialize cart functionality
    initializeCartFeatures();
});

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
    if (currentUserId !== null) {
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

// Newsletter subscription (placeholder)
window.ECommerceApp = {
    newsletter: {
        subscribe: function(form) {
            const email = $(form).find('input[type="email"]').val();
            if (email) {
                showCartAlert('Thank you for subscribing!', 'success');
                $(form)[0].reset();
            }
            return false;
        }
    }
};
</script>

<style>
.cart-alert {
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.product-card {
    transition: transform 0.3s ease;
}

.product-card:hover {
    transform: translateY(-5px);
}

.category-card {
    transition: transform 0.3s ease;
}

.category-card:hover {
    transform: translateY(-5px);
}

.category-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s ease;
}

.category-card:hover .category-overlay {
    opacity: 1;
}
</style>
