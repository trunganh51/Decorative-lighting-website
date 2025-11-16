<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Đảm bảo admin_check.jsp vẫn tồn tại và hoạt động tốt --%>
<%@ include file="admin_check.jsp" %> 
<%
    // Import các DAO
    dao.ProductDAO productDAO = new dao.ProductDAO();
    dao.OrderDAO orderDAO = new dao.OrderDAO();
    dao.UserDAO userDAO = new dao.UserDAO();
    
    // --- Mục 1: Tổng sản phẩm ---
    int totalProducts = productDAO.countProducts();

    // --- Mục 2: Tổng doanh thu (chỉ tính các đơn "giao thành công") ---
    double totalRevenue = orderDAO.getTotalRevenue(); // đã có hàm getTotalRevenue()

    // --- Mục 3: Sản phẩm sắp hết hàng (< 20) ---
    List<model.Product> lowStockProducts = productDAO.getLowStockProducts();

    // --- Mục 4: Sản phẩm còn hàng (>= 20) ---
    List<model.Product> inStockProducts = productDAO.getInStockProducts();

    // --- Mục 5: Top 5 Users tiêu dùng nhiều nhất ---
    // UserDAO.getTopUsers(int limit) trả về List<Map<String,Object>>
    List<Map<String, Object>> topUsers = userDAO.getTopUsers(5);

    pageContext.setAttribute("totalProducts", totalProducts);
    pageContext.setAttribute("totalRevenue", totalRevenue);
    pageContext.setAttribute("lowStockProducts", lowStockProducts);
    pageContext.setAttribute("inStockProducts", inStockProducts);
    pageContext.setAttribute("topUsers", topUsers);
%>

