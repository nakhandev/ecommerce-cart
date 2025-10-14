<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Order Confirmation" scope="request"/>

<!-- Confirmation Container -->
<div class="container py-5">
    <!-- Loading Spinner -->
    <div class="text-center d-none" id="loadingSpinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <div class="mt-2">Loading order details...</div>
    </div>

    <!-- Confirmation Content -->
    <div id="confirmationContent" class="d-none">
        <!-- Success Header -->
        <div class="text-center mb-5">
            <div class="success-icon mb-4">
                <i class="fas fa-check-circle fa-5x text-success"></i>
            </div>
            <h1 class="display-4 text-success mb-3">Order Confirmed!</h1>
            <p class="lead text-muted">Thank you for your order. Your payment has been processed successfully.</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <!-- Order Details Card -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-receipt me-2"></i>Order Details
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="fw-bold">Order Information</h6>
                                <table class="table table-sm">
                                    <tr>
                                        <td><strong>Order Number:</strong></td>
                                        <td id="orderNumber">Loading...</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Order Date:</strong></td>
                                        <td id="orderDate">Loading...</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Order Status:</strong></td>
                                        <td><span class="badge bg-success" id="orderStatus">Confirmed</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Payment Method:</strong></td>
                                        <td id="paymentMethod">Loading...</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold">Delivery Address</h6>
                                <div id="deliveryAddressDisplay" class="text-muted">
                                    Loading...
                                </div>
                            </div>
                        </div>

                        <!-- Order Items -->
                        <h6 class="fw-bold mb-3">Order Items</h6>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                        <th>Unit Price</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody id="orderItemsList">
                                    <!-- Items will be loaded here -->
                                </tbody>
                            </table>
                        </div>

                        <!-- Order Summary -->
                        <div class="row justify-content-end">
                            <div class="col-lg-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h6 class="fw-bold mb-3">Order Summary</h6>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Subtotal:</span>
                                            <span id="summarySubtotal">₹0.00</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Shipping:</span>
                                            <span id="summaryShipping">₹0.00</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Tax (GST):</span>
                                            <span id="summaryTax">₹0.00</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Discount:</span>
                                            <span class="text-success" id="summaryDiscount">-₹0.00</span>
                                        </div>
                                        <hr>
                                        <div class="d-flex justify-content-between mb-0">
                                            <strong>Total:</strong>
                                            <strong class="text-success" id="summaryTotal">₹0.00</strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- What's Next Card -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-clock me-2"></i>What's Next?
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 text-center mb-3">
                                <div class="step-icon mb-3">
                                    <i class="fas fa-cog fa-3x text-primary"></i>
                                </div>
                                <h6>Order Processing</h6>
                                <p class="small text-muted">We'll prepare your items for shipment</p>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <div class="step-icon mb-3">
                                    <i class="fas fa-shipping-fast fa-3x text-warning"></i>
                                </div>
                                <h6>Shipping</h6>
                                <p class="small text-muted">Your order will be shipped within 1-2 business days</p>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <div class="step-icon mb-3">
                                    <i class="fas fa-box-open fa-3x text-success"></i>
                                </div>
                                <h6>Delivery</h6>
                                <p class="small text-muted">You'll receive your order at your doorstep</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Email Confirmation -->
                <div class="alert alert-info">
                    <i class="fas fa-envelope me-2"></i>
                    <strong>Email Confirmation Sent!</strong>
                    <br>
                    A confirmation email has been sent to your registered email address with all order details and tracking information.
                </div>

                <!-- Action Buttons -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <a href="<c:url value='/orders'/>" class="btn btn-primary btn-lg w-100">
                            <i class="fas fa-list me-2"></i>View Order History
                        </a>
                    </div>
                    <div class="col-md-6 mb-3">
                        <a href="<c:url value='/'/>" class="btn btn-outline-secondary btn-lg w-100">
                            <i class="fas fa-store me-2"></i>Continue Shopping
                        </a>
                    </div>
                </div>

                <!-- Order Notes -->
                <div id="orderNotesSection" class="mt-4" style="display: none;">
                    <div class="card border-warning">
                        <div class="card-body">
                            <h6 class="text-warning">
                                <i class="fas fa-sticky-note me-2"></i>Order Notes
                            </h6>
                            <p class="mb-0" id="orderNotesDisplay">Loading...</p>
                        </div>
                    </div>
                </div>

                <!-- Help Section -->
                <div class="card shadow-sm mt-4">
                    <div class="card-body text-center">
                        <h6 class="mb-3">Need Help?</h6>
                        <p class="text-muted mb-3">If you have any questions about your order, we're here to help!</p>
                        <div class="d-flex justify-content-center gap-3">
                            <a href="mailto:support@eshop.com" class="btn btn-outline-primary">
                                <i class="fas fa-envelope me-2"></i>Email Support
                            </a>
                            <a href="tel:+91-9876543210" class="btn btn-outline-success">
                                <i class="fas fa-phone me-2"></i>Call Support
                            </a>
                        </div>
                        <div class="mt-3">
                            <small class="text-muted">Support Hours: 9:00 AM - 9:00 PM (Mon-Sat)</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Error State -->
    <div id="errorContent" class="d-none text-center py-5">
        <i class="fas fa-exclamation-triangle fa-5x text-warning mb-4"></i>
        <h2 class="text-warning">Order Not Found</h2>
        <p class="text-muted mb-4">We couldn't find the order you're looking for.</p>
        <a href="<c:url value='/'/>" class="btn btn-primary">Go to Homepage</a>
    </div>
