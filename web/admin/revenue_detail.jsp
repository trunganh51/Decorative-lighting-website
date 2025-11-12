<%@ include file="admin_check.jsp" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết doanh thu tuần ${weekCode}</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #0a192f;
            color: white;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            text-align: center;
        }
        th {
            background: rgba(0,217,255,0.2);
        }
        h2 {
            color: #00d9ff;
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<h2>📅 Chi tiết doanh thu tuần ${weekCode}</h2>
<table>
    <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Số lượng</th>
            <th>Doanh thu (VND)</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${details}">
            <tr>
                <td><c:out value="${row[0]}"/></td>
                <td><c:out value="${row[1]}"/></td>
                <td><c:out value="${row[2]}"/> VND</td>
            </tr>
        </c:forEach>
        <c:if test="${empty details}">
            <tr><td colspan="3">Không có dữ liệu cho tuần này</td></tr>
        </c:if>
    </tbody>
</table>

<div style="text-align:center;">
    <a href="${pageContext.request.contextPath}/admin/products?action=revenue" class="button">⬅ Quay lại biểu đồ</a>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
