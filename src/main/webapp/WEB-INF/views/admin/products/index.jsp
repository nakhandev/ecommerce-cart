<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1>Product Management</h1>
            <p class="text-muted">Manage your product inventory, pricing, and stock levels</p>
        </div>
        <div>
            <a href="<c:url value='/admin/products/create'/>" class="btn btn-admin-primary">
                <i class="fas fa-plus me-2"></i>Add New Product
            </a>
        </div>
    </div>
</div>

<!-- Statistics Cards -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="admin-card stats-card">
            <div class="stat-icon text-primary">
                <i class="fas fa-box"></i>
            </div>
            <div class="stat-value" id="totalProducts">-</div>
            <div class="stat-label">Total Products</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card stats-card">
            <div class="stat-icon text-success">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-value" id="activeProducts">-</div>
            <div class="stat-label">Active Products</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card stats-card">
            <div class="stat-icon text-warning">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="stat-value" id="lowStockProducts">-</div>
            <div class="stat-label">Low Stock Items</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="admin-card stats-card">
            <div class="stat-icon text-info">
                <i class="fas fa-tag"></i>
            </div>
            <div class="stat-value" id="onSaleProducts">-</div>
            <div class="stat-label">On Sale</div>
        </div>
    </div>
</div>

<!-- Filters and Search -->
<div class="admin-card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Product Filters</h5>
        <button class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">
            <i class="fas fa-undo me-1"></i>Reset
        </button>
    </div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-3">
                <label for="searchInput" class="form-label">Search Products</label>
                <input type="text" class="form-control" id="searchInput" placeholder="Search by name or SKU...">
            </div>
            <div class="col-md-2">
                <label for="categoryFilter" class="form-label">Category</label>
                <select class="form-select" id="categoryFilter">
                    <option value="">All Categories</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="statusFilter" class="form-label">Status</label>
                <select class="form-select" id="statusFilter">
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="stockFilter" class="form-label">Stock Status</label>
                <select class="form-select" id="stockFilter">
                    <option value="">All Stock</option>
                    <option value="in_stock">In Stock</option>
                    <option value="low_stock">Low Stock</option>
                    <option value="out_of_stock">Out of Stock</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">&nbsp;</label>
                <div class="d-grid">
                    <button class="btn btn-admin-primary" onclick="applyFilters()">
                        <i class="fas fa-search me-1"></i>Apply Filters
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Products Table -->
<div class="admin-card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Products</h5>
        <div class="d-flex gap-2">
            <div class="dropdown">
                <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    <i class="fas fa-download me-1"></i>Export
                </button>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="#" onclick="exportProducts('csv')">
                        <i class="fas fa-file-csv me-2"></i>Export to CSV
                    </a>
                    <a class="dropdown-item" href="#" onclick="exportProducts('excel')">
                        <i class="fas fa-file-excel me-2"></i>Export to Excel
                    </a>
                </div>
            </div>
            <button class="btn btn-outline-primary btn-sm" onclick="refreshProducts()">
                <i class="fas fa-sync-alt me-1"></i>Refresh
            </button>
        </div>
    </div>
    <div class="card-body">
        <!-- Bulk Actions -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="selectAllProducts">
                <label class="form-check-label" for="selectAllProducts">
                    Select All
                </label>
            </div>
            <div class="dropdown">
                <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    <i class="fas fa-cogs me-1"></i>Bulk Actions
                </button>
                <div class="dropdown-menu dropdown-menu-end">
                    <a class="dropdown-item" href="#" onclick="bulkActivate()">
                        <i class="fas fa-check me-2"></i>Activate Selected
                    </a>
                    <a class="dropdown-item" href="#" onclick="bulkDeactivate()">
                        <i class="fas fa-pause me-2"></i>Deactivate Selected
                    </a>
                    <a class="dropdown-item" href="#" onclick="bulkSetFeatured()">
                        <i class="fas fa-star me-2"></i>Set as Featured
                    </a>
                    <a class="dropdown-item" href="#" onclick="bulkRemoveFeatured()">
                        <i class="fas fa-star-half-alt me-2"></i>Remove from Featured
                    </a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item text-danger" href="#" onclick="bulkDelete()">
                        <i class="fas fa-trash me-2"></i>Delete Selected
                    </a>
                </div>
            </div>
        </div>

        <!-- Products Table -->
        <div class="table-responsive">
            <table class="table table-hover" id="productsTable">
                <thead class="table-light">
                    <tr>
                        <th width="40">
                            <input type="checkbox" class="form-check-input" id="selectAll">
                        </th>
                        <th>Product</th>
                        <th>SKU</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th>Featured</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="productsTableBody">
                    <!-- Products will be loaded here via AJAX -->
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <nav aria-label="Product pagination" id="paginationContainer">
            <!-- Pagination will be loaded here -->
        </nav>
    </div>
