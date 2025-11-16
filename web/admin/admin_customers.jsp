<%@ include file="admin_check.jsp" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Danh sách khách hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body { font-family: 'Poppins', Arial, sans-serif; background: #f6f8fb; margin: 0; color: #222;}
        .container { max-width:1000px; margin:35px auto; background:#fff; border-radius:12px; padding:28px 20px; box-shadow:0 1.5px 15px rgba(40,52,78,0.07);}
        h2 { color:#25357e; margin-bottom:25px; text-align:center;}
        .customer-box {background:rgba(255,255,255,0.05);padding:16px;margin:24px auto;width:95%;border-radius:12px;}
        .orders-table {width:92%;margin:10px auto;}
        .orders-table th, .orders-table td {padding:8px 12px;border:1px solid rgba(40,52,78,0.08);}
        .orders-table th {background:#e5e9f2;color:#28344e;}
        .orders-table td {background:#fafbff;color:#222;}
        .button {background:#007bff;color:#fff;border:none;padding:5px 16px;border-radius:5px;cursor:pointer;font-weight:600;transition:background 0.18s;text-decoration:none;}
        .button:hover {background:#0056b3;}
        /* Dark mode */
        body.dark-mode {background: linear-gradient(135deg, #0a192f, #020c1b)!important;color:#e0e0e0;}
        body.dark-mode .container {background:rgba(255,255,255,0.04);color:#e0e0e0;}
        body.dark-mode .customer-box {background:rgba(0,0,0,0.13);}
        body.dark-mode .orders-table {background:rgba(255,255,255,0.05);}
        body.dark-mode .orders-table th {background:#232b40!important;color:#00d9ff;}
        body.dark-mode .orders-table td {background:transparent;color:#e0e0e0!important;}
        body.dark-mode .button {background:#00d9ff;color:#222;}
        body.dark-mode .button:hover {background:#0099cc;color:#fff;}
    </style>
    <script>
        function toggleMode() {document.body.classList.toggle('dark-mode');}
    </script>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>
<div class="container">
    <h2>👥 Danh sách khách hàng</h2>
    <c:forEach var="u" items="${users}">
        <div class="customer-box">
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
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.orderId}" class="button">Xem</a>
                                </td>
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
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
