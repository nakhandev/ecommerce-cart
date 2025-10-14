<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1>Product Details</h1>
            <p class="text-muted">View comprehensive product information and analytics</p>
        </div>
        <div>
            <a href="<c:url value='/admin/products'/>" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Products
            </a>
        </div>
    </div>
</div>

<!-- Loading Spinner -->
<div class="text-center d-none" id="loadingSpinner">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    <div class="mt-2">Loading product details...</div>
</div>

<!-- Product Details (Initially Hidden) -->
<div id="productDetailsContainer" class="d-none">
    <div class="row">
        <!-- Product Overview -->
        <div class="col-lg-8">
            <div class="admin-card">
                <div class="card-header">
                    <h5 class="mb-0">Product Overview</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <img id="productMainImage" src="" alt="Product Image"
                                 class="img-fluid rounded mb-3" style="max-height: 300px; width: 100%; object-fit: cover;">
                        </div>
                        <div class="col-md-8">
                            <h3 id="productTitle" class="mb-3"></h3>

                            <div class="row mb-3">
                                <div class="col-sm-6">
                                    <label class="text-muted">SKU:</label>
                                    <div><code id="productSku" class="bg-light px-2 py-1"></code></div>
                                </div>
                                <div class="col-sm-6">
                                    <label class="text-muted">Category:</label>
                                    <div><span id="productCategory" class="badge bg-secondary"></span></div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-sm-6">
                                    <label class="text-muted">Price:</label>
                                    <div>
                                        <span id="productPrice" class="h5 text-primary fw-bold"></span>
                                        <span id="productDiscount" class="ms-2"></span>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <label class="text-muted">Stock:</label>
                                    <div>
                                        <span id="productStock" class="badge"></span>
                                        <span id="stockStatus" class="ms-2"></span>
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-sm-6">
                                    <label class="text-muted">Status:</label>
                                    <div><span id="productStatus" class="badge"></span></div>
                                </div>
                                <div class="col-sm-6">
                                    <label class="text-muted">Featured:</label>
                                    <div><span id="productFeatured" class="badge"></span></div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="text-muted">Short Description:</label>
                                <div id="productShortDescription"></div>
                            </div>

                            <div class="mb-3">
                                <label class="text-muted">Long Description:</label>
                                <div id="productLongDescription" class="border rounded p-3 bg-light"></div>
                            </div>

                            <!-- Product Specifications -->
                            <div class="row" id="productSpecs">
                                <div class="col-sm-4">
                                    <label class="text-muted">Weight:</label>
                                    <div id="productWeight"></div>
                                </div>
                                <div class="col-sm-4">
                                    <label class="text-muted">Dimensions:</label>
                                    <div id="productDimensions"></div>
                                </div>
                                <div class="col-sm-4">
                                    <label class="text-muted">Created:</label>
                                    <div id="productCreated"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sales Analytics -->
            <div class="admin-card">
                <div class="card-header">
                    <h5 class="mb-0">Sales Analytics</h5>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-md-3">
                            <div class="stat-icon text-success mx-auto mb-2" style="font-size: 2rem;">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h4 id="totalOrders">-</h4>
                            <small class="text-muted">Total Orders</small>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-icon text-primary mx-auto mb-2" style="font-size: 2rem;">
                                <i class="fas fa-boxes"></i>
                            </div>
                            <h4 id="totalSold">-</h4>
                            <small class="text-muted">Units Sold</small>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-icon text-warning mx-auto mb-2" style="font-size: 2rem;">
                                <i class="fas fa-rupee-sign"></i>
                            </div>
                            <h4 id="totalRevenue">₹-</h4>
                            <small class="text-muted">Total Revenue</small>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-icon text-info mx-auto mb-2" style="font-size: 2rem;">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <h4 id="avgRating">-</h4>
                            <small class="text-muted">Avg Rating</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Quick Actions -->
            <div class="admin-card">
                <div class="card-header">
                    <h6 class="mb-0">Quick Actions</h6>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="#" class="btn btn-primary" id="editProductBtn">
                            <i class="fas fa-edit me-2"></i>Edit Product
                        </a>
                        <button class="btn btn-outline-success" onclick="updateStock()">
                            <i class="fas fa-plus me-2"></i>Update Stock
                        </button>
                        <button class="btn btn-outline-warning" onclick="updatePrice()">
                            <i class="fas fa-tag me-2"></i>Update Price
                        </button>
                        <button class="btn btn-outline-info" onclick="toggleFeaturedStatus()">
                            <i class="fas fa-star me-2"></i>Toggle Featured
                        </button>
                        <button class="btn btn-outline-secondary" onclick="duplicateProduct()">
                            <i class="fas fa-copy me-2"></i>Duplicate Product
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-download me-2"></i>Export Data
                            </button>
                            <div class="dropdown-menu w-100">
                                <a class="dropdown-item" href="#" onclick="exportProductData('summary')">
                                    <i class="fas fa-file-alt me-2"></i>Product Summary
                                </a>
                                <a class="dropdown-item" href="#" onclick="exportProductData('analytics')">
                                    <i class="fas fa-chart-bar me-2"></i>Sales Analytics
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="admin-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h6 class="mb-0">Recent Orders</h6>
                    <a href="#" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="card-body">
                    <div id="recentOrders">
                        <div class="text-center text-muted">
                            <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                            <p>No recent orders</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Product Timeline -->
            <div class="admin-card">
                <div class="card-header">
                    <h6 class="mb-0">Activity Timeline</h6>
                </div>
                <div class="card-body">
                    <div class="timeline" id="productTimeline">
                        <div class="timeline-item">
                            <div class="timeline-marker bg-primary"></div>
                            <div class="timeline-content">
                                <h6 class="timeline-title">Product Created</h6>
                                <p class="timeline-text" id="createdDate"></p>
                            </div>
                        </div>
                        <div class="timeline-item" id="lastUpdatedItem">
                            <div class="timeline-marker bg-info"></div>
                            <div class="timeline-content">
                                <h6 class="timeline-title">Last Updated</h6>
                                <p class="timeline-text" id="updatedDate"></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modals -->
