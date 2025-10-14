<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="My Orders" scope="request"/>

<!-- Orders Container -->
<div class="container py-4">
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">
                <i class="fas fa-boxes text-primary me-2"></i>My Orders
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<c:url value='/'/>">Home</a></li>
                    <li class="breadcrumb-item active">My Orders</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div class="text-center d-none" id="loadingSpinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <div class="mt-2">Loading your orders...</div>
    </div>

    <!-- Orders Content -->
    <div id="ordersContent" class="d-none">
        <!-- Filter Tabs -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <ul class="nav nav-pills nav-fill" id="orderStatusTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="all-tab" data-bs-toggle="pill" data-bs-target="#all-orders" type="button" role="tab">
                            <i class="fas fa-list me-2"></i>All Orders
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pending-tab" data-bs-toggle="pill" data-bs-target="#pending-orders" type="button" role="tab">
                            <i class="fas fa-clock me-2"></i>Pending
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="processing-tab" data-bs-toggle="pill" data-bs-target="#processing-orders" type="button" role="tab">
                            <i class="fas fa-cog me-2"></i>Processing
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="shipped-tab" data-bs-toggle="pill" data-bs-target="#shipped-orders" type="button" role="tab">
                            <i class="fas fa-shipping-fast me-2"></i>Shipped
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="delivered-tab" data-bs-toggle="pill" data-bs-target="#delivered-orders" type="button" role="tab">
                            <i class="fas fa-check-circle me-2"></i>Delivered
                        </button>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Orders List -->
        <div class="tab-content" id="ordersTabContent">
            <!-- All Orders Tab -->
            <div class="tab-pane fade show active" id="all-orders" role="tabpanel">
                <div id="allOrdersList">
                    <!-- Orders will be loaded here -->
                </div>
            </div>

            <!-- Pending Orders Tab -->
            <div class="tab-pane fade" id="pending-orders" role="tabpanel">
                <div id="pendingOrdersList">
                    <!-- Pending orders will be loaded here -->
                </div>
            </div>

            <!-- Processing Orders Tab -->
            <div class="tab-pane fade" id="processing-orders" role="tabpanel">
                <div id="processingOrdersList">
                    <!-- Processing orders will be loaded here -->
                </div>
            </div>

            <!-- Shipped Orders Tab -->
            <div class="tab-pane fade" id="shipped-orders" role="tabpanel">
                <div id="shippedOrdersList">
                    <!-- Shipped orders will be loaded here -->
                </div>
            </div>

            <!-- Delivered Orders Tab -->
            <div class="tab-pane fade" id="delivered-orders" role="tabpanel">
                <div id="deliveredOrdersList">
                    <!-- Delivered orders will be loaded here -->
                </div>
            </div>
        </div>

        <!-- Empty State -->
        <div id="emptyOrdersState" class="d-none text-center py-5">
            <i class="fas fa-box-open fa-4x text-muted mb-4"></i>
            <h3 class="text-muted">No Orders Found</h3>
            <p class="text-muted mb-4">You haven't placed any orders yet. Start shopping to see your orders here!</p>
            <a href="<c:url value='/products'/>" class="btn btn-primary btn-lg">
                <i class="fas fa-store me-2"></i>Start Shopping
            </a>
        </div>

        <!-- Load More Button -->
        <div id="loadMoreSection" class="text-center d-none">
            <button class="btn btn-outline-primary" onclick="loadMoreOrders()">
                <i class="fas fa-plus me-2"></i>Load More Orders
            </button>
        </div>
    </div>
</div>

<!-- Order Details Modal -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Order Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="orderDetailsContent">
                <!-- Order details will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="printOrder()">
                    <i class="fas fa-print me-2"></i>Print Order
                </button>
            </div>
        </div>
    </div>
</div>

<c:choose>
<c:when test="${not empty sessionScope.user}">
<script>
$(document).ready(function() {
    loadOrders();

    // Tab change handler
    $('button[data-bs-toggle="pill"]').on('shown.bs.tab', function (e) {
        const target = $(e.target).attr('data-bs-target');
        switch (target) {
            case '#all-orders':
                currentStatusFilter = 'ALL';
                break;
            case '#pending-orders':
                currentStatusFilter = 'PENDING';
                break;
            case '#processing-orders':
                currentStatusFilter = 'PROCESSING';
                break;
            case '#shipped-orders':
                currentStatusFilter = 'SHIPPED';
                break;
            case '#delivered-orders':
                currentStatusFilter = 'DELIVERED';
                break;
        }
        currentPage = 0;
        loadOrders();
    });

    // Auto-refresh orders every 60 seconds
    setInterval(function() {
        if (!$('#loadingSpinner').hasClass('d-none')) {
            loadOrders(false); // Silent refresh
        }
    }, 60000);
});

