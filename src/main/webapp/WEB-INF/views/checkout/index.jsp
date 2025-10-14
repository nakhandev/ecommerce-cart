<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Checkout" scope="request"/>

<!-- Checkout Container -->
<div class="container py-4">
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">
                <i class="fas fa-credit-card text-primary me-2"></i>Checkout
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<c:url value='/'/>">Home</a></li>
                    <li class="breadcrumb-item"><a href="<c:url value='/cart'/>">Cart</a></li>
                    <li class="breadcrumb-item active">Checkout</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div class="text-center d-none" id="loadingSpinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <div class="mt-2">Loading checkout information...</div>
    </div>

    <!-- Checkout Content -->
    <div id="checkoutContent" class="d-none">
        <div class="row">
            <!-- Left Column - Forms -->
            <div class="col-lg-8">
                <!-- Shipping Address Section -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-truck me-2 text-primary"></i>Shipping Address
                        </h5>
                    </div>
                    <div class="card-body">
                        <!-- Address Selection -->
                        <div class="mb-3">
                            <label class="form-label">Select Shipping Address</label>
                            <select class="form-select" id="shippingAddressSelect" onchange="toggleShippingAddressForm()">
                                <option value="">-- Select an address --</option>
                                <!-- Addresses will be loaded here -->
                            </select>
                        </div>

                        <!-- Add New Address Button -->
                        <div class="d-grid">
                            <button type="button" class="btn btn-outline-primary" onclick="showShippingAddressForm()">
                                <i class="fas fa-plus me-2"></i>Add New Shipping Address
                            </button>
                        </div>

                        <!-- Shipping Address Form (Hidden by default) -->
                        <div id="shippingAddressForm" class="mt-3" style="display: none;">
                            <h6 class="fw-bold mb-3">Add New Shipping Address</h6>
                            <form id="newShippingAddressForm">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="shippingFirstName" class="form-label">First Name *</label>
                                        <input type="text" class="form-control" id="shippingFirstName" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="shippingLastName" class="form-label">Last Name *</label>
                                        <input type="text" class="form-control" id="shippingLastName" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="shippingPhone" class="form-label">Phone Number *</label>
                                    <input type="tel" class="form-control" id="shippingPhone" pattern="[0-9]{10}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="shippingAddressLine1" class="form-label">Address Line 1 *</label>
                                    <input type="text" class="form-control" id="shippingAddressLine1" required>
                                </div>

                                <div class="mb-3">
                                    <label for="shippingAddressLine2" class="form-label">Address Line 2</label>
                                    <input type="text" class="form-control" id="shippingAddressLine2">
                                </div>

                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label for="shippingCity" class="form-label">City *</label>
                                        <input type="text" class="form-control" id="shippingCity" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="shippingState" class="form-label">State *</label>
                                        <select class="form-select" id="shippingState" required>
                                            <option value="">Select State</option>
                                            <option value="Andhra Pradesh">Andhra Pradesh</option>
                                            <option value="Arunachal Pradesh">Arunachal Pradesh</option>
                                            <option value="Assam">Assam</option>
                                            <option value="Bihar">Bihar</option>
                                            <option value="Chhattisgarh">Chhattisgarh</option>
                                            <option value="Goa">Goa</option>
                                            <option value="Gujarat">Gujarat</option>
                                            <option value="Haryana">Haryana</option>
                                            <option value="Himachal Pradesh">Himachal Pradesh</option>
                                            <option value="Jharkhand">Jharkhand</option>
                                            <option value="Karnataka">Karnataka</option>
                                            <option value="Kerala">Kerala</option>
                                            <option value="Madhya Pradesh">Madhya Pradesh</option>
                                            <option value="Maharashtra">Maharashtra</option>
                                            <option value="Manipur">Manipur</option>
                                            <option value="Meghalaya">Meghalaya</option>
                                            <option value="Mizoram">Mizoram</option>
                                            <option value="Nagaland">Nagaland</option>
                                            <option value="Odisha">Odisha</option>
                                            <option value="Punjab">Punjab</option>
                                            <option value="Rajasthan">Rajasthan</option>
                                            <option value="Sikkim">Sikkim</option>
                                            <option value="Tamil Nadu">Tamil Nadu</option>
                                            <option value="Telangana">Telangana</option>
                                            <option value="Tripura">Tripura</option>
                                            <option value="Uttar Pradesh">Uttar Pradesh</option>
                                            <option value="Uttarakhand">Uttarakhand</option>
                                            <option value="West Bengal">West Bengal</option>
                                            <option value="Delhi">Delhi</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="shippingPincode" class="form-label">Pincode *</label>
                                        <input type="text" class="form-control" id="shippingPincode" pattern="[0-9]{6}" required>
                                    </div>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-primary" onclick="saveShippingAddress()">
                                        <i class="fas fa-save me-2"></i>Save Address
                                    </button>
                                    <button type="button" class="btn btn-secondary" onclick="hideShippingAddressForm()">
                                        Cancel
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Billing Address Section -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-receipt me-2 text-primary"></i>Billing Address
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="sameAsShipping" checked onchange="toggleBillingAddress()">
                            <label class="form-check-label" for="sameAsShipping">
                                Same as shipping address
                            </label>
                        </div>

                        <div id="billingAddressSection" style="display: none;">
                            <!-- Billing Address Selection -->
                            <div class="mb-3">
                                <label class="form-label">Select Billing Address</label>
                                <select class="form-select" id="billingAddressSelect" onchange="toggleBillingAddressForm()">
                                    <option value="">-- Select an address --</option>
                                    <!-- Addresses will be loaded here -->
                                </select>
                            </div>

                            <!-- Add New Billing Address Button -->
                            <div class="d-grid">
                                <button type="button" class="btn btn-outline-primary" onclick="showBillingAddressForm()">
                                    <i class="fas fa-plus me-2"></i>Add New Billing Address
                                </button>
                            </div>

                            <!-- Billing Address Form (Hidden by default) -->
                            <div id="billingAddressForm" class="mt-3" style="display: none;">
                                <h6 class="fw-bold mb-3">Add New Billing Address</h6>
                                <form id="newBillingAddressForm">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="billingFirstName" class="form-label">First Name *</label>
                                            <input type="text" class="form-control" id="billingFirstName" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="billingLastName" class="form-label">Last Name *</label>
                                            <input type="text" class="form-control" id="billingLastName" required>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="billingPhone" class="form-label">Phone Number *</label>
                                        <input type="tel" class="form-control" id="billingPhone" pattern="[0-9]{10}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="billingAddressLine1" class="form-label">Address Line 1 *</label>
                                        <input type="text" class="form-control" id="billingAddressLine1" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="billingAddressLine2" class="form-label">Address Line 2</label>
                                        <input type="text" class="form-control" id="billingAddressLine2">
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label for="billingCity" class="form-label">City *</label>
                                            <input type="text" class="form-control" id="billingCity" required>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label for="billingState" class="form-label">State *</label>
                                            <select class="form-select" id="billingState" required>
                                                <option value="">Select State</option>
                                                <option value="Andhra Pradesh">Andhra Pradesh</option>
                                                <option value="Arunachal Pradesh">Arunachal Pradesh</option>
                                                <option value="Assam">Assam</option>
                                                <option value="Bihar">Bihar</option>
                                                <option value="Chhattisgarh">Chhattisgarh</option>
                                                <option value="Goa">Goa</option>
                                                <option value="Gujarat">Gujarat</option>
                                                <option value="Haryana">Haryana</option>
                                                <option value="Himachal Pradesh">Himachal Pradesh</option>
                                                <option value="Jharkhand">Jharkhand</option>
                                                <option value="Karnataka">Karnataka</option>
                                                <option value="Kerala">Kerala</option>
                                                <option value="Madhya Pradesh">Madhya Pradesh</option>
                                                <option value="Maharashtra">Maharashtra</option>
                                                <option value="Manipur">Manipur</option>
                                                <option value="Meghalaya">Meghalaya</option>
                                                <option value="Mizoram">Mizoram</option>
                                                <option value="Nagaland">Nagaland</option>
                                                <option value="Odisha">Odisha</option>
                                                <option value="Punjab">Punjab</option>
                                                <option value="Rajasthan">Rajasthan</option>
                                                <option value="Sikkim">Sikkim</option>
                                                <option value="Tamil Nadu">Tamil Nadu</option>
                                                <option value="Telangana">Telangana</option>
                                                <option value="Tripura">Tripura</option>
                                                <option value="Uttar Pradesh">Uttar Pradesh</option>
                                                <option value="Uttarakhand">Uttarakhand</option>
                                                <option value="West Bengal">West Bengal</option>
                                                <option value="Delhi">Delhi</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label for="billingPincode" class="form-label">Pincode *</label>
                                            <input type="text" class="form-control" id="billingPincode" pattern="[0-9]{6}" required>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-primary" onclick="saveBillingAddress()">
                                            <i class="fas fa-save me-2"></i>Save Address
                                        </button>
                                        <button type="button" class="btn btn-secondary" onclick="hideBillingAddressForm()">
                                            Cancel
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Notes -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-sticky-note me-2 text-primary"></i>Order Notes (Optional)
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="orderNotes" class="form-label">Special delivery instructions or notes</label>
                            <textarea class="form-control" id="orderNotes" rows="3"
                                      placeholder="Add any special instructions for delivery or notes about your order..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="d-flex justify-content-between">
                    <a href="<c:url value='/cart'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Cart
                    </a>
                    <button type="button" class="btn btn-primary btn-lg" onclick="proceedToPayment()">
                        Continue to Payment <i class="fas fa-arrow-right ms-2"></i>
                    </button>
                </div>
            </div>

            <!-- Right Column - Order Summary -->
            <div class="col-lg-4">
                <div class="card shadow-sm sticky-top" style="top: 20px;">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Order Summary</h5>
                    </div>
                    <div class="card-body">
                        <!-- Cart Items -->
                        <div id="orderItemsList">
                            <!-- Items will be loaded here -->
                        </div>

                        <hr>

                        <!-- Order Totals -->
                        <div class="row mb-2">
                            <div class="col-6">Subtotal:</div>
                            <div class="col-6 text-end" id="summarySubtotal">₹0.00</div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-6">Shipping:</div>
                            <div class="col-6 text-end" id="summaryShipping">₹0.00</div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-6">Tax (GST):</div>
                            <div class="col-6 text-end" id="summaryTax">₹0.00</div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-6">Discount:</div>
                            <div class="col-6 text-end text-success" id="summaryDiscount">-₹0.00</div>
                        </div>

                        <hr>

                        <div class="row mb-3">
                            <div class="col-6">
                                <strong>Total:</strong>
                            </div>
                            <div class="col-6 text-end">
                                <strong class="text-primary" id="summaryTotal">₹0.00</strong>
                            </div>
                        </div>

                        <!-- Security Badge -->
                        <div class="text-center">
                            <small class="text-muted">
                                <i class="fas fa-shield-alt text-success me-1"></i>
                                Secure Checkout
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Address Form Template -->
<div class="d-none">
    <select id="addressTemplate">
        <option value="">-- Select an address --</option>
    </select>
