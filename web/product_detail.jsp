<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.name} - Chi tiết sản phẩm</title>
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
            padding: 30px 20px;
        }
        
        .success-alert {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #c3e6cb;
        }
        
        .main-content {
            display: flex;
            gap: 40px;
            flex-wrap: wrap;
        }
        
        .product-section {
            flex: 1;
            min-width: 400px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .product-section h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 25px;
            font-size: 2rem;
        }
        
        .product-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        
        .product-info {
            margin-bottom: 30px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #333;
        }
        
        .price-value {
            color: #007bff;
            font-weight: bold;
            font-size: 1.2rem;
        }
        
        .stock-value {
            color: #28a745;
            font-weight: 600;
        }
        
        .cart-form {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
        }
        
        .quantity-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .quantity-input {
            width: 80px;
            padding: 8px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
            transition: background-color 0.3s ease;
        }
        
        .button:hover {
            background-color: #0056b3;
            text-decoration: none;
            color: white;
        }
        
        .button.secondary {
            background-color: #6c757d;
        }
        
        .button.secondary:hover {
            background-color: #545b62;
        }
        
        .related-section {
            flex: 2;
            min-width: 600px;
        }
        
        .section-title {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            font-size: 1.8rem;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .product-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
        }
        
        .product-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .product-card h4 {
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .product-card .price {
            color: #007bff;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .back-link {
            text-align: center;
            margin-top: 40px;
        }
        
        .back-link a {
            color: #007bff;
            text-decoration: none;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .main-content {
                flex-direction: column;
            }
            
            .product-section,
            .related-section {
                min-width: auto;
            }
            
            .quantity-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
<%@ include file="partials/header.jsp" %>

<div class="container">
    <c:if test="${param.added eq 'true'}">
        <div class="success-alert">
            ✅ Sản phẩm đã được thêm vào giỏ hàng!
        </div>
    </c:if>

    <div class="main-content">
        <!-- Product Detail -->
        <div class="product-section">
            <h2>💡 ${product.name}</h2>
            <img src="${pageContext.request.contextPath}/${product.imagePath}"
                 alt="${product.name}" class="product-image">
            
            <div class="product-info">
                <div class="info-item">
                    <span class="info-label">💰 Giá:</span>
                    <span class="info-value price-value">${product.price}₫</span>
                </div>
                <div class="info-item">
                    <span class="info-label">🏭 Hãng:</span>
                    <span class="info-value">${product.manufacturer}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">📦 Kho:</span>
                    <span class="info-value stock-value">${product.quantity} sản phẩm</span>
                </div>
            </div>

            <div class="cart-form">
                <form action="${pageContext.request.contextPath}/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">
                    
                    <div class="quantity-section">
                        <label for="qty">Số lượng:</label>
                        <input type="number" id="qty" name="quantity" 
                               class="quantity-input" min="1" max="${product.quantity}" value="1">
                    </div>
                    
                    <button type="submit" class="button">🛒 Thêm vào giỏ</button>
                    <a href="${pageContext.request.contextPath}/products?action=list" 
                       class="button secondary">📋 Danh sách</a>
                </form>
            </div>
        </div>

        <!-- Related Products -->
        <div class="related-section">
            <h3 class="section-title">🔥 Sản phẩm khác</h3>
            <div class="product-grid">
                <c:forEach var="p" items="${relatedProducts}">
                    <div class="product-card">
                        <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}">
                        <h4>${p.name}</h4>
                        <p class="price">${p.price}₫</p>
                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.id}"
                           class="button">Xem chi tiết</a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/products?action=list">
            ⬅ Quay lại danh sách sản phẩm
        </a>
    </div>
</div>

<%@ include file="partials/footer.jsp" %>
</body>
</html>