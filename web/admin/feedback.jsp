<%@ include file="admin_check.jsp" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản lý ý kiến</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body { font-family: 'Poppins', Arial, sans-serif; background: #f6f8fb; margin: 0; color: #222;}
        .main-header { background: #28344e; color:#fff; padding:12px 0 0 0; box-shadow: 0 2px 12px rgba(40,52,78,0.09);}
        .site-title { font-size:1.7rem; font-weight:bold; text-align:center; margin-bottom:10px; letter-spacing:2px;}
        .nav-bar { background:#202940; padding:0; margin-top:10px; box-shadow:0 2px 8px rgba(32,41,64,0.075); display:flex; justify-content:space-between;align-items:center;}
        .menu { margin:0;padding:0 20px;display:flex;list-style:none;align-items:center;gap:25px;}
        .menu li a { color:#fff; text-decoration:none; padding:15px 22px;display:flex;align-items:center; font-weight:600;transition:background 0.25s; border-radius:7px;}
        .menu li a:hover, .menu li a.active { background:#34416b; color:#ffd700;}
        .menu li i {margin-right:6px;font-size:1.05em;}
        .right-area {display:flex;align-items:center;gap:14px;}
        .login-area { color: #fff; font-weight: 500; margin-right: 22px; display: flex; align-items: center; gap: 10px;}
        .login-btn { background:#FFD700;color:#333;padding:8px 16px; border-radius:6px; font-weight:600;transition:0.3s;text-transform:uppercase;box-shadow:0 2px 6px rgba(0,0,0,0.1);text-decoration:none;}
        .login-btn:hover {background:#FFC107;color:#000;}
        .dark-toggle { background: #34416b; color: #ffd700; border: none; border-radius: 6px; padding: 8px 15px; font-weight: bold; cursor: pointer; font-size: 1rem; transition: background 0.25s; display: flex; align-items: center; gap: 6px;}
        .dark-toggle:hover { background: #FFD700; color: #28344e;}
        .container { max-width:900px; margin:35px auto; background:#fff; border-radius:12px; padding:28px 20px; box-shadow:0 1.5px 15px rgba(40,52,78,0.07);}
        h2 { color:#25357e; margin-bottom:25px; text-align:center;}
        .table { width:100%; border-collapse:collapse; margin-top:18px; background:#fafbff; border-radius:9px; overflow:hidden; box-shadow:0 1px 7px rgba(36,44,62,0.09);}
        .table th, .table td { border:1px solid #e5e9f2; padding:9px 11px; text-align:center; color:#222;}
        .table th { background:#e5e9f2; font-weight:bold; color:#28344e; font-size:1rem; letter-spacing:0.5px;}
        .table tr:nth-child(even) { background:#f0f2f7;}
        .table tr:hover td { background:#f9f1d9;}
        .empty-message { text-align:center; color:#888; font-size:1.1em; margin-top:26px; margin-bottom:24px;}
        @media (max-width:900px) {.container{padding:6px;}.main-header,.site-title{font-size:1.15rem;}.table th,.table td{padding:5px;}}
        /* DARK MODE */
        body.dark-mode {background: linear-gradient(135deg, #0a192f, #020c1b) !important; color: #e0e0e0;}
        body.dark-mode .main-header {background: #1a2233; color:#ffd700;}
        body.dark-mode .site-title {color:#00d9ff;}
        body.dark-mode .nav-bar {background: #232b40 !important;}
        body.dark-mode .menu li a {color: #e0e0e0 !important;}
        body.dark-mode .menu li a:hover {background: #00d9ff !important; color: #181838 !important;}
        body.dark-mode .login-btn {background: #00d9ff; color:#232b40;}
        body.dark-mode .login-btn:hover {background: #0099cc; color:#fff;}
        body.dark-mode .dark-toggle {background:#FFD700;color:#181838;}
        body.dark-mode .dark-toggle:hover {background:#232b40;color:#FFD700;}
        body.dark-mode .container {background:rgba(255,255,255,0.04);color:#e0e0e0;}
        body.dark-mode .table {background:rgba(255,255,255,0.05);}
        body.dark-mode .table th, body.dark-mode .table td {color:#e0e0e0!important;}
        body.dark-mode .table th {background:#232b40!important; color:#00d9ff;}
        body.dark-mode .table tr:nth-child(even) {background: #181838 !important;}
        body.dark-mode .table tr:hover td {background: #263157 !important;}
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
    <h2>Danh sách ý kiến khách hàng</h2>
    <c:choose>
        <c:when test="${empty feedbacks}">
            <div class="empty-message">Hiện chưa có ý kiến nào được gửi.</div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Nội dung</th>
                        <th>Thời gian</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="f" items="${feedbacks}">
                        <tr>
                            <td>${f.id}</td>
                            <td>${f.name}</td>
                            <td>${f.email}</td>
                            <td>${f.message}</td>
                            <td>${f.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
