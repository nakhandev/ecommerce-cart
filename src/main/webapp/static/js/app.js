/**
 * E-commerce Cart System - Main JavaScript File
 * Common functionality and utilities
 */

// Application namespace
window.ECommerceApp = window.ECommerceApp || {};

// Enhanced Product Gallery
ECommerceApp.productGallery = {
    // Initialize product gallery
    init: function() {
        this.initGallery();
        this.initZoom();
    },

    // Initialize image gallery
    initGallery: function() {
        const galleries = document.querySelectorAll('.product-gallery');
        galleries.forEach(gallery => {
            const mainImage = gallery.querySelector('.product-gallery-main img');
            const thumbnails = gallery.querySelectorAll('.product-gallery-thumbnail');

            thumbnails.forEach((thumbnail, index) => {
                thumbnail.addEventListener('click', () => {
                    // Remove active class from all thumbnails
                    thumbnails.forEach(thumb => thumb.classList.remove('active'));

                    // Add active class to clicked thumbnail
                    thumbnail.classList.add('active');

                    // Change main image
                    if (mainImage) {
                        const newSrc = thumbnail.querySelector('img').src;
                        mainImage.src = newSrc;
                        mainImage.classList.add('animate-fade-in');
                        setTimeout(() => mainImage.classList.remove('animate-fade-in'), 300);
                    }
                });
            });
        });
    },

    // Initialize zoom functionality
    initZoom: function() {
        const zoomImages = document.querySelectorAll('.product-zoom');
        zoomImages.forEach(image => {
            image.addEventListener('mousemove', this.handleZoom);
            image.addEventListener('mouseleave', this.hideZoom);
        });
    },

    // Handle zoom on mouse move
    handleZoom: function(e) {
        const zoomImage = e.currentTarget;
        const lens = zoomImage.querySelector('.product-zoom-lens');
        if (!lens) return;

        const rect = zoomImage.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        // Calculate lens position
        let lensX = x - lens.offsetWidth / 2;
        let lensY = y - lens.offsetHeight / 2;

        // Keep lens within bounds
        lensX = Math.max(0, Math.min(lensX, zoomImage.offsetWidth - lens.offsetWidth));
        lensY = Math.max(0, Math.min(lensY, zoomImage.offsetHeight - lens.offsetHeight));

        lens.style.left = lensX + 'px';
        lens.style.top = lensY + 'px';

        // Set background position for zoom effect
        const img = zoomImage.querySelector('img');
        if (img) {
            const bgX = (x / zoomImage.offsetWidth) * 100;
            const bgY = (y / zoomImage.offsetHeight) * 100;
            lens.style.backgroundImage = `url(${img.src})`;
            lens.style.backgroundPosition = `${bgX}% ${bgY}%`;
            lens.style.backgroundSize = `${zoomImage.offsetWidth * 2}px ${zoomImage.offsetHeight * 2}px`;
        }
    },

    // Hide zoom lens
    hideZoom: function(e) {
        const lens = e.currentTarget.querySelector('.product-zoom-lens');
        if (lens) {
            lens.style.opacity = '0';
        }
    }
};

// Utility functions
ECommerceApp.utils = {
    // Show loading state
    showLoading: function(element) {
        if (element) {
            element.classList.add('loading');
        }
    },

    // Hide loading state
    hideLoading: function(element) {
        if (element) {
            element.classList.remove('loading');
        }
    },

    // Show toast notification
    showToast: function(message, type = 'info') {
        const toastHtml = `
            <div class="toast align-items-center text-white bg-${type}" role="alert">
                <div class="d-flex">
                    <div class="toast-body">${message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        `;

        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
            toastContainer.style.zIndex = '9999';
            document.body.appendChild(toastContainer);
        }

        toastContainer.insertAdjacentHTML('beforeend', toastHtml);

        const toastElement = toastContainer.lastElementChild;
        const toast = new bootstrap.Toast(toastElement);

        toast.show();

        // Remove toast element after hiding
        toastElement.addEventListener('hidden.bs.toast', function() {
            toastElement.remove();
        });
    },

    // Format currency
    formatCurrency: function(amount) {
        return '₹' + parseFloat(amount).toLocaleString('en-IN');
    },

    // Debounce function for search
    debounce: function(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
};

