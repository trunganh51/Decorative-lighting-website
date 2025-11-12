<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<header class="main-header">
    <div class="site-title">QUẢN TRỊ HỆ THỐNG</div>
    <nav class="nav-bar">
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/products?action=list"><i class="fas fa-boxes"></i> Sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products?action=revenue"><i class="fas fa-chart-bar"></i> Doanh thu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="fas fa-users"></i> Khách hàng</a></li>
<li><a href="${pageContext.request.contextPath}/admin/feedbacks"><i class="fas fa-comments"></i> Ý kiến</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-shopping-basket"></i> Đơn hàng</a></li>
        </ul>
        <div class="login-area">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span>Xin chào, ${sessionScope.user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/auth?action=logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a class="login-btn" href="${pageContext.request.contextPath}/auth?action=login">
                        <i class="fas fa-user"></i> ĐĂNG NHẬP
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>