</div>

<script>
let currentCart = {};
let userAddresses = [];
let selectedShippingAddress = null;
let selectedBillingAddress = null;

$(document).ready(function() {
    loadCheckoutData();

    // Auto-refresh cart data every 30 seconds
    setInterval(function() {
        if (!$('#loadingSpinner').hasClass('d-none')) {
            loadCartSummary();
        }
    }, 30000);
});

function loadCheckoutData() {
    $('#loadingSpinner').removeClass('d-none');
    $('#checkoutContent').addClass('d-none');

    // Check if user is logged in
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            loadUserAddresses();
            loadCartSummary();
        </c:when>
        <c:otherwise>
            // Redirect to login if not logged in
            window.location.href = '/auth/login?redirect=/checkout';
        </c:otherwise>
    </c:choose>
}

function loadUserAddresses() {
    const userId = <c:out value="${sessionScope.user.id}"/>;

    $.ajax({
        url: '/api/user/addresses',
        type: 'GET',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                userAddresses = response.data || [];
                renderAddressOptions();
            }
        },
        error: function() {
            console.error('Error loading user addresses');
        }
    });
}

function loadCartSummary() {
    const userId = <c:out value="${sessionScope.user.id}"/>;

    $.ajax({
        url: '/api/cart',
        type: 'GET',
        data: { userId: userId },
        success: function(response) {
            if (response.success) {
                currentCart = response.data;
                renderOrderSummary(currentCart);
            } else {
                // Redirect to cart if empty
                window.location.href = '<c:url value="/cart"/>';
            }
        },
        error: function() {
            showError('Error loading cart information');
        },
        complete: function() {
            $('#loadingSpinner').addClass('d-none');
            $('#checkoutContent').removeClass('d-none');
        }
    });
}