// Cart functionality
ECommerceApp.cart = {
    // Add item to cart
    addToCart: function(productId, quantity = 1) {
        // Show loading state
        const button = event.target;
        ECommerceApp.utils.showLoading(button);

        // In a real application, this would make an AJAX call
        setTimeout(() => {
            ECommerceApp.utils.hideLoading(button);
            ECommerceApp.utils.showToast('Product added to cart successfully!', 'success');

            // Update cart count in header (if exists)
            this.updateCartCount(quantity);
        }, 500);
    },

    // Update cart count display
    updateCartCount: function(quantity) {
        const cartCountElement = document.querySelector('.cart-count');
        if (cartCountElement) {
            const currentCount = parseInt(cartCountElement.textContent) || 0;
            cartCountElement.textContent = currentCount + quantity;
        }
    },

    // Remove item from cart
    removeFromCart: function(productId) {
        // Show confirmation dialog
        if (confirm('Are you sure you want to remove this item from cart?')) {
            // In a real application, this would make an AJAX call
            ECommerceApp.utils.showToast('Item removed from cart!', 'info');
        }
    },

    // Update item quantity
    updateQuantity: function(productId, newQuantity) {
        if (newQuantity < 1) return;

        // In a real application, this would make an AJAX call
        console.log(`Updating quantity for product ${productId} to ${newQuantity}`);
    }
};

// Product functionality
ECommerceApp.products = {
    // Quick view product
    quickView: function(productId) {
        // In a real application, this would open a modal with product details
        console.log(`Quick view for product ${productId}`);
        ECommerceApp.utils.showToast('Quick view feature coming soon!', 'info');
    },

    // Add to wishlist
    addToWishlist: function(productId) {
        // In a real application, this would make an AJAX call
        ECommerceApp.utils.showToast('Added to wishlist!', 'success');
    },

    // Share product
    share: function(productId, productName) {
        if (navigator.share) {
            navigator.share({
                title: productName,
                text: `Check out this product: ${productName}`,
                url: window.location.href
            });
        } else {
            // Fallback for browsers that don't support Web Share API
            const shareText = `Check out this product: ${productName} - ${window.location.href}`;

            // Copy to clipboard
            if (navigator.clipboard) {
                navigator.clipboard.writeText(shareText).then(() => {
                    ECommerceApp.utils.showToast('Link copied to clipboard!', 'success');
                });
            } else {
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = shareText;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                ECommerceApp.utils.showToast('Link copied to clipboard!', 'success');
            }
        }
    }
};

// Search functionality
ECommerceApp.search = {
    // Initialize search
    init: function() {
        const searchInput = document.querySelector('#searchInput');
        if (searchInput) {
            const debouncedSearch = ECommerceApp.utils.debounce(this.performSearch, 300);
            searchInput.addEventListener('input', debouncedSearch);
        }
    },

    // Perform search
    performSearch: function(event) {
        const query = event.target.value.trim();
        if (query.length < 2) return;

        // In a real application, this would make an AJAX call
        console.log(`Searching for: ${query}`);
    }
};

// Newsletter subscription
ECommerceApp.newsletter = {
    // Subscribe to newsletter
    subscribe: function(form) {
        const emailInput = form.querySelector('input[type="email"]');
        const email = emailInput.value.trim();

        if (!this.validateEmail(email)) {
            ECommerceApp.utils.showToast('Please enter a valid email address!', 'danger');
            return false;
        }

        // Show loading state
        const button = form.querySelector('button[type="submit"]');
        ECommerceApp.utils.showLoading(button);

        // In a real application, this would make an AJAX call
        setTimeout(() => {
            ECommerceApp.utils.hideLoading(button);
            ECommerceApp.utils.showToast('Thank you for subscribing!', 'success');
            emailInput.value = '';
        }, 1000);

        return false; // Prevent form submission
    },

    // Validate email address
    validateEmail: function(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
};

// Image lazy loading
ECommerceApp.lazyLoading = {
    // Initialize lazy loading
    init: function() {
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        this.loadImage(entry.target);
                        observer.unobserve(entry.target);
                    }
                });
            });

            // Observe all images with data-src attribute
            document.querySelectorAll('img[data-src]').forEach(img => {
                imageObserver.observe(img);
            });
        }
    },

    // Load image
    loadImage: function(img) {
        img.src = img.dataset.src;
        img.classList.remove('lazy');
    }
};

