<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Footer -->
<footer class="footer bg-dark text-light mt-5">
    <div class="container py-5">
        <div class="row">
            <!-- Company Info -->
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="d-flex align-items-center mb-3">
                    <i class="fas fa-shopping-cart text-primary me-2 fs-4"></i>
                    <h5 class="mb-0 text-primary">E-Shop</h5>
                </div>
                <p class="text-muted">
                    Your trusted online shopping destination. We offer a wide range of high-quality products
                    with fast delivery and excellent customer service.
                </p>
                <div class="social-links">
                    <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="text-primary mb-3">Quick Links</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="<c:url value='/'/>" class="text-muted">Home</a></li>
                    <li class="mb-2"><a href="<c:url value='/products'/>" class="text-muted">Products</a></li>
                    <li class="mb-2"><a href="<c:url value='/categories'/>" class="text-muted">Categories</a></li>
                    <li class="mb-2"><a href="<c:url value='/contact'/>" class="text-muted">Contact</a></li>
                </ul>
            </div>

            <!-- Customer Service -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="text-primary mb-3">Customer Service</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="<c:url value='/help'/>" class="text-muted">Help Center</a></li>
                    <li class="mb-2"><a href="<c:url value='/shipping'/>" class="text-muted">Shipping Info</a></li>
                    <li class="mb-2"><a href="<c:url value='/returns'/>" class="text-muted">Returns</a></li>
                    <li class="mb-2"><a href="<c:url value='/faq'/>" class="text-muted">FAQ</a></li>
                </ul>
            </div>

            <!-- Contact Info -->
            <div class="col-lg-4 col-md-6 mb-4">
                <h6 class="text-primary mb-3">Contact Info</h6>
                <div class="d-flex align-items-center mb-2">
                    <i class="fas fa-map-marker-alt text-primary me-2"></i>
                    <span class="text-muted">123 Shopping Street, Commerce City, CC 12345</span>
                </div>
                <div class="d-flex align-items-center mb-2">
                    <i class="fas fa-phone text-primary me-2"></i>
                    <span class="text-muted">+1 (555) 123-4567</span>
                </div>
                <div class="d-flex align-items-center mb-2">
                    <i class="fas fa-envelope text-primary me-2"></i>
                    <span class="text-muted">support@ecommerce.com</span>
                </div>
                <div class="d-flex align-items-center">
                    <i class="fas fa-clock text-primary me-2"></i>
                    <span class="text-muted">Mon-Fri: 9AM-6PM, Sat: 10AM-4PM</span>
                </div>
            </div>
        </div>

        <!-- Newsletter Subscription -->
        <div class="row mt-4">
            <div class="col-lg-8 mx-auto">
                <div class="newsletter-section bg-primary rounded p-4 text-center">
                    <h6 class="text-white mb-2">Subscribe to our Newsletter</h6>
                    <p class="text-white-50 mb-3">Get the latest updates, offers, and product news delivered to your inbox.</p>
                    <form class="d-flex justify-content-center">
                        <input type="email" class="form-control me-2" placeholder="Enter your email" style="max-width: 300px;">
                        <button type="submit" class="btn btn-light">Subscribe</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom Bar -->
    <div class="border-top border-secondary py-3">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0 text-muted">
                        © 2025 E-Shop. All rights reserved. |
                        <a href="<c:url value='/privacy'/>" class="text-muted">Privacy Policy</a> |
                        <a href="<c:url value='/terms'/>" class="text-muted">Terms of Service</a>
                    </p>
                </div>
                <div class="col-md-6 text-end">
                    <span class="text-muted">Powered by Spring MVC & Bootstrap</span>
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
.social-links a {
    transition: color 0.3s ease;
}

.social-links a:hover {
    color: var(--bs-primary) !important;
}

.newsletter-section {
    background: linear-gradient(135deg, var(--bs-primary) 0%, #0056b3 100%);
}

.footer a {
    text-decoration: none;
    transition: color 0.3s ease;
}

.footer a:hover {
    color: var(--bs-primary) !important;
}
</style>
