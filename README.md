<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=28&pause=1000&color=00C0FF&center=true&vCenter=true&width=435&lines=E-commerce+Cart+System;Version+1.0.0+(V1)" alt="Typing SVG" />
</p>


<h1 align="center">🛒 E-commerce Cart System</h1>
<h3 align="center">A full-featured shopping cart built using <span style="color:#6DB33F;">Spring MVC</span>, <span style="color:#00758F;">MySQL</span>, and <span style="color:#E76F00;">JSP</span></h3>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Java-11+-E76F00?style=for-the-badge&logo=openjdk&logoColor=white">
    <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/Java-11+-F89820?style=for-the-badge&logo=openjdk&logoColor=black">
    <img alt="Java Badge" src="https://img.shields.io/badge/Java-11+-E76F00?style=for-the-badge&logo=openjdk&logoColor=white">
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Spring%20MVC-6DB33F?style=for-the-badge&logo=spring&logoColor=white">
    <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/Spring%20MVC-6DB33F?style=for-the-badge&logo=spring&logoColor=black">
    <img alt="Spring MVC Badge" src="https://img.shields.io/badge/Spring%20MVC-6DB33F?style=for-the-badge&logo=spring&logoColor=white">
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
    <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/MySQL-8.0-F29111?style=for-the-badge&logo=mysql&logoColor=black">
    <img alt="MySQL Badge" src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/JSP-View%20Layer-00599C?style=for-the-badge&logo=oracle&logoColor=white">
    <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/JSP-View%20Layer-008FCC?style=for-the-badge&logo=oracle&logoColor=black">
    <img alt="JSP Badge" src="https://img.shields.io/badge/JSP-View%20Layer-00599C?style=for-the-badge&logo=oracle&logoColor=white">
  </picture>
</p>

## 🎉 **LIVE & WORKING!** All major issues have been resolved:
- ✅ **Security Configuration** - Modern Spring Security 5.x implementation
- ✅ **JSP Pages** - All pages fully functional with jQuery integration
- ✅ **AJAX Functionality** - Dynamic content loading working perfectly
- ✅ **Template Issues** - Fixed category/product display problems
- ✅ **Database Integration** - Complete data flow from backend to frontend

## ✨ Features Implemented

### 🏗️ **Core Architecture**
- **Layered Architecture**: Controller, Service, Repository, and Model layers
- **Spring Boot Integration**: Auto-configuration and dependency injection
- **JPA/Hibernate**: ORM with MySQL database
- **MVC Pattern**: Clean separation of concerns

### 👥 **User Management**
- User registration and authentication
- Role-based access control (ADMIN, MANAGER, CUSTOMER)
- Password encryption with BCrypt
- User profile management

### 📦 **Product Management**
- Product catalog with categories
- Product search and filtering
- Inventory management
- Featured products and discounts
- Product image support

### 🛒 **Shopping Cart**
- Add/remove items from cart
- Quantity management
- Real-time total calculations
- Stock validation
- Cart persistence

### 💳 **Order Processing**
- Complete checkout workflow
- Order status tracking
- Order history
- Tax and shipping calculations

### 💰 **Payment System**
- Mock payment gateway (prototype)
- Payment status tracking
- Transaction management
- Multiple payment method support

### 📊 **Sample Data**
- Pre-populated categories and products
- Sample user accounts
- Test orders and payments

## 🚀 Quick Start

### Prerequisites
- **Java 11+**
- **MySQL 8.0+**
- **Maven 3.6+**

### 1. Database Setup

1. **Install MySQL Server** (if not already installed)
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install mysql-server

   # CentOS/RHEL
   sudo yum install mysql-server

   # macOS
   brew install mysql
   ```

2. **Start MySQL Service**
   ```bash
   sudo systemctl start mysql  # Linux
   brew services start mysql   # macOS
   ```

3. **Create Database**
   ```sql
   CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'ecommerce_user'@'localhost' IDENTIFIED BY 'yourpassword';
   GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'ecommerce_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

4. **Update Database Configuration**
   Edit `src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   spring.datasource.username=nakdev
   spring.datasource.password=Linux@1998
   ```

### 2. Run the Application

