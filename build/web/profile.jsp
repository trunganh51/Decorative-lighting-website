<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang cá nhân</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f4f6f8;
                color: #333;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 600px;
                margin: 40px auto;
                padding: 30px 24px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 24px;
                font-size: 1.8rem;
            }

            .profile-form {
                width: 100%;
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-label {
                font-weight: 600;
                color: #555;
                margin-bottom: 8px;
                font-size: 0.95rem;
            }

            .form-input {
                width: 100%;
                padding: 12px 14px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 1rem;
                transition: all 0.2s;
                box-sizing: border-box; /* Quan trọng: tránh input bị tràn */
            }

            .form-input:focus {
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0,123,255,0.3);
                outline: none;
            }

            .button-group {
                display: flex;
                gap: 12px;
                margin-top: 8px;
            }

            .btn {
                padding: 12px 24px;
                border-radius: 8px;
                border: none;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
                transition: background 0.2s;
                color: #fff;
                background: #007bff;
                text-align: center;
                text-decoration: none; /* Cho thẻ <a> */
                display: inline-block; /* Cho thẻ <a> */
                line-height: 1.2;
            }

            .btn:hover {
                background: #0056b3;
            }

            .btn-secondary {
                background: #6c757d;
            }

            .btn-secondary:hover {
                background: #545b62;
            }

            .success-message,
            .error-message {
                width: 100%;
                padding: 12px;
                font-weight: 600;
                text-align: center;
                border-radius: 6px;
                font-size: 0.95rem;
                margin-bottom: 16px;
                box-sizing: border-box;
            }

            .success-message {
                background: #d4edda;
                color: #155724;
            }

            .error-message {
                background: #f8d7da;
                color: #721c24;
            }

            /* Responsive */
            @media (max-width: 600px) {
                .container {
                    margin: 20px;
                    padding: 20px;
                }

                .button-group {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }
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
                <a href="${pageContext.request.contextPath}/products?action=list" class="btn btn-secondary">⬅ Về trang sản phẩm</a>
            </form>
        </div>

        <%@ include file="partials/footer.jsp" %>
    </body>
</html>
