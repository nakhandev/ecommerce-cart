<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Admin Sidebar -->
<div class="admin-sidebar" id="adminSidebar">
    <!-- Sidebar Header -->
    <div class="sidebar-header">
        <h4><i class="fas fa-cog me-2"></i>Admin Panel</h4>
    </div>

    <!-- Sidebar Navigation -->
    <nav class="nav nav-pills flex-column mt-3">
        <!-- Dashboard -->
        <a href="<c:url value='/admin/dashboard'/>"
           class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>

        <!-- Products -->
        <div class="nav-item">
            <a href="<c:url value='/admin/products'/>"
               class="nav-link ${currentPage == 'products' ? 'active' : ''}">
                <i class="fas fa-box"></i> Products
            </a>
        </div>

        <!-- Categories -->
        <a href="<c:url value='/admin/categories'/>"
           class="nav-link ${currentPage == 'categories' ? 'active' : ''}">
            <i class="fas fa-tags"></i> Categories
        </a>

        <!-- Orders -->
        <a href="<c:url value='/admin/orders'/>"
           class="nav-link ${currentPage == 'orders' ? 'active' : ''}">
            <i class="fas fa-shopping-cart"></i> Orders
        </a>

        <!-- Users -->
        <a href="<c:url value='/admin/users'/>"
           class="nav-link ${currentPage == 'users' ? 'active' : ''}">
            <i class="fas fa-users"></i> Users
        </a>

        <!-- Payments -->
        <a href="<c:url value='/admin/payments'/>"
           class="nav-link ${currentPage == 'payments' ? 'active' : ''}">
            <i class="fas fa-credit-card"></i> Payments
        </a>

        <!-- Reports -->
        <a href="<c:url value='/admin/reports'/>"
           class="nav-link ${currentPage == 'reports' ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i> Reports
        </a>

        <!-- Settings -->
        <a href="<c:url value='/admin/settings'/>"
           class="nav-link ${currentPage == 'settings' ? 'active' : ''}">
            <i class="fas fa-cog"></i> Settings
        </a>
    </nav>

    <!-- Sidebar Footer -->
    <div class="mt-auto p-3 border-top border-secondary">
        <div class="text-center">
            <small class="text-white-50">
                Logged in as:<br>
                <strong>${sessionScope.user.firstName} ${sessionScope.user.lastName}</strong><br>
                <span class="badge bg-light text-dark">${sessionScope.user.role}</span>
            </small>
        </div>
    </div>
</div>