<!-- Stock Update Modal -->
<div class="modal fade" id="stockModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Stock</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="stockForm">
                    <div class="mb-3">
                        <label class="form-label">Current Stock: <span id="currentStockValue"></span></label>
                    </div>
                    <div class="mb-3">
                        <label for="newStockQuantity" class="form-label">New Stock Quantity</label>
                        <input type="number" class="form-control" id="newStockQuantity" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label for="stockNote" class="form-label">Note (Optional)</label>
                        <textarea class="form-control" id="stockNote" rows="2" placeholder="Reason for stock update..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveStockUpdate()">Update Stock</button>
            </div>
        </div>
    </div>
</div>

<!-- Price Update Modal -->
<div class="modal fade" id="priceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Price</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="priceForm">
                    <div class="mb-3">
                        <label class="form-label">Current Price: <span id="currentPriceValue"></span></label>
                    </div>
                    <div class="mb-3">
                        <label for="newPrice" class="form-label">New Price (₹)</label>
                        <input type="number" class="form-control" id="newPrice" step="0.01" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label for="priceNote" class="form-label">Note (Optional)</label>
                        <textarea class="form-control" id="priceNote" rows="2" placeholder="Reason for price change..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="savePriceUpdate()">Update Price</button>
            </div>
        </div>
    </div>
</div>

<script>
let currentProduct = {};
let productId = window.location.pathname.split('/').pop();

$(document).ready(function() {
    if (productId && productId !== 'view') {
        loadProduct(productId);
    } else {
        showError('Invalid product ID');
    }
});