function renderAddressOptions() {
    const shippingSelect = $('#shippingAddressSelect');
    const billingSelect = $('#billingAddressSelect');

    // Clear existing options (except the first one)
    shippingSelect.find('option:not(:first)').remove();
    billingSelect.find('option:not(:first)').remove();

    // Add addresses to both selects
    userAddresses.forEach(function(address) {
        const optionHtml = `<option value="${address.id}">
            ${address.firstName} ${address.lastName}, ${address.addressLine1}, ${address.city}, ${address.state} - ${address.pincode}
        </option>`;

        shippingSelect.append(optionHtml);
        billingSelect.append(optionHtml);
    });
}

function renderOrderSummary(cart) {
    if (!cart || !cart.items || cart.items.length === 0) {
        window.location.href = '<c:url value="/cart"/>';
        return;
    }

    // Render cart items
    let itemsHtml = '';
    cart.items.forEach(function(item) {
        itemsHtml += `
            <div class="d-flex justify-content-between align-items-center mb-2">
                <div class="flex-grow-1">
                    <small class="fw-bold">${item.productName}</small>
                    <br>
                    <small class="text-muted">Qty: ${item.quantity}</small>
                </div>
                <div class="text-end">
                    <small class="fw-bold">₹${item.subtotal.toFixed(2)}</small>
                </div>
            </div>
        `;
    });

    $('#orderItemsList').html(itemsHtml);

    // Update totals
    const subtotal = cart.totalAmount || 0;
    const shipping = subtotal > 500 ? 0 : 50; // Free shipping over ₹500
    const tax = subtotal * 0.18; // 18% GST
    const total = subtotal + shipping + tax;

    $('#summarySubtotal').text(`₹${subtotal.toFixed(2)}`);
    $('#summaryShipping').text(shipping === 0 ? 'FREE' : `₹${shipping.toFixed(2)}`);
    $('#summaryTax').text(`₹${tax.toFixed(2)}`);
    $('#summaryTotal').text(`₹${total.toFixed(2)}`);
}

