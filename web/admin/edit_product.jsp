<%@ include file="admin_check.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Chỉnh sửa sản phẩm</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<div class="container" style="max-width:600px;">
    <h2 style="text-align:center; margin-top:20px;">Chỉnh sửa sản phẩm</h2>

    <form action="${pageContext.request.contextPath}/admin/products" 
          method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${product.id}">

        <label>Danh mục:</label>
        <select name="categoryId" required style="color:black; background-color:white; border-radius:6px; padding:6px;">
            <c:forEach var="c" items="${categories}">
                <option value="${c.categoryId}" 
                    <c:if test="${c.categoryId == product.categoryId}">selected="selected"</c:if>>
                    ${c.name}
                </option>
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
            <img src="${pageContext.request.contextPath}/${product.imagePath}" 
                 alt="${product.name}" 
                 style="width:100px;height:100px;object-fit:cover;border-radius:8px;border:1px solid #ccc;">
        </div>

        <!-- ✅ Giữ đường dẫn ảnh cũ -->
        <input type="hidden" name="imagePath" value="${product.imagePath}">

        <label>Chọn ảnh mới (nếu muốn đổi):</label>
        <!-- ✅ Đã sửa: image/* -->
        <input type="file" name="imageFile" accept="image/*">

        <button type="submit" class="button" style="margin-top:15px; width:100%;">
            💾 Cập nhật sản phẩm
        </button>
    </form>

    <p style="margin-top:20px; text-align:center;">
        <a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">
            ⬅ Quay lại danh sách
        </a>
    </p>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
