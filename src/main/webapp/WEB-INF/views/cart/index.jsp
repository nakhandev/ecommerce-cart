<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">
                <i class="fas fa-shopping-cart text-primary me-2"></i>Shopping Cart
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<c:url value='/'/>">Home</a></li>
                    <li class="breadcrumb-item active">Shopping Cart</li>
                </ol>
            </nav>
        </div>
    </div>
</div>

<!-- Loading Spinner -->
<div class="text-center d-none" id="loadingSpinner">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    <div class="mt-2">Loading your cart...</div>
</div>

<!-- Cart Content -->
<div id="cartContent" class="d-none">
    <!-- Empty Cart Message -->
    <div class="container" id="emptyCartContainer">
        <div class="row justify-content-center">
            <div class="col-md-8 text-center">
                <div class="empty-cart-container p-5">
                    <i class="fas fa-shopping-cart fa-4x text-muted mb-4"></i>
                    <h3>Your cart is empty</h3>
                    <p class="text-muted mb-4">Looks like you haven't added any items to your cart yet.</p>
                    <a href="<c:url value='/products'/>" class="btn btn-primary btn-lg">
                        <i class="fas fa-store me-2"></i>Continue Shopping
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Cart Items -->
    <div class="container" id="cartItemsContainer">
        <div class="row">
            <!-- Cart Items List -->
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Cart Items (<span id="cartItemCount">0</span>)</h5>
                    </div>
                    <div class="card-body">
                        <div id="cartItemsList">
                            <!-- Cart items will be loaded here -->
                        </div>
                    </div>
                </div>

                <!-- Cart Actions -->
                <div class="d-flex justify-content-between mt-3">
                    <a href="<c:url value='/products'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Continue Shopping
                    </a>
                    <button class="btn btn-outline-danger" onclick="clearCart()">
                        <i class="fas fa-trash me-2"></i>Clear Cart
                    </button>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-lg-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Order Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal (<span id="summaryItemCount">0</span> items):</span>
                            <span id="summarySubtotal">₹0.00</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <span id="summaryShipping">₹0.00</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Tax:</span>
                            <span id="summaryTax">₹0.00</span>
                        </div>

                        <hr>
                        <div class="d-flex justify-content-between mb-3">
                            <strong>Total:</strong>
                            <strong class="text-primary" id="summaryTotal">₹0.00</strong>
                        </div>

                        <!-- Promo Code -->
                        <div class="mb-3">
                            <label for="promoCode" class="form-label">Promo Code</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="promoCode" placeholder="Enter promo code">
                                <button class="btn btn-outline-primary" onclick="applyPromoCode()">Apply</button>
                            </div>
                        </div>

                        <!-- Checkout Buttons -->
                        <div class="d-grid gap-2">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="<c:url value='/checkout'/>" class="btn btn-success btn-lg">
                                        <i class="fas fa-credit-card me-2"></i>Proceed to Checkout
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-success btn-lg" onclick="showLoginPrompt()">
                                        <i class="fas fa-credit-card me-2"></i>Proceed to Checkout
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <button class="btn btn-outline-primary" onclick="saveForLater()">
                                <i class="fas fa-bookmark me-2"></i>Save for Later
                            </button>
                        </div>

                        <!-- Security Badges -->
                        <div class="mt-4 pt-3 border-top">
                            <div class="text-center small text-muted">
                                <i class="fas fa-shield-alt text-success me-1"></i>
                                Secure Checkout
                            </div>
                            <div class="text-center small text-muted mt-1">
                                <i class="fas fa-lock text-success me-1"></i>
                                SSL Encrypted
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Cart Features -->
                <div class="card shadow-sm mt-3">
                    <div class="card-body">
                        <h6 class="card-title">Why Shop With Us?</h6>
                        <div class="row text-center">
                            <div class="col-4">
                                <i class="fas fa-truck fa-2x text-primary mb-2"></i>
                                <small class="d-block">Free Shipping</small>
                                <small class="text-muted">On orders over ₹500</small>
                            </div>
                            <div class="col-4">
                                <i class="fas fa-undo fa-2x text-primary mb-2"></i>
                                <small class="d-block">Easy Returns</small>
                                <small class="text-muted">30-day returns</small>
                            </div>
                            <div class="col-4">
                                <i class="fas fa-headset fa-2x text-primary mb-2"></i>
                                <small class="d-block">24/7 Support</small>
                                <small class="text-muted">Customer service</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Login Prompt Modal -->
<div class="modal fade" id="loginModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Login Required</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>You need to be logged in to proceed to checkout. Would you like to login or continue shopping?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Continue Shopping</button>
                <a href="<c:url value='/auth/login?redirect=/checkout'/>" class="btn btn-primary">Login</a>
            </div>
        </div>
    </div>