function toggleShippingAddressForm() {
    const select = $('#shippingAddressSelect');
    const selectedValue = select.val();

    if (selectedValue) {
        // Find selected address
        selectedShippingAddress = userAddresses.find(addr => addr.id == selectedValue);
        $('#shippingAddressForm').hide();
    } else {
        selectedShippingAddress = null;
    }
}

function toggleBillingAddress() {
    const sameAsShipping = $('#sameAsShipping').is(':checked');

    if (sameAsShipping) {
        $('#billingAddressSection').hide();
        selectedBillingAddress = selectedShippingAddress;
    } else {
        $('#billingAddressSection').show();
        selectedBillingAddress = null;
    }
}

function showShippingAddressForm() {
    $('#shippingAddressForm').show();
    $('#shippingAddressSelect').val('');
    selectedShippingAddress = null;

    // Clear form
    $('#newShippingAddressForm')[0].reset();
}

function hideShippingAddressForm() {
    $('#shippingAddressForm').hide();

    // Restore previous selection if any
    if (selectedShippingAddress) {
        $('#shippingAddressSelect').val(selectedShippingAddress.id);
    }
}

function showBillingAddressForm() {
    $('#billingAddressForm').show();
    $('#billingAddressSelect').val('');
    selectedBillingAddress = null;

    // Clear form
    $('#newBillingAddressForm')[0].reset();
}

function hideBillingAddressForm() {
    $('#billingAddressForm').hide();

    // Restore previous selection if any
    if (selectedBillingAddress) {
        $('#billingAddressSelect').val(selectedBillingAddress.id);
    }
}

