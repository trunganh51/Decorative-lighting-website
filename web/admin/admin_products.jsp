<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản lý sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif;
            background: #f6f8fb;
            color: #222;
            margin: 0;
            padding: 0;
            line-height: 1.7;
        }
        .main-header {
            background: #28344e;
            color: #fff;
            padding: 12px 0 0 0;
            box-shadow: 0 2px 12px rgba(40,52,78,0.09);
        }
        .site-title {
            font-size: 1.7rem;
            font-weight: bold;
            text-align: center;
            margin-bottom: 10px;
            letter-spacing: 2px;
        }
        .nav-bar {
            background: #202940;
            padding: 0;
            margin-top: 10px;
            box-shadow: 0 2px 8px rgba(32,41,64,0.075);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .menu {
            margin: 0;
            padding: 0 20px;
            display: flex;
            list-style: none;
            align-items: center;
            gap: 25px;
        }
        .menu li a {
            color: #fff;
            text-decoration: none;
            padding: 15px 22px;
            display: flex;
            align-items: center;
            font-weight: 600;
            transition: background 0.25s;
            border-radius: 7px;
        }
        .menu li a:hover, .menu li a.active {
            background: #34416b;
            color: #ffd700;
        }
        .menu li i {
            margin-right: 6px;
            font-size: 1.05em;
        }
        .right-area { display: flex; align-items: center; gap: 14px; }
        .login-area {
            color: #fff;
            font-weight: 500;
            margin-right: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .login-btn {
            background: #FFD700;
            color: #333;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            transition: 0.3s;
            text-transform: uppercase;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            text-decoration: none;
        }
        .login-btn:hover {
            background: #FFC107;
            color: #000;
        }
        .dark-toggle {
            background: #34416b;
            color: #ffd700;
            border: none;
            border-radius: 6px;
            padding: 8px 15px;
            font-weight: bold;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.25s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .dark-toggle:hover { background: #FFD700; color: #28344e; }
        .container {
            max-width: 1100px;
            margin: 28px auto;
            padding: 22px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 1.5px 15px rgba(40,52,78,0.07);
        }
        h2 {
            color: #25357e;
            margin: 22px 0;
            font-size: 1.6rem;
        }
        .button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 9px 22px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.25s;
            text-decoration: none;
            display: inline-block;
        }
        .button:hover {
            background-color: #0056b3;
            color: #fff;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 18px;
            background: #fafbff;
            border-radius: 9px;
            overflow: hidden;
            box-shadow: 0 1px 7px rgba(36,44,62,0.09);
        }
        .table th, .table td {
            border: 1px solid #e5e9f2;
            padding: 9px 11px;
            text-align: center;
            color: #222;
        }
        .table th {
            background: #e5e9f2;
            font-weight: bold;
            color: #28344e;
            font-size: 1rem;
            letter-spacing: 0.5px;
        }
        .table tr:nth-child(even) {
            background: #f0f2f7;
        }
        .table tr:hover td {
            background: #f9f1d9;
        }
        .table img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 1px 6px rgba(36,44,62,0.07);
        }
        @media (max-width: 900px) {
            .container { padding: 6px; }
            .main-header, .site-title { font-size: 1.15rem; }
            .table th, .table td { padding: 5px; }
        }
        /* DARK MODE */
body.dark-mode {
    background: linear-gradient(135deg, #0a192f, #020c1b) !important;
    color: #e0e0e0;
}
body.dark-mode .container {
    background: rgba(255,255,255,0.04);
    color: #e0e0e0;
}
body.dark-mode .table {
    background: rgba(255,255,255,0.05);
}
body.dark-mode .table th {
    background: #232b40 !important;
    color: #00d9ff !important;
}
body.dark-mode .table td {
    background: transparent !important;
    color: #e0e0e0 !important;
}
body.dark-mode .table tr:nth-child(even) {
    background: #181838 !important;
}
body.dark-mode .table tr:hover td {
    background: #263157 !important;
}
body.dark-mode .button, body.dark-mode a.button {
    background-color: #00d9ff;
    color: #181838;
}
body.dark-mode .button:hover, body.dark-mode a.button:hover {
    background-color: #00aacc;
    color: #fff;
}

    </style>
    <script>
        function toggleMode() {
            document.body.classList.toggle('dark-mode');
        }
    </script>
</head>
<body>
    <%@ include file="../partials/headeradmin.jsp" %>


<div class="container">
    <h2 style="text-align:center; margin-top:20px;">Quản lý sản phẩm</h2>

    <div style="margin-bottom:20px; text-align:right;">
        <a href="${pageContext.request.contextPath}/admin/products?action=add" class="button">Thêm sản phẩm</a>
    </div>
<form method="get" action="${pageContext.request.contextPath}/admin/products?action=search" style="margin-bottom: 20px;">
    <input type="hidden" name="action" value="search">
    <input type="text" name="keyword" placeholder="🔍 Tìm sản phẩm..."
           value="${keyword != null ? keyword : ''}"
           style="padding:8px 12px; width:260px; border:1px solid #ccc; border-radius:6px;">
    <button type="submit"
            style="padding:8px 14px; background-color:#007bff; border:none; border-radius:6px; color:white;">
        Tìm
    </button>
</form>

    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Danh mục</th>
                <th>Tên</th>
                <th>Giá</th>
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
        <td>
            <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}">
        </td>
        <td>
            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="button" style="background:#0088cc; margin-right:6px;">
                <i class="fas fa-pen"></i> Sửa
            </a>
            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}" class="button" style="background:#e53935;" 
               onclick="return confirm('Bạn có chắc muốn xoá sản phẩm này?');">
                <i class="fas fa-trash"></i> Xóa
            </a>
        </td>
    </tr>
</c:forEach>
        </tbody>
    </table>

    <p style="margin-top:20px; text-align:center;">
        <a href="${pageContext.request.contextPath}/products?action=list" class="button">Về trang chủ</a>
    </p>
</div>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