</div>

<!-- Loading Spinner -->
<div class="text-center d-none" id="loadingSpinner">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    <div class="mt-2">Loading products...</div>
</div>

<!-- Product Details Modal -->
<div class="modal fade" id="productModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Product Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="productModalBody">
                <!-- Product details will be loaded here -->
            </div>
        </div>
    </div>
</div>

<script>
let currentPage = 0;
let currentFilters = {};

$(document).ready(function() {
    loadProducts();
    loadCategories();
    loadStatistics();

    // Search input with debounce
    let searchTimeout;
    $('#searchInput').on('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            currentFilters.search = $('#searchInput').val();
            currentPage = 0;
            loadProducts();
        }, 500);
    });

    // Filter change handlers
    $('#categoryFilter, #statusFilter, #stockFilter').change(function() {
        applyFilters();
    });

    // Select all checkbox
    $('#selectAllProducts').change(function() {
        $('.product-checkbox').prop('checked', $(this).prop('checked'));
    });
});

function loadProducts(page = 0) {
    currentPage = page;
    $('#loadingSpinner').removeClass('d-none');
    $('#productsTableBody').addClass('d-none');

    $.ajax({
        url: '/api/products',
        type: 'GET',
        data: {
            page: page,
            size: 10,
            ...currentFilters
        },
        success: function(response) {
            if (response.success) {
                renderProducts(response.data.content);
                renderPagination(response.data);
            } else {
                showError('Failed to load products');
            }
        },
        error: function() {
            showError('Error loading products');
        },
        complete: function() {
            $('#loadingSpinner').addClass('d-none');
            $('#productsTableBody').removeClass('d-none');
        }
    });
}

