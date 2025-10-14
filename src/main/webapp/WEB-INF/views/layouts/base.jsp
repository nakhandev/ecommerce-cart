<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : ''}"/>E-commerce Cart System</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<c:url value='/static/css/custom.css'/>" rel="stylesheet">

    <!-- Favicon -->
    <link href="<c:url value='/static/images/favicon.svg'/>" rel="icon" type="image/svg+xml">
</head>
<body>
    <!-- Header/Navbar -->
    <%@ include file="../includes/header.jsp" %>

    <!-- Main Content -->
    <main class="main-content">
        <c:if test="${not empty pageMessage}">
            <div class="container mt-4">
                <div class="alert alert-${pageMessage.type} alert-dismissible fade show" role="alert">
                    ${pageMessage.text}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- Page Content -->
        <jsp:include page="${pageContent != null ? pageContent : 'public/index.jsp'}"/>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <!-- Custom JS -->
    <script src="<c:url value='/static/js/app.js'/>"></script>

    <!-- Page-specific scripts -->
    <c:if test="${not empty pageScripts}">
        <c:forEach var="script" items="${pageScripts}">
            <script src="<c:url value='/static/js/${script}'/>"></script>
        </c:forEach>
    </c:if>
</body>
</html>
