<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Admin Header -->
<div class="admin-header d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center">
        <!-- Mobile Sidebar Toggle -->
        <button class="btn btn-outline-secondary me-3 d-lg-none" id="mobileSidebarToggle">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Desktop Sidebar Toggle -->
        <button class="btn btn-outline-secondary me-3 d-none d-lg-block" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Page Title -->
        <div>
            <h5 class="mb-0">${pageTitle != null ? pageTitle : 'Dashboard'}</h5>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="<c:url value='/admin/dashboard'/>">Admin</a>
                    </li>
                    <li class="breadcrumb-item active">${currentPage != null ? currentPage : 'Dashboard'}</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Right Side Actions -->
    <div class="d-flex align-items-center">
        <!-- Notifications -->
        <div class="dropdown me-3">
            <button class="btn btn-outline-secondary position-relative" type="button" data-bs-toggle="dropdown">
                <i class="fas fa-bell"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    3
                </span>
            </button>
            <div class="dropdown-menu dropdown-menu-end">
                <h6 class="dropdown-header">Notifications</h6>
                <a class="dropdown-item" href="#">
                    <small class="text-muted">2 minutes ago</small><br>
                    <span>Low stock alert for 3 products</span>
                </a>
                <a class="dropdown-item" href="#">
                    <small class="text-muted">1 hour ago</small><br>
                    <span>New order received #12345</span>
                </a>
                <a class="dropdown-item" href="#">
                    <small class="text-muted">3 hours ago</small><br>
                    <span>Payment failed for order #12344</span>
                </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item text-center" href="<c:url value='/admin/notifications'/>">
                    View all notifications
                </a>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="dropdown me-3">
            <button class="btn btn-admin-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                <i class="fas fa-plus me-1"></i>Quick Add
            </button>
            <div class="dropdown-menu dropdown-menu-end">
                <a class="dropdown-item" href="<c:url value='/admin/products/create'/>">
                    <i class="fas fa-box me-2"></i>Add Product
                </a>
                <a class="dropdown-item" href="<c:url value='/admin/categories/create'/>">
                    <i class="fas fa-tags me-2"></i>Add Category
                </a>
                <a class="dropdown-item" href="<c:url value='/admin/users/create'/>">
                    <i class="fas fa-user me-2"></i>Add User
                </a>
            </div>
        </div>

        <!-- User Menu -->
        <div class="dropdown">
            <button class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                <div class="user-avatar me-2">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.profileImage}">
                            <img src="${sessionScope.user.profileImage}" alt="User" class="rounded-circle" width="32" height="32">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                ${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="d-none d-md-block">
                    <div class="fw-bold">${sessionScope.user.firstName}</div>
                    <small class="text-muted">${sessionScope.user.role}</small>
                </div>
            </button>
            <div class="dropdown-menu dropdown-menu-end">
                <h6 class="dropdown-header">
                    ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                </h6>
                <a class="dropdown-item" href="<c:url value='/admin/profile'/>">
                    <i class="fas fa-user me-2"></i>My Profile
                </a>
                <a class="dropdown-item" href="<c:url value='/admin/settings'/>">
                    <i class="fas fa-cog me-2"></i>Settings
                </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="<c:url value='/admin/dashboard'/>">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
                <a class="dropdown-item" href="<c:url value='/'/>">
                    <i class="fas fa-store me-2"></i>View Store
                </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item text-danger" href="<c:url value='/auth/logout'/>">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>
    </div>
</div>

<style>
.user-avatar img {
    object-fit: cover;
}
</style>
