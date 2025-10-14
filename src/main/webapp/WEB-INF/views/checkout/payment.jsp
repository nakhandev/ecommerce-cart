<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Payment" scope="request"/>

<!-- Payment Container -->
<div class="container py-4">
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">
                <i class="fas fa-credit-card text-primary me-2"></i>Payment Method
            </h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<c:url value='/'/>">Home</a></li>
                    <li class="breadcrumb-item"><a href="<c:url value='/cart'/>">Cart</a></li>
                    <li class="breadcrumb-item"><a href="<c:url value='/checkout'/>">Checkout</a></li>
                    <li class="breadcrumb-item active">Payment</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div class="text-center d-none" id="loadingSpinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <div class="mt-2">Loading payment information...</div>
    </div>

    <!-- Payment Content -->
    <div id="paymentContent" class="d-none">
        <div class="row">
            <!-- Left Column - Payment Methods -->
            <div class="col-lg-8">
                <!-- Payment Method Selection -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-wallet me-2 text-primary"></i>Choose Payment Method
                        </h5>
                    </div>
                    <div class="card-body">
                        <!-- Credit/Debit Card -->
                        <div class="payment-method-option mb-4" data-method="card">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="cardPayment" value="CARD" checked>
                                <label class="form-check-label" for="cardPayment">
                                    <strong>Credit/Debit Card</strong>
                                    <br>
                                    <small class="text-muted">Pay securely with your Visa, MasterCard, or RuPay</small>
                                </label>
                                <div class="payment-icons mt-2">
                                    <i class="fab fa-cc-visa fa-2x text-primary me-2"></i>
                                    <i class="fab fa-cc-mastercard fa-2x text-danger me-2"></i>
                                    <i class="fab fa-cc-amex fa-2x text-info me-2"></i>
                                    <i class="fas fa-credit-card fa-2x text-success"></i>
                                </div>
                            </div>

                            <!-- Card Form -->
                            <div id="cardForm" class="payment-form mt-3">
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <label for="cardNumber" class="form-label">Card Number *</label>
                                        <input type="text" class="form-control" id="cardNumber"
                                               placeholder="1234 5678 9012 3456" maxlength="19" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="expiryDate" class="form-label">Expiry Date *</label>
                                        <input type="text" class="form-control" id="expiryDate"
                                               placeholder="MM/YY" maxlength="5" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="cvv" class="form-label">CVV *</label>
                                        <input type="text" class="form-control" id="cvv"
                                               placeholder="123" maxlength="4" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="cardHolderName" class="form-label">Cardholder Name *</label>
                                    <input type="text" class="form-control" id="cardHolderName" required>
                                </div>
                            </div>
                        </div>

                        <hr>

                        <!-- UPI -->
                        <div class="payment-method-option mb-4" data-method="upi">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="upiPayment" value="UPI">
                                <label class="form-check-label" for="upiPayment">
                                    <strong>UPI (Unified Payments Interface)</strong>
                                    <br>
                                    <small class="text-muted">Pay instantly using UPI apps like Google Pay, PhonePe, Paytm</small>
                                </label>
                                <div class="payment-icons mt-2">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/UPI_Logo.png/100px-UPI_Logo.png"
                                         alt="UPI" style="height: 30px;" class="me-2">
                                    <i class="fab fa-google-pay fa-2x text-primary me-2"></i>
                                    <i class="fas fa-mobile-alt fa-2x text-success me-2"></i>
                                    <span class="badge bg-info">PhonePe</span>
                                    <span class="badge bg-primary ms-2">Paytm</span>
                                </div>
                            </div>

                            <!-- UPI Form -->
                            <div id="upiForm" class="payment-form mt-3" style="display: none;">
                                <div class="mb-3">
                                    <label for="upiId" class="form-label">UPI ID *</label>
                                    <input type="text" class="form-control" id="upiId"
                                           placeholder="yourname@upi" required>
                                    <div class="form-text">Enter your UPI ID (e.g., john@oksbi, john@paytm)</div>
                                </div>

                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    You will be redirected to your UPI app to complete the payment.
                                </div>
                            </div>
                        </div>

                        <hr>

                        <!-- Net Banking -->
                        <div class="payment-method-option mb-4" data-method="netbanking">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="netBankingPayment" value="NET_BANKING">
                                <label class="form-check-label" for="netBankingPayment">
                                    <strong>Net Banking</strong>
                                    <br>
                                    <small class="text-muted">Pay directly from your bank account</small>
                                </label>
                                <div class="payment-icons mt-2">
                                    <i class="fas fa-university fa-2x text-secondary me-2"></i>
                                    <span class="badge bg-light text-dark">SBI</span>
                                    <span class="badge bg-light text-dark ms-1">HDFC</span>
                                    <span class="badge bg-light text-dark ms-1">ICICI</span>
                                    <span class="badge bg-light text-dark ms-1">Axis</span>
                                </div>
                            </div>

                            <!-- Net Banking Form -->
                            <div id="netBankingForm" class="payment-form mt-3" style="display: none;">
                                <div class="mb-3">
                                    <label for="bankSelect" class="form-label">Select Your Bank *</label>
                                    <select class="form-select" id="bankSelect" required>
                                        <option value="">Choose your bank...</option>
                                        <option value="SBI">State Bank of India</option>
                                        <option value="HDFC">HDFC Bank</option>
                                        <option value="ICICI">ICICI Bank</option>
                                        <option value="AXIS">Axis Bank</option>
                                        <option value="PNB">Punjab National Bank</option>
                                        <option value="BOI">Bank of India</option>
                                        <option value="BOB">Bank of Baroda</option>
                                        <option value="KOTAK">Kotak Mahindra Bank</option>
                                        <option value="INDUSIND">IndusInd Bank</option>
                                        <option value="YES">Yes Bank</option>
                                        <option value="FEDERAL">Federal Bank</option>
                                        <option value="IDBI">IDBI Bank</option>
                                        <option value="RBL">RBL Bank</option>
                                        <option value="BANDHAN">Bandhan Bank</option>
                                        <option value="OTHER">Other Banks</option>
                                    </select>
                                </div>

                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    You will be redirected to your bank's secure payment page.
                                </div>
                            </div>
                        </div>

                        <hr>

                        <!-- Cash on Delivery -->
                        <div class="payment-method-option mb-4" data-method="cod">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="codPayment" value="COD">
                                <label class="form-check-label" for="codPayment">
                                    <strong>Cash on Delivery</strong>
                                    <br>
                                    <small class="text-muted">Pay with cash when your order is delivered</small>
                                </label>
                                <div class="payment-icons mt-2">
                                    <i class="fas fa-money-bill-wave fa-2x text-success me-2"></i>
                                    <i class="fas fa-truck fa-2x text-primary me-2"></i>
                                    <span class="badge bg-success">Cash Payment</span>
                                </div>
                            </div>

                            <!-- COD Info -->
                            <div id="codForm" class="payment-form mt-3" style="display: none;">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <strong>Cash on Delivery Available!</strong>
                                    <br>
                                    Pay with cash when your order arrives at your doorstep. No online payment required.
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Delivery Instructions</label>
                                    <textarea class="form-control" id="codInstructions" rows="2"
                                              placeholder="Any special instructions for delivery (optional)"></textarea>
                                </div>
                            </div>
                        </div>

                        <hr>

                        <!-- Wallet Payments -->
                        <div class="payment-method-option mb-4" data-method="wallet">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="walletPayment" value="WALLET">
                                <label class="form-check-label" for="walletPayment">
                                    <strong>Digital Wallets</strong>
                                    <br>
                                    <small class="text-muted">Pay using Paytm, PhonePe, Amazon Pay, or other wallets</small>
                                </label>
                                <div class="payment-icons mt-2">
                                    <span class="badge bg-primary me-2">Paytm</span>
                                    <span class="badge bg-success me-2">PhonePe</span>
                                    <span class="badge bg-warning text-dark me-2">Amazon Pay</span>
                                    <span class="badge bg-info me-2">FreeCharge</span>
                                </div>
                            </div>

                            <!-- Wallet Form -->
                            <div id="walletForm" class="payment-form mt-3" style="display: none;">
                                <div class="mb-3">
                                    <label for="walletSelect" class="form-label">Select Wallet *</label>
                                    <select class="form-select" id="walletSelect" required>
                                        <option value="">Choose your wallet...</option>
                                        <option value="PAYTM">Paytm</option>
                                        <option value="PHONEPE">PhonePe</option>
                                        <option value="AMAZON_PAY">Amazon Pay</option>
                                        <option value="FREECHARGE">FreeCharge</option>
                                        <option value="MOBIKWIK">MobiKwik</option>
                                        <option value="JIO_MONEY">JioMoney</option>
                                        <option value="AIRTEL_MONEY">Airtel Money</option>
                                    </select>
                                </div>

                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    You will be redirected to your wallet app to complete the payment.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Security Information -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h6 class="fw-bold text-success mb-3">
                            <i class="fas fa-shield-alt me-2"></i>Secure Payment
                        </h6>
                        <div class="row text-center">
                            <div class="col-md-4 mb-2">
                                <i class="fas fa-lock fa-2x text-success mb-2"></i>
                                <div class="small">SSL Encrypted</div>
                            </div>
                            <div class="col-md-4 mb-2">
                                <i class="fas fa-user-shield fa-2x text-primary mb-2"></i>
                                <div class="small">PCI Compliant</div>
                            </div>
                            <div class="col-md-4 mb-2">
                                <i class="fas fa-thumbs-up fa-2x text-info mb-2"></i>
                                <div class="small">100% Secure</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="d-flex justify-content-between">
                    <a href="<c:url value='/checkout'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Information
                    </a>
                    <button type="button" class="btn btn-success btn-lg" onclick="processPayment()">
                        <i class="fas fa-lock me-2"></i>Complete Order
                    </button>
                </div>
            </div>

            <!-- Right Column - Order Summary -->
            <div class="col-lg-4">
                <!-- Order Summary -->
                <div class="card shadow-sm sticky-top" style="top: 20px;">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Order Summary</h5>
                    </div>
                    <div class="card-body">
                        <!-- Delivery Address -->
                        <div class="mb-3">
                            <h6 class="fw-bold">Delivery Address</h6>
                            <div id="deliveryAddressDisplay">
                                <!-- Address will be loaded here -->
                            </div>
                        </div>

                        <hr>

                        <!-- Cart Items -->
                        <div id="paymentOrderItems">
                            <!-- Items will be loaded here -->
                        </div>

                        <hr>

                        <!-- Order Totals -->
                        <div class="row mb-2">
                            <div class="col-6">Subtotal:</div>
                            <div class="col-6 text-end" id="paymentSubtotal">₹0.00</div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-6">Shipping:</div>
                            <div class="col-6 text-end" id="paymentShipping">₹0.00</div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-6">Tax (GST):</div>
                            <div class="col-6 text-end" id="paymentTax">₹0.00</div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-6">Discount:</div>
                            <div class="col-6 text-end text-success" id="paymentDiscount">-₹0.00</div>
                        </div>

                        <hr>

                        <div class="row mb-3">
                            <div class="col-6">
                                <strong>Total:</strong>
                            </div>
                            <div class="col-6 text-end">
                                <strong class="text-success" id="paymentTotal">₹0.00</strong>
                            </div>
                        </div>

                        <!-- Selected Payment Method -->
                        <div class="mb-3">
                            <small class="text-muted">Payment Method:</small>
                            <div id="selectedPaymentMethod" class="fw-bold">Credit/Debit Card</div>
                        </div>
                    </div>
                </div>

                <!-- Payment Security -->
                <div class="card shadow-sm mt-3">
                    <div class="card-body text-center">
                        <h6 class="text-success mb-3">
                            <i class="fas fa-shield-alt me-2"></i>Your Payment is Secure
                        </h6>
                        <p class="small text-muted mb-0">
                            We use industry-standard encryption to protect your payment information.
                            Your card details are never stored on our servers.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
