<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
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
        
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2rem;
        }
        
        .search-info {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .search-keyword {
            color: #007bff;
            font-weight: bold;
        }
        
        .search-count {
            color: #28a745;
            font-weight: bold;
        }
        
        .search-actions {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .clean-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        
        .clean-btn:hover {
            background-color: #545b62;
            text-decoration: none;
            color: white;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
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
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .product-card h3 {
            margin-bottom: 10px;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .product-card .price {
            color: #007bff;
            font-weight: bold;
            font-size: 1.1rem;
            margin-bottom: 15px;
        }
        
        .button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 3px;
            font-size: 0.9rem;
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
        
        .no-results {
            background: white;
            padding: 60px 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .no-results h3 {
            color: #2c3e50;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }
        
        .no-results p {
            color: #666;
            margin-bottom: 30px;
        }
        
        .suggestions {
            text-align: left;
            max-width: 500px;
            margin: 30px auto;
        }
        
        .suggestions h4 {
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .suggestions ul {
            list-style: none;
            padding: 0;
        }
        
        .suggestions li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }
        
        .suggestions li:before {
            content: '•';
            color: #007bff;
            position: absolute;
            left: 0;
        }
        
        .back-section {
            text-align: center;
            margin-top: 40px;
        }
        
        @media (max-width: 768px) {
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
            }
        }
    </style>
</head>
<body>
<%@ include file="partials/header.jsp" %>

<div class="container">
    <h2>🔍 Kết quả tìm kiếm</h2>

    <!-- Search Info -->
    <c:if test="${not empty searchKeyword}">
        <div class="search-info">
            <p>
                Kết quả tìm kiếm cho: <span class="search-keyword">"${searchKeyword}"</span>
                - Tìm thấy <span class="search-count">${not empty products ? products.size() : 0}</span> sản phẩm
            </p>
        </div>
    </c:if>

    <!-- Actions -->
    <div class="search-actions">
        <a href="${pageContext.request.contextPath}/products?action=list" class="clean-btn">
            🧹 Xem tất cả sản phẩm
        </a>
    </div>

    <!-- Results -->
    <c:choose>
        <c:when test="${not empty products}">
            <div class="product-grid">
                <c:forEach var="p" items="${products}">
                    <div class="product-card">
                        <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}" />
                        <h3>${p.name}</h3>
                        <p class="price">${p.price}₫</p>
                        
                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="add" />
                            <input type="hidden" name="productId" value="${p.id}" />
                            <button type="submit" class="button">🛒 Thêm vào giỏ</button>
                        </form>
                        
                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.id}" 
                           class="button secondary">Chi tiết</a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="no-results">
                <h3>Không tìm thấy sản phẩm</h3>
                <p>Rất tiếc, không có sản phẩm nào phù hợp với từ khóa tìm kiếm.</p>
                
                <div class="suggestions">
                    <h4>Gợi ý:</h4>
                    <ul>
                        <li>Kiểm tra lại chính tả</li>
                        <li>Thử từ khóa ngắn gọn hơn</li>
                        <li>Tìm theo danh mục sản phẩm</li>
                        <li>Tìm theo thương hiệu</li>
                    </ul>
                </div>
                
                <a href="${pageContext.request.contextPath}/products?action=list" class="button">
                    🏠 Về trang chủ
                </a>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="back-section">
        <a href="${pageContext.request.contextPath}/products?action=list" class="button secondary">
            ⬅ Quay lại danh sách sản phẩm
        </a>
    </div>
</div>

<%@ include file="partials/footer.jsp" %>
</body>
</html>