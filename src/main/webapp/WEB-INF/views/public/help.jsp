<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Page Title -->
<c:set var="pageTitle" value="Help Center" scope="request"/>

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
        .help-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding-top: 2rem;
        }

        .help-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 3rem;
        }

        .help-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .help-card-header {
            background: #667eea;
            color: white;
            padding: 1.5rem;
            border-radius: 10px 10px 0 0;
            border: none;
        }

        .help-card-body {
            padding: 2rem;
        }

        .faq-item {
            border-bottom: 1px solid #e9ecef;
            padding: 1.5rem 0;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .faq-answer {
            color: #718096;
            line-height: 1.6;
        }

        .contact-info {
            background: #e7f3ff;
            border-left: 4px solid #667eea;
            padding: 1.5rem;
            margin: 2rem 0;
        }

        .search-box {
            max-width: 500px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../includes/header.jsp"/>

    <!-- Help Hero Section -->
    <section class="help-hero">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto text-center">
                    <h1 class="display-4 fw-bold mb-3">Help Center</h1>
                    <p class="lead mb-4">Find answers to common questions and get the help you need</p>

                    <!-- Search Box -->
                    <div class="search-box">
                        <form class="d-flex">
                            <input class="form-control form-control-lg me-2" type="search"
                                   placeholder="Search for help..." aria-label="Search">
                            <button class="btn btn-light btn-lg" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <div class="help-container">
        <div class="container">
            <div class="row">
                <!-- Main Content -->
                <div class="col-lg-8">
                    <!-- Quick Help Topics -->
                    <div class="help-card card">
                        <div class="help-card-header">
                            <h3 class="mb-0"><i class="fas fa-question-circle me-2"></i>Quick Help Topics</h3>
                        </div>
                        <div class="help-card-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center p-3 bg-light rounded">
                                        <i class="fas fa-shopping-cart fa-2x text-primary me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Ordering & Payment</h6>
                                            <small class="text-muted">How to place orders and payment methods</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center p-3 bg-light rounded">
                                        <i class="fas fa-truck fa-2x text-success me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Shipping & Delivery</h6>
                                            <small class="text-muted">Track your orders and delivery information</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center p-3 bg-light rounded">
                                        <i class="fas fa-undo fa-2x text-warning me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Returns & Exchanges</h6>
                                            <small class="text-muted">How to return or exchange items</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center p-3 bg-light rounded">
                                        <i class="fas fa-user-circle fa-2x text-info me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Account & Profile</h6>
                                            <small class="text-muted">Manage your account settings</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- FAQ Section -->
                    <div class="help-card card">
                        <div class="help-card-header">
                            <h3 class="mb-0"><i class="fas fa-list me-2"></i>Frequently Asked Questions</h3>
                        </div>
                        <div class="help-card-body">
                            <div class="faq-item">
                                <div class="faq-question">How do I place an order?</div>
                                <div class="faq-answer">
                                    To place an order, simply browse our products, add items to your cart, and proceed to checkout.
                                    You'll need to provide shipping information and select a payment method to complete your purchase.
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question">What payment methods do you accept?</div>
                                <div class="faq-answer">
                                    We accept all major credit cards (Visa, MasterCard, American Express), debit cards,
                                    net banking, UPI payments, and digital wallets for your convenience.
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question">How long does delivery take?</div>
                                <div class="faq-answer">
                                    Standard delivery typically takes 3-5 business days. Express delivery options are available
                                    for most locations and can deliver within 1-2 business days.
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question">Can I return or exchange items?</div>
                                <div class="faq-answer">
                                    Yes, we offer a 30-day return policy for most items. Items must be in their original condition
                                    with tags attached. Some items like personalized products may not be eligible for return.
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question">How do I track my order?</div>
                                <div class="faq-answer">
                                    Once your order is shipped, you'll receive a tracking number via email. You can also
                                    track your order by logging into your account and visiting the "My Orders" section.
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question">Do you offer international shipping?</div>
                                <div class="faq-answer">
                                    Currently, we only ship within India. We're working on expanding our shipping options
                                    to serve customers internationally in the near future.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="col-lg-4">
                    <!-- Contact Information -->
                    <div class="help-card card">
                        <div class="help-card-header">
                            <h5 class="mb-0"><i class="fas fa-phone me-2"></i>Contact Us</h5>
                        </div>
                        <div class="help-card-body">
                            <div class="contact-info">
                                <h6>Need more help?</h6>
                                <p class="mb-3">Our customer support team is here to help you with any questions or concerns.</p>

                                <div class="mb-3">
                                    <strong><i class="fas fa-envelope me-2"></i>Email:</strong><br>
                                    <a href="mailto:support@eshop.com">support@eshop.com</a>
                                </div>

                                <div class="mb-3">
                                    <strong><i class="fas fa-phone me-2"></i>Phone:</strong><br>
                                    <a href="tel:+91-1800-123-4567">+91-1800-123-4567</a>
                                </div>

                                <div class="mb-3">
                                    <strong><i class="fas fa-clock me-2"></i>Hours:</strong><br>
                                    Mon-Fri: 9:00 AM - 8:00 PM<br>
                                    Sat-Sun: 10:00 AM - 6:00 PM
                                </div>
                            </div>

                            <a href="<c:url value='/contact'/>" class="btn btn-primary w-100">
                                <i class="fas fa-envelope me-2"></i>Contact Support
                            </a>
                        </div>
                    </div>

                    <!-- Popular Articles -->
                    <div class="help-card card">
                        <div class="help-card-header">
                            <h5 class="mb-0"><i class="fas fa-star me-2"></i>Popular Articles</h5>
                        </div>
                        <div class="help-card-body">
                            <div class="list-group list-group-flush">
                                <a href="#" class="list-group-item list-group-item-action py-3">
                                    <i class="fas fa-credit-card me-2 text-primary"></i>
                                    Payment Methods Guide
                                </a>
                                <a href="#" class="list-group-item list-group-item-action py-3">
                                    <i class="fas fa-truck me-2 text-success"></i>
                                    Shipping & Delivery Information
                                </a>
                                <a href="#" class="list-group-item list-group-item-action py-3">
                                    <i class="fas fa-undo me-2 text-warning"></i>
                                    Returns & Exchanges Policy
                                </a>
                                <a href="#" class="list-group-item list-group-item-action py-3">
                                    <i class="fas fa-user-circle me-2 text-info"></i>
                                    Account Management
                                </a>
                                <a href="#" class="list-group-item list-group-item-action py-3">
                                    <i class="fas fa-shield-alt me-2 text-danger"></i>
                                    Privacy & Security
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp"/>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
