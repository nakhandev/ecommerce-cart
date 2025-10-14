<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1>Edit Product</h1>
            <p class="text-muted">Update product information and settings</p>
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
    <div class="mt-2">Loading product...</div>
</div>

<!-- Edit Form (Initially Hidden) -->
<div id="editFormContainer" class="d-none">
    <div class="row">
        <div class="col-lg-8">
            <div class="admin-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Product Information</h5>
                    <div>
                        <span class="badge bg-info">ID: <span id="productId"></span></span>
                        <span class="badge bg-secondary ms-2">SKU: <span id="productSku"></span></span>
                    </div>
                </div>
                <div class="card-body">
                    <form id="editProductForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductName" class="form-label">Product Name *</label>
                                    <input type="text" class="form-control" id="editProductName" name="name" required>
                                    <div class="form-text">Enter the full product name</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductSku" class="form-label">SKU *</label>
                                    <input type="text" class="form-control" id="editProductSku" name="sku" required readonly>
                                    <div class="form-text">SKU cannot be changed</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductCategory" class="form-label">Category *</label>
                                    <select class="form-select" id="editProductCategory" name="categoryId" required>
                                        <option value="">Select Category</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductPrice" class="form-label">Price *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">₹</span>
                                        <input type="number" class="form-control" id="editProductPrice" name="price"
                                               step="0.01" min="0" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductStock" class="form-label">Stock Quantity *</label>
                                    <input type="number" class="form-control" id="editProductStock" name="stockQuantity"
                                           min="0" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductDiscount" class="form-label">Discount (%)</label>
                                    <input type="number" class="form-control" id="editProductDiscount" name="discountPercentage"
                                           min="0" max="100" step="0.01" value="0">
                                    <div class="form-text">Leave 0 for no discount</div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="editProductShortDescription" class="form-label">Short Description</label>
                            <input type="text" class="form-control" id="editProductShortDescription"
                                   name="shortDescription" maxlength="1000">
                            <div class="form-text">Brief description (max 1000 characters)</div>
                        </div>

                        <div class="mb-3">
                            <label for="editProductLongDescription" class="form-label">Long Description</label>
                            <textarea class="form-control" id="editProductLongDescription" name="longDescription"
                                      rows="4" placeholder="Detailed product description..."></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductImage" class="form-label">Product Image</label>
                                    <input type="file" class="form-control" id="editProductImage" name="imageFile"
                                           accept="image/*">
                                    <div class="form-text">Upload new image to replace current one</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editProductImageUrl" class="form-label">Or Image URL</label>
                                    <input type="url" class="form-control" id="editProductImageUrl" name="imageUrl"
                                           placeholder="https://example.com/image.jpg">
                                </div>
                            </div>
                        </div>

                        <!-- Current Image Preview -->
                        <div class="mb-3">
                            <label class="form-label">Current Image</label>
                            <div id="currentImageContainer">
                                <img id="currentImage" src="" alt="Current product image"
                                     class="img-fluid rounded" style="max-height: 200px;">
                            </div>
                        </div>

                        <!-- Product Features -->
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="editIsActive" name="isActive">
                                    <label class="form-check-label" for="editIsActive">
                                        Active Product
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="editIsFeatured" name="isFeatured">
                                    <label class="form-check-label" for="editIsFeatured">
                                        Featured Product
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Additional Details -->
                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="editProductWeight" class="form-label">Weight (kg)</label>
                                    <input type="number" class="form-control" id="editProductWeight" name="weightKg"
                                           step="0.001" min="0">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="editProductLength" class="form-label">Length (cm)</label>
                                    <input type="number" class="form-control" id="editProductLength" name="dimensionsLength"
                                           step="0.01" min="0">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="editProductWidth" class="form-label">Width (cm)</label>
                                    <input type="number" class="form-control" id="editProductWidth" name="dimensionsWidth"
                                           step="0.01" min="0">
                                </div>
                            </div>
                        </div>

                        <!-- Product Stats -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Created Date</label>
                                    <input type="text" class="form-control" id="createdAt" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Last Updated</label>
                                    <input type="text" class="form-control" id="updatedAt" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between">
                            <div>
                                <button type="button" class="btn btn-outline-danger me-2" onclick="deleteProduct()">
                                    <i class="fas fa-trash me-2"></i>Delete Product
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="duplicateProduct()">
                                    <i class="fas fa-copy me-2"></i>Duplicate
                                </button>
                            </div>
                            <div>
                                <button type="button" class="btn btn-outline-primary me-2" onclick="previewChanges()">
                                    <i class="fas fa-eye me-2"></i>Preview Changes
                                </button>
                                <button type="submit" class="btn btn-admin-primary">
                                    <i class="fas fa-save me-2"></i>Update Product
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Preview Panel -->
        <div class="col-lg-4">
            <div class="admin-card">
                <div class="card-header">
                    <h5 class="mb-0">Preview Changes</h5>
                </div>
                <div class="card-body">
                    <div id="editProductPreview">
                        <div class="text-center text-muted">
                            <i class="fas fa-eye fa-3x mb-3"></i>
                            <p>Updated preview will appear here</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="admin-card">
                <div class="card-header">
                    <h6 class="mb-0">Quick Actions</h6>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-success btn-sm" onclick="quickStockUpdate()">
                            <i class="fas fa-plus me-2"></i>Add Stock
                        </button>
                        <button class="btn btn-outline-warning btn-sm" onclick="quickPriceUpdate()">
                            <i class="fas fa-tag me-2"></i>Update Price
                        </button>
                        <button class="btn btn-outline-info btn-sm" onclick="toggleFeatured()">
                            <i class="fas fa-star me-2"></i>Toggle Featured
                        </button>
                        <button class="btn btn-outline-secondary btn-sm" onclick="viewProductHistory()">
                            <i class="fas fa-history me-2"></i>View History
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Product Details Modal -->
<div class="modal fade" id="productDetailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Product Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="productDetailsModalBody">
                <!-- Product details will be loaded here -->
            </div>
        </div>
    </div>