// Form validation
ECommerceApp.validation = {
    // Initialize form validation
    init: function() {
        // Add real-time validation to forms
        document.querySelectorAll('.needs-validation').forEach(form => {
            form.addEventListener('submit', this.handleSubmit);
            form.addEventListener('input', this.handleInput);
        });
    },

    // Handle form submission
    handleSubmit: function(event) {
        const form = event.target;
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
            ECommerceApp.utils.showToast('Please fill in all required fields correctly!', 'danger');
        }
        form.classList.add('was-validated');
    },

    // Handle real-time input validation
    handleInput: function(event) {
        const field = event.target;
        const feedback = field.parentNode.querySelector('.invalid-feedback');

        if (field.checkValidity()) {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
            if (feedback) feedback.style.display = 'none';
        } else {
            field.classList.remove('is-valid');
            field.classList.add('is-invalid');
            if (feedback) feedback.style.display = 'block';
        }
    }
};

// Initialize application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize all modules
    ECommerceApp.productGallery.init();
    ECommerceApp.search.init();
    ECommerceApp.lazyLoading.init();
    ECommerceApp.validation.init();
    ECommerceApp.formValidation.init();

    // Add smooth scrolling to anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Add fade-in animation to cards
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
            }
        });
    }, observerOptions);

    // Observe cards for animation
    document.querySelectorAll('.product-card, .category-card, .feature-card').forEach(card => {
        observer.observe(card);
    });

    // Initialize enhanced animations
    this.initAnimations();

    console.log('E-Commerce App initialized successfully!');
});

// Enhanced animations initialization
ECommerceApp.initAnimations = function() {
    // Stagger animation for product cards
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach((card, index) => {
        card.style.animationDelay = `${index * 0.1}s`;
    });

    // Add bounce effect to buttons on hover
    document.querySelectorAll('.btn-ecommerce').forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.classList.add('animate-pulse');
        });

        button.addEventListener('mouseleave', function() {
            this.classList.remove('animate-pulse');
        });
    });

    // Add parallax effect to hero section
    if (document.querySelector('.hero-section')) {
        window.addEventListener('scroll', function() {
            const scrolled = window.pageYOffset;
            const heroImage = document.querySelector('.hero-section img');
            if (heroImage) {
                const rate = scrolled * -0.5;
                heroImage.style.transform = `translateY(${rate}px)`;
            }
        });
    }
};

