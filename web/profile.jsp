<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang cá nhân</title>
    <style>
        body { font-family: 'Arial',sans-serif; background: #f8f9fa; color: #333; }
        .container { max-width: 600px; margin: 36px auto 0 auto; padding: 28px 24px 32px 24px; background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08);}
        h2 { text-align: center; color: #2c3e50; margin-bottom: 18px;}
        .profile-form { margin-top: 16px; }
        .form-group { margin-bottom: 18px; }
        .form-label { font-weight: 600; color: #555; display: block; margin-bottom: 8px;}
        .form-input { width: 100%; padding: 11px 14px; border: 1px solid #ddd; border-radius: 6px; font-size: 1rem;}
        .form-input:focus { border-color: #007bff !important; outline: none;}
        .btn { padding: 10px 24px; background: #007bff; color: #fff; border-radius: 6px; border: none; font-weight:600; cursor: pointer; transition: background .2s;}
        .btn:hover { background: #0056b3; }
        .btn-secondary { background: #6c757d;}
        .btn-secondary:hover{background:#545b62;}
        .success-message {background: #d4edda; color:#155724; padding:10px 0;font-weight:600;text-align:center;border-radius: 5px;margin-bottom: 14px;}
        .error-message {background: #f8d7da; color:#721c24; padding:10px 0;font-weight:600;text-align:center;border-radius: 5px;margin-bottom: 14px;}
        .back-link{text-align:center; margin-top:32px;}
        .back-link a{color:#007bff; text-decoration:none;}
        .back-link a:hover{text-decoration:underline;}
        @media (max-width:600px) { .container { padding: 12px; } }
    </style>
</head>
<body>
<%@ include file="partials/header.jsp" %>

<div class="container">
    <h2>👤 Thông tin cá nhân</h2>

<c:if test="${not empty success}">
    <div class="success-message">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="error-message">${error}</div>
</c:if>


    <form action="${pageContext.request.contextPath}/profile" method="post" class="profile-form" autocomplete="off">
        <div class="form-group">
            <label for="fullName" class="form-label">Tên hiển thị:</label>
            <input type="text" id="fullName" name="fullName" class="form-input" value="${user.fullName}" maxlength="48" required>
        </div>
        <div class="form-group">
            <label for="email" class="form-label">Email:</label>
            <input type="email" id="email" name="email" class="form-input" value="${user.email}" maxlength="60" required>
        </div>
        <div class="form-group">
            <label for="password" class="form-label">Mật khẩu mới:</label>
            <input type="password" id="password" name="password" class="form-input" autocomplete="new-password" minlength="6" maxlength="32">
        </div>
        <div class="form-group">
            <label for="confirmPassword" class="form-label">Nhập lại mật khẩu:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" autocomplete="new-password" minlength="6" maxlength="32">
        </div>
        <button type="submit" class="btn">💾 Cập nhật</button>
        <a href="${pageContext.request.contextPath}/products?action=list" class="btn btn-secondary" style="margin-left:8px;">⬅ Về trang sản phẩm</a>
    </form>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/products?action=list">Quay lại trang sản phẩm</a>
    </div>
</div>

<%@ include file="partials/footer.jsp" %>
</body>
</html>
