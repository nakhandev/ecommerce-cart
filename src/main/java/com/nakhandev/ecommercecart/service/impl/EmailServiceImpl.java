package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.Order;
import com.nakhandev.ecommercecart.model.User;
import com.nakhandev.ecommercecart.service.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

@Service
public class EmailServiceImpl implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailServiceImpl.class);

    @Value("${spring.mail.host:smtp.gmail.com}")
    private String smtpHost;

    @Value("${spring.mail.port:587}")
    private int smtpPort;

    @Value("${spring.mail.username:}")
    private String smtpUsername;

    @Value("${spring.mail.password:}")
    private String smtpPassword;

    @Value("${app.email.from:noreply@eshop.com}")
    private String fromEmail;

    @Value("${app.email.enabled:false}")
    private boolean emailEnabled;

    @Override
    public void sendOrderConfirmationEmail(Order order, User user) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send order confirmation to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Order Confirmation - " + order.getOrderNumber();
            String content = buildOrderConfirmationEmailContent(order, user);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Order confirmation email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send order confirmation email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendOrderStatusUpdateEmail(Order order, User user, String oldStatus, String newStatus) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send status update to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Order Status Updated - " + order.getOrderNumber();
            String content = buildOrderStatusUpdateEmailContent(order, user, oldStatus, newStatus);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Order status update email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send order status update email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendShippingNotificationEmail(Order order, User user) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send shipping notification to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Your Order is On the Way! - " + order.getOrderNumber();
            String content = buildShippingNotificationEmailContent(order, user);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Shipping notification email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send shipping notification email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendDeliveryConfirmationEmail(Order order, User user) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send delivery confirmation to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Order Delivered Successfully - " + order.getOrderNumber();
            String content = buildDeliveryConfirmationEmailContent(order, user);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Delivery confirmation email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send delivery confirmation email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendOrderCancellationEmail(Order order, User user) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send cancellation email to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Order Cancelled - " + order.getOrderNumber();
            String content = buildOrderCancellationEmailContent(order, user);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Order cancellation email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send order cancellation email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendPasswordResetEmail(User user, String resetToken) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send password reset to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Password Reset Request - E-Shop";
            String resetLink = "http://localhost:8080/auth/reset-password?token=" + resetToken;
            String content = buildPasswordResetEmailContent(user, resetLink);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Password reset email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send password reset email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendWelcomeEmail(User user) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send welcome email to: {}", user.getEmail());
            return;
        }

        try {
            String subject = "Welcome to E-Shop!";
            String content = buildWelcomeEmailContent(user);

            sendEmail(user.getEmail(), subject, content);
            logger.info("Welcome email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send welcome email to: " + user.getEmail(), e);
        }
    }

    @Override
    public void sendPromotionalEmail(User user, String subject, String content) {
        if (!emailEnabled) {
            logger.info("Email notifications are disabled. Would send promotional email to: {}", user.getEmail());
            return;
        }

        try {
            sendEmail(user.getEmail(), subject, content);
            logger.info("Promotional email sent to: {}", user.getEmail());

        } catch (Exception e) {
            logger.error("Failed to send promotional email to: " + user.getEmail(), e);
        }
    }

    private void sendEmail(String toEmail, String subject, String content) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUsername, smtpPassword);
            }
        };

        Session session = Session.getInstance(props, auth);

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(content, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private String buildOrderConfirmationEmailContent(Order order, User user) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        // Header
        content.append("<div style='text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0; font-size: 28px;'>🎉 Order Confirmed!</h1>");
        content.append("<p style='margin: 10px 0 0 0; opacity: 0.9;'>Thank you for shopping with E-Shop</p>");
        content.append("</div>");

        // Order Details
        content.append("<div style='background: #f8f9fa; padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<h2 style='color: #333; margin-top: 0;'>Order Details</h2>");
        content.append("<table style='width: 100%; border-collapse: collapse;'>");
        content.append("<tr><td style='padding: 10px 0;'><strong>Order Number:</strong></td><td>").append(order.getOrderNumber()).append("</td></tr>");
        content.append("<tr><td style='padding: 10px 0;'><strong>Order Date:</strong></td><td>").append(order.getOrderDate().format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm"))).append("</td></tr>");
        content.append("<tr><td style='padding: 10px 0;'><strong>Payment Method:</strong></td><td>").append(formatPaymentMethod(order.getPayment() != null ? order.getPayment().getPaymentMethod() : "N/A")).append("</td></tr>");
        content.append("<tr><td style='padding: 10px 0;'><strong>Total Amount:</strong></td><td style='color: #28a745; font-weight: bold;'>₹").append(order.getTotalAmount()).append("</td></tr>");
        content.append("</table>");
        content.append("</div>");

        // Items
        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<h3 style='color: #333; margin-top: 0;'>Order Items</h3>");
        content.append("<table style='width: 100%; border-collapse: collapse;'>");

        if (order.getOrderItems() != null) {
            for (var item : order.getOrderItems()) {
                content.append("<tr>");
                content.append("<td style='padding: 15px 0; border-bottom: 1px solid #e9ecef;'>");
                content.append("<strong>").append(item.getProduct().getName()).append("</strong><br>");
                content.append("<small style='color: #666;'>Quantity: ").append(item.getQuantity()).append(" × ₹").append(item.getUnitPrice()).append("</small>");
                content.append("</td>");
                content.append("<td style='padding: 15px 0; border-bottom: 1px solid #e9ecef; text-align: right;'>");
                content.append("<strong>₹").append(item.getSubtotal()).append("</strong>");
                content.append("</td>");
                content.append("</tr>");
            }
        }

        content.append("</table>");
        content.append("</div>");

        // Footer
        content.append("<div style='background: #343a40; color: white; padding: 30px; border-radius: 0 0 10px 10px; text-align: center;'>");
        content.append("<h4 style='margin: 0 0 15px 0;'>What's Next?</h4>");
        content.append("<p style='margin: 0 0 20px 0;'>We'll send you shipping updates as soon as your order is on its way!</p>");
        content.append("<p style='margin: 0; opacity: 0.8;'>Questions? Contact our support team at support@eshop.com</p>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String buildOrderStatusUpdateEmailContent(Order order, User user, String oldStatus, String newStatus) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        content.append("<div style='text-align: center; background: #17a2b8; color: white; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0;'>📦 Order Status Updated</h1>");
        content.append("</div>");

        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<p>Hi ").append(user.getFirstName()).append(",</p>");
        content.append("<p>Your order status has been updated:</p>");
        content.append("<table style='width: 100%; background: #f8f9fa; padding: 20px; border-radius: 8px;'>");
        content.append("<tr><td style='padding: 10px 0;'><strong>Order Number:</strong></td><td>").append(order.getOrderNumber()).append("</td></tr>");
        content.append("<tr><td style='padding: 10px 0;'><strong>Previous Status:</strong></td><td>").append(oldStatus).append("</td></tr>");
        content.append("<tr><td style='padding: 10px 0;'><strong>New Status:</strong></td><td style='color: #28a745; font-weight: bold;'>").append(newStatus).append("</td></tr>");
        content.append("</table>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String buildShippingNotificationEmailContent(Order order, User user) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        content.append("<div style='text-align: center; background: #ffc107; color: #212529; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0;'>🚚 Your Order is On the Way!</h1>");
        content.append("</div>");

        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<p>Hi ").append(user.getFirstName()).append(",</p>");
        content.append("<p>Great news! Your order has been shipped and is on its way to you.</p>");
        content.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        content.append("<h4>Order Details:</h4>");
        content.append("<strong>Order Number:</strong> ").append(order.getOrderNumber()).append("<br>");
        content.append("<strong>Shipping Date:</strong> ").append(order.getShippedDate().format(DateTimeFormatter.ofPattern("dd MMM yyyy"))).append("<br>");
        content.append("<strong>Expected Delivery:</strong> ").append(order.getShippedDate().plusDays(3).format(DateTimeFormatter.ofPattern("dd MMM yyyy")));
        content.append("</div>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String buildDeliveryConfirmationEmailContent(Order order, User user) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        content.append("<div style='text-align: center; background: #28a745; color: white; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0;'>✅ Order Delivered Successfully!</h1>");
        content.append("</div>");

        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<p>Hi ").append(user.getFirstName()).append(",</p>");
        content.append("<p>We're happy to inform you that your order has been delivered successfully!</p>");
        content.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        content.append("<h4>Delivery Details:</h4>");
        content.append("<strong>Order Number:</strong> ").append(order.getOrderNumber()).append("<br>");
        content.append("<strong>Delivery Date:</strong> ").append(order.getDeliveredDate().format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm")));
        content.append("</div>");
        content.append("<p>We hope you love your purchase! Don't forget to leave a review for the products you bought.</p>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String buildOrderCancellationEmailContent(Order order, User user) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        content.append("<div style='text-align: center; background: #dc3545; color: white; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0;'>❌ Order Cancelled</h1>");
        content.append("</div>");

        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<p>Hi ").append(user.getFirstName()).append(",</p>");
        content.append("<p>Your order has been cancelled as per your request.</p>");
        content.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        content.append("<h4>Order Details:</h4>");
        content.append("<strong>Order Number:</strong> ").append(order.getOrderNumber()).append("<br>");
        content.append("<strong>Cancellation Date:</strong> ").append(order.getCancelledDate().format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm")));
        content.append("</div>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String buildPasswordResetEmailContent(User user, String resetLink) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        content.append("<div style='text-align: center; background: #6f42c1; color: white; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0;'>🔐 Password Reset</h1>");
        content.append("</div>");

        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<p>Hi ").append(user.getFirstName()).append(",</p>");
        content.append("<p>You have requested to reset your password. Click the button below to reset it:</p>");
        content.append("<div style='text-align: center; margin: 30px 0;'>");
        content.append("<a href='").append(resetLink).append("' style='background: #6f42c1; color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; display: inline-block;'>Reset Password</a>");
        content.append("</div>");
        content.append("<p style='color: #666; font-size: 14px;'>This link will expire in 24 hours for security reasons.</p>");
        content.append("<p style='color: #666; font-size: 14px;'>If you didn't request this reset, please ignore this email.</p>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String buildWelcomeEmailContent(User user) {
        StringBuilder content = new StringBuilder();

        content.append("<!DOCTYPE html>");
        content.append("<html><head><meta charset='UTF-8'></head><body>");
        content.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>");

        content.append("<div style='text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px 10px 0 0;'>");
        content.append("<h1 style='margin: 0;'>🎉 Welcome to E-Shop!</h1>");
        content.append("</div>");

        content.append("<div style='padding: 30px; border: 1px solid #e9ecef; border-top: none;'>");
        content.append("<p>Hi ").append(user.getFirstName()).append(",</p>");
        content.append("<p>Welcome to E-Shop! We're thrilled to have you join our community of smart shoppers.</p>");
        content.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        content.append("<h4>What's Next?</h4>");
        content.append("<ul>");
        content.append("<li>Browse our amazing collection of products</li>");
        content.append("<li>Add items to your cart and enjoy seamless checkout</li>");
        content.append("<li>Track your orders in real-time</li>");
        content.append("<li>Get exclusive deals and offers</li>");
        content.append("</ul>");
        content.append("</div>");
        content.append("<p>Happy Shopping! 🛍️</p>");
        content.append("<p>Best regards,<br>The E-Shop Team</p>");
        content.append("</div>");

        content.append("</div>");
        content.append("</body></html>");

        return content.toString();
    }

    private String formatPaymentMethod(String method) {
        if (method == null) return "N/A";

        switch (method.toUpperCase()) {
            case "CARD": return "Credit/Debit Card";
            case "UPI": return "UPI Payment";
            case "NET_BANKING": return "Net Banking";
            case "COD": return "Cash on Delivery";
            case "WALLET": return "Digital Wallet";
            default: return method;
        }
    }
}