// Enhanced Form Validation System
ECommerceApp.formValidation = {
    // Initialize form validation
    init: function() {
        this.initRealTimeValidation();
        this.initPasswordStrengthMeter();
        this.initPhoneNumberValidation();
        this.initEmailValidation();
        this.initCreditCardValidation();
    },

    // Real-time validation for all forms
    initRealTimeValidation: function() {
        const forms = document.querySelectorAll('form[data-validate="true"]');
        forms.forEach(form => {
            const inputs = form.querySelectorAll('input, select, textarea');

            inputs.forEach(input => {
                input.addEventListener('blur', (e) => this.validateField(e.target));
                input.addEventListener('input', (e) => this.validateField(e.target));
            });
        });
    },

    // Validate individual field
    validateField: function(field) {
        const rules = this.getValidationRules(field);
        const value = field.value.trim();
        const errors = [];

        // Check each validation rule
        for (let rule of rules) {
            if (!this.validateRule(value, rule, field)) {
                errors.push(this.getErrorMessage(rule, field));
            }
        }

        this.displayFieldErrors(field, errors);
        return errors.length === 0;
    },

    // Get validation rules for field
    getValidationRules: function(field) {
        const rules = [];

        // Required validation
        if (field.hasAttribute('required') || field.classList.contains('required')) {
            rules.push('required');
        }

        // Email validation
        if (field.type === 'email' || field.classList.contains('validate-email')) {
            rules.push('email');
        }

        // Phone validation
        if (field.type === 'tel' || field.classList.contains('validate-phone')) {
            rules.push('phone');
        }

        // Password validation
        if (field.type === 'password' || field.classList.contains('validate-password')) {
            rules.push('password');
        }

        // Confirm password validation
        if (field.classList.contains('confirm-password')) {
            rules.push('confirmPassword');
        }

        // Credit card validation
        if (field.classList.contains('validate-credit-card')) {
            rules.push('creditCard');
        }

        // Custom pattern validation
        if (field.hasAttribute('pattern')) {
            rules.push('pattern');
        }

        // Length validation
        if (field.hasAttribute('minlength') || field.hasAttribute('maxlength')) {
            rules.push('length');
        }

        return rules;
    },

    // Validate specific rule
    validateRule: function(value, rule, field) {
        switch (rule) {
            case 'required':
                return value.length > 0;

            case 'email':
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(value);

            case 'phone':
                const phoneRegex = /^(\+91|91|0)?[6-9]\d{9}$/;
                return phoneRegex.test(value.replace(/\s/g, ''));

            case 'password':
                return value.length >= 8 &&
                       /[A-Z]/.test(value) &&
                       /[a-z]/.test(value) &&
                       /\d/.test(value) &&
                       /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(value);

            case 'confirmPassword':
                const passwordField = document.querySelector(`#${field.dataset.passwordField || 'password'}`);
                return passwordField && value === passwordField.value;

            case 'creditCard':
                return this.validateCreditCard(value);

            case 'pattern':
                const pattern = new RegExp(field.getAttribute('pattern'));
                return pattern.test(value);

            case 'length':
                const minLength = parseInt(field.getAttribute('minlength')) || 0;
                const maxLength = parseInt(field.getAttribute('maxlength')) || Infinity;
                return value.length >= minLength && value.length <= maxLength;

            default:
                return true;
        }
    },

    // Get error message for rule
    getErrorMessage: function(rule, field) {
        const messages = {
            required: 'This field is required',
            email: 'Please enter a valid email address',
            phone: 'Please enter a valid phone number',
            password: 'Password must contain at least 8 characters with uppercase, lowercase, number, and special character',
            confirmPassword: 'Passwords do not match',
            creditCard: 'Please enter a valid credit card number',
            pattern: 'Please enter a valid value',
            length: `Please enter between ${field.getAttribute('minlength') || 0} and ${field.getAttribute('maxlength') || '∞'} characters`
        };

        return messages[rule] || 'Invalid value';
    },

    // Display field errors
    displayFieldErrors: function(field, errors) {
        // Remove existing error display
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }

        // Remove existing success indicator
        field.classList.remove('is-valid');

        if (errors.length > 0) {
            field.classList.add('is-invalid');
            field.classList.remove('is-valid');

            // Create error element
            const errorElement = document.createElement('div');
            errorElement.className = 'field-error invalid-feedback';
            errorElement.textContent = errors[0]; // Show first error
            field.parentNode.appendChild(errorElement);
        } else {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
        }
    },

    // Validate credit card number using Luhn algorithm
    validateCreditCard: function(number) {
        // Remove spaces and non-numeric characters
        const cleanNumber = number.replace(/\D/g, '');

        if (cleanNumber.length < 13 || cleanNumber.length > 19) {
            return false;
        }

        // Luhn algorithm
        let sum = 0;
        let isEven = false;

        for (let i = cleanNumber.length - 1; i >= 0; i--) {
            let digit = parseInt(cleanNumber.charAt(i));

            if (isEven) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }

            sum += digit;
            isEven = !isEven;
        }

        return sum % 10 === 0;
    },

    // Initialize password strength meter
    initPasswordStrengthMeter: function() {
        const passwordFields = document.querySelectorAll('input[type="password"].password-strength');
        passwordFields.forEach(field => {
            field.addEventListener('input', (e) => this.updatePasswordStrength(e.target));
        });
    },

    // Update password strength indicator
    updatePasswordStrength: function(field) {
        const password = field.value;
        const strengthBar = document.querySelector(`#${field.id}-strength`);
        const strengthText = document.querySelector(`#${field.id}-strength-text`);

        if (!strengthBar) return;

        const strength = this.calculatePasswordStrength(password);

        // Update strength bar
        strengthBar.className = `password-strength-bar ${strength.level}`;
        strengthBar.style.width = `${strength.percentage}%`;

        // Update strength text
        if (strengthText) {
            strengthText.textContent = strength.text;
            strengthText.className = `password-strength-text ${strength.level}`;
        }
    },

    // Calculate password strength
    calculatePasswordStrength: function(password) {
        let score = 0;

        if (password.length >= 8) score += 20;
        if (password.length >= 12) score += 10;
        if (/[a-z]/.test(password)) score += 15;
        if (/[A-Z]/.test(password)) score += 15;
        if (/\d/.test(password)) score += 15;
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) score += 15;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score += 10;

        let level = 'weak';
        let text = 'Weak';

        if (score >= 80) {
            level = 'strong';
            text = 'Strong';
        } else if (score >= 60) {
            level = 'medium';
            text = 'Medium';
        } else if (score >= 40) {
            level = 'fair';
            text = 'Fair';
        }

        return {
            score: score,
            level: level,
            text: text,
            percentage: score
        };
    },

    // Initialize phone number formatting
    initPhoneNumberValidation: function() {
        const phoneFields = document.querySelectorAll('input[type="tel"]');
        phoneFields.forEach(field => {
            field.addEventListener('input', (e) => this.formatPhoneNumber(e.target));
            field.addEventListener('blur', (e) => this.validateField(e.target));
        });
    },

    // Format phone number as user types
    formatPhoneNumber: function(field) {
        let value = field.value.replace(/\D/g, '');

        if (value.length > 0) {
            // Format as: +91 XXXXX XXXXX
            if (value.length <= 3) {
                value = value;
            } else if (value.length <= 8) {
                value = value.substring(0, 3) + ' ' + value.substring(3);
            } else {
                value = value.substring(0, 3) + ' ' + value.substring(3, 8) + ' ' + value.substring(8, 13);
            }
        }

        field.value = value;
    },

    // Initialize email validation with domain check
    initEmailValidation: function() {
        const emailFields = document.querySelectorAll('input[type="email"]');
        emailFields.forEach(field => {
            field.addEventListener('blur', (e) => {
                const email = e.target.value;
                if (email && this.validateRule(email, 'email', field)) {
                    this.checkEmailDomain(email, field);
                }
            });
        });
    },

    // Check email domain for common typos
    checkEmailDomain: function(email, field) {
        const commonDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];
        const domain = email.split('@')[1];

        // Check for common typos
        const suggestions = [];
        commonDomains.forEach(commonDomain => {
            if (this.calculateLevenshteinDistance(domain, commonDomain) <= 2) {
                suggestions.push(commonDomain);
            }
        });

        if (suggestions.length > 0) {
            this.showEmailSuggestion(field, domain, suggestions[0]);
        }
    },

    // Show email domain suggestion
    showEmailSuggestion: function(field, currentDomain, suggestedDomain) {
        const suggestionHtml = `
            <div class="email-suggestion alert alert-info py-2 px-3 mt-1">
                <small>Did you mean <strong>${field.value.split('@')[0]}@${suggestedDomain}</strong>?
                <button class="btn btn-sm btn-primary ms-2" onclick="this.applySuggestion('${suggestedDomain}')">Yes</button>
                <button class="btn btn-sm btn-secondary ms-1" onclick="this.parentNode.remove()">No</button></small>
            </div>
        `;

        const existingSuggestion = field.parentNode.querySelector('.email-suggestion');
        if (existingSuggestion) {
            existingSuggestion.remove();
        }

        field.parentNode.insertAdjacentHTML('beforeend', suggestionHtml);
    },

    // Initialize credit card validation
    initCreditCardValidation: function() {
        const cardFields = document.querySelectorAll('input.validate-credit-card');
        cardFields.forEach(field => {
            field.addEventListener('input', (e) => this.formatCreditCard(e.target));
            field.addEventListener('blur', (e) => this.validateField(e.target));
        });
    },

    // Format credit card number
    formatCreditCard: function(field) {
        let value = field.value.replace(/\D/g, '');

        // Add spaces every 4 digits
        value = value.replace(/(\d{4})(?=\d)/g, '$1 ');

        field.value = value;
    },

    // Calculate Levenshtein distance for typo detection
    calculateLevenshteinDistance: function(a, b) {
        if (a.length === 0) return b.length;
        if (b.length === 0) return a.length;

        const matrix = [];

        for (let i = 0; i <= b.length; i++) {
            matrix[i] = [i];
        }

        for (let j = 0; j <= a.length; j++) {
            matrix[0][j] = j;
        }

        for (let i = 1; i <= b.length; i++) {
            for (let j = 1; j <= a.length; j++) {
                if (b.charAt(i - 1) === a.charAt(j - 1)) {
                    matrix[i][j] = matrix[i - 1][j - 1];
                } else {
                    matrix[i][j] = Math.min(
                        matrix[i - 1][j - 1] + 1,
                        matrix[i][j - 1] + 1,
                        matrix[i - 1][j] + 1
                    );
                }
            }
        }

        return matrix[b.length][a.length];
    }
};