<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<style>
    /* CSS CỦA BẠN (GIỮ NGUYÊN) */
    /* Base Styles */
    body { font-family: "Segoe UI", Arial, Helvetica, sans-serif; background: #f9f9f9; color: #222; margin:0;}
    h3 {color: #333;}
    .section { padding: 0 20px; max-width: 1400px; margin: 0 auto; }

    /* Stat Cards */
    .stat-cards { display: flex; justify-content: center; gap: 24px; margin: 35px 0 24px 0;}
    .stat-card { background: #fff; border-radius: 13px; box-shadow: 0 2px 14px rgba(40,52,78,0.09); padding: 16px 18px; min-width:120px; width:165px; display: flex; flex-direction: column; align-items: flex-start;}
    .stat-card .stat-label {font-size: 1.01rem;}
    .stat-card .stat-value {font-size: 1.44rem; font-weight: bold; margin-top: 5px; color: #007bff;}
    .stat-card i {color: #007bff; font-size: 1.2rem;}

    /* Layout (Điều chỉnh tỉ lệ 2.5:1) */
    .dashboard-area {
        display: grid;
        grid-template-columns: 2.5fr 1fr;
        gap: 24px;
        align-items: flex-start;
    }
    @media (max-width:900px) {
      .dashboard-area{ grid-template-columns:1fr; }
      #top5Section{margin-top:22px;}
    }

    /* Product Tables */
    .stock-area {background:#fff; border-radius:10px; box-shadow:0 2px 10px rgba(40,52,78,0.06); padding:26px;}
    .stock-tabs { display:flex; gap:10px; margin-bottom:13px; }
    .stock-btn { border:none; border-radius:7px; padding:10px 24px; background:#e4e8f7; color:#34416b; font-weight:600; font-size:1.04rem; cursor:pointer;}
    .stock-btn.active, .stock-btn:hover { background:#34416b; color:#ffd700; border:2px solid #ffd700; }
    .stock-table { margin-bottom:18px;}
    table { border-collapse: collapse; width: 100%; margin-bottom: 10px;}
    th, td { border: 1px solid #bbb; padding: 8px 6px; text-align: center; font-size:0.98em; transition:background 0.2s;}
    th { background: #f5f6fa;}
    
    /* 🌟 Cải tiến Font Size: Chỉ tăng cho bảng CÒN HÀNG 🌟 */
    /* Giữ nguyên font-size cho bảng SẮP HẾT HÀNG */
    #tabLowStock table th, #tabLowStock table td { font-size: 0.98em; } 
    
    /* Tăng font-size cho bảng CÒN HÀNG */
    #tabInStock table th, #tabInStock table td { font-size: 1.15em; padding: 10px 8px;}

    /* 🌟 Sửa lỗi CSS: Form nhập hàng layout DỌC (Một trên, một dưới) 🌟 */
    .stock-form {
        display: flex;
        flex-direction: column; /* Đổi thành cột */
        align-items: center; 
        justify-content: center;
        gap: 5px; 
        width: 100%;
    }
    .form-fields {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 100%; 
    }
    .stock-input { 
        font-size: 0.9em; 
        padding: 5px 4px; 
        border: 2px solid #007bff; 
        border-radius: 6px; 
        background: #f7fafc; 
        font-weight: 500; 
        text-align: center; 
        width: 80px; /* Kích thước tối ưu hơn */
        box-sizing: border-box; /* Bao gồm padding và border trong chiều rộng */
    }
    .stock-submit { 
        font-size: 0.9em; 
        font-weight: bold; 
        background: #007bff; 
        color: #fff; 
        border: none; 
        border-radius: 6px; 
        padding: 6px 8px; 
        width: 80px; /* Bằng với input */
        box-sizing: border-box; /* Bao gồm padding và border trong chiều rộng */
        cursor: pointer; 
        display: flex; 
        align-items: center; 
        gap: 4px; 
        justify-content:center;
    }
    .stock-submit:hover { background: #28344e; color: #ffd700;}
    .stock-submit i { font-size: 1em; color: #ffd700;}

    /* --- Sửa lỗi CSS TOP 5 USERS --- */
    #top5Section {
        background: #fff; border-radius:14px; 
        box-shadow: 0 2px 13px rgba(26,56,109,0.07); 
        padding:24px 18px; 
        min-width:240px;
    }
    .top5-title { margin-bottom: 15px; font-size: 1.28rem; color: #007bff; display: flex; align-items: center; gap: 8px; font-weight:600;}
    .top5-list { display:grid; grid-template-columns:1fr; gap: 13px;}
    .top5-card {
        background: #fcfcfc; border-radius: 10px;
        box-shadow: 0 2px 9px rgba(40,52,78,0.07); 
        padding: 20px 15px; 
        border: 2px solid #e3e9f6; 
        transition: box-shadow .17s, border-color.2s;
    }
    .top5-card.top1 { border-color: #ffd700;}
    .top5-card:hover { box-shadow:0 7px 21px rgba(40,123,255,0.13);}
    .user-rank { font-size: 1.09em; font-weight: bold; color: #ffbe00; display: flex; align-items: center; gap: 4px; margin-bottom: 4px;}
    .top5-card:not(.top1) .user-rank { color: #adb5bd; }
    .user-rank .fa-crown { color: #ffd700;}
    .user-rank .fa-medal { color: #58a8f8;}
    .rank-no { background: #ececec; color: #007bff; border-radius: 8px; padding: 1px 7px; font-size: 1em; margin-left: 2px;}
    .top5-card.top1 .rank-no { background: #ffe47a; color:#c28100;}
    .user-info { font-size: 1.06em; margin-bottom: 1px;}
    .user-name a { font-weight:600; color:#007bff; text-decoration:none;}
    .user-name a:hover {color:#ff7f0e;}
    .user-email { font-size: 0.93em; color: #586180;}
    .user-phone { font-size: 0.95em; color:#2d8b36;}
    .user-phone i { margin-right: 6px; }
    .user-data { font-size: 0.99em; margin-top: 3px; display:flex; flex-direction:row; gap:10px; color: #475178; justify-content:flex-start;}
    .user-orders { font-weight:600; color:#2981dc;}
    .user-money { font-weight:600; color: #145f20;}
    /* --------------------------------- */


    /* Dark Mode */
    body.dark-mode {background: #181a20; color: #e0e0e0;}
    body.dark-mode h3 {color: #ffd700;}
    
    /* Cải tiến Dark Mode: Màu Thẻ Thống Kê */
    body.dark-mode .stat-card {background: #202535; border: 1px solid #3a4768;}
    body.dark-mode .stat-card i {color: #79a6fe;} 
    body.dark-mode .stat-card .stat-label { color:#c7d4ff;} 
    body.dark-mode .stat-card .stat-value { 
        color:#00e5ff; 
        text-shadow: 0 0 5px rgba(0, 229, 255, 0.4);
    }
    
    body.dark-mode .stock-area {background:#23262f;}
    body.dark-mode .stock-btn { background:#181838; color:#FFD700;}
    body.dark-mode .stock-btn.active, body.dark-mode .stock-btn:hover { background:#ffd700; color:#181838; border-color: #ffd700;}
    
    body.dark-mode table, body.dark-mode th, body.dark-mode td {background:#23253a !important; color:#e0e0e0; border-color:#323454;}
    body.dark-mode th {background:#26314b !important;}
    
    body.dark-mode .stock-input {background:#1a2233; color:#fff; border-color:#ffd700;}
    body.dark-mode .stock-input:focus {border-color:#e0e0e0;}
    body.dark-mode .stock-submit {background:#ffd700; color:#222;}
    body.dark-mode .stock-submit i {color:#222;}
    body.dark-mode .stock-submit:hover {background:#007bff; color:#fff;}
    body.dark-mode .stock-submit:hover i {color:#ffd700;}

    body.dark-mode #top5Section {background:#23262f;}
    body.dark-mode .top5-title {color:#00d9ff;}
    body.dark-mode .top5-card {background:#20252f; border-color:#313f76;}
    body.dark-mode .top5-card.top1 {border-color:#ffd700;}
    body.dark-mode .user-info .user-name a {color:#ffd700;}
    body.dark-mode .user-info .user-name a:hover{color:#00d9ff;}
    body.dark-mode .user-email {color:#73d1fb;}
    body.dark-mode .user-phone{color:#73e49f;}
    body.dark-mode .user-phone i { color: #00d9ff; }
    body.dark-mode .user-orders { color:#00bfb3;}
    body.dark-mode .user-money { color: #7fff8d;}
</style>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>
<div class="stat-cards">
    <div class="stat-card">
        <i class="fas fa-bags-shopping"></i>
        <span class="stat-label">Tổng sản phẩm</span>
        <span class="stat-value">
            <fmt:formatNumber value="${totalProducts}" type="number"/>
        </span>
    </div>
    <div class="stat-card">
        <i class="fas fa-sack-dollar"></i>
        <span class="stat-label">Tổng doanh thu</span>
        <span class="stat-value">
            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
        </span>
    </div>
    <div class="stat-card">
        <i class="fas fa-chart-line"></i>
        <span class="stat-label">Lãi (20%)</span>
        <span class="stat-value">
            <fmt:formatNumber value="${totalRevenue * 0.2}" type="currency" currencySymbol="₫"/>
        </span>
    </div>
</div>
<div class="section dashboard-area">
    <div class="stock-area">
        <div class="stock-tabs">
            <button id="btnLowStock" class="stock-btn active" onclick="showTab('low')">Sắp hết hàng (&lt; 20)</button>
            <button id="btnInStock" class="stock-btn" onclick="showTab('in')">Còn hàng (&ge; 20)</button>
        </div>
        <div id="tabLowStock" class="stock-table">
            <h3>Sản phẩm sắp hết hàng (&lt; 20)</h3>
            <table>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Nhập hàng</th>
                </tr>
                <c:forEach var="p" items="${lowStockProducts}">
                    <tr>
                        <td>${p.name}</td>
                        <td style="color:red; font-weight:bold">${p.quantity}</td>
                        <td>
                            <%-- 🌟 ACTION GỌI ĐẾN ADMINPRODUCTSERVLET 🌟 --%>
                           <form method="post" action="${pageContext.request.contextPath}/admin/products" class="stock-form">
                                <input type="hidden" name="action" value="updateQuantity"/>
                                <input type="hidden" name="id" value="${p.id}"/>
                                <div class="form-fields">
                                    <input type="number" min="1" name="quantity" placeholder="SL" class="stock-input" required/>
                                </div>
                                <button type="submit" class="stock-submit">
                                    <i class="fas fa-plus-circle"></i> Nhập
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div id="tabInStock" class="stock-table" style="display:none;">
            <h3>Sản phẩm còn hàng (&ge; 20)</h3>
            <table>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng</th>
                </tr>
                <c:forEach var="p" items="${inStockProducts}">
                    <tr>
                        <td>${p.name}</td>
                        <td>${p.quantity}</td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <div id="top5Section">
        <h3 class="top5-title"><i class="fas fa-crown"></i> Top 5 Users Tiêu Dùng Nhiều Nhất</h3>
        <div class="top5-list">
            <c:forEach var="u" items="${topUsers}" varStatus="vs">
                <div class="top5-card <c:if test='${vs.index == 0}'>top1</c:if>">
                    <div class="user-rank">
                        <i class="fas <c:choose>
                            <c:when test='${vs.index == 0}'>fa-crown</c:when>
                            <c:otherwise>fa-medal</c:otherwise>
                        </c:choose>"></i>
                        <span class="rank-no">${vs.index+1}</span>
                    </div>
                    <div class="user-info">
                        <div class="user-name">
                            <a href="${pageContext.request.contextPath}/admin/userProfile?id=${u.user_id}">
                                ${u.full_name}
                            </a>
                        </div>
                        <div class="user-email">${u.email}</div>
                        <div class="user-phone"><i class="fas fa-phone"></i> ${u.phoneNumber}</div>
                    </div>
                    <div class="user-data">
                        <div class="user-orders"><i class="fas fa-shopping-cart"></i> ${u.orderCount} đơn</div>
                        <div class="user-money"><i class="fas fa-coins"></i> <fmt:formatNumber value="${u.totalSpent}" type="currency" currencySymbol="₫"/></div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
<script>
    function setTheme(mode) {
        document.body.classList.remove("darkmode", "lightmode");
        document.body.classList.add(mode);
        localStorage.setItem("dashboardTheme", mode);
        document.body.classList.toggle('dark-mode', mode === 'darkmode');
    }
    function toggleTheme() {
        var current = document.body.classList.contains("dark-mode") ? "darkmode" : "lightmode";
        setTheme(current === "darkmode" ? "lightmode" : "darkmode");
    }
    (function() {
        var theme = localStorage.getItem("dashboardTheme") || "lightmode";
        setTheme(theme);
    })();
    function showTab(tab) {
        document.getElementById("tabLowStock").style.display = tab==="low" ? "" : "none";
        document.getElementById("tabInStock").style.display = tab==="in" ? "" : "none";
        document.getElementById("btnLowStock").classList.toggle("active",tab==="low");
        document.getElementById("btnInStock").classList.toggle("active",tab==="in");
    }
</script>
</body>
</html>