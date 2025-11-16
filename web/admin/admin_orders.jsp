<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../partials/headeradmin.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <style>
        body { font-family:'Poppins',Arial,sans-serif;background:#f6f8fb;margin:0;color:#222;}
        .container { max-width:100vw;width:100vw;min-width:1200px;margin:38px 0 0 0; background:#fff; border-radius:0; padding:30px 22px; box-shadow:0 2px 18px rgba(36,44,62,0.08);}
        h2 { color:#00d9ff;text-align:center;margin-bottom:26px;font-size:1.8rem; }
        .table { width:100%; table-layout:auto; border-collapse:collapse; background:#fafbff; border-radius:10px; box-shadow:0 1.2px 8px rgba(36,44,62,0.09);}
        .table th,.table td { border:1px solid #e5e9f2; padding:10px 13px; text-align:center; font-size:1rem; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .table th { background:#e5e9f2; color:#28344e; font-weight:600;}
        .table tr:nth-child(even) { background:#f0f2f7;}
        .table tr:hover td { background:#f9f1d9; }
        .button {background:#0088cc;color:#fff;border:none;padding:7px 20px;border-radius:5px;cursor:pointer;font-weight:600;text-decoration:none;display:inline-block;transition:background .2s;}
        .button:hover {background:#005099;}
        select {padding:6px 12px;font-size:1rem;border-radius:5px;border:1px solid #e5e9f2;}
        form {display:inline;}
        /* --- DARK MODE --- */
        body.dark-mode { background:linear-gradient(135deg,#0a192f,#020c1b)!important; color:#e0e0e0; }
        body.dark-mode .container { background:rgba(255,255,255,0.04); color:#e0e0e0;}
        body.dark-mode .table { background:rgba(255,255,255,0.05);}
        body.dark-mode .table th, body.dark-mode .table td { color:#e0e0e0!important; }
        body.dark-mode .table th { background:#232b40!important; color:#00d9ff;}
        body.dark-mode .table tr:nth-child(even) { background:#181838!important; }
        body.dark-mode .table tr:hover td { background:#263157!important; }
        body.dark-mode .button { background:#00d9ff; color:#222;}
        body.dark-mode .button:hover {background:#0099cc;color:#fff;}
        body.dark-mode select { background:#131b33!important; color:#00d9ff; border:1px solid #232b40;}
    </style>
    <script>
        function toggleMode(){document.body.classList.toggle('dark-mode');}
    </script>
</head>
<body>
<div class="container">
    <h2>📦 Quản lý đơn hàng</h2>
    <table class="table">
        <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Địa chỉ</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="o" items="${orders}">
            <tr>
                <td><c:out value="${o.orderId}"/></td>
                <td><c:out value="${o.userName}"/></td>
                <td><c:out value="${o.userEmail}"/></td>
                <td><c:out value="${o.phone}"/></td>
                <td><fmt:formatDate value="${o.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td><fmt:formatNumber value="${o.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫</td>
                <td><c:out value="${o.shippingAddress}"/></td>
                <td><c:out value="${o.status}"/></td>
                <td style="text-align:center;">
                    <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.orderId}"
                       class="button" style="background:#0088cc;">🔍 Xem</a>
                    <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="orderId" value="${o.orderId}">
                        <select name="status">
                            <option value="Chờ duyệt" <c:if test="${o.status == 'Chờ duyệt'}">selected</c:if>>Chờ duyệt</option>
                            <option value="Đang giao" <c:if test="${o.status == 'Đang giao'}">selected</c:if>>Đang giao</option>
                            <option value="Đã giao" <c:if test="${o.status == 'Đã giao'}">selected</c:if>>Đã giao</option>
                            <option value="Đã huỷ" <c:if test="${o.status == 'Đã huỷ'}">selected</c:if>>Đã huỷ</option>
                        </select>
                        <button type="submit" class="button">Cập nhật</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