// Enhanced Error Display System
ECommerceApp.errorDisplay = {
    // Show form-level errors
    showFormErrors: function(form, errors) {
        // Clear existing errors
        this.clearFormErrors(form);

        if (errors.length === 0) return;

        // Create error summary
        const errorSummary = document.createElement('div');
        errorSummary.className = 'alert alert-danger alert-dismissible fade show';
        errorSummary.innerHTML = `
            <strong>Please fix the following errors:</strong>
            <ul class="mb-0 mt-2">
                ${errors.map(error => `<li>${error}</li>`).join('')}
            </ul>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        form.insertBefore(errorSummary, form.firstChild);
    },

    // Clear form errors
    clearFormErrors: function(form) {
        const existingErrors = form.querySelectorAll('.alert-danger');
        existingErrors.forEach(error => error.remove());
    },

    // Show success message
    showSuccessMessage: function(message, container = null) {
        const successHtml = `
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;

        const targetContainer = container || document.querySelector('.message-container') || document.body;
        targetContainer.insertAdjacentHTML('afterbegin', successHtml);

        // Auto-hide after 5 seconds
        setTimeout(() => {
            const alert = targetContainer.querySelector('.alert-success');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    },

    // Show error message
    showErrorMessage: function(message, container = null) {
        const errorHtml = `
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;

        const targetContainer = container || document.querySelector('.message-container') || document.body;
        targetContainer.insertAdjacentHTML('afterbegin', errorHtml);

        // Auto-hide after 8 seconds
        setTimeout(() => {
            const alert = targetContainer.querySelector('.alert-danger');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 8000);
    }
};

// Enhanced Security Features
ECommerceApp.security = {
    // Input sanitization
    sanitizeInput: function(input) {
        const div = document.createElement('div');
        div.textContent = input;
        return div.innerHTML;
    },

    // Validate file upload
    validateFileUpload: function(file, allowedTypes, maxSize) {
        if (!file) return { valid: false, error: 'No file selected' };

        // Check file type
        if (allowedTypes && !allowedTypes.includes(file.type)) {
            return { valid: false, error: `File type not allowed. Allowed types: ${allowedTypes.join(', ')}` };
        }

        // Check file size
        if (maxSize && file.size > maxSize) {
            const maxSizeMB = (maxSize / (1024 * 1024)).toFixed(2);
            return { valid: false, error: `File size too large. Maximum size: ${maxSizeMB}MB` };
        }

        return { valid: true };
    },

    // Generate CSRF token (placeholder for real implementation)
    generateCSRFToken: function() {
        return 'csrf_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    },

    // Validate CSRF token (placeholder for real implementation)
    validateCSRFToken: function(token) {
        // In real implementation, validate against server-side token
        return token && token.startsWith('csrf_');
    }
};

// Global functions for backward compatibility (used in JSP files)
function addToCart(productId, quantity) {
    ECommerceApp.cart.addToCart(productId, quantity);
}

// Apply email suggestion
HTMLDivElement.prototype.applySuggestion = function(suggestedDomain) {
    const emailField = this.parentNode.parentNode.querySelector('input[type="email"]');
    if (emailField) {
        const localPart = emailField.value.split('@')[0];
        emailField.value = localPart + '@' + suggestedDomain;
        this.remove();
    }
};