function renderProducts(products) {
    let html = '';

    if (products.length === 0) {
        html = '<tr><td colspan="9" class="text-center text-muted py-4">No products found</td></tr>';
    } else {
        products.forEach(function(product) {
            html += `
                <tr>
                    <td>
                        <input type="checkbox" class="form-check-input product-checkbox" value="${product.id}">
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <img src="${product.imageUrl || '/static/images/products/no-image.png'}"
                                 alt="${product.name}" class="rounded me-3" style="width: 50px; height: 50px; object-fit: cover;">
                            <div>
                                <div class="fw-bold">${product.name}</div>
                                <small class="text-muted">${product.shortDescription || 'No description'}</small>
                            </div>
                        </div>
                    </td>
                    <td>
                        <code class="bg-light px-2 py-1">${product.sku}</code>
                    </td>
                    <td>
                        <span class="badge bg-secondary">${product.categoryName || 'Uncategorized'}</span>
                    </td>
                    <td>
                        <div class="fw-bold">₹${product.discountedPrice}</div>
                        ${product.discountPercentage > 0 ? `<small class="text-muted text-decoration-line-through">₹${product.originalPrice}</small>` : ''}
                    </td>
                    <td>
                        <span class="badge ${getStockBadgeClass(product.stockQuantity)}">
                            ${product.stockQuantity || 0}
                        </span>
                    </td>
                    <td>
                        <span class="badge ${product.isActive ? 'bg-success' : 'bg-danger'}">
                            ${product.isActive ? 'Active' : 'Inactive'}
                        </span>
                    </td>
                    <td>
                        ${product.isFeatured ? '<i class="fas fa-star text-warning"></i>' : '<i class="far fa-star text-muted"></i>'}
                    </td>
                    <td>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-ellipsis-v"></i>
                            </button>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#" onclick="viewProduct(${product.id})">
                                    <i class="fas fa-eye me-2"></i>View
                                </a>
                                <a class="dropdown-item" href="/admin/products/edit/${product.id}">
                                    <i class="fas fa-edit me-2"></i>Edit
                                </a>
                                <a class="dropdown-item" href="#" onclick="toggleFeatured(${product.id}, ${!product.isFeatured})">
                                    <i class="fas fa-star me-2"></i>${product.isFeatured ? 'Remove Featured' : 'Set Featured'}
                                </a>
                                <a class="dropdown-item" href="#" onclick="toggleActive(${product.id}, ${!product.isActive})">
                                    <i class="fas fa-toggle-${product.isActive ? 'off' : 'on'} me-2"></i>${product.isActive ? 'Deactivate' : 'Activate'}
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item text-danger" href="#" onclick="deleteProduct(${product.id})">
                                    <i class="fas fa-trash me-2"></i>Delete
                                </a>
                            </div>
                        </div>
                    </td>
                </tr>
            `;
        });
    }

    $('#productsTableBody').html(html);
}

function renderPagination(data) {
    if (data.totalPages <= 1) {
        $('#paginationContainer').empty();
        return;
    }

    let html = '<ul class="pagination justify-content-center">';

    // Previous button
    if (data.hasPrevious) {
        html += `<li class="page-item"><a class="page-link" href="#" onclick="loadProducts(${data.number - 1})">Previous</a></li>`;
    }

    // Page numbers
    for (let i = 0; i < data.totalPages; i++) {
        if (i === data.number) {
            html += `<li class="page-item active"><span class="page-link">${i + 1}</span></li>`;
        } else {
            html += `<li class="page-item"><a class="page-link" href="#" onclick="loadProducts(${i})">${i + 1}</a></li>`;
        }
    }

    // Next button
    if (data.hasNext) {
        html += `<li class="page-item"><a class="page-link" href="#" onclick="loadProducts(${data.number + 1})">Next</a></li>`;
    }

    html += '</ul>';
    $('#paginationContainer').html(html);
}

function getStockBadgeClass(stock) {
    if (stock === 0) return 'bg-danger';
    if (stock <= 5) return 'bg-warning';
    return 'bg-success';
}

function applyFilters() {
    currentFilters = {
        search: $('#searchInput').val(),
        category: $('#categoryFilter').val(),
        status: $('#statusFilter').val(),
        stock: $('#stockFilter').val()
    };
    currentPage = 0;
    loadProducts();
}

function resetFilters() {
    $('#searchInput').val('');
    $('#categoryFilter').val('');
    $('#statusFilter').val('');
    $('#stockFilter').val('');
    currentFilters = {};
    currentPage = 0;
    loadProducts();
}

function loadCategories() {
    $.ajax({
        url: '/api/categories',
        type: 'GET',
        success: function(response) {
            if (response.success) {
                let html = '<option value="">All Categories</option>';
                response.data.forEach(function(category) {
                    html += `<option value="${category.id}">${category.name}</option>`;
                });
                $('#categoryFilter').html(html);
            }
        }
    });
}

function loadStatistics() {
    $.ajax({
        url: '/api/products/stats',
        type: 'GET',
        success: function(response) {
            if (response.success) {
                const stats = response.data;
                $('#totalProducts').text(stats.activeProducts + stats.inactiveProducts || 0);
                $('#activeProducts').text(stats.activeProducts || 0);
                $('#lowStockProducts').text(stats.lowStockProducts || 0);
                $('#onSaleProducts').text('Loading...'); // Would need additional endpoint
            }
        }
    });
}

