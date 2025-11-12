<%@ include file="admin_check.jsp" %>

<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản lý sản phẩm</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>
<div class="container">
    <h2 style="text-align:center; margin-top:20px;">Quản lý sản phẩm</h2>
    <div style="margin-bottom:20px; text-align:right;">
        <a href="${pageContext.request.contextPath}/admin/products?action=add" class="button">Thêm sản phẩm</a>
    </div>
    <table class="table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Danh mục</th>
            <th>Tên</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Đã bán</th>
            <th>Hình ảnh</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.id}</td>
    <td>
    <c:forEach var="c" items="${categories}">
        <c:if test="${c.categoryId == p.categoryId}">
            ${c.name}
        </c:if>
    </c:forEach>
</td>


                <td>${p.name}</td>
                <td>${p.price}₫</td>
                <td>${p.quantity}</td>
                <td>${p.soldQuantity}</td>
                <td><img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}" style="width:60px;height:60px;object-fit:cover;"></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="button" style="margin-right:5px;background:#0088cc;">Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}" class="button" style="background:#cc0000;" onclick="return confirm('Bạn có chắc muốn xoá sản phẩm này?');">Xoá</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <p style="margin-top:20px; text-align:center;"><a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">Làm mới</a></p>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>