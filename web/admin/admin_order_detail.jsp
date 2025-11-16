<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${orderId}</title>
    <style>
        body { font-family:'Poppins',Arial,sans-serif;background:#f6f8fb;margin:0;color:#222; }
        .container { max-width:900px; margin:38px auto; background:#fff; border-radius:14px; padding:35px 32px; box-shadow:0 2px 16px rgba(36,44,62,0.10);}
        h2 { color:#00d9ff;text-align:center;margin-bottom:28px;font-size:1.48rem; }
        .table { width:100%; border-collapse:collapse; background:#fafbff; border-radius:10px; box-shadow:0 1px 8px rgba(36,44,62,0.06);}
        .table th,.table td { border:1px solid #e5e9f2; padding:13px 10px;text-align:center;font-size:1.06rem;color:#222;}
        .table th { background:#e5e9f2; color:#28344e; font-weight:600;}
        .table tr:nth-child(even) { background:#f0f2f7;}
        .table tr:hover td { background:#f9f1d9;}
        img { border-radius:8px;box-shadow:0 1px 6px rgba(100,120,160,0.09);}
        .button {background:#00d9ff;color:#fff;border:none;padding:8px 24px;border-radius:5px;cursor:pointer; font-weight:600;text-decoration:none;display:inline-block;transition:background .2s;}
        .button:hover {background:#0099cc;}
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
    </style>
    <script>
        function toggleMode() { document.body.classList.toggle('dark-mode'); }
    </script>
</head>
<body>
    <%@ include file="../partials/headeradmin.jsp" %>
<div class="container">
    <h2>📋 Chi tiết đơn hàng #${orderId}</h2>
    <table class="table">
        <thead>
            <tr>
                <th>Ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá</th>
                <th>Tổng</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="d" items="${details}">
            <tr>
                <td>
                    <img src="${pageContext.request.contextPath}/${d.product.imagePath}"
                         width="80" height="80" style="object-fit:cover;">
                </td>
                <td><c:out value="${d.product.name}"/></td>
                <td><c:out value="${d.quantity}"/></td>
                <td><fmt:formatNumber value="${d.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫</td>
                <td><fmt:formatNumber value="${d.quantity * d.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>₫</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <p style="text-align:center;margin-top:26px;">
        <a href="${pageContext.request.contextPath}/admin/orders"
           class="button">⬅ Quay lại danh sách</a>
    </p>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