function loadOrders(showLoading = true) {
    if (showLoading) {
        $('#loadingSpinner').removeClass('d-none');
        $('#ordersContent').addClass('d-none');
    }

    const userId = <c:out value="${sessionScope.user.id}"/>;

    $.ajax({
        url: '/api/orders',
        type: 'GET',
        data: {
            userId: userId,
            page: currentPage,
            size: 10
        },
        success: function(response) {
            if (response.success) {
                if (currentPage === 0) {
                    currentOrders = response.data;
                } else {
                    currentOrders = currentOrders.concat(response.data);
                }

                renderOrders(currentOrders);

                // Check if there are more orders
                hasMoreOrders = response.data && response.data.length === 10;

                if (hasMoreOrders) {
                    $('#loadMoreSection').removeClass('d-none');
                } else {
                    $('#loadMoreSection').addClass('d-none');
                }
            } else {
                showEmptyState();
            }
        },
        error: function() {
            showError('Error loading orders');
        },
        complete: function() {
            if (showLoading) {
                $('#loadingSpinner').addClass('d-none');
                $('#ordersContent').removeClass('d-none');
            }
        }
    });
}
</script>
</c:when>
<c:otherwise>
<script>
$(document).ready(function() {
    loadOrders();

    // Tab change handler
    $('button[data-bs-toggle="pill"]').on('shown.bs.tab', function (e) {
        const target = $(e.target).attr('data-bs-target');
        switch (target) {
            case '#all-orders':
                currentStatusFilter = 'ALL';
                break;
            case '#pending-orders':
                currentStatusFilter = 'PENDING';
                break;
            case '#processing-orders':
                currentStatusFilter = 'PROCESSING';
                break;
            case '#shipped-orders':
                currentStatusFilter = 'SHIPPED';
                break;
            case '#delivered-orders':
                currentStatusFilter = 'DELIVERED';
                break;
        }
        currentPage = 0;
        loadOrders();
    });

    // Auto-refresh orders every 60 seconds
    setInterval(function() {
        if (!$('#loadingSpinner').hasClass('d-none')) {
            loadOrders(false); // Silent refresh
        }
    }, 60000);
});

function loadOrders(showLoading = true) {
    if (showLoading) {
        $('#loadingSpinner').removeClass('d-none');
        $('#ordersContent').addClass('d-none');
    }

    // Redirect to login if not logged in
    window.location.href = '/auth/login?redirect=/orders';
}
</script>
</c:otherwise>
</c:choose>

function renderOrders(orders) {
    if (!orders || orders.length === 0) {
        showEmptyState();
        return;
    }

    // Filter orders based on current status filter
    let filteredOrders = orders;
    if (currentStatusFilter !== 'ALL') {
        filteredOrders = orders.filter(order => order.status === currentStatusFilter);
    }

    if (filteredOrders.length === 0) {
        showEmptyState();
        return;
    }

    // Group orders by status for tab display
    const ordersByStatus = {
        'ALL': filteredOrders,
        'PENDING': filteredOrders.filter(order => order.status === 'PENDING'),
        'PROCESSING': filteredOrders.filter(order => order.status === 'PROCESSING'),
        'SHIPPED': filteredOrders.filter(order => order.status === 'SHIPPED'),
        'DELIVERED': filteredOrders.filter(order => order.status === 'DELIVERED')
    };

    // Render orders for each tab
    Object.keys(ordersByStatus).forEach(status => {
        const containerId = status.toLowerCase() + 'OrdersList';
        const statusOrders = ordersByStatus[status];

        let ordersHtml = '';
        statusOrders.forEach(function(order) {
            ordersHtml += renderOrderCard(order);
        });

        $('#' + containerId).html(ordersHtml);
    });

    $('#ordersContent').removeClass('d-none');
    $('#emptyOrdersState').addClass('d-none');
}