// Product Actions
function viewProduct(id) {
    $.ajax({
        url: `/api/products/${id}`,
        type: 'GET',
        success: function(response) {
            if (response.success) {
                showProductModal(response.data);
            }
        }
    });
}

function deleteProduct(id) {
    if (confirm('Are you sure you want to delete this product?')) {
        $.ajax({
            url: `/api/products/${id}`,
            type: 'DELETE',
            success: function(response) {
                if (response.success) {
                    showSuccess('Product deleted successfully');
                    loadProducts(currentPage);
                    loadStatistics();
                } else {
                    showError('Failed to delete product');
                }
            }
        });
    }
}

function toggleFeatured(id, featured) {
    $.ajax({
        url: `/api/products/${id}/featured`,
        type: 'PUT',
        data: { featured: featured },
        success: function(response) {
            if (response.success) {
                showSuccess(`Product ${featured ? 'set as' : 'removed from'} featured`);
                loadProducts(currentPage);
            } else {
                showError('Failed to update featured status');
            }
        }
    });
}

function toggleActive(id, active) {
    $.ajax({
        url: `/api/products/${id}/stock`,
        type: 'PUT',
        data: { stockQuantity: active ? 1 : 0 },
        success: function(response) {
            if (response.success) {
                showSuccess(`Product ${active ? 'activated' : 'deactivated'}`);
                loadProducts(currentPage);
                loadStatistics();
            } else {
                showError('Failed to update product status');
            }
        }
    });
}

// Bulk Actions
function bulkActivate() {
    const selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        showWarning('Please select products to activate');
        return;
    }

    performBulkAction(selectedIds, 'activate');
}

function bulkDeactivate() {
    const selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        showWarning('Please select products to deactivate');
        return;
    }

    performBulkAction(selectedIds, 'deactivate');
}

function bulkDelete() {
    const selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        showWarning('Please select products to delete');
        return;
    }

    if (confirm(`Are you sure you want to delete ${selectedIds.length} selected products?`)) {
        performBulkAction(selectedIds, 'delete');
    }
}

function getSelectedProductIds() {
    return $('.product-checkbox:checked').map(function() {
        return $(this).val();
    }).get();
}

function performBulkAction(ids, action) {
    // Implementation would depend on backend support for bulk operations
    showInfo(`Bulk ${action} operation would be implemented here`);
}

// Utility Functions
function showSuccess(message) {
    showAlert(message, 'success');
}

function showError(message) {
    showAlert(message, 'danger');
}

function showWarning(message) {
    showAlert(message, 'warning');
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

function refreshProducts() {
    loadProducts(currentPage);
    loadStatistics();
}

function exportProducts(format) {
    showInfo(`Export to ${format.toUpperCase()} would be implemented here`);
}

function showProductModal(product) {
    const modalBody = `
        <div class="row">
            <div class="col-md-4">
                <img src="${product.imageUrl || '/static/images/products/no-image.png'}"
                     alt="${product.name}" class="img-fluid rounded">
            </div>
            <div class="col-md-8">
                <h4>${product.name}</h4>
                <p class="text-muted">${product.shortDescription || 'No description'}</p>
                <table class="table table-sm">
                    <tr><td><strong>SKU:</strong></td><td>${product.sku}</td></tr>
                    <tr><td><strong>Price:</strong></td><td>₹${product.discountedPrice}</td></tr>
                    <tr><td><strong>Stock:</strong></td><td>${product.stockQuantity || 0}</td></tr>
                    <tr><td><strong>Category:</strong></td><td>${product.categoryName || 'Uncategorized'}</td></tr>
                    <tr><td><strong>Status:</strong></td><td>${product.isActive ? 'Active' : 'Inactive'}</td></tr>
                </table>
            </div>
        </div>
    `;
    $('#productModalBody').html(modalBody);
    $('#productModal').modal('show');
}
</script>