</div>

<script>
let orderData = {};

$(document).ready(function() {
    loadOrderConfirmation();
});

function loadOrderConfirmation() {
    $('#loadingSpinner').removeClass('d-none');

    // Get order ID from URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const orderId = urlParams.get('orderId');

    if (!orderId) {
        showErrorContent('No order ID provided');
        return;
    }

    // Load order details
    $.ajax({
        url: '/api/orders/' + orderId,
        type: 'GET',
        success: function(response) {
            if (response.success) {
                orderData = response.data;
                renderOrderConfirmation(orderData);
                $('#loadingSpinner').addClass('d-none');
                $('#confirmationContent').removeClass('d-none');
            } else {
                showErrorContent('Order not found');
            }
        },
        error: function() {
            showErrorContent('Error loading order details');
        }
    });
}

function renderOrderConfirmation(order) {
    // Order Information
    $('#orderNumber').text(order.orderNumber || 'N/A');
    $('#orderDate').text(formatDate(order.orderDate));
    $('#orderStatus').text(order.status || 'Confirmed');
    $('#paymentMethod').text(formatPaymentMethod(order.paymentMethod));

    // Delivery Address
    $('#deliveryAddressDisplay').html(formatAddress(order.shippingAddress));

    // Order Items
    if (order.items && order.items.length > 0) {
        let itemsHtml = '';
        order.items.forEach(function(item) {
            itemsHtml += `
                <tr>
                    <td>
                        <div class="fw-bold">${item.productName}</div>
                        <small class="text-muted">SKU: ${item.productSku}</small>
                    </td>
                    <td>${item.quantity}</td>
                    <td>₹${item.unitPrice.toFixed(2)}</td>
                    <td class="fw-bold">₹${item.subtotal.toFixed(2)}</td>
                </tr>
            `;
        });
        $('#orderItemsList').html(itemsHtml);
    }

    // Order Summary
    const subtotal = order.totalAmount || 0;
    const shipping = order.shippingAmount || 0;
    const tax = order.taxAmount || 0;
    const discount = order.discountAmount || 0;
    const total = order.totalAmount || 0;

    $('#summarySubtotal').text(`₹${subtotal.toFixed(2)}`);
    $('#summaryShipping').text(shipping === 0 ? 'FREE' : `₹${shipping.toFixed(2)}`);
    $('#summaryTax').text(`₹${tax.toFixed(2)}`);
    $('#summaryDiscount').text(`-₹${discount.toFixed(2)}`);
    $('#summaryTotal').text(`₹${total.toFixed(2)}`);

    // Order Notes
    if (order.orderNotes) {
        $('#orderNotesDisplay').text(order.orderNotes);
        $('#orderNotesSection').show();
    }

    // Update page title
    document.title = `Order ${order.orderNumber} - E-Shop`;
}

