<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Liên hệ</title>
    <!-- Dùng cùng font với header -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --gold: var(--gold, #d4af37);
            --gold-soft: var(--gold-soft, #e6c763);
            --text-dark: var(--text-dark, #1a1a1a);
            --text-muted: var(--text-muted, #666);
            --bg-white: var(--bg-white, #fff);
            --bg-soft: var(--bg-soft, #fafafa);
            --border: var(--border, #e6e6e6);
            --radius-sm: var(--radius-sm, 8px);
            --radius-md: var(--radius-md, 12px);
            --shadow: var(--shadow, 0 8px 24px rgba(0,0,0,0.06));
            --focus-ring: var(--focus-ring, 0 0 0 3px rgba(212,175,55,.35));
            --font-main: var(--font-main, 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif);
            --transition: var(--transition, .25s ease);
        }

        html, body { height: 100%; }
        body {
            font-family: var(--font-main);
            background-color: var(--bg-soft);
            color: var(--text-dark);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .container {
            max-width: 860px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .contact-box {
            background: var(--bg-white);
            padding: 28px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
        }

        h2 {
            text-align: center;
            color: var(--text-dark);
            margin-bottom: 20px;
            font-size: 2rem;
            letter-spacing: .3px;
        }

        .success-message {
            background-color: #eef8e9;
            color: #256029;
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 18px;
            text-align: center;
            border: 1px solid #cfe9c7;
            font-weight: 500;
        }

        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: var(--text-dark); }

        input[type="text"], input[type="email"], textarea {
            width: 100%;
            padding: 12px 12px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 1rem;
            font-family: var(--font-main);
            background: #fff;
            transition: border-color var(--transition), box-shadow var(--transition), background-color var(--transition);
        }

        input:hover, textarea:hover { background-color: #fcfcfc; }
        input:focus, textarea:focus {
            outline: none;
            border-color: var(--gold);
            box-shadow: var(--focus-ring);
            background-color: #fff;
        }

        textarea { resize: vertical; min-height: 140px; }

        .submit-button {
            width: 100%;
            background-color: var(--gold);
            color: white;
            border: none;
            padding: 14px;
            border-radius: var(--radius-sm);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            letter-spacing: .4px;
            transition: background-color var(--transition), transform .15s ease, filter var(--transition);
        }
        .submit-button:hover {
            background-color: var(--gold-soft);
            filter: brightness(1.02);
            transform: translateY(-1px);
        }
        .submit-button:active { transform: translateY(0); }

        @media (max-width: 768px) {
            .container { padding: 28px 16px; }
            .contact-box { padding: 22px; }
            h2 { font-size: 1.8rem; }
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