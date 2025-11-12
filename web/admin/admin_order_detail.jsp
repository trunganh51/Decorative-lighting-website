<%@ include file="admin_check.jsp" %>

<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<%@ include file="../partials/headeradmin.jsp" %>

<h2 style="text-align:center;color:#00d9ff;margin:20px 0;">📋 Chi tiết đơn hàng #${orderId}</h2>

<table border="1" style="width:90%;margin:0 auto;color:white;border-collapse:collapse;">
    <tr style="background:rgba(255,255,255,0.1);">
        <th>Ảnh</th>
        <th>Tên sản phẩm</th>
        <th>Số lượng</th>
        <th>Giá</th>
        <th>Tổng</th>
    </tr>

    <c:forEach var="d" items="${details}">
        <tr>
            <td>
                <img src="${pageContext.request.contextPath}/${d.product.imagePath}"
                     width="80" height="80" style="object-fit:cover;border-radius:8px;">
            </td>
            <td>${d.product.name}</td>
            <td>${d.quantity}</td>
            <td>${d.price}₫</td>
            <td>${d.quantity * d.price}₫</td>
        </tr>
    </c:forEach>
</table>

<p style="text-align:center;margin-top:20px;">
    <a href="${pageContext.request.contextPath}/admin/orders"
       class="button" style="background:#00d9ff;">⬅ Quay lại danh sách</a>
</p>

<%@ include file="../partials/footer.jsp" %>
