<%@ include file="admin_check.jsp" %>

<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khách hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <style>
        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            color: white;
        }
        th, td {
            padding: 8px 12px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        th { background: rgba(255,255,255,0.1); }
        .orders-table {
            width: 90%;
            margin: 10px auto;
        }
    </style>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>
<h2 style="text-align:center;color:#00d9ff;margin:20px 0;">👥 Danh sách khách hàng</h2>

<c:forEach var="u" items="${users}">
    <div style="background:rgba(255,255,255,0.05);padding:15px;margin:20px auto;width:90%;border-radius:10px;">
        <h3 style="color:#00d9ff;">${u.fullName} (${u.email})</h3>
        <p><strong>Vai trò:</strong> ${u.role}</p>
        <c:set var="userOrders" value="${ordersByUser[u.id]}" />
        <c:if test="${not empty userOrders}">
            <table class="orders-table">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${userOrders}">
                        <tr>
                            <td>${o.orderId}</td>
                            <td>${o.orderDate}</td>
                            <td>${o.totalPrice}₫</td>
                            <td>${o.status}</td>
                            <td><a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.orderId}" class="button">Xem</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty userOrders}">
            <p style="color:#aaa;">Chưa có đơn hàng.</p>
        </c:if>
    </div>
</c:forEach>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>