</div>

<!-- Promo Code Applied Modal -->
<div class="modal fade" id="promoModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Promo Code Applied!</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="promoMessage">Your promo code has been successfully applied!</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<script>
let currentCart = {};
let appliedPromoCode = null;

$(document).ready(function() {
    loadCart();

    // Auto-refresh cart every 30 seconds
    setInterval(function() {
        if (!$('#loadingSpinner').hasClass('d-none')) {
            loadCart();
        }
    }, 30000);
});

function loadCart() {
    $('#loadingSpinner').removeClass('d-none');
    $('#cartContent').addClass('d-none');

    // Get user ID from session or use guest ID
    const userId = getCurrentUserId();

    $.ajax({
        url: '/api/cart',
        type: 'GET',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                currentCart = response.data;
                renderCart(currentCart);
                updateCartBadge();
            } else {
                showEmptyCart();
            }
        },
        error: function() {
            showError('Error loading cart');
        },
        complete: function() {
            $('#loadingSpinner').addClass('d-none');
        }
    });
}

function renderCart(cart) {
    if (!cart || !cart.items || cart.items.length === 0) {
        showEmptyCart();
        return;
    }

    $('#cartContent').removeClass('d-none');
    $('#emptyCartContainer').addClass('d-none');
    $('#cartItemsContainer').removeClass('d-none');

    // Update cart count
    $('#cartItemCount').text(cart.totalItems || 0);

    // Render cart items
    let itemsHtml = '';
    cart.items.forEach(function(item) {
        itemsHtml += renderCartItem(item);
    });
    $('#cartItemsList').html(itemsHtml);

    // Update summary
    updateOrderSummary(cart);
}

function renderCartItem(item) {
    const discountedPrice = item.productDiscountedPrice || item.unitPrice;
    const originalPrice = item.unitPrice;
    const hasDiscount = item.productDiscountPercentage > 0;

    return `
        <div class="cart-item border-bottom py-3" data-product-id="${item.productId}">
            <div class="row align-items-center">
                <div class="col-md-2">
                    <img src="${item.productImageUrl || '/static/images/products/no-image.png'}"
                         alt="${item.productName}" class="img-fluid rounded" style="height: 80px; object-fit: cover;">
                </div>
                <div class="col-md-4">
                    <h6 class="mb-1">${item.productName}</h6>
                    <p class="text-muted small mb-1">SKU: ${item.productSku}</p>
                    ${hasDiscount ? `<small class="text-success">Save ₹${((originalPrice - discountedPrice) * item.quantity).toFixed(2)}</small>` : ''}
                </div>
                <div class="col-md-2">
                    <div class="quantity-controls">
                        <div class="input-group input-group-sm">
                            <button class="btn btn-outline-secondary" type="button" onclick="updateQuantity(${item.productId}, ${item.quantity - 1})">
                                <i class="fas fa-minus"></i>
                            </button>
                            <input type="number" class="form-control text-center" value="${item.quantity}"
                                   min="1" max="99" onchange="updateQuantity(${item.productId}, this.value)" style="width: 60px;">
                            <button class="btn btn-outline-secondary" type="button" onclick="updateQuantity(${item.productId}, ${item.quantity + 1})">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-md-2 text-center">
                    <div class="fw-bold">₹${discountedPrice.toFixed(2)}</div>
                    ${hasDiscount ? `<small class="text-muted text-decoration-line-through">₹${originalPrice.toFixed(2)}</small>` : ''}
                </div>
                <div class="col-md-2 text-center">
                    <div class="fw-bold text-primary">₹${item.subtotal.toFixed(2)}</div>
                    <button class="btn btn-sm btn-outline-danger mt-1" onclick="removeItem(${item.productId})">
                        <i class="fas fa-trash"></i> Remove
                    </button>
                </div>
            </div>
        </div>
    `;
}

function updateOrderSummary(cart) {
    const subtotal = cart.totalAmount || 0;
    const shipping = subtotal > 500 ? 0 : 50; // Free shipping over ₹500
    const tax = subtotal * 0.18; // 18% GST
    const total = subtotal + shipping + tax;

    $('#summaryItemCount').text(cart.totalItems || 0);
    $('#summarySubtotal').text(`₹${subtotal.toFixed(2)}`);
    $('#summaryShipping').text(shipping === 0 ? 'FREE' : `₹${shipping.toFixed(2)}`);
    $('#summaryTax').text(`₹${tax.toFixed(2)}`);
    $('#summaryTotal').text(`₹${total.toFixed(2)}`);

    // Update shipping text color
    $('#summaryShipping').removeClass('text-success text-muted');
    if (shipping === 0) {
        $('#summaryShipping').addClass('text-success').text('FREE');
    } else {
        $('#summaryShipping').addClass('text-muted').text(`₹${shipping.toFixed(2)}`);
    }
}

