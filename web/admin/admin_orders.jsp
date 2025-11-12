<%@ include file="admin_check.jsp" %>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<head>
    <meta charset="UTF-8">
    <title>Đơn hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>

<%@ include file="../partials/headeradmin.jsp" %>

<h2 style="text-align:center;color:#00d9ff;margin:20px 0;">📦 Quản lý đơn hàng</h2>

<table border="1" style="width:95%;margin:0 auto;color:white;border-collapse:collapse;">
    <tr style="background:rgba(255,255,255,0.1);">
        <th>Mã đơn</th>
        <th>Người đặt</th>
        <th>Ngày đặt</th>
        <th>Tổng tiền</th>
        <th>Địa chỉ</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>

    <c:forEach var="o" items="${orders}">
        <tr>
            <td>${o.orderId}</td>

            <td>
                <c:choose>
                    <c:when test="${not empty o.userName}">
                        ${o.userName}
                    </c:when>
                    <c:otherwise>
                        #${o.userId}
                    </c:otherwise>
                </c:choose>
            </td>

            <td>${o.orderDate}</td>
            <td>${o.totalPrice}₫</td>
            <td>${o.shippingAddress}</td>
            <td>${o.status}</td>

            <td style="text-align:center;">
                <!-- 🔍 Xem chi tiết -->
                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.orderId}"
                   class="button" style="background:#0088cc;">🔍 Xem</a>

                <!-- ✅ Duyệt đơn: chỉ hiển thị khi trạng thái là 'Chờ duyệt' -->
                <c:if test="${o.status eq 'Chờ duyệt'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="orderId" value="${o.orderId}">
                        <button type="submit" class="button" style="background:#28a745;">✅ Duyệt đơn</button>
                    </form>
                </c:if>

                <!-- 🟡 Khi đã duyệt hoặc giao thì không cho sửa -->
                <c:if test="${o.status ne 'Chờ duyệt'}">
                    <span style="opacity:0.7;">đã duyệt</span>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>

<%@ include file="../partials/footer.jsp" %>
