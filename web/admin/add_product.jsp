<%@ include file="admin_check.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Thêm sản phẩm</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<div class="container" style="max-width:500px;">
    <h2 style="text-align:center; margin-top:20px;">Thêm sản phẩm mới</h2>

    <!-- ✅ Form xử lý thêm sản phẩm -->
    <form action="${pageContext.request.contextPath}/admin/products" 
          method="post" enctype="multipart/form-data">

        <input type="hidden" name="action" value="add">

        <label>Danh mục:</label>
       <select name="categoryId" required style="color:black; background-color:white; border-radius:6px; padding:6px;">
            <c:forEach var="c" items="${categories}">
                <option value="${c.categoryId}">${c.name}</option>
            </c:forEach>
        </select>

        <label>Tên sản phẩm:</label>
        <input type="text" name="name" required>

        <label>Mô tả:</label>
        <textarea name="description" rows="4"></textarea>

        <label>Giá:</label>
        <input type="number" name="price" step="0.01" min="0" required>

        <label>Số lượng:</label>
        <input type="number" name="quantity" value="0" min="0">

        <label>Số lượng đã bán:</label>
        <input type="number" name="soldQuantity" value="0" min="0">

        <label>Thương hiệu:</label>
        <input type="text" name="manufacturer">

        <label>Chọn ảnh sản phẩm:</label>
        <input type="file" name="imageFile" accept="image/*">

        <!-- ✅ Ẩn đường dẫn ảnh để fallback nếu không chọn -->
        <input type="hidden" name="imagePath" value="">

        <button type="submit" class="button" 
                style="margin-top:10px; width:100%; background:#00b4d8; color:white; border:none; border-radius:8px; padding:10px;">
            ➕ Thêm sản phẩm
        </button>
    </form>

    <p style="margin-top:20px; text-align:center;">
        <a href="${pageContext.request.contextPath}/admin/products?action=list" 
           class="button" 
           style="display:inline-block; text-decoration:none; background:#555; color:white; padding:8px 14px; border-radius:6px;">
            ⬅ Quay lại danh sách
        </a>
    </p>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