function renderOrderCard(order) {
    const statusBadge = getStatusBadge(order.status);
    const paymentMethod = formatPaymentMethod(order.paymentMethod);

    let cancelButton = '';
    if (canCancelOrder(order)) {
        cancelButton = '<button class="btn btn-sm btn-outline-danger" onclick="cancelOrder(' + order.id + ')">' +
                      '<i class="fas fa-times me-1"></i>Cancel</button>';
    }

    let reorderButton = '';
    if (order.status === 'DELIVERED') {
        reorderButton = '<button class="btn btn-sm btn-outline-success" onclick="reorderItems(' + order.id + ')">' +
                       '<i class="fas fa-redo me-1"></i>Reorder</button>';
    }

    return '<div class="card shadow-sm mb-3 order-card" data-order-id="' + order.id + '">' +
           '<div class="card-body">' +
               '<div class="row align-items-center">' +
                   '<div class="col-md-2">' +
                       '<div class="order-number fw-bold">' + order.orderNumber + '</div>' +
                       '<div class="order-date small text-muted">' + formatDate(order.orderDate) + '</div>' +
                   '</div>' +
                   '<div class="col-md-3">' +
                       '<div class="order-status">' + statusBadge + '</div>' +
                       '<div class="payment-method small text-muted mt-1">' +
                           '<i class="fas fa-credit-card me-1"></i>' + paymentMethod +
                       '</div>' +
                   '</div>' +
                   '<div class="col-md-3">' +
                       '<div class="item-count small">' +
                           '<i class="fas fa-box me-1"></i>' + order.totalItems + ' item' + (order.totalItems !== 1 ? 's' : '') +
                       '</div>' +
                       '<div class="order-total fw-bold">' + order.displayTotalAmount + '</div>' +
                   '</div>' +
                   '<div class="col-md-4">' +
                       '<div class="order-actions d-flex gap-2 flex-wrap">' +
                           '<button class="btn btn-sm btn-outline-primary" onclick="viewOrderDetails(' + order.id + ')">' +
                               '<i class="fas fa-eye me-1"></i>View Details' +
                           '</button>' +
                           cancelButton +
                           reorderButton +
                       '</div>' +
                   '</div>' +
               '</div>' +
               '<!-- Expandable Order Items Preview -->' +
               '<div class="order-preview mt-3" style="display: none;">' +
                   '<hr>' +
                   '<div class="row">' +
                       '<div class="col-md-8">' +
                           '<div class="order-items-preview">' +
                               renderOrderItemsPreview(order.items) +
                           '</div>' +
                       '</div>' +
                       '<div class="col-md-4 text-end">' +
                           '<button class="btn btn-sm btn-primary" onclick="viewOrderDetails(' + order.id + ')">' +
                               'View Full Details <i class="fas fa-arrow-right ms-1"></i>' +
                           '</button>' +
                       '</div>' +
                   '</div>' +
               '</div>' +
           '</div>' +
       '</div>';
}

function renderOrderItemsPreview(items) {
    if (!items || items.length === 0) return '<p class="text-muted">No items found</p>';

    let itemsHtml = '';
    items.slice(0, 2).forEach(function(item) { // Show only first 2 items
        itemsHtml += `
            <div class="d-flex align-items-center mb-2">
                <img src="${item.productImageUrl || '/static/images/products/no-image.png'}"
                     alt="${item.productName}" class="rounded me-2" style="width: 40px; height: 40px; object-fit: cover;">
                <div class="flex-grow-1">
                    <div class="fw-bold small">${item.productName}</div>
                    <div class="text-muted small">Qty: ${item.quantity} × ₹${item.unitPrice.toFixed(2)}</div>
                </div>
                <div class="text-end">
                    <div class="fw-bold small">₹${item.subtotal.toFixed(2)}</div>
                </div>
            </div>
        `;
    });

    if (items.length > 2) {
        itemsHtml += `<div class="text-muted small">... and ${items.length - 2} more item${items.length - 2 !== 1 ? 's' : ''}</div>`;
    }

    return itemsHtml;
}