#### Option A: Using Shell Scripts (Recommended)
```bash
# Clone and navigate to project
git clone https://github.com/nakhandev/ecommerce-cart.git
cd ecommerce-cart

# Make scripts executable (one time only)
chmod +x start.sh stop.sh status.sh

# Start the application
./start.sh

# Check status
./status.sh

# Stop the application
./stop.sh
```

#### Option B: Using Maven Commands
```bash
# Clone and navigate to project
git clone https://github.com/nakhandev/ecommerce-cart.git
cd ecommerce-cart

# Build and run
mvn clean install
mvn spring-boot:run

# Or run directly
mvn spring-boot:run
```

**Application will be available at:** http://localhost:8080

### 3. Application Management

#### Using Shell Scripts
```bash
# Start application
./start.sh

# Check status
./status.sh

# Stop application
./stop.sh

# View logs
tail -f application.log
```

#### Using Maven
```bash
# Start application
mvn spring-boot:run

# Stop application (Ctrl+C)
# View application logs
# Application runs in foreground
```

### 4. Default Login Credentials

| Username | Password | Role |
|----------|----------|------|
| `admin` | `password123` | ADMIN |
| `manager` | `password123` | MANAGER |
| `nakdev` | `password123` | CUSTOMER |
| `jane_smith` | `password123` | CUSTOMER |

## 📁 Project Structure

```
ecommerce-cart/
├── controller/           # REST API controllers ✅
│   ├── CartController.java ✅
│   ├── CategoryController.java ✅
│   ├── HomeController.java ✅
│   ├── OrderController.java ✅
│   ├── PaymentController.java ✅
│   ├── ProductController.java ✅
│   └── UserController.java ✅
├── service/              # Business logic layer ✅
│   ├── CartService.java ✅
│   ├── CategoryService.java ✅
│   ├── OrderService.java ✅
│   ├── PaymentService.java ✅
│   ├── ProductService.java ✅
│   └── UserService.java ✅
├── service/impl/         # Service implementations ✅
├── repository/           # Data access layer ✅
├── model/                # JPA entities ✅
├── config/               # Configuration classes ✅
│   ├── SecurityConfig.java ✅ (Modern Spring Security 5.x)
│   ├── WebMvcConfig.java ✅
│   └── DataInitializer.java ✅
├── webapp/               # JSP views ✅ (Fully implemented)
│   ├── WEB-INF/views/    # All pages working ✅
│   │   ├── public/       # Home, About, Contact ✅
│   │   ├── products/     # Product catalog with AJAX ✅
│   │   ├── categories/   # Category browsing ✅
│   │   ├── cart/         # Shopping cart ✅
│   │   ├── checkout/     # Checkout process ✅
│   │   ├── orders/       # Order management ✅
│   │   ├── admin/        # Admin interface ✅
│   │   ├── account/      # User account ✅
│   │   └── error/        # Error pages ✅
│   └── static/           # CSS, JS, Images ✅
│       ├── css/custom.css ✅
│       ├── js/app.js ✅
│       └── images/ ✅
└── resources/
    ├── application.properties ✅
    └── data.sql ✅ (Auto-populated with sample data)
```

## 🛠️ Technology Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| **Java** | 11+ | Core language |
| **Spring Boot** | 2.7.0 | Web framework |
| **Spring MVC** | - | Web layer |
| **Spring Data JPA** | - | Data access |
| **MySQL** | 8.0+ | Database |
| **Hibernate** | - | ORM |
| **Maven** | 3.6+ | Build tool |
| **JSP** | - | View templates |

## 🔧 Configuration

### Application Properties
Key configuration options in `application.properties`:

```properties
# Server
server.port=8080

# Database
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce_db
spring.datasource.username=root
spring.datasource.password=yourpassword

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# JSP Views
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

## 📊 Sample Data

The application automatically initializes with:

### Categories (6)
- Electronics, Clothing, Books
- Home & Garden, Sports & Outdoors
- Health & Beauty

### Products (10)
- iPhone 15 Pro, Samsung Galaxy S24
- MacBook Air M3, Sony WH-1000XM5
- Clean Code Book, Coffee Maker
- Yoga Mat, Running Shoes, etc.

### Users (4)
- Admin, Manager, 2 Customers

## 🔄 REST API Endpoints (Fully Implemented)

### 📊 **API Base URL:** `http://localhost:8080/api/`