let checkoutData = {};
let selectedPaymentMethod = 'CARD';

$(document).ready(function() {
    loadPaymentData();

    // Payment method change handler
    $('input[name="paymentMethod"]').change(function() {
        selectedPaymentMethod = $(this).val();
        togglePaymentForms();
        updatePaymentMethodDisplay();
    });

    // Card number formatting
    $('#cardNumber').on('input', function() {
        let value = $(this).val().replace(/\s/g, '');
        if (value.length > 0) {
            value = value.match(new RegExp('.{1,4}', 'g')).join(' ');
        }
        $(this).val(value);
    });

    // Expiry date formatting
    $('#expiryDate').on('input', function() {
        let value = $(this).val().replace(/\D/g, '');
        if (value.length >= 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }
        $(this).val(value);
    });

    // CVV input restriction
    $('#cvv').on('input', function() {
        $(this).val($(this).val().replace(/\D/g, ''));
    });
});

function loadPaymentData() {
    $('#loadingSpinner').removeClass('d-none');
    $('#paymentContent').addClass('d-none');

    // Load checkout data from session storage
    const storedData = sessionStorage.getItem('checkoutData');
    if (!storedData) {
        // Redirect to checkout if no data
        window.location.href = '/checkout';
        return;
    }

    try {
        checkoutData = JSON.parse(storedData);
        renderPaymentSummary();
        $('#loadingSpinner').addClass('d-none');
        $('#paymentContent').removeClass('d-none');
    } catch (e) {
        console.error('Error parsing checkout data:', e);
        window.location.href = '/checkout';
    }
}