function showEmptyCart() {
    $('#cartContent').removeClass('d-none');
    $('#cartItemsContainer').addClass('d-none');
    $('#emptyCartContainer').removeClass('d-none');
    updateCartBadge();
}

function updateQuantity(productId, newQuantity) {
    if (newQuantity < 1) {
        removeItem(productId);
        return;
    }

    const userId = getCurrentUserId();

    $.ajax({
        url: `/api/cart/items/${productId}`,
        type: 'PUT',
        data: {
            userId: userId,
            quantity: newQuantity
        },
        success: function(response) {
            if (response.success) {
                loadCart(); // Reload cart to get updated data
                showSuccess('Quantity updated');
            } else {
                showError('Failed to update quantity');
            }
        },
        error: function() {
            showError('Error updating quantity');
        }
    });
}

function removeItem(productId) {
    if (!confirm('Are you sure you want to remove this item from your cart?')) {
        return;
    }

    const userId = getCurrentUserId();

    $.ajax({
        url: `/api/cart/items/${productId}`,
        type: 'DELETE',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                loadCart(); // Reload cart to get updated data
                showSuccess('Item removed from cart');
            } else {
                showError('Failed to remove item');
            }
        },
        error: function() {
            showError('Error removing item');
        }
    });
}

function clearCart() {
    if (!confirm('Are you sure you want to clear your entire cart?')) {
        return;
    }

    const userId = getCurrentUserId();

    $.ajax({
        url: '/api/cart',
        type: 'DELETE',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                loadCart(); // Reload cart to show empty state
                showSuccess('Cart cleared');
            } else {
                showError('Failed to clear cart');
            }
        },
        error: function() {
            showError('Error clearing cart');
        }
    });
}

function applyPromoCode() {
    const promoCode = $('#promoCode').val().trim();

    if (!promoCode) {
        showError('Please enter a promo code');
        return;
    }

    // This would typically call an API to validate the promo code
    // For now, we'll simulate a successful application
    appliedPromoCode = promoCode;
    $('#promoMessage').text(`Promo code "${promoCode}" applied successfully! You saved 10% on your order.`);
    $('#promoModal').modal('show');

    // Update summary with discount
    const currentTotal = parseFloat($('#summaryTotal').text().replace('₹', ''));
    const discountedTotal = currentTotal * 0.9; // 10% discount
    $('#summaryTotal').text(`₹${discountedTotal.toFixed(2)}`);

    $('#promoCode').val('');
}

function saveForLater() {
    showInfo('Items saved for later! You can find them in your wishlist.');
}

function showLoginPrompt() {
    $('#loginModal').modal('show');
}

function getCurrentUserId() {
    // Check if user is logged in
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            return ${sessionScope.user.id};
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
    const itemCount = currentCart.totalItems || 0;
    $('#cartBadge').text(itemCount);

    // Update header cart badge if it exists
    if ($('.cart-badge').length) {
        $('.cart-badge').text(itemCount);
    }
}

function showSuccess(message) {
    showAlert(message, 'success');
}

function showError(message) {
    showAlert(message, 'danger');
}

function showInfo(message) {
    showAlert(message, 'info');
}

function showAlert(message, type) {
    const alertHtml = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;

    // Remove existing alerts
    $('.alert').remove();

    // Add new alert at the top of the page
    $('.container:first').prepend(alertHtml);

    // Auto-hide after 5 seconds
    setTimeout(() => $('.alert').fadeOut(), 5000);
}
</script>

<style>
.empty-cart-container {
    background: #f8f9fa;
    border-radius: 10px;
    border: 2px dashed #dee2e6;
}

.cart-item {
    transition: all 0.3s ease;
}

.cart-item:hover {
    background-color: #f8f9fa;
}

.quantity-controls .btn {
    min-width: 35px;
}

.quantity-controls input {
    border-left: none;
    border-right: none;
}

.quantity-controls .btn:first-child {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
}

.quantity-controls .btn:last-child {
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
}

.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.btn-outline-danger:hover {
    background-color: #dc3545;
    border-color: #dc3545;
}

@media (max-width: 768px) {
    .cart-item {
        padding: 1rem 0;
    }

    .quantity-controls {
        margin-top: 1rem;
    }

    .empty-cart-container {
        padding: 3rem 1rem !important;
    }
}
</style>
