package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.model.User;

public interface EmailService {

    /**
     * Send order confirmation email to customer
     */
    void sendOrderConfirmationEmail(Order order, User user);

    /**
     * Send order status update email
     */
    void sendOrderStatusUpdateEmail(Order order, User user, String oldStatus, String newStatus);

    /**
     * Send shipping notification email
     */
    void sendShippingNotificationEmail(Order order, User user);

    /**
     * Send delivery confirmation email
     */
    void sendDeliveryConfirmationEmail(Order order, User user);

    /**
     * Send order cancellation email
     */
    void sendOrderCancellationEmail(Order order, User user);

    /**
     * Send password reset email
     */
    void sendPasswordResetEmail(User user, String resetToken);

    /**
     * Send welcome email to new user
     */
    void sendWelcomeEmail(User user);

    /**
     * Send promotional email
     */
    void sendPromotionalEmail(User user, String subject, String content);
}