function getStatusBadge(status) {
    const statusConfig = {
        'PENDING': '<span class="badge bg-warning">Pending</span>',
        'CONFIRMED': '<span class="badge bg-info">Confirmed</span>',
        'PROCESSING': '<span class="badge bg-primary">Processing</span>',
        'SHIPPED': '<span class="badge bg-success">Shipped</span>',
        'DELIVERED': '<span class="badge bg-success">Delivered</span>',
        'CANCELLED': '<span class="badge bg-danger">Cancelled</span>',
        'REFUNDED': '<span class="badge bg-secondary">Refunded</span>'
    };

    return statusConfig[status] || `<span class="badge bg-secondary">${status}</span>`;
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

function formatDate(dateString) {
    if (!dateString) return 'N/A';

    const date = new Date(dateString);
    return date.toLocaleDateString('en-IN', {
        day: 'numeric',
        month: 'short',
        year: 'numeric'
    });
}

function viewOrderDetails(orderId) {
    // Load order details via AJAX
    $.ajax({
        url: '/api/orders/' + orderId,
        type: 'GET',
        success: function(response) {
            if (response.success) {
                showOrderDetailsModal(response.data);
            } else {
                showError('Failed to load order details');
            }
        },
        error: function() {
            showError('Error loading order details');
        }
    });
}

function showOrderDetailsModal(order) {
    const statusBadge = getStatusBadge(order.status);
    const paymentMethod = formatPaymentMethod(order.paymentMethod);

    const modalContent = `
        <div class="row mb-4">
            <div class="col-md-6">
                <h6 class="fw-bold">Order Information</h6>
                <table class="table table-sm">
                    <tr>
                        <td><strong>Order Number:</strong></td>
                        <td>${order.orderNumber}</td>
                    </tr>
                    <tr>
                        <td><strong>Order Date:</strong></td>
                        <td>${formatDate(order.orderDate)}</td>
                    </tr>
                    <tr>
                        <td><strong>Status:</strong></td>
                        <td>${statusBadge}</td>
                    </tr>
                    <tr>
                        <td><strong>Payment Method:</strong></td>
                        <td>${paymentMethod}</td>
                    </tr>
                </table>
            </div>
            <div class="col-md-6">
                <h6 class="fw-bold">Shipping Address</h6>
                <div class="text-muted">
                    ${formatAddress(order.shippingAddress)}
                </div>
            </div>
        </div>

        <h6 class="fw-bold mb-3">Order Items</h6>
        <div class="table-responsive mb-4">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    ${renderOrderItemsTable(order.items)}
                </tbody>
            </table>
        </div>

        <div class="row">
            <div class="col-md-6">
                ${order.orderNotes ? `
                    <h6 class="fw-bold">Order Notes</h6>
                    <p class="text-muted">${order.orderNotes}</p>
                ` : ''}
            </div>
            <div class="col-md-6">
                <div class="order-summary-card bg-light p-3 rounded">
                    <h6 class="fw-bold mb-3">Order Summary</h6>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal:</span>
                        <span>₹${(order.totalAmount || 0).toFixed(2)}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Shipping:</span>
                        <span>${(order.shippingAmount || 0) === 0 ? 'FREE' : '₹' + (order.shippingAmount || 0).toFixed(2)}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Tax:</span>
                        <span>₹${(order.taxAmount || 0).toFixed(2)}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Discount:</span>
                        <span class="text-success">-₹${(order.discountAmount || 0).toFixed(2)}</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-0">
                        <strong>Total:</strong>
                        <strong class="text-primary">₹${(order.totalAmount || 0).toFixed(2)}</strong>
                    </div>
                </div>
            </div>
        </div>
    `;

    $('#orderDetailsContent').html(modalContent);
    $('#orderDetailsModal').modal('show');
}

function renderOrderItemsTable(items) {
    if (!items || items.length === 0) return '<tr><td colspan="4" class="text-center text-muted">No items found</td></tr>';

    let itemsHtml = '';
    items.forEach(function(item) {
        itemsHtml += `
            <tr>
                <td>
                    <div class="d-flex align-items-center">
                        <img src="${item.productImageUrl || '/static/images/products/no-image.png'}"
                             alt="${item.productName}" class="rounded me-2" style="width: 40px; height: 40px; object-fit: cover;">
                        <div>
                            <div class="fw-bold">${item.productName}</div>
                            <small class="text-muted">SKU: ${item.productSku}</small>
                        </div>
                    </div>
                </td>
                <td>${item.quantity}</td>
                <td>₹${item.unitPrice.toFixed(2)}</td>
                <td class="fw-bold">₹${item.subtotal.toFixed(2)}</td>
            </tr>
        `;
    });

    return itemsHtml;
}

function formatAddress(addressString) {
    if (!addressString) return 'N/A';

    // Split address by comma and format
    const parts = addressString.split(',').map(part => part.trim());
    return parts.join('<br>');
}

function canCancelOrder(order) {
    return order.status === 'PENDING' || order.status === 'CONFIRMED';
}

function cancelOrder(orderId) {
    if (confirm('Are you sure you want to cancel this order?')) {
        $.ajax({
            url: '/api/orders/' + orderId + '/cancel',
            type: 'PUT',
            success: function(response) {
                if (response.success) {
                    showSuccess('Order cancelled successfully');
                    // Reload orders after a short delay
                    setTimeout(() => loadOrders(), 1000);
                } else {
                    showError('Failed to cancel order');
                }
            },
            error: function() {
                showError('Error cancelling order');
            }
        });
    }
}

function reorderItems(orderId) {
    const userId = <c:out value="${sessionScope.user.id}"/>;
    if (!userId) {
        showError('Please login to reorder items');
        return;
    }

    // Show loading state
    const reorderButton = $(`.order-card[data-order-id="${orderId}"] .btn-outline-success`);
    const originalText = reorderButton.html();
    reorderButton.html('<i class="fas fa-spinner fa-spin me-1"></i>Reordering...').prop('disabled', true);

    // First validate if reorder is possible
    $.ajax({
        url: `/api/orders/${orderId}/validate-reorder`,
        type: 'GET',
        data: { userId: userId },
        success: function(response) {
            if (response.success && response.data.length === 0) {
                // No validation errors, proceed with reorder
                performReorder(orderId, userId, reorderButton, originalText);
            } else {
                // Show validation errors
                reorderButton.html(originalText).prop('disabled', false);
                const errors = response.data.join('<br>');
                showError('Cannot reorder items:<br>' + errors);
            }
        },
        error: function(xhr) {
            reorderButton.html(originalText).prop('disabled', false);
            if (xhr.status === 404) {
                showError('Order not found or you do not have permission to reorder');
            } else {
                showError('Error validating reorder request');
            }
        }
    });
}

function performReorder(orderId, userId, reorderButton, originalText) {
    $.ajax({
        url: `/api/orders/${orderId}/reorder`,
        type: 'POST',
        data: { userId: userId },
        success: function(response) {
            reorderButton.html(originalText).prop('disabled', false);

            if (response.success) {
                showSuccess('Items successfully added to your cart!');

                // Update cart count in header if exists
                if (typeof updateCartCount === 'function') {
                    updateCartCount();
                }

                // Optionally redirect to cart page after a delay
                setTimeout(() => {
                    if (confirm('Items added to cart. Would you like to view your cart?')) {
                        window.location.href = '/cart';
                    }
                }, 2000);
            } else {
                showError('Failed to reorder items: ' + (response.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            reorderButton.html(originalText).prop('disabled', false);

            if (xhr.status === 404) {
                showError('Order not found or you do not have permission to reorder');
            } else if (xhr.status === 400) {
                showError('Cannot reorder this order. Only delivered orders can be reordered.');
            } else {
                showError('Error processing reorder request');
            }
        }
    });
}

function loadMoreOrders() {
    currentPage++;
    loadOrders(false);
}

function showEmptyState() {
    $('#ordersContent').addClass('d-none');
    $('#emptyOrdersState').removeClass('d-none');
    $('#loadMoreSection').addClass('d-none');
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

// Add click handler for order cards to expand/collapse preview
$(document).on('click', '.order-card', function(e) {
    // Don't expand if clicking on buttons
    if ($(e.target).closest('.btn').length) {
        return;
    }

    const preview = $(this).find('.order-preview');
    preview.slideToggle();
});
</script>

<style>
.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.2s ease;
}

.card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}

.order-card {
    cursor: pointer;
}

.nav-pills .nav-link {
    border-radius: 8px;
    margin: 0 2px;
}

.nav-pills .nav-link.active {
    background-color: #0d6efd;
}

.badge {
    font-size: 0.8em;
}

.btn-sm {
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
}

.order-preview {
    background-color: #f8f9fa;
    border-radius: 8px;
    padding: 1rem;
}

.table th {
    border-top: none;
    font-weight: 600;
    color: #495057;
}

.order-summary-card {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

@media (max-width: 768px) {
    .order-actions {
        flex-direction: column;
        gap: 0.5rem !important;
    }

    .btn-sm {
        width: 100%;
        justify-content: center;
    }

    .nav-pills .nav-link {
        padding: 0.5rem;
        font-size: 0.875rem;
    }
}
</style>