function saveShippingAddress() {
    const addressData = {
        firstName: $('#shippingFirstName').val(),
        lastName: $('#shippingLastName').val(),
        phone: $('#shippingPhone').val(),
        addressLine1: $('#shippingAddressLine1').val(),
        addressLine2: $('#shippingAddressLine2').val(),
        city: $('#shippingCity').val(),
        state: $('#shippingState').val(),
        pincode: $('#shippingPincode').val(),
        type: 'SHIPPING'
    };

    // Validate required fields
    if (!addressData.firstName || !addressData.lastName || !addressData.phone ||
        !addressData.addressLine1 || !addressData.city || !addressData.state || !addressData.pincode) {
        showError('Please fill in all required fields');
        return;
    }

    const userId = <c:out value="${sessionScope.user.id}"/>;

    $.ajax({
        url: '/api/user/addresses',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ ...addressData, userId: userId }),
        success: function(response) {
            if (response.success) {
                showSuccess('Shipping address saved successfully');
                loadUserAddresses();
                hideShippingAddressForm();
            } else {
                showError('Failed to save shipping address');
            }
        },
        error: function() {
            showError('Error saving shipping address');
        }
    });
}

function saveBillingAddress() {
    const addressData = {
        firstName: $('#billingFirstName').val(),
        lastName: $('#billingLastName').val(),
        phone: $('#billingPhone').val(),
        addressLine1: $('#billingAddressLine1').val(),
        addressLine2: $('#billingAddressLine2').val(),
        city: $('#billingCity').val(),
        state: $('#billingState').val(),
        pincode: $('#billingPincode').val(),
        type: 'BILLING'
    };

    // Validate required fields
    if (!addressData.firstName || !addressData.lastName || !addressData.phone ||
        !addressData.addressLine1 || !addressData.city || !addressData.state || !addressData.pincode) {
        showError('Please fill in all required fields');
        return;
    }

    const userId = <c:out value="${sessionScope.user.id}"/>;

    $.ajax({
        url: '/api/user/addresses',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ ...addressData, userId: userId }),
        success: function(response) {
            if (response.success) {
                showSuccess('Billing address saved successfully');
                loadUserAddresses();
                hideBillingAddressForm();
            } else {
                showError('Failed to save billing address');
            }
        },
        error: function() {
            showError('Error saving billing address');
        }
    });
}

function proceedToPayment() {
    // Validate that shipping address is selected
    if (!selectedShippingAddress) {
        showError('Please select a shipping address');
        return;
    }

    // If billing address is different from shipping, validate it too
    if (!$('#sameAsShipping').is(':checked') && !selectedBillingAddress) {
        showError('Please select a billing address');
        return;
    }

    // Use shipping address as billing address if same
    if (!$('#sameAsShipping').is(':checked')) {
        selectedBillingAddress = userAddresses.find(addr => addr.id == $('#billingAddressSelect').val());
    }

    // Store checkout data in session storage for next step
    const checkoutData = {
        shippingAddress: selectedShippingAddress,
        billingAddress: selectedBillingAddress,
        orderNotes: $('#orderNotes').val(),
        cart: currentCart
    };

    sessionStorage.setItem('checkoutData', JSON.stringify(checkoutData));

    // Proceed to payment page
    window.location.href = '<c:url value="/checkout/payment"/>';
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

    // Remove existing alerts
    $('.alert').remove();

    // Add new alert at the top of the page
    $('.container:first').prepend(alertHtml);

    // Auto-hide after 5 seconds
    setTimeout(() => $('.alert').fadeOut(), 5000);
}
</script>

<style>
.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.sticky-top {
    top: 20px !important;
}

.form-check-input:checked {
    background-color: #0d6efd;
    border-color: #0d6efd;
}

.btn-outline-primary:hover {
    background-color: #0d6efd;
    border-color: #0d6efd;
}

@media (max-width: 768px) {
    .sticky-top {
        position: static !important;
    }

    .d-flex.justify-content-between {
        flex-direction: column;
        gap: 1rem;
    }
}
</style>