### 👥 **User Management APIs**
```
POST   /api/users/register           - Register new user
GET    /api/users/profile           - Get user profile
PUT    /api/users/profile           - Update user profile
GET    /api/users                   - Get all users (admin)
GET    /api/users/{id}              - Get user by ID (admin)
GET    /api/users/search            - Search users
PUT    /api/users/{id}/activate     - Activate user (admin)
PUT    /api/users/{id}/deactivate   - Deactivate user (admin)
PUT    /api/users/{id}/role         - Change user role (admin)
DELETE /api/users/{id}              - Delete user (admin)
GET    /api/users/stats             - Get user statistics (admin)
```

### 📦 **Product Management APIs**
```
GET    /api/products                - List all products (paginated)
GET    /api/products/{id}           - Get product details
POST   /api/products                - Create product (admin)
PUT    /api/products/{id}           - Update product (admin)
DELETE /api/products/{id}           - Delete product (admin)
GET    /api/products/search         - Search products
GET    /api/products/featured       - Get featured products
GET    /api/products/sale           - Get products on sale
GET    /api/products/in-stock       - Get in-stock products
GET    /api/products/price-range    - Get products by price range
GET    /api/products/category/{id}  - Get products by category
PUT    /api/products/{id}/stock     - Update product stock (admin)
PUT    /api/products/{id}/featured  - Set product as featured (admin)
GET    /api/products/stats          - Get product statistics (admin)
GET    /api/products/{id}/availability - Check product availability
```

### 🏷️ **Category Management APIs**
```
GET    /api/categories              - List all categories
GET    /api/categories/{id}         - Get category details
POST   /api/categories              - Create category (admin)
PUT    /api/categories/{id}         - Update category (admin)
DELETE /api/categories/{id}         - Delete category (admin)
GET    /api/categories/active       - Get active categories
GET    /api/categories/search       - Search categories
PUT    /api/categories/{id}/activate    - Activate category (admin)
PUT    /api/categories/{id}/deactivate  - Deactivate category (admin)
GET    /api/categories/stats        - Get category statistics (admin)
```

### 🛒 **Shopping Cart APIs**
```
GET    /api/cart                    - Get user cart
POST   /api/cart/items              - Add item to cart
PUT    /api/cart/items/{productId}  - Update item quantity
DELETE /api/cart/items/{productId}  - Remove item from cart
DELETE /api/cart                    - Clear cart
GET    /api/cart/items              - Get cart items
GET    /api/cart/count              - Get cart item count
GET    /api/cart/empty              - Check if cart is empty
GET    /api/cart/validate           - Validate cart items
POST   /api/cart/recalculate        - Recalculate cart totals
GET    /api/cart/contains/{productId} - Check if product in cart
GET    /api/cart/summary            - Get cart summary
```

### 📋 **Order Management APIs**
```
POST   /api/orders                  - Create order from cart
POST   /api/orders/place            - Place order (with payment)
GET    /api/orders                  - Get user orders
GET    /api/orders/{id}             - Get order details
GET    /api/orders/number/{orderNumber} - Get order by number
GET    /api/orders/status/{status}  - Get orders by status
PUT    /api/orders/{id}/status      - Update order status (admin)
PUT    /api/orders/{id}/cancel      - Cancel order
GET    /api/orders/search           - Search orders
GET    /api/orders/recent           - Get recent orders
GET    /api/orders/can-place        - Check if order can be placed
GET    /api/orders/validate         - Validate order for placement
GET    /api/orders/stats            - Get order statistics (admin)
DELETE /api/orders/{id}             - Delete order (admin)
```

### 💳 **Payment Management APIs**
```
POST   /api/payments/process        - Process payment
GET    /api/payments/{id}           - Get payment details
GET    /api/payments/transaction/{id} - Get payment by transaction ID
GET    /api/payments/order/{orderId} - Get payment by order ID
GET    /api/payments/status/{status} - Get payments by status
GET    /api/payments/method/{method} - Get payments by method
GET    /api/payments/user/{userId}  - Get payments by user
GET    /api/payments/search         - Search payments
PUT    /api/payments/{id}/status    - Update payment status (admin)
PUT    /api/payments/{id}/complete  - Mark payment as completed (admin)
PUT    /api/payments/{id}/fail      - Mark payment as failed (admin)
GET    /api/payments/stats          - Get payment statistics (admin)
GET    /api/payments                - Get all payments (admin)
```

