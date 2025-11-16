<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    UserDAO dao = new UserDAO();
    String search = request.getParameter("search");
    List<User> users;
    if (search != null && !search.trim().isEmpty()) {
        users = dao.searchUsers(search);
    } else {
        users = dao.getAllUsers();
    }
    request.setAttribute("users", users);
    String message = (String) request.getAttribute("message");
%>
<!-- Font Awesome để dùng icon đẹp -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
   
    .main-header {background: #28344e; color: #fff; padding: 12px 0 0 0;}
    .site-title {font-size: 1.7rem; font-weight: bold; text-align: center;}
    .dark-toggle { background: #34416b; color: #ffd700; border: none; border-radius: 6px; padding: 8px 15px; font-weight: bold; cursor: pointer; font-size: 1rem;}
    .dark-toggle:hover { background: #FFD700; color: #28344e;}
    body.dark-mode {background: linear-gradient(135deg, #0a192f, #020c1b); color: #e0e0e0;}
    body.dark-mode .main-header {background: #1a2233; color:#ffd700;}
    body.dark-mode .site-title {color:#00d9ff;}
    table { margin-top: 18px; width: 100%; border-collapse: collapse; background: #fff;}
    th, td { border: 1px solid #ddd; padding: 9px 10px;}
    th { background: #34416b; color: #fff;}
    tr:nth-child(even) {background: #f5f5f7;}
    .search-bar { margin-bottom: 12px; padding: 8px 10px; width: 260px;}
    .btn { padding: 6px 16px; color: #fff; background: #007bff; border-radius: 4px; border: none; cursor: pointer; font-size: 0.96rem;}
    .btn-role { background: #ff9800; margin-left: 6px;}
    .btn-role-admin { background: #1976d2;}
    .btn-del { background: #dc3545; }
    .notification { margin: 15px 0 8px 0; padding: 10px 18px; border-radius: 4px; color: #197a1a; background: #e7fbe6; border: 1px solid #b7eebb;}
    body.dark-mode table {background: #232b40;}
    body.dark-mode th {background: #34416b; color: #ffd700;}
    body.dark-mode tr:nth-child(even){background: #181838;}
    body.dark-mode td, body.dark-mode th {color: #e0e0e0;}
    body.dark-mode .search-bar {background: #181838; color:#ffd700; border-color:#34416b;}
    body.dark-mode .notification {background: #144e22; color: #f9fff9; border-color: #197a1a;}
</style>

<%@ include file="../partials/headeradmin.jsp" %>
<div style="max-width:960px;margin:36px auto 20px auto;">
    <form method="get" action="${pageContext.request.contextPath}/admin/account">
        <input type="text" name="search" class="search-bar" placeholder="Tìm tài khoản..." value="${param.search != null ? param.search : ''}">
        <button type="submit" class="btn"><i class="fas fa-search"></i> Tìm kiếm</button>
    </form>
    <c:if test="${not empty message}">
        <div class="notification">${message}</div>
    </c:if>
    <table>
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Email</th>
            <th>Vai trò</th>
          
        </tr>
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.id}</td>
                <td>${user.fullName}</td>
                <td>${user.email}</td>
                <td>
                    <span style="font-weight:bold; color:${user.role == 'admin' ? '#1976d2' : '#ff9800'};">
                        ${user.role}
                    </span>
                </td>
                
            </tr>
        </c:forEach>
    </table>
</div>
