<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1>Add New Product</h1>
            <p class="text-muted">Create a new product in your inventory</p>
        </div>
        <div>
            <a href="<c:url value='/admin/products'/>" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Products
            </a>
        </div>
    </div>
</div>

<!-- Product Creation Form -->
<div class="row">
    <div class="col-lg-8">
        <div class="admin-card">
            <div class="card-header">
                <h5 class="mb-0">Product Information</h5>
            </div>
            <div class="card-body">
                <form id="productForm" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productName" class="form-label">Product Name *</label>
                                <input type="text" class="form-control" id="productName" name="name" required>
                                <div class="form-text">Enter the full product name</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productSku" class="form-label">SKU *</label>
                                <input type="text" class="form-control" id="productSku" name="sku" required>
                                <div class="form-text">Unique product identifier</div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productCategory" class="form-label">Category *</label>
                                <select class="form-select" id="productCategory" name="categoryId" required>
                                    <option value="">Select Category</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productPrice" class="form-label">Price *</label>
                                <div class="input-group">
                                    <span class="input-group-text">₹</span>
                                    <input type="number" class="form-control" id="productPrice" name="price"
                                           step="0.01" min="0" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productStock" class="form-label">Stock Quantity *</label>
                                <input type="number" class="form-control" id="productStock" name="stockQuantity"
                                       min="0" value="0" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productDiscount" class="form-label">Discount (%)</label>
                                <input type="number" class="form-control" id="productDiscount" name="discountPercentage"
                                       min="0" max="100" step="0.01" value="0">
                                <div class="form-text">Leave 0 for no discount</div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="productShortDescription" class="form-label">Short Description</label>
                        <input type="text" class="form-control" id="productShortDescription"
                               name="shortDescription" maxlength="1000">
                        <div class="form-text">Brief description (max 1000 characters)</div>
                    </div>

                    <div class="mb-3">
                        <label for="productLongDescription" class="form-label">Long Description</label>
                        <textarea class="form-control" id="productLongDescription" name="longDescription"
                                  rows="4" placeholder="Detailed product description..."></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productImage" class="form-label">Product Image</label>
                                <input type="file" class="form-control" id="productImage" name="imageFile"
                                       accept="image/*">
                                <div class="form-text">Upload product image (JPG, PNG, GIF)</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productImageUrl" class="form-label">Or Image URL</label>
                                <input type="url" class="form-control" id="productImageUrl" name="imageUrl"
                                       placeholder="https://example.com/image.jpg">
                            </div>
                        </div>
                    </div>

                    <!-- Product Features -->
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" checked>
                                <label class="form-check-label" for="isActive">
                                    Active Product
                                </label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured">
                                <label class="form-check-label" for="isFeatured">
                                    Featured Product
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Details -->
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="productWeight" class="form-label">Weight (kg)</label>
                                <input type="number" class="form-control" id="productWeight" name="weightKg"
                                       step="0.001" min="0">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="productLength" class="form-label">Length (cm)</label>
                                <input type="number" class="form-control" id="productLength" name="dimensionsLength"
                                       step="0.01" min="0">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="productWidth" class="form-label">Width (cm)</label>
                                <input type="number" class="form-control" id="productWidth" name="dimensionsWidth"
                                       step="0.01" min="0">
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="generateSku">
                            <label class="form-check-label" for="generateSku">
                                Auto-generate SKU if empty
                            </label>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                            <i class="fas fa-undo me-2"></i>Reset Form
                        </button>
                        <div>
                            <button type="button" class="btn btn-outline-primary me-2" onclick="saveAsDraft()">
                                <i class="fas fa-save me-2"></i>Save as Draft
                            </button>
                            <button type="submit" class="btn btn-admin-primary">
                                <i class="fas fa-plus me-2"></i>Create Product
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
                <h5 class="mb-0">Preview</h5>
            </div>
            <div class="card-body">
                <div id="productPreview">
                    <div class="text-center text-muted">
                        <i class="fas fa-eye fa-3x mb-3"></i>
                        <p>Product preview will appear here as you fill the form</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Tips -->
        <div class="admin-card">
            <div class="card-header">
                <h6 class="mb-0">Tips</h6>
            </div>
            <div class="card-body">
                <ul class="list-unstyled small">
                    <li class="mb-2">
                        <i class="fas fa-check text-success me-2"></i>
                        Use a clear, descriptive product name
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-check text-success me-2"></i>
                        Ensure SKU is unique across all products
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-check text-success me-2"></i>
                        Add high-quality product images
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-check text-success me-2"></i>
                        Set appropriate stock levels
                    </li>
                    <li class="mb-0">
                        <i class="fas fa-check text-success me-2"></i>
                        Use discounts to attract customers
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    loadCategories();
    setupFormHandlers();
    updatePreview();
});

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
                $('#productCategory').html(html);
            }
        }
    });
}