</div>

<script>
let currentProduct = {};
let productId = window.location.pathname.split('/').pop();

$(document).ready(function() {
    if (productId && productId !== 'edit') {
        loadProduct(productId);
        loadCategories();
        setupFormHandlers();
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
                populateForm(currentProduct);
                updatePreview();
                $('#loadingSpinner').addClass('d-none');
                $('#editFormContainer').removeClass('d-none');
            } else {
                showError('Product not found');
            }
        },
        error: function() {
            showError('Error loading product');
        }
    });
}

function populateForm(product) {
    $('#productId').text(product.id);
    $('#productSku').text(product.sku);

    $('#editProductName').val(product.name);
    $('#editProductSku').val(product.sku);
    $('#editProductPrice').val(product.price);
    $('#editProductStock').val(product.stockQuantity);
    $('#editProductDiscount').val(product.discountPercentage || 0);
    $('#editProductShortDescription').val(product.shortDescription);
    $('#editProductLongDescription').val(product.longDescription);
    $('#editProductImageUrl').val(product.imageUrl);
    $('#editIsActive').prop('checked', product.isActive);
    $('#editIsFeatured').prop('checked', product.isFeatured);

    // Optional fields
    $('#editProductWeight').val(product.weightKg);
    $('#editProductLength').val(product.dimensionsLength);
    $('#editProductWidth').val(product.dimensionsWidth);

    // Set category
    if (product.categoryId) {
        $('#editProductCategory').val(product.categoryId);
    }

    // Set dates
    if (product.createdAt) {
        $('#createdAt').val(new Date(product.createdAt).toLocaleString());
    }
    if (product.updatedAt) {
        $('#updatedAt').val(new Date(product.updatedAt).toLocaleString());
    }

    // Set current image
    if (product.imageUrl) {
        $('#currentImage').attr('src', product.imageUrl);
    } else {
        $('#currentImage').attr('src', '/static/images/products/no-image.png');
    }
}

function loadCategories() {
    $.ajax({
        url: '/api/categories',
        type: 'GET',
        success: function(response) {
            if (response.success) {
                let html = '<option value="">Select Category</option>';
                response.data.forEach(function(category) {
                    html += `<option value="${category.id}">${category.name}</option>`;
                });
                $('#editProductCategory').html(html);
            }
        }
    });
}

function setupFormHandlers() {
    // Form inputs change handlers for preview
    $('#editProductName, #editProductPrice, #editProductDiscount, #editProductShortDescription, #editProductImageUrl').on('input', function() {
        updatePreview();
    });

    $('#editProductCategory').change(function() {
        updatePreview();
    });

    // Form submission
    $('#editProductForm').submit(function(e) {
        e.preventDefault();
        updateProduct();
    });
}

function updatePreview() {
    const name = $('#editProductName').val();
    const price = parseFloat($('#editProductPrice').val()) || 0;
    const discount = parseFloat($('#editProductDiscount').val()) || 0;
    const description = $('#editProductShortDescription').val();
    const imageUrl = $('#editProductImageUrl').val() || $('#currentImage').attr('src');

    if (name || price > 0) {
        const discountedPrice = discount > 0 ? price * (1 - discount / 100) : price;

        const previewHtml = `
            <div class="product-preview">
                <img src="${imageUrl}"
                     alt="Product" class="img-fluid rounded mb-3" style="max-height: 150px; width: 100%; object-fit: cover;">
                <h6 class="fw-bold">${name || 'Product Name'}</h6>
                <div class="mb-2">
                    <span class="fw-bold text-primary">₹${discountedPrice.toFixed(2)}</span>
                    ${discount > 0 ? `<small class="text-muted text-decoration-line-through ms-2">₹${price.toFixed(2)}</small>` : ''}
                    ${discount > 0 ? `<small class="badge bg-success ms-2">${discount}% OFF</small>` : ''}
                </div>
                <p class="small text-muted">${description || 'No description available'}</p>
            </div>
        `;

        $('#editProductPreview').html(previewHtml);
    } else {
        $('#editProductPreview').html(`
            <div class="text-center text-muted">
                <i class="fas fa-eye fa-3x mb-3"></i>
                <p>Updated preview will appear here</p>
            </div>
        `);
    }
}

function updateProduct() {
    // Validate form
    if (!validateEditForm()) {
        return;
    }

    // Show loading
    const submitBtn = $('#editProductForm button[type="submit"]');
    const originalText = submitBtn.html();
    submitBtn.html('<i class="fas fa-spinner fa-spin me-2"></i>Updating...').prop('disabled', true);

    // Create FormData for file upload
    const formData = new FormData();
    formData.append('name', $('#editProductName').val());
    formData.append('sku', $('#editProductSku').val());
    formData.append('categoryId', $('#editProductCategory').val());
    formData.append('price', $('#editProductPrice').val());
    formData.append('stockQuantity', $('#editProductStock').val());
    formData.append('discountPercentage', $('#editProductDiscount').val());
    formData.append('shortDescription', $('#editProductShortDescription').val());
    formData.append('longDescription', $('#editProductLongDescription').val());
    formData.append('isActive', $('#editIsActive').is(':checked'));
    formData.append('isFeatured', $('#editIsFeatured').is(':checked'));

    // Optional fields
    if ($('#editProductImageUrl').val()) {
        formData.append('imageUrl', $('#editProductImageUrl').val());
    }
    if ($('#editProductWeight').val()) {
        formData.append('weightKg', $('#editProductWeight').val());
    }
    if ($('#editProductLength').val()) {
        formData.append('dimensionsLength', $('#editProductLength').val());
    }
    if ($('#editProductWidth').val()) {
        formData.append('dimensionsWidth', $('#editProductWidth').val());
    }

    // File upload
    const imageFile = $('#editProductImage')[0].files[0];
    if (imageFile) {
        formData.append('imageFile', imageFile);
    }

    $.ajax({
        url: `/api/products/${productId}`,
        type: 'PUT',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            if (response.success) {
                showSuccess('Product updated successfully!');
                setTimeout(function() {
                    window.location.href = '/admin/products';
                }, 1500);
            } else {
                showError('Failed to update product: ' + (response.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            let errorMessage = 'Error updating product';
            if (xhr.responseJSON && xhr.responseJSON.message) {
                errorMessage = xhr.responseJSON.message;
            }
            showError(errorMessage);
        },
        complete: function() {
            submitBtn.html(originalText).prop('disabled', false);
        }
    });
}

function validateEditForm() {
    let isValid = true;
    const errors = [];

    // Required field validation
    if (!$('#editProductName').val().trim()) {
        errors.push('Product name is required');
        isValid = false;
    }

    if (!$('#editProductCategory').val()) {
        errors.push('Category is required');
        isValid = false;
    }

    if (!$('#editProductPrice').val() || parseFloat($('#editProductPrice').val()) <= 0) {
        errors.push('Valid price is required');
        isValid = false;
    }

    if (!$('#editProductStock').val() || parseInt($('#editProductStock').val()) < 0) {
        errors.push('Valid stock quantity is required');
        isValid = false;
    }

    if (errors.length > 0) {
        showError(errors.join('<br>'));
    }

    return isValid;
}

function deleteProduct() {
    if (confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
        $.ajax({
            url: `/api/products/${productId}`,
            type: 'DELETE',
            success: function(response) {
                if (response.success) {
                    showSuccess('Product deleted successfully');
                    setTimeout(function() {
                        window.location.href = '/admin/products';
                    }, 1500);
                } else {
                    showError('Failed to delete product');
                }
            },
            error: function() {
                showError('Error deleting product');
            }
        });
    }
}

function duplicateProduct() {
    if (confirm('Create a copy of this product with a new SKU?')) {
        // This would need a dedicated endpoint for duplication
        showInfo('Product duplication feature would be implemented here');
    }
}

function previewChanges() {
    updatePreview();
    $('#productDetailsModal').modal('show');
}

function quickStockUpdate() {
    const currentStock = parseInt($('#editProductStock').val()) || 0;
    const newStock = prompt('Enter new stock quantity:', currentStock);

    if (newStock !== null && !isNaN(newStock)) {
        $('#editProductStock').val(parseInt(newStock));
        updatePreview();
        showSuccess('Stock quantity updated');
    }
}

function quickPriceUpdate() {
    const currentPrice = parseFloat($('#editProductPrice').val()) || 0;
    const newPrice = prompt('Enter new price:', currentPrice);

    if (newPrice !== null && !isNaN(newPrice)) {
        $('#editProductPrice').val(parseFloat(newPrice));
        updatePreview();
        showSuccess('Price updated');
    }
}

function toggleFeatured() {
    const isFeatured = $('#editIsFeatured').is(':checked');
    $('#editIsFeatured').prop('checked', !isFeatured);
    updatePreview();
    showSuccess(`Product ${!isFeatured ? 'set as' : 'removed from'} featured`);
}

function viewProductHistory() {
    showInfo('Product history feature would be implemented here');
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
.product-preview {
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 1rem;
    background: #f8f9fa;
}

#currentImageContainer {
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 1rem;
    background: #f8f9fa;
    text-align: center;
}

#currentImage {
    max-width: 100%;
    height: auto;
}
</style>