function renderPaymentSummary() {
    // Display delivery address
    if (checkoutData.shippingAddress) {
        const addr = checkoutData.shippingAddress;
        $('#deliveryAddressDisplay').html(`
            <div class="small">
                <strong>${addr.firstName} ${addr.lastName}</strong><br>
                ${addr.addressLine1}${addr.addressLine2 ? ', ' + addr.addressLine2 : ''}<br>
                ${addr.city}, ${addr.state} - ${addr.pincode}<br>
                Phone: ${addr.phone}
            </div>
        `);
    }

    // Display order items and totals
    if (checkoutData.cart && checkoutData.cart.items) {
        let itemsHtml = '';
        checkoutData.cart.items.forEach(function(item) {
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

        $('#paymentOrderItems').html(itemsHtml);

        // Update totals
        const subtotal = checkoutData.cart.totalAmount || 0;
        const shipping = subtotal > 500 ? 0 : 50;
        const tax = subtotal * 0.18;
        const total = subtotal + shipping + tax;

        $('#paymentSubtotal').text(`₹${subtotal.toFixed(2)}`);
        $('#paymentShipping').text(shipping === 0 ? 'FREE' : `₹${shipping.toFixed(2)}`);
        $('#paymentTax').text(`₹${tax.toFixed(2)}`);
        $('#paymentTotal').text(`₹${total.toFixed(2)}`);
    }
}

function togglePaymentForms() {
    // Hide all payment forms
    $('.payment-form').hide();

    // Show selected payment form
    const selectedMethod = $('input[name="paymentMethod"]:checked').val();
    switch (selectedMethod) {
        case 'CARD':
            $('#cardForm').show();
            break;
        case 'UPI':
            $('#upiForm').show();
            break;
        case 'NET_BANKING':
            $('#netBankingForm').show();
            break;
        case 'COD':
            $('#codForm').show();
            break;
        case 'WALLET':
            $('#walletForm').show();
            break;
    }
}

function updatePaymentMethodDisplay() {
    const methodNames = {
        'CARD': 'Credit/Debit Card',
        'UPI': 'UPI Payment',
        'NET_BANKING': 'Net Banking',
        'COD': 'Cash on Delivery',
        'WALLET': 'Digital Wallet'
    };

    $('#selectedPaymentMethod').text(methodNames[selectedPaymentMethod] || 'Credit/Debit Card');
}

function processPayment() {
    // Show loading state
    const button = event.target;
    const originalText = button.innerHTML;
    button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';
    button.disabled = true;

    // Validate payment form based on selected method
    if (!validatePaymentForm()) {
        button.innerHTML = originalText;
        button.disabled = false;
        return;
    }

    // Collect payment data
    const paymentData = {
        method: selectedPaymentMethod,
        amount: checkoutData.cart.totalAmount,
        data: getPaymentFormData()
    };

    // Process the order
    createOrder(paymentData)
        .then(function(response) {
            if (response.success) {
                // Clear cart and checkout data
                clearCheckoutData();

                // Redirect to confirmation page
                window.location.href = '/checkout/confirmation?orderId=' + response.data.id;
            } else {
                throw new Error(response.message || 'Payment processing failed');
            }
        })
        .catch(function(error) {
            console.error('Payment error:', error);
            showError('Payment processing failed: ' + error.message);
        })
        .finally(function() {
            button.innerHTML = originalText;
            button.disabled = false;
        });
}

function validatePaymentForm() {
    switch (selectedPaymentMethod) {
        case 'CARD':
            return validateCardForm();
        case 'UPI':
            return validateUPIForm();
        case 'NET_BANKING':
            return validateNetBankingForm();
        case 'COD':
            return true; // COD doesn't need validation
        case 'WALLET':
            return validateWalletForm();
        default:
            return false;
    }
}

function validateCardForm() {
    const cardNumber = $('#cardNumber').val().replace(/\s/g, '');
    const expiryDate = $('#expiryDate').val();
    const cvv = $('#cvv').val();
    const cardHolderName = $('#cardHolderName').val();

    if (cardNumber.length < 13 || cardNumber.length > 19) {
        showError('Please enter a valid card number');
        return false;
    }

    if (!/^\d{2}\/\d{2}$/.test(expiryDate)) {
        showError('Please enter a valid expiry date (MM/YY)');
        return false;
    }

    if (cvv.length < 3 || cvv.length > 4) {
        showError('Please enter a valid CVV');
        return false;
    }

    if (!cardHolderName.trim()) {
        showError('Please enter the cardholder name');
        return false;
    }

    return true;
}

function validateUPIForm() {
    const upiId = $('#upiId').val().trim();

    if (!upiId) {
        showError('Please enter your UPI ID');
        return false;
    }

    // Basic UPI ID validation
    const upiPattern = /^[\w\.-]+@[\w\.-]+$/;
    if (!upiPattern.test(upiId)) {
        showError('Please enter a valid UPI ID');
        return false;
    }

    return true;
}

function validateNetBankingForm() {
    const bankSelect = $('#bankSelect').val();

    if (!bankSelect) {
        showError('Please select your bank');
        return false;
    }

    return true;
}

function validateWalletForm() {
    const walletSelect = $('#walletSelect').val();

    if (!walletSelect) {
        showError('Please select your wallet');
        return false;
    }

    return true;
}

function getPaymentFormData() {
    switch (selectedPaymentMethod) {
        case 'CARD':
            return {
                cardNumber: $('#cardNumber').val().replace(/\s/g, ''),
                expiryDate: $('#expiryDate').val(),
                cvv: $('#cvv').val(),
                cardHolderName: $('#cardHolderName').val()
            };
        case 'UPI':
            return {
                upiId: $('#upiId').val().trim()
            };
        case 'NET_BANKING':
            return {
                bankCode: $('#bankSelect').val()
            };
        case 'COD':
            return {
                instructions: $('#codInstructions').val()
            };
        case 'WALLET':
            return {
                walletCode: $('#walletSelect').val()
            };
        default:
            return {};
    }
}

function createOrder(paymentData) {
    const userId = <c:out value="${sessionScope.user.id}"/>;

    // Build shipping address string
    const shippingAddr = checkoutData.shippingAddress.addressLine1 + ', ' +
                        (checkoutData.shippingAddress.addressLine2 || '') + ', ' +
                        checkoutData.shippingAddress.city + ', ' +
                        checkoutData.shippingAddress.state + ' - ' +
                        checkoutData.shippingAddress.pincode;

    // Build billing address string (same as shipping if not provided)
    const billingAddr = checkoutData.billingAddress ?
        (checkoutData.billingAddress.addressLine1 + ', ' +
         (checkoutData.billingAddress.addressLine2 || '') + ', ' +
         checkoutData.billingAddress.city + ', ' +
         checkoutData.billingAddress.state + ' - ' +
         checkoutData.billingAddress.pincode) :
        shippingAddr;

    const orderData = {
        userId: userId,
        shippingAddress: shippingAddr,
        billingAddress: billingAddr,
        orderNotes: checkoutData.orderNotes || '',
        paymentMethod: paymentData.method,
        paymentData: paymentData.data
    };

    return $.ajax({
        url: '/api/orders',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(orderData)
    }).promise();
}

function clearCheckoutData() {
    // Clear cart
    const userId = <c:out value="${sessionScope.user.id}"/>;
    $.ajax({
        url: '/api/cart',
        type: 'DELETE',
        data: { userId: userId }
    });

    // Clear session storage
    sessionStorage.removeItem('checkoutData');
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

// Initialize payment forms
$(document).ready(function() {
    togglePaymentForms();
    updatePaymentMethodDisplay();
});
</script>

<style>
.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.sticky-top {
    top: 20px !important;
}

.payment-method-option {
    padding: 1rem;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    transition: all 0.3s ease;
    cursor: pointer;
}

.payment-method-option:hover {
    border-color: #0d6efd;
    background-color: #f8f9fa;
}

.form-check-input:checked ~ .payment-method-option {
    border-color: #0d6efd;
    background-color: #f8f9fa;
}

.payment-form {
    border-top: 1px solid #e9ecef;
    margin-top: 1rem;
    padding-top: 1rem;
}

.payment-icons {
    margin-top: 0.5rem;
}

.badge {
    font-size: 0.75rem;
}

.btn-success:hover {
    background-color: #198754;
    border-color: #198754;
}

.alert {
    border: none;
    border-radius: 8px;
}

@media (max-width: 768px) {
    .sticky-top {
        position: static !important;
    }

    .d-flex.justify-content-between {
        flex-direction: column;
        gap: 1rem;
    }

    .payment-method-option {
        margin-bottom: 1rem;
    }
}
</style>