function loadProduct(id) {
    $('#loadingSpinner').removeClass('d-none');

    $.ajax({
        url: `/api/products/${id}`,
        type: 'GET',
        success: function(response) {
            if (response.success) {
                currentProduct = response.data;
                renderProductDetails(currentProduct);
                loadProductAnalytics(id);
                $('#loadingSpinner').addClass('d-none');
                $('#productDetailsContainer').removeClass('d-none');
            } else {
                showError('Product not found');
            }
        },
        error: function() {
            showError('Error loading product');
        }
    });
}

function renderProductDetails(product) {
    // Basic Information
    $('#productTitle').text(product.name);
    $('#productSku').text(product.sku);
    $('#productCategory').text(product.categoryName || 'Uncategorized');

    // Price and Discount
    const price = parseFloat(product.price) || 0;
    const discount = parseFloat(product.discountPercentage) || 0;
    const discountedPrice = discount > 0 ? price * (1 - discount / 100) : price;

    $('#productPrice').text(`₹${discountedPrice.toFixed(2)}`);
    if (discount > 0) {
        $('#productDiscount').html(`<small class="text-muted text-decoration-line-through">₹${price.toFixed(2)}</small> <span class="badge bg-success">${discount}% OFF</span>`);
    } else {
        $('#productDiscount').empty();
    }

    // Stock Information
    const stock = product.stockQuantity || 0;
    $('#productStock').text(stock).removeClass().addClass('badge ' + getStockBadgeClass(stock));

    if (stock === 0) {
        $('#stockStatus').html('<span class="text-danger">Out of Stock</span>');
    } else if (stock <= 5) {
        $('#stockStatus').html('<span class="text-warning">Low Stock</span>');
    } else {
        $('#stockStatus').html('<span class="text-success">In Stock</span>');
    }

    // Status and Featured
    $('#productStatus').text(product.isActive ? 'Active' : 'Inactive')
        .removeClass().addClass('badge ' + (product.isActive ? 'bg-success' : 'bg-danger'));

    $('#productFeatured').text(product.isFeatured ? 'Featured' : 'Not Featured')
        .removeClass().addClass('badge ' + (product.isFeatured ? 'bg-warning' : 'bg-secondary'));

    // Descriptions
    $('#productShortDescription').text(product.shortDescription || 'No short description available');
    $('#productLongDescription').html(product.longDescription ? product.longDescription.replace(/\n/g, '<br>') : 'No detailed description available');

    // Specifications
    $('#productWeight').text(product.weightKg ? `${product.weightKg} kg` : 'Not specified');
    $('#productDimensions').text(product.dimensionsLength && product.dimensionsWidth ?
        `${product.dimensionsLength} × ${product.dimensionsWidth} cm` : 'Not specified');

    // Dates
    $('#productCreated').text(new Date(product.createdAt).toLocaleString());
    $('#createdDate').text(new Date(product.createdAt).toLocaleDateString());

    if (product.updatedAt) {
        $('#productUpdated').text(new Date(product.updatedAt).toLocaleString());
        $('#updatedDate').text(new Date(product.updatedAt).toLocaleDateString());
    } else {
        $('#lastUpdatedItem').hide();
    }

    // Image
    $('#productMainImage').attr('src', product.imageUrl || '/static/images/products/no-image.png');

    // Edit button URL
    $('#editProductBtn').attr('href', `/admin/products/edit/${product.id}`);
}

function getStockBadgeClass(stock) {
    if (stock === 0) return 'bg-danger';
    if (stock <= 5) return 'bg-warning';
    return 'bg-success';
}

function loadProductAnalytics(productId) {
    // This would load actual analytics data
    // For now, showing placeholder data
    $('#totalOrders').text('24');
    $('#totalSold').text('156');
    $('#totalRevenue').text('₹45,230');
    $('#avgRating').text('4.2');

    // Load recent orders (placeholder)
    const recentOrdersHtml = `
        <div class="order-item mb-3 pb-3 border-bottom">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <div class="fw-bold">#12345</div>
                    <small class="text-muted">2 days ago</small>
                </div>
                <div class="text-end">
                    <div>₹1,299</div>
                    <small class="text-success">Completed</small>
                </div>
            </div>
        </div>
        <div class="order-item mb-3 pb-3 border-bottom">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <div class="fw-bold">#12344</div>
                    <small class="text-muted">5 days ago</small>
                </div>
                <div class="text-end">
                    <div>₹899</div>
                    <small class="text-success">Completed</small>
                </div>
            </div>
        </div>
    `;
    $('#recentOrders').html(recentOrdersHtml);
}

