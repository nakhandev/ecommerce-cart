<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty sessionScope.user or sessionScope.user.role != 'ADMIN'}">
    <c:redirect url="/auth/login?error=access_denied"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle + ' - ' : ''}"/>Admin Panel - E-commerce Cart System</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom Admin CSS -->
    <style>
        :root {
            --admin-primary: #0d6efd;
            --admin-secondary: #6c757d;
            --admin-success: #198754;
            --admin-danger: #dc3545;
            --admin-warning: #ffc107;
            --admin-info: #0dcaf0;
            --admin-light: #f8f9fa;
            --admin-dark: #212529;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }

        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, var(--admin-primary) 0%, #0056b3 100%);
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            width: 280px;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .admin-sidebar.collapsed {
            margin-left: -280px;
        }

        .admin-sidebar .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .admin-sidebar .sidebar-header h4 {
            margin: 0;
            font-weight: 600;
        }

        .admin-sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
        }

        .admin-sidebar .nav-link:hover,
        .admin-sidebar .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .admin-sidebar .nav-link i {
            width: 20px;
            margin-right: 10px;
        }

        .main-content {
            margin-left: 280px;
            padding: 2rem;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }

        .main-content.expanded {
            margin-left: 0;
        }

        .admin-header {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .admin-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 1.5rem;
        }

        .admin-card .card-header {
            background: white;
            border-bottom: 1px solid #eee;
            font-weight: 600;
            padding: 1.25rem;
        }

        .admin-card .card-body {
            padding: 1.5rem;
        }

        .stats-card {
            text-align: center;
            padding: 1.5rem;
        }

        .stats-card .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            opacity: 0.7;
        }

        .stats-card .stat-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stats-card .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }

        .btn-admin-primary {
            background-color: var(--admin-primary);
            border-color: var(--admin-primary);
        }

        .btn-admin-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--admin-primary);
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-header h1 {
            color: var(--admin-dark);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .page-header .breadcrumb {
            margin-bottom: 0;
        }

        .alert {
            border-radius: 8px;
            border: none;
        }

        .dropdown-menu {
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        @media (max-width: 768px) {
            .admin-sidebar {
                margin-left: -280px;
            }

            .admin-sidebar.show {
                margin-left: 0;
            }

            .main-content {
                margin-left: 0;
            }

            .main-content.expanded {
                margin-left: 280px;
            }
        }
    </style>

    <!-- Favicon -->
    <link href="<c:url value='/static/images/favicon.svg'/>" rel="icon" type="image/svg+xml">
</head>
<body>
    <!-- Admin Sidebar -->
    <%@ include file="../includes/admin-sidebar.jsp" %>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Admin Header -->
        <%@ include file="../includes/admin-header.jsp" %>

        <!-- Page Content -->
        <c:if test="${not empty pageMessage}">
            <div class="container-fluid">
                <div class="alert alert-${pageMessage.type} alert-dismissible fade show" role="alert">
                    ${pageMessage.text}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- Dynamic Page Content -->
        <jsp:include page="${pageContent != null ? pageContent : 'products/index.jsp'}"/>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <!-- Custom Admin JS -->
    <script>
        $(document).ready(function() {
            // Sidebar toggle
            $('#sidebarToggle').click(function() {
                $('.admin-sidebar').toggleClass('collapsed');
                $('.main-content').toggleClass('expanded');
            });

            // Mobile sidebar toggle
            $('#mobileSidebarToggle').click(function() {
                $('.admin-sidebar').toggleClass('show');
            });

            // Close sidebar when clicking outside on mobile
            $(document).click(function(e) {
                if (!$(e.target).closest('.admin-sidebar').length && !$(e.target).closest('#mobileSidebarToggle').length) {
                    $('.admin-sidebar').removeClass('show');
                }
            });

            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut();
            }, 5000);
        });
    </script>

    <!-- Page-specific scripts -->
    <c:if test="${not empty pageScripts}">
        <c:forEach var="script" items="${pageScripts}">
            <script src="<c:url value='/static/js/admin/${script}'/>"></script>
        </c:forEach>
    </c:if>
</body>
</html>
