<%@ include file="admin_check.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    



    <meta charset="UTF-8">
    <title>Admin - Chỉnh sửa sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif;
            background: #f6f8fb;
            margin: 0;
            color: #222;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            background: #fff;
            border-radius: 10px;
            padding: 32px 22px;
            box-shadow: 0 6px 26px rgba(40,52,78,0.07);
        }
        h2 {
            color: #25357e;
            margin-bottom: 22px;
            text-align: center;
        }
        label {
            font-weight: 600;
            margin-top: 14px;
            display: block;
        }
        input[type="text"], input[type="number"], textarea, select {
            width: 100%;
            padding: 8px;
            border-radius: 7px;
            border: 1px solid #ccc;
            background: #fafdff;
            margin-bottom: 12px;
            margin-top: 4px;
        }
        textarea { resize: vertical; }
        .button {
            background: #007bff;
            color: #fff;
            border: none;
            padding: 10px 28px;
            border-radius: 6px;
            font-weight: 600;
            transition: 0.2s;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .button:hover { background: #0056b3; }
        .error { color: #e53935; font-weight: bold; }
        img { border-radius: 8px; }
    </style>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<div class="container">
    <h2>Chỉnh sửa sản phẩm</h2>

    <!-- Nếu sản phẩm không tồn tại -->
    <c:if test="${empty product}">
        <div class="error" style="text-align:center; margin-bottom:20px;">
            Sản phẩm không tồn tại hoặc đã bị xóa!
        </div>
        <p style="text-align:center;">
            <a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">Quay lại danh sách</a>
        </p>
    </c:if>

    <!-- Nếu sản phẩm tồn tại -->
    <c:if test="${not empty product}">
        <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${product.id}">

            <label>Danh mục:</label>
            <select name="categoryId">
                <c:forEach var="c" items="${categories}">
                    <option value="${c.categoryId}" <c:if test="${c.categoryId == product.categoryId}">selected</c:if>>${c.name}</option>
                </c:forEach>
            </select>

            <label>Tên sản phẩm:</label>
            <input type="text" name="name" value="${product.name}" required>

            <label>Mô tả:</label>
            <textarea name="description" rows="4">${product.description}</textarea>

            <label>Giá:</label>
            <input type="number" name="price" step="0.01" value="${product.price}" required>

            <label>Số lượng còn:</label>
            <input type="number" name="quantity" value="${product.quantity}">

            <label>Số lượng đã bán:</label>
            <input type="number" name="soldQuantity" value="${product.soldQuantity}">

            <label>Thương hiệu:</label>
            <input type="text" name="manufacturer" value="${product.manufacturer}">

            <label>Ảnh hiện tại:</label>
            <div style="margin-bottom:10px;">
                <img src="${pageContext.request.contextPath}/${product.imagePath}" alt="${product.name}" style="width:80px;height:80px;object-fit:cover;">
            </div>
            <input type="hidden" name="imagePath" value="${product.imagePath}">

            <label>Chọn ảnh mới (nếu muốn đổi):</label>
            <input type="file" name="imageFile">

            <button type="submit" class="button" style="margin-top:10px; width:100%;">Cập nhật</button>
        </form>

        <p style="margin-top:20px; text-align:center;">
            <a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">Quay lại danh sách</a>
        </p>
    </c:if>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