## 🎯 **Recent Fixes & Improvements (v1.0)**
*All major issues have been resolved and the application is now fully functional!*

### ✅ **Security & Configuration**
- **Fixed Deprecated Security**: Replaced `WebSecurityConfigurerAdapter` with modern Spring Security 5.x
- **Modern Configuration**: Updated to use `SecurityFilterChain` bean pattern
- **Lambda Expressions**: Clean, modern configuration syntax

### ✅ **Frontend Integration**
- **jQuery Integration**: Added jQuery 3.7.1 CDN to all JSP pages
- **Bootstrap JS**: Full Bootstrap 5.3 integration for responsive components
- **AJAX Functionality**: Dynamic content loading working perfectly
- **Real-time Updates**: Live cart updates and search functionality

### ✅ **Template & Display Issues**
- **Fixed Categories Page**: Resolved JavaScript template issues showing "false" values
- **Clean Products Page**: Removed debug content and streamlined interface
- **Proper Data Binding**: Category names, descriptions, and product counts display correctly
- **Error Handling**: Graceful fallbacks for missing data

### ✅ **User Experience**
- **Responsive Design**: Mobile-friendly layouts across all pages
- **Interactive Elements**: Working buttons, forms, and navigation
- **Loading States**: Proper loading indicators and user feedback
- **Modern UI**: Clean, professional interface design

## 🚀 **Current Status - FULLY FUNCTIONAL**
- **✅ All JSP Pages Working**: Home, Products, Categories, Cart, Orders, Admin
- **✅ All REST APIs Working**: Complete backend functionality
- **✅ Database Integration**: Full data flow from backend to frontend
- **✅ Security**: Modern authentication and authorization
- **✅ User Interface**: Professional, responsive design

## 🚧 Future Enhancements (v2.0)
1. **Real Payment Gateway** - Stripe/PayPal integration
2. **Email Notifications** - Order confirmations and updates
3. **Advanced Admin Dashboard** - Enhanced management interface
4. **Docker Support** - Containerization for easy deployment
5. **API Documentation** - Swagger/OpenAPI integration

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**
   ```bash
   # Check MySQL status
   sudo systemctl status mysql

   # Verify database exists
   mysql -u root -p -e "SHOW DATABASES;"
   ```

2. **Port Already in Use**
   ```bash
   # Change port in application.properties
   server.port=8081
   ```

3. **Memory Issues**
   ```bash
   # Increase Maven memory
   MAVEN_OPTS="-Xmx1024m" mvn spring-boot:run
   ```

## 📝 Development Notes

- **Database**: Auto-creates tables via Hibernate
- **Sample Data**: Automatically loaded on startup
- **Logging**: Detailed logging with SLF4J
- **Validation**: Bean validation with custom validators
- **Transactions**: Service layer methods are transactional

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---
## 👨‍💻 Author

**[MD Nawab Ali Khan](https://github.com/nakhandev)**  
💼 *Java Backend Developer | Open Source Enthusiast*  

<p align="center">
  <a href="https://github.com/nakhandev">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/GitHub-nakhandev-181717?style=for-the-badge&logo=github&logoColor=white">
      <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/GitHub-nakhandev-F0F0F0?style=for-the-badge&logo=github&logoColor=black">
      <img alt="GitHub Profile" src="https://img.shields.io/badge/GitHub-nakhandev-181717?style=for-the-badge&logo=github&logoColor=white">
    </picture>
  </a>
  <a href="https://nakhandev.github.io">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/🌐%20Portfolio-nakhandev.github.io-0078D7?style=for-the-badge">
      <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/🌐%20Portfolio-nakhandev.github.io-0A66C2?style=for-the-badge">
      <img alt="Portfolio Link" src="https://img.shields.io/badge/🌐%20Portfolio-nakhandev.github.io-0078D7?style=for-the-badge">
    </picture>
  </a>
</p>

---

<p align="center">✨ Built with ❤️ using <b>Spring MVC + JSP</b> ✨</p>

*For questions or support, please contact: admin@ecommerce.com*
