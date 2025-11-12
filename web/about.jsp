<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        h2 {
            text-align: center;
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 30px;
        }
        
        .intro-text {
            text-align: center;
            color: #666;
            font-size: 1.1rem;
            max-width: 800px;
            margin: 0 auto 50px;
        }
        
        .category-container {
            display: flex;
            gap: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .category-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            width: 450px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .category-card:hover {
            transform: translateY(-5px);
        }
        
        .category-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .category-card h3 {
            color: #2c3e50;
            font-size: 1.4rem;
            margin-bottom: 15px;
        }
        
        .category-card p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .button {
            background-color: #007bff;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        
        .button:hover {
            background-color: #0056b3;
        }
        
        @media (max-width: 768px) {
            .category-card {
                width: 100%;
            }
            
            h2 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<%@ include file="partials/header.jsp" %>

<div class="container">
    <h2>Giới thiệu về Web Bán Đèn Trang Trí</h2>
    <p class="intro-text">
        Chào mừng bạn đến với <strong>Web Bán Đèn Trang Trí</strong> – nơi cung cấp các sản phẩm chiếu sáng hiện đại và phong cách.
        Chúng tôi phân chia sản phẩm theo 2 dòng chính để giúp bạn dễ dàng lựa chọn phù hợp với không gian sống.
    </p>

    <div class="category-container">
        <div class="category-card">
            <img src="${pageContext.request.contextPath}/images/indoor.jpg" alt="Chiếu sáng trong nhà">
            <h3>💡 Chiếu sáng trong nhà</h3>
            <p>
                Mang lại ánh sáng ấm áp, sang trọng cho không gian sống của bạn với các mẫu
                <strong>đèn chùm, đèn bàn, đèn tường, đèn ốp trần</strong> đa dạng phong cách.
            </p>
            <a href="${pageContext.request.contextPath}/products?category=trongnha" class="button">
                Xem sản phẩm
            </a>
        </div>

        <div class="category-card">
            <img src="${pageContext.request.contextPath}/images/outdoor.jpg" alt="Chiếu sáng ngoài trời">
            <h3>🌟 Chiếu sáng ngoài trời</h3>
            <p>
                Tô điểm cho không gian sân vườn, cổng và lối đi với các mẫu
                <strong>đèn trụ cổng, đèn pha, đèn sân vườn</strong> bền đẹp, tiết kiệm năng lượng.
            </p>
            <a href="${pageContext.request.contextPath}/products?category=ngoaitroi" class="button">
                Xem sản phẩm
            </a>
        </div>
    </div>
</div>

<%@ include file="partials/footer.jsp" %>
</body>
</html>