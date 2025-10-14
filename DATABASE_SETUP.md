# Database Setup Guide

## Prerequisites
- MySQL Server 8.0 or higher installed
- MySQL Workbench (optional, for GUI management)
- Database user with appropriate privileges

## Installation Steps

### 1. Install MySQL Server

#### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

#### CentOS/RHEL:
```bash
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
```

#### macOS:
```bash
brew install mysql
brew services start mysql
```

#### Windows:
Download and install MySQL Installer from: https://dev.mysql.com/downloads/installer/

### 2. Secure MySQL Installation
```bash
sudo mysql_secure_installation
```

### 3. Create Database and User

#### Using MySQL Command Line:
```bash
sudo mysql -u root -p

# Create database
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Create user (replace 'yourpassword' with a strong password)
CREATE USER 'nakdev'@'localhost' IDENTIFIED BY 'Linux@1998';

# Grant privileges
GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'nakdev'@'localhost';

# Flush privileges
FLUSH PRIVILEGES;

# Exit MySQL
EXIT;
```

#### Using MySQL Workbench:
1. Open MySQL Workbench
2. Connect to your MySQL server
3. Go to "File" → "New Query Tab"
4. Execute the above SQL commands

### 4. Update Application Properties

Update `src/main/resources/application.properties` with your database credentials:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=nakdev
spring.datasource.password=Linux@1998
```

### 5. Test Database Connection

Run the application:
```bash
mvn spring-boot:run
```

If the application starts without database connection errors, the setup is successful.

## Troubleshooting

### Common Issues:

1. **Connection Refused**
   - Ensure MySQL server is running
   - Check if the database exists
   - Verify username and password

2. **Access Denied**
   - Check user privileges
   - Ensure the user exists
   - Verify the database name

3. **SSL Connection Error**
   - Add `useSSL=false` to the JDBC URL
   - Or configure SSL properly if required

### Useful Commands:

```bash
# Check MySQL status
sudo systemctl status mysql

# Start MySQL
sudo systemctl start mysql

# Stop MySQL
sudo systemctl stop mysql

# Restart MySQL
sudo systemctl restart mysql

# Check MySQL processes
ps aux | grep mysql

# Connect to MySQL
mysql -u root -p

# Show databases
SHOW DATABASES;

# Use database
USE ecommerce_db;

# Show tables
SHOW TABLES;

# Describe table structure
DESCRIBE users;
```

## Database Schema

The application will automatically create the following tables:

- **users** - User accounts and authentication
- **products** - Product catalog
- **categories** - Product categories
- **carts** - Shopping carts
- **cart_items** - Items in carts
- **orders** - Customer orders
- **order_items** - Items in orders
- **payments** - Payment transactions

## Sample Data

After successful setup, the application will automatically populate sample data including:
- Sample user accounts
- Product categories
- Sample products
- Test orders

## Performance Tuning

For production, consider these optimizations:

```sql
-- Create indexes for better performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_payments_order ON payments(order_id);
```

## Backup and Recovery

```bash
# Create backup
mysqldump -u root -p ecommerce_db > ecommerce_backup.sql

# Restore backup
mysql -u root -p ecommerce_db < ecommerce_backup.sql
