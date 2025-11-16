<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Thêm sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body { font-family: 'Poppins', Arial, sans-serif; background: #f6f8fb; margin: 0; color: #222;}
        .container { max-width:600px; margin:30px auto; background:#fff; border-radius:10px; padding:32px 22px; box-shadow:0 6px 26px rgba(40,52,78,0.07);}
        h2 { color:#25357e; margin-bottom:22px; text-align:center;}
        label { font-weight:600; margin-top:14px; display:block;}
        input[type="text"], input[type="number"], textarea, select {
            width:100%; padding:8px; border-radius:7px; border:1px solid #ccc; background:#fafdff; margin-bottom:12px; margin-top:4px;
        }
        textarea {resize:vertical;}
        .button {
            background:#007bff; color:#fff; border:none; padding:10px 24px; border-radius:6px; font-weight:600; transition:0.2s;
            cursor:pointer; text-decoration:none; display:inline-block;
        }
        .button:hover {background:#0056b3;}
        .error {color:#e53935; font-weight:bold;}
        img {border-radius:8px;}

        /* Dark mode */
        body.dark-mode {background: linear-gradient(135deg, #0a192f, #020c1b) !important; color: #e0e0e0;}
        body.dark-mode .container {background:rgba(255,255,255,0.04);color:#e0e0e0;}
        body.dark-mode input[type="text"], 
        body.dark-mode input[type="number"], 
        body.dark-mode textarea, 
        body.dark-mode select {
            background:rgba(255,255,255,0.07);
            color:#e0e0e0;
            border:1px solid #232b40;
        }
        body.dark-mode .button {background:#00d9ff;color:#222;}
        body.dark-mode .button:hover {background:#0099cc;color:#fff;}
    </style>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<div class="container">
    <h2>Thêm sản phẩm mới</h2>
    <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">
        <label>Danh mục:</label>
        <select name="categoryId">
            <c:forEach var="c" items="${categories}">
                <option value="${c.categoryId}">${c.name}</option>
            </c:forEach>
        </select>
        <label>Tên sản phẩm:</label>
        <input type="text" name="name" required>
        <label>Mô tả:</label>
        <textarea name="description" rows="4"></textarea>
        <label>Giá:</label>
        <input type="number" name="price" step="0.01" required>
        <label>Số lượng:</label>
        <input type="number" name="quantity">
        <label>Thương hiệu:</label>
        <input type="text" name="manufacturer">
        <label>Chọn ảnh sản phẩm:</label>
        <input type="file" name="imageFile">
        <button type="submit" class="button" style="margin-top:14px; width:100%;">Thêm sản phẩm</button>
    </form>
    <p style="margin-top:20px; text-align:center;">
        <a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">Quay lại danh sách</a>
    </p>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