function formatDate(dateString) {
    if (!dateString) return 'N/A';

    const date = new Date(dateString);
    return date.toLocaleDateString('en-IN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

function formatPaymentMethod(method) {
    const methodNames = {
        'CARD': 'Credit/Debit Card',
        'UPI': 'UPI Payment',
        'NET_BANKING': 'Net Banking',
        'COD': 'Cash on Delivery',
        'WALLET': 'Digital Wallet'
    };

    return methodNames[method] || method || 'N/A';
}

function formatAddress(addressString) {
    if (!addressString) return 'N/A';

    // Split address by comma and format
    const parts = addressString.split(',').map(part => part.trim());
    if (parts.length <= 1) return addressString;

    return parts.join('<br>');
}

function showErrorContent(message) {
    $('#loadingSpinner').addClass('d-none');
    $('#confirmationContent').addClass('d-none');
    $('#errorContent').removeClass('d-none');

    // Update error message if provided
    if (message) {
        $('#errorContent .text-muted').first().text(message);
    }
}

// Print order functionality
function printOrder() {
    window.print();
}

// Share order functionality (if supported)
function shareOrder() {
    if (navigator.share && orderData.orderNumber) {
        navigator.share({
            title: `Order ${orderData.orderNumber}`,
            text: `Check out my order ${orderData.orderNumber} from E-Shop`,
            url: window.location.href
        });
    } else {
        // Fallback - copy to clipboard
        navigator.clipboard.writeText(window.location.href).then(function() {
            showSuccess('Order link copied to clipboard!');
        });
    }
}

// Add print and share buttons if supported
$(document).ready(function() {
    // Add print button
    const printButton = `
        <button class="btn btn-outline-secondary me-2" onclick="printOrder()">
            <i class="fas fa-print me-2"></i>Print Order
        </button>
    `;

    // Add share button if supported
    if (navigator.share || navigator.clipboard) {
        const shareButton = `
            <button class="btn btn-outline-primary" onclick="shareOrder()">
                <i class="fas fa-share me-2"></i>Share Order
            </button>
        `;
        $('.btn-group').append(shareButton);
    }

    $('.card-body').first().append(printButton);
});
</script>

<style>
.success-icon {
    animation: checkmark 0.8s ease-in-out;
}

@keyframes checkmark {
    0% {
        transform: scale(0);
        opacity: 0;
    }
    50% {
        transform: scale(1.2);
        opacity: 0.8;
    }
    100% {
        transform: scale(1);
        opacity: 1;
    }
}

.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.step-icon {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
    color: white;
}

.table th {
    border-top: none;
    font-weight: 600;
    color: #495057;
}

.badge {
    font-size: 0.85em;
}

.alert {
    border: none;
    border-radius: 10px;
}

.btn-outline-primary:hover,
.btn-outline-secondary:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

@media print {
    .btn, .breadcrumb, .alert {
        display: none !important;
    }

    .card {
        box-shadow: none !important;
        border: 1px solid #ddd !important;
    }

    .container {
        max-width: none !important;
    }
}

@media (max-width: 768px) {
    .display-4 {
        font-size: 2.5rem;
    }

    .step-icon {
        width: 60px;
        height: 60px;
    }

    .step-icon i {
        font-size: 1.5rem;
    }
}
</style>
