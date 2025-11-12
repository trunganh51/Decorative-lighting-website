<%@ include file="admin_check.jsp" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ý kiến khách hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<div class="container" style="margin-top:30px; color:white;">
    <h2 style="text-align:center; color:#00d9ff;">💬 Ý kiến khách hàng</h2>

    <c:choose>
        <c:when test="${empty feedbacks}">
            <p style="text-align:center; margin-top:20px;">Hiện chưa có ý kiến nào được gửi.</p>
        </c:when>
        <c:otherwise>
            <table border="1" style="width:90%;margin:20px auto;color:white;border-collapse:collapse;">
                <tr style="background:rgba(255,255,255,0.1);">
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Email</th>
                    <th>Nội dung</th>
                    <th>Thời gian</th>
                </tr>
                <c:forEach var="f" items="${feedbacks}">
                    <tr>
                        <td>${f.id}</td>
                        <td>${f.name}</td>
                        <td>${f.email}</td>
                        <td>${f.message}</td>
                        <td>${f.createdAt}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <p style="text-align:center;margin-top:20px;">
        <a href="${pageContext.request.contextPath}/admin/products?action=list"
           class="button">⬅ Quay lại trang quản lý</a>
    </p>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
