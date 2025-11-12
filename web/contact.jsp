<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Liên hệ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .contact-box {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2rem;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #c3e6cb;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
        }
        
        input[type="text"],
        input[type="email"],
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            font-family: Arial, sans-serif;
        }
        
        input:focus,
        textarea:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        
        textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .submit-button {
            width: 100%;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .submit-button:hover {
            background-color: #0056b3;
        }
        
        @media (max-width: 768px) {
            .contact-box {
                padding: 30px 20px;
            }
            
            h2 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>

<%@ include file="partials/header.jsp" %>

<div class="container">
    <div class="contact-box">
        <h2>📩 Liên hệ với chúng tôi</h2>

        <c:if test="${not empty param.success}">
            <div class="success-message">
                ✅ Cảm ơn bạn đã gửi ý kiến! Chúng tôi sẽ phản hồi sớm nhất.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/SendFeedbackServlet" method="post">
            <div class="form-group">
                <label for="name">Họ và tên:</label>
                <input type="text" id="name" name="name"
                       value="${sessionScope.user != null ? sessionScope.user.fullName : ''}"
                       placeholder="Nhập họ tên của bạn" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email"
                       value="${sessionScope.user != null ? sessionScope.user.email : ''}"
                       placeholder="Nhập địa chỉ email" required>
            </div>

            <div class="form-group">
                <label for="message">Nội dung:</label>
                <textarea id="message" name="message" 
                          placeholder="Nhập nội dung bạn muốn gửi..." required></textarea>
            </div>

            <button type="submit" class="submit-button">Gửi ý kiến</button>
        </form>
    </div>
</div>

<%@ include file="partials/footer.jsp" %>
</body>
</html>