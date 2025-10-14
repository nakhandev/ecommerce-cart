-- Sample Data for E-commerce Cart System
-- This script will populate the database with sample data for testing and demonstration

-- Insert sample categories
INSERT IGNORE INTO categories (name, description, image_url, is_active, display_order, created_at, updated_at) VALUES
('Electronics', 'Latest gadgets and electronic devices', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=500', true, 1, NOW(), NOW()),
('Clothing', 'Fashion and apparel for men and women', 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500', true, 2, NOW(), NOW()),
('Books', 'Wide collection of books and literature', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500', true, 3, NOW(), NOW()),
('Home & Garden', 'Home improvement and gardening supplies', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500', true, 4, NOW(), NOW()),
('Sports & Outdoors', 'Sports equipment and outdoor gear', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500', true, 5, NOW(), NOW()),
('Health & Beauty', 'Personal care and beauty products', 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500', true, 6, NOW(), NOW());

-- Insert sample products
INSERT IGNORE INTO products (name, short_description, long_description, sku, price, stock_quantity, image_url, is_active, is_featured, discount_percentage, category_id, created_at, updated_at) VALUES
-- Electronics
('iPhone 15 Pro', 'Latest iPhone with advanced camera system', 'The iPhone 15 Pro features a titanium design, A17 Pro chip, and advanced camera system with 5x telephoto zoom.', 'IPH15P-128', 1299.99, 50, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500', true, true, 5.0, 1, NOW(), NOW()),
('Samsung Galaxy S24', 'Premium Android smartphone', 'Samsung Galaxy S24 with Snapdragon 8 Gen 3, 120Hz display, and professional-grade camera system.', 'SGS24-256', 899.99, 30, 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500', true, true, 0.0, 1, NOW(), NOW()),
('MacBook Air M3', 'Lightweight laptop with M3 chip', '13-inch MacBook Air with Apple M3 chip, up to 18 hours of battery life, and stunning Liquid Retina display.', 'MBA-M3-13', 1099.99, 25, 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500', true, false, 10.0, 1, NOW(), NOW()),
('Sony WH-1000XM5', 'Premium noise-canceling headphones', 'Industry-leading noise canceling headphones with exceptional sound quality and 30-hour battery life.', 'SONY-WH1000XM5', 399.99, 100, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', true, true, 15.0, 1, NOW(), NOW()),

-- Clothing
('Cotton T-Shirt', 'Comfortable basic t-shirt', '100% organic cotton t-shirt available in multiple colors and sizes. Perfect for everyday wear.', 'TSHIRT-COTTON-M', 29.99, 200, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500', true, false, 0.0, 2, NOW(), NOW()),
('Denim Jeans', 'Classic straight-fit jeans', 'Premium denim jeans with classic straight fit. Made from high-quality cotton blend for comfort and durability.', 'JEANS-DENIM-32', 79.99, 150, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500', true, true, 20.0, 2, NOW(), NOW()),
('Leather Jacket', 'Genuine leather motorcycle jacket', 'Premium genuine leather jacket with quilted lining. Perfect for motorcycle enthusiasts and fashion lovers.', 'JACKET-LEATHER-M', 199.99, 20, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500', true, true, 0.0, 2, NOW(), NOW()),

-- Books
('Clean Code', 'A Handbook of Agile Software Craftsmanship', 'Even bad code can function. But if code isn''t clean, it can bring a development organization to its knees.', 'BOOK-CLEANC-001', 47.99, 75, 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500', true, true, 10.0, 3, NOW(), NOW()),
('The Pragmatic Programmer', 'Your Journey To Mastery', 'A guide to pragmatic programming for software engineers and developers.', 'BOOK-PRAGPROG-001', 42.99, 60, 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500', true, false, 0.0, 3, NOW(), NOW()),
('Design Patterns', 'Elements of Reusable Object-Oriented Software', 'The Gang of Four book on design patterns - a must-read for every software developer.', 'BOOK-DESIGNPAT-001', 54.99, 40, 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500', true, true, 5.0, 3, NOW(), NOW()),

-- Home & Garden
('Coffee Maker', 'Automatic drip coffee machine', '12-cup programmable coffee maker with thermal carafe and auto-shutoff feature.', 'COFFEEMAKER-12C', 89.99, 35, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500', true, false, 0.0, 4, NOW(), NOW()),
('Air Purifier', 'HEPA air purification system', 'True HEPA air purifier with smart sensor technology and quiet operation.', 'AIRPURIFIER-HEPA', 249.99, 15, 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500', true, true, 12.0, 4, NOW(), NOW()),

-- Sports & Outdoors
('Yoga Mat', 'Premium non-slip exercise mat', 'Extra thick yoga mat with excellent grip and cushioning for all types of yoga and exercise.', 'YOGAMAT-PREMIUM', 39.99, 80, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500', true, false, 0.0, 5, NOW(), NOW()),
('Running Shoes', 'Lightweight athletic footwear', 'Professional running shoes with advanced cushioning and breathable mesh upper.', 'RUNSHOES-LITE-10', 129.99, 45, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500', true, true, 8.0, 5, NOW(), NOW()),

-- Health & Beauty
('Vitamin C Serum', 'Brightening facial treatment', 'Potent vitamin C serum for skin brightening and anti-aging benefits.', 'VITC-SERUM-30ML', 34.99, 90, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500', true, false, 15.0, 6, NOW(), NOW()),
('Electric Toothbrush', 'Sonic cleaning technology', 'Advanced sonic toothbrush with multiple cleaning modes and smart timer.', 'TOOTHBRUSH-SONIC', 79.99, 55, 'https://images.unsplash.com/photo-1559599101-f09722fb4948?w=500', true, true, 0.0, 6, NOW(), NOW());

-- Insert sample users
INSERT IGNORE INTO users (username, email, password, first_name, last_name, phone_number, is_active, role, created_at, updated_at) VALUES
('admin', 'admin@ecommerce.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lbdxp8lQ2W6.5fIxm', 'Admin', 'User', '1234567890', true, 'ADMIN', NOW(), NOW()),
('nakdev', 'nakdev@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lbdxp8lQ2W6.5fIxm', 'Nak', 'Dev', '9876543210', true, 'CUSTOMER', NOW(), NOW()),
('jane_smith', 'jane@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lbdxp8lQ2W6.5fIxm', 'Jane', 'Smith', '5556667777', true, 'CUSTOMER', NOW(), NOW()),
('manager', 'manager@ecommerce.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lbdxp8lQ2W6.5fIxm', 'Store', 'Manager', '1112223333', true, 'MANAGER', NOW(), NOW());

-- Note: Passwords are hashed using BCrypt. The plain text password for all users is "password123"

-- Create sample carts for users
INSERT IGNORE INTO carts (user_id, total_items, total_amount, created_at, updated_at)
SELECT id, 0, 0.00, NOW(), NOW() FROM users WHERE username IN ('nakdev', 'jane_smith');

-- Add sample cart items
INSERT IGNORE INTO cart_items (cart_id, product_id, quantity, unit_price, subtotal, created_at, updated_at)
SELECT c.id, p.id, 2, p.price * 0.9, p.price * 0.9 * 2, NOW(), NOW()
FROM carts c, products p, users u
WHERE c.user_id = u.id AND u.username = 'nakdev' AND p.sku = 'IPH15P-128';

INSERT IGNORE INTO cart_items (cart_id, product_id, quantity, unit_price, subtotal, created_at, updated_at)
SELECT c.id, p.id, 1, p.price, p.price * 1, NOW(), NOW()
FROM carts c, products p, users u
WHERE c.user_id = u.id AND u.username = 'nakdev' AND p.sku = 'SONY-WH1000XM5';

INSERT IGNORE INTO cart_items (cart_id, product_id, quantity, unit_price, subtotal, created_at, updated_at)
SELECT c.id, p.id, 3, p.price * 0.85, p.price * 0.85 * 3, NOW(), NOW()
FROM carts c, products p, users u
WHERE c.user_id = u.id AND u.username = 'jane_smith' AND p.sku = 'TSHIRT-COTTON-M';

-- Update cart totals
UPDATE carts c
SET total_items = (
    SELECT COALESCE(SUM(ci.quantity), 0)
    FROM cart_items ci
    WHERE ci.cart_id = c.id
),
total_amount = (
    SELECT COALESCE(SUM(ci.subtotal), 0.00)
    FROM cart_items ci
    WHERE ci.cart_id = c.id
);

-- Create sample orders
INSERT IGNORE INTO orders (user_id, order_number, status, total_items, total_amount, tax_amount, shipping_amount, shipping_address, order_date, created_at, updated_at)
SELECT u.id, CONCAT('ORD-', UNIX_TIMESTAMP(NOW()), '-', LPAD(FLOOR(RAND() * 1000), 3, '0')),
'DELIVERED', 2, 2599.98, 207.99, 50.00, '123 Main St, City, State 12345',
DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY),
DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY),
NOW(), NOW()
FROM users u WHERE u.username = 'nakdev';

INSERT IGNORE INTO orders (user_id, order_number, status, total_items, total_amount, tax_amount, shipping_amount, shipping_address, order_date, created_at, updated_at)
SELECT u.id, CONCAT('ORD-', UNIX_TIMESTAMP(NOW()), '-', LPAD(FLOOR(RAND() * 1000), 3, '0')),
'SHIPPED', 1, 89.99, 7.20, 0.00, '456 Oak Ave, Town, State 67890',
DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 15) DAY),
DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 15) DAY),
NOW(), NOW()
FROM users u WHERE u.username = 'jane_smith';

-- Create sample order items
INSERT IGNORE INTO order_items (order_id, product_id, quantity, unit_price, subtotal, product_name, product_sku, created_at)
SELECT o.id, p.id, 1, p.price * 0.95, p.price * 0.95, p.name, p.sku, NOW()
FROM orders o, products p, users u
WHERE o.user_id = u.id AND u.username = 'nakdev' AND p.sku = 'IPH15P-128';

INSERT IGNORE INTO order_items (order_id, product_id, quantity, unit_price, subtotal, product_name, product_sku, created_at)
SELECT o.id, p.id, 1, p.price * 0.85, p.price * 0.85, p.name, p.sku, NOW()
FROM orders o, products p, users u
WHERE o.user_id = u.id AND u.username = 'nakdev' AND p.sku = 'SONY-WH1000XM5';

INSERT IGNORE INTO order_items (order_id, product_id, quantity, unit_price, subtotal, product_name, product_sku, created_at)
SELECT o.id, p.id, 1, p.price, p.price, p.name, p.sku, NOW()
FROM orders o, products p, users u
WHERE o.user_id = u.id AND u.username = 'jane_smith' AND p.sku = 'COFFEEMAKER-12C';

-- Update order totals
UPDATE orders o
SET total_items = (
    SELECT COALESCE(SUM(oi.quantity), 0)
    FROM order_items oi
    WHERE oi.order_id = o.id
),
total_amount = (
    SELECT COALESCE(SUM(oi.subtotal), 0.00) + COALESCE(o.tax_amount, 0.00) + COALESCE(o.shipping_amount, 0.00) - COALESCE(o.discount_amount, 0.00)
    FROM order_items oi
    WHERE oi.order_id = o.id
);

-- Create sample payments
INSERT IGNORE INTO payments (order_id, payment_method, transaction_id, amount, currency, status, payment_date, created_at, updated_at)
SELECT o.id, 'CREDIT_CARD', CONCAT('TXN-', UNIX_TIMESTAMP(NOW()), '-', LPAD(FLOOR(RAND() * 1000), 3, '0')),
o.total_amount, 'INR', 'COMPLETED', NOW(), NOW(), NOW()
FROM orders o WHERE o.user_id IN (SELECT id FROM users WHERE username IN ('nakdev', 'jane_smith'));

-- Update product stock quantities (reduce by orders)
UPDATE products p
SET stock_quantity = stock_quantity - (
    SELECT COALESCE(SUM(oi.quantity), 0)
    FROM order_items oi
    WHERE oi.product_id = p.id
)
WHERE p.id IN (SELECT DISTINCT product_id FROM order_items);
