<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="My Orders" scope="request"/>

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
        .account-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding-top: 2rem;
        }

        .account-header {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .order-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .order-header {
            background: #667eea;
            color: white;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .order-body {
            padding: 1.5rem;
        }

        .order-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #e9ecef;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1rem;
        }

        .order-item-info {
            flex-grow: 1;
        }

        .order-item-name {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .order-item-details {
            color: #718096;
            font-size: 0.9rem;
        }

        .order-status {
            padding: 0.375rem 0.75rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
            text-align: center;
            min-width: 100px;
        }

        .status-pending { background: #fff3cd; color: #856404; }
        .status-processing { background: #cce7ff; color: #0066cc; }
        .status-shipped { background: #d4edda; color: #155724; }
        .status-delivered { background: #d1ecf1; color: #0c5460; }
        .status-cancelled { background: #f8d7da; color: #721c24; }

        .order-total {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }

        .order-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-track {
            background: #667eea;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .btn-track:hover {
            background: #5a67d8;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .empty-icon {
            font-size: 4rem;
            color: #cbd5e0;
            margin-bottom: 1rem;
        }

        .filter-tabs {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1rem;
            margin-bottom: 2rem;
        }

        .filter-tab {
            border: none;
            background: none;
            padding: 0.5rem 1rem;
            margin-right: 0.5rem;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-tab.active {
            background: #667eea;
            color: white;
        }

        .filter-tab:not(.active) {
            color: #718096;
        }

        .filter-tab:not(.active):hover {
            background: #f8f9fa;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../includes/header.jsp"/>

    <!-- Account Header -->
    <div class="account-container">
        <div class="container">
            <div class="account-header">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h2 class="mb-1">My Orders</h2>
                        <p class="text-muted mb-0">Track and manage your orders</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <a href="<c:url value='/products'/>" class="btn btn-primary">
                            <i class="fas fa-shopping-bag me-2"></i>Continue Shopping
                        </a>
                    </div>
                </div>
            </div>

            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <div class="d-flex flex-wrap gap-2">
                    <button class="filter-tab active" data-status="all">All Orders</button>
                    <button class="filter-tab" data-status="pending">Pending</button>
                    <button class="filter-tab" data-status="processing">Processing</button>
                    <button class="filter-tab" data-status="shipped">Shipped</button>
                    <button class="filter-tab" data-status="delivered">Delivered</button>
                    <button class="filter-tab" data-status="cancelled">Cancelled</button>
                </div>
            </div>

            <!-- Orders List -->
            <div id="orders-container">
                <!-- Sample Order (in real app, this would be populated from backend) -->
                <div class="order-card" data-status="delivered">
                    <div class="order-header">
                        <div>
                            <strong>Order #ESH-2025-001</strong><br>
                            <small>Placed on October 10, 2025</small>
                        </div>
                        <div class="order-status status-delivered">
                            Delivered
                        </div>
                    </div>
                    <div class="order-body">
                        <!-- Order Items -->
                        <div class="order-item">
                            <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=80&h=80&fit=crop"
                                 alt="Product" class="order-item-image">
                            <div class="order-item-info">
                                <div class="order-item-name">Wireless Bluetooth Headphones</div>
                                <div class="order-item-details">Quantity: 1 • Color: Black</div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">₹2,999</div>
                            </div>
                        </div>

                        <div class="order-item">
                            <img src="https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=80&h=80&fit=crop"
                                 alt="Product" class="order-item-image">
                            <div class="order-item-info">
                                <div class="order-item-name">Smart Watch Series 5</div>
                                <div class="order-item-details">Quantity: 1 • Color: Silver</div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">₹15,999</div>
                            </div>
                        </div>

                        <!-- Order Total -->
                        <div class="order-total">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>Total: ₹18,998</strong><br>
                                    <small class="text-muted">Free shipping • Paid via Credit Card</small>
                                </div>
                                <div class="order-actions">
                                    <a href="#" class="btn-track">
                                        <i class="fas fa-truck me-1"></i>Track Package
                                    </a>
                                    <button class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-redo me-1"></i>Reorder
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Another Sample Order -->
                <div class="order-card" data-status="shipped">
                    <div class="order-header">
                        <div>
                            <strong>Order #ESH-2025-002</strong><br>
                            <small>Placed on October 12, 2025</small>
                        </div>
                        <div class="order-status status-shipped">
                            Shipped
                        </div>
                    </div>
                    <div class="order-body">
                        <div class="order-item">
                            <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=80&h=80&fit=crop"
                                 alt="Product" class="order-item-image">
                            <div class="order-item-info">
                                <div class="order-item-name">Laptop Backpack</div>
                                <div class="order-item-details">Quantity: 1 • Color: Gray</div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">₹1,299</div>
                            </div>
                        </div>

                        <div class="order-total">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>Total: ₹1,299</strong><br>
                                    <small class="text-muted">Standard shipping • Paid via UPI</small>
                                </div>
                                <div class="order-actions">
                                    <a href="#" class="btn-track">
                                        <i class="fas fa-truck me-1"></i>Track Package
                                    </a>
                                    <button class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-times me-1"></i>Cancel Order
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty State (when no orders) -->
            <div id="empty-state" class="empty-state" style="display: none;">
                <div class="empty-icon">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <h4>No Orders Found</h4>
                <p class="text-muted mb-4">You haven't placed any orders yet. Start shopping to see your orders here!</p>
                <a href="<c:url value='/products'/>" class="btn btn-primary btn-lg">
                    <i class="fas fa-shopping-bag me-2"></i>Start Shopping
                </a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp"/>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Filter functionality
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                const status = this.getAttribute('data-status');

                // Update active tab
                document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                // Filter orders
                filterOrders(status);
            });
        });

        function filterOrders(status) {
            const orders = document.querySelectorAll('.order-card');
            let visibleCount = 0;

            orders.forEach(order => {
                const orderStatus = order.getAttribute('data-status');
                if (status === 'all' || orderStatus === status) {
                    order.style.display = 'block';
                    visibleCount++;
                } else {
                    order.style.display = 'none';
                }
            });

            // Show/hide empty state
            const emptyState = document.getElementById('empty-state');
            const ordersContainer = document.getElementById('orders-container');

            if (visibleCount === 0) {
                ordersContainer.style.display = 'none';
                emptyState.style.display = 'block';
            } else {
                ordersContainer.style.display = 'block';
                emptyState.style.display = 'none';
            }
        }
    </script>
</body>
</html>
