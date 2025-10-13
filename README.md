<!-- 🛒 E-commerce Cart System - Full-Featured Shopping Cart -->

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

---

## 🧩 Overview

A **modular and scalable E-commerce Cart System** implementing a layered architecture to handle products, carts, and orders efficiently.  
Supports integration with **multiple payment gateways** and ensures smooth checkout experiences for users.

---

## ⚙️ Features

- 🛍️ **Product Management** – Add, edit, and view products  
- 🛒 **Cart System** – Add/remove items, update quantities  
- 💰 **Checkout Process** – Secure order creation and payment flow  
- 💳 **Payment Gateway Integration** – Multiple providers supported  
- 👤 **User Authentication** – Session-based login & registration  
- 📦 **Order History** – Track past orders easily  
- 🧱 **Layered Architecture** – Separation of controller, service, and DAO layers  

---

## 🧱 Tech Stack

| Tech | Role |
|------|------|
| ☕ **Java 11+** | Core language |
| 🌿 **Spring MVC** | Web framework |
| 🧮 **MySQL** | Database |
| 🧾 **JSP** | Frontend views |
| 🧰 **Maven** | Build tool |
| 🧪 **Postman / Browser** | Testing interface |

---

## 📂 Project Structure
```bash
ecommerce-cart/
├── controller/       # Web controllers (Cart, Product, Order)
├── service/          # Business logic
├── dao/              # Data access objects
├── model/            # Entity classes
├── webapp/
│   ├── WEB-INF/views/  # JSP pages
│   └── static/         # CSS, JS, images
└── resources/
    ├── application.properties
    └── data.sql (optional)
```

---

## ⚡ Setup & Run

### 🔧 1. Clone the repo
```bash
git clone https://github.com/nakhandev/ecommerce-cart.git
cd ecommerce-cart-system
```

### 🗄️ 2. Configure Database (`application.properties`)
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce_db
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.jpa.hibernate.ddl-auto=update
```

### ▶️ 3. Run the App
```bash
mvn clean install
mvn spring-boot:run
```
> Runs on: **http://localhost:8080**

---

## 🧾 Example Workflow

1. User registers and logs in  
2. Browses product list  
3. Adds items to the cart  
4. Proceeds to checkout  
5. Completes payment and receives order confirmation  

---

## ⚠️ Error Response Example
```json
{
  "timestamp": "2025-10-14T12:45:32Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Product not found in catalog",
  "path": "/cart/add"
}
```

---

## 🚀 Future Enhancements

- 📱 Responsive frontend (Bootstrap / React integration)  
- 🧾 Invoice PDF generation  
- 💌 Email order confirmation  
- 🧠 AI-based product recommendations  
- 🐳 Docker support  

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