// Action Functions
function updateStock() {
    const currentStock = currentProduct.stockQuantity || 0;
    $('#currentStockValue').text(currentStock);
    $('#newStockQuantity').val(currentStock);
    $('#stockModal').modal('show');
}

function saveStockUpdate() {
    const newStock = $('#newStockQuantity').val();

    if (!newStock || newStock < 0) {
        showError('Please enter a valid stock quantity');
        return;
    }

    $.ajax({
        url: `/api/products/${productId}/stock`,
        type: 'PUT',
        data: { stockQuantity: newStock },
        success: function(response) {
            if (response.success) {
                showSuccess('Stock updated successfully');
                $('#stockModal').modal('hide');
                loadProduct(productId); // Reload to show updated data
            } else {
                showError('Failed to update stock');
            }
        },
        error: function() {
            showError('Error updating stock');
        }
    });
}

function updatePrice() {
    const currentPrice = currentProduct.price || 0;
    $('#currentPriceValue').text(`₹${currentPrice}`);
    $('#newPrice').val(currentPrice);
    $('#priceModal').modal('show');
}

function savePriceUpdate() {
    const newPrice = $('#newPrice').val();

    if (!newPrice || newPrice <= 0) {
        showError('Please enter a valid price');
        return;
    }

    $.ajax({
        url: `/api/products/${productId}`,
        type: 'PUT',
        data: {
            name: currentProduct.name,
            price: newPrice,
            stockQuantity: currentProduct.stockQuantity,
            categoryId: currentProduct.categoryId
        },
        success: function(response) {
            if (response.success) {
                showSuccess('Price updated successfully');
                $('#priceModal').modal('hide');
                loadProduct(productId); // Reload to show updated data
            } else {
                showError('Failed to update price');
            }
        },
        error: function() {
            showError('Error updating price');
        }
    });
}

function toggleFeaturedStatus() {
    const isFeatured = currentProduct.isFeatured;

    $.ajax({
        url: `/api/products/${productId}/featured`,
        type: 'PUT',
        data: { featured: !isFeatured },
        success: function(response) {
            if (response.success) {
                showSuccess(`Product ${!isFeatured ? 'set as' : 'removed from'} featured`);
                loadProduct(productId); // Reload to show updated data
            } else {
                showError('Failed to update featured status');
            }
        },
        error: function() {
            showError('Error updating featured status');
        }
    });
}

function duplicateProduct() {
    if (confirm('Create a copy of this product with a new SKU?')) {
        showInfo('Product duplication feature would be implemented here');
    }
}

function exportProductData(type) {
    showInfo(`Export ${type} feature would be implemented here`);
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
    $('.page-header').after(alertHtml);

    // Auto-hide after 5 seconds
    setTimeout(() => $('.alert').fadeOut(), 5000);
}
</script>

<style>
.timeline {
    position: relative;
    padding-left: 30px;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 15px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: #dee2e6;
}

.timeline-item {
    position: relative;
    margin-bottom: 20px;
}

.timeline-marker {
    position: absolute;
    left: -30px;
    top: 0;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    border: 2px solid #fff;
}

.timeline-title {
    font-size: 0.9rem;
    font-weight: 600;
    margin-bottom: 5px;
}

.timeline-text {
    font-size: 0.8rem;
    color: #6c757d;
    margin-bottom: 0;
}

.order-item {
    font-size: 0.9rem;
}

.stat-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(13, 110, 253, 0.1);
}
</style>