function setupFormHandlers() {
    // Form inputs change handlers for preview
    $('#productName, #productPrice, #productDiscount, #productShortDescription, #productImageUrl').on('input', function() {
        updatePreview();
    });

    $('#productCategory').change(function() {
        updatePreview();
    });

    // Auto-generate SKU
    $('#generateSku').change(function() {
        if ($(this).is(':checked') && $('#productSku').val() === '') {
            generateSku();
        }
    });

    $('#productName').on('input', function() {
        if ($('#generateSku').is(':checked') && $('#productSku').val() === '') {
            generateSku();
        }
    });

    // Form submission
    $('#productForm').submit(function(e) {
        e.preventDefault();
        createProduct();
    });
}

function generateSku() {
    const name = $('#productName').val();
    if (name) {
        const baseSku = name.toLowerCase()
            .replace(/[^a-z0-9]/g, '')
            .substring(0, 8)
            .toUpperCase();
        const randomNum = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        $('#productSku').val(baseSku + randomNum);
    }
}

function updatePreview() {
    const name = $('#productName').val();
    const price = parseFloat($('#productPrice').val()) || 0;
    const discount = parseFloat($('#productDiscount').val()) || 0;
    const description = $('#productShortDescription').val();
    const imageUrl = $('#productImageUrl').val();
    const categoryId = $('#productCategory').val();

    let previewHtml = '';

    if (name || price > 0) {
        const discountedPrice = discount > 0 ? price * (1 - discount / 100) : price;

        previewHtml = `
            <div class="product-preview">
                <img src="${imageUrl || '/static/images/products/no-image.png'}"
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
    } else {
        previewHtml = `
            <div class="text-center text-muted">
                <i class="fas fa-eye fa-3x mb-3"></i>
                <p>Product preview will appear here as you fill the form</p>
            </div>
        `;
    }

    $('#productPreview').html(previewHtml);
}

function createProduct() {
    // Validate form
    if (!validateForm()) {
        return;
    }

    // Show loading
    const submitBtn = $('#productForm button[type="submit"]');
    const originalText = submitBtn.html();
    submitBtn.html('<i class="fas fa-spinner fa-spin me-2"></i>Creating...').prop('disabled', true);

    // Create FormData for file upload
    const formData = new FormData();
    formData.append('name', $('#productName').val());
    formData.append('sku', $('#productSku').val());
    formData.append('categoryId', $('#productCategory').val());
    formData.append('price', $('#productPrice').val());
    formData.append('stockQuantity', $('#productStock').val());
    formData.append('discountPercentage', $('#productDiscount').val());
    formData.append('shortDescription', $('#productShortDescription').val());
    formData.append('longDescription', $('#productLongDescription').val());
    formData.append('isActive', $('#isActive').is(':checked'));
    formData.append('isFeatured', $('#isFeatured').is(':checked'));

    // Optional fields
    if ($('#productImageUrl').val()) {
        formData.append('imageUrl', $('#productImageUrl').val());
    }
    if ($('#productWeight').val()) {
        formData.append('weightKg', $('#productWeight').val());
    }
    if ($('#productLength').val()) {
        formData.append('dimensionsLength', $('#productLength').val());
    }
    if ($('#productWidth').val()) {
        formData.append('dimensionsWidth', $('#productWidth').val());
    }

    // File upload
    const imageFile = $('#productImage')[0].files[0];
    if (imageFile) {
        formData.append('imageFile', imageFile);
    }

    $.ajax({
        url: '/api/products',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            if (response.success) {
                showSuccess('Product created successfully!');
                setTimeout(function() {
                    window.location.href = '/admin/products';
                }, 1500);
            } else {
                showError('Failed to create product: ' + (response.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            let errorMessage = 'Error creating product';
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

function validateForm() {
    let isValid = true;
    const errors = [];

    // Required field validation
    if (!$('#productName').val().trim()) {
        errors.push('Product name is required');
        isValid = false;
    }

    if (!$('#productSku').val().trim()) {
        errors.push('SKU is required');
        isValid = false;
    }

    if (!$('#productCategory').val()) {
        errors.push('Category is required');
        isValid = false;
    }

    if (!$('#productPrice').val() || parseFloat($('#productPrice').val()) <= 0) {
        errors.push('Valid price is required');
        isValid = false;
    }

    if (!$('#productStock').val() || parseInt($('#productStock').val()) < 0) {
        errors.push('Valid stock quantity is required');
        isValid = false;
    }

    // SKU uniqueness check
    if ($('#productSku').val().trim()) {
        // This would need an API endpoint to check SKU uniqueness
        // For now, we'll skip this validation
    }

    if (errors.length > 0) {
        showError(errors.join('<br>'));
    }

    return isValid;
}

function saveAsDraft() {
    $('#isActive').prop('checked', false);
    $('#productForm').submit();
}

function resetForm() {
    if (confirm('Are you sure you want to reset the form? All data will be lost.')) {
        $('#productForm')[0].reset();
        updatePreview();
    }
}

function showSuccess(message) {
    showAlert(message, 'success');
}

function showError(message) {
    showAlert(message, 'danger');
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
</style>
