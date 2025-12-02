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
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Tài khoản người dùng</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
  <%@ include file="../partials/admin_navbar.jspf" %>
  <c:set var="activeMenu" value="accounts" scope="request"/>
  <%@ include file="../partials/admin_sidebar.jspf" %>

  <div class="content-wrapper">
    <section class="content-header"><div class="container-fluid"><h1>Tài khoản người dùng</h1></div></section>

    <section class="content">
      <div class="container-fluid">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <form method="get" action="${pageContext.request.contextPath}/admin/account" class="form-inline mr-auto">
              <div class="input-group input-group-sm">
                <input type="text" name="search" class="form-control" placeholder="Tìm tài khoản..." value="${param.search != null ? param.search : ''}">
                <span class="input-group-append">
                  <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                </span>
              </div>
            </form>
            <c:if test="${not empty message}">
              <span class="badge badge-info">${message}</span>
            </c:if>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-striped mb-0">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="user" items="${users}">
                    <tr>
                      <td>${user.id}</td>
                      <td>${user.fullName}</td>
                      <td>${user.email}</td>
                      <td>
                        <span class="badge ${user.role == 'admin' ? 'badge-primary' : 'badge-warning'}">${user.role}</span>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty users}">
                    <tr><td colspan="4" class="text-center text-muted py-3">Không có dữ liệu.</td></tr>
                  </c:if>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>

  <footer class="main-footer"><strong>Light Admin</strong></footer>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>