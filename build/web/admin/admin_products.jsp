<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý sản phẩm</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
  <%@ include file="../partials/admin_navbar.jspf" %>
  <c:set var="activeMenu" value="products" scope="request"/>
  <%@ include file="../partials/admin_sidebar.jspf" %>

  <div class="content-wrapper">
    <section class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6"><h1>Quản lý sản phẩm</h1></div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/products?action=list">Sản phẩm</a></li>
              <li class="breadcrumb-item active">Danh sách</li>
            </ol>
          </div>
        </div>
      </div>
    </section>

    <section class="content">
      <div class="container-fluid">

        <div class="card">
          <div class="card-header d-flex align-items-center">
            <form method="get" action="${pageContext.request.contextPath}/admin/products" class="form-inline mr-auto">
              <input type="hidden" name="action" value="search">
              <div class="input-group input-group-sm">
                <input type="text" name="keyword" class="form-control" placeholder="Tìm sản phẩm..." value="${keyword != null ? keyword : ''}">
                <span class="input-group-append">
                  <button class="btn btn-primary" type="submit"><i class="fas fa-search"></i></button>
                </span>
              </div>
            </form>
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-sm btn-success">
              <i class="fas fa-plus"></i> Thêm sản phẩm
            </a>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-striped table-hover mb-0">
                <thead>
                  <tr>
                    <th style="width:80px;">ID</th>
                    <th>Danh mục</th>
                    <th>Tên</th>
                    <th style="width:140px;">Giá</th>
                    <th style="width:90px;">Ảnh</th>
                    <th style="width:180px;">Hành động</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="p" items="${products}">
                    <tr>
                      <td>${p.id}</td>
                      <td>
                        <c:forEach var="c" items="${categories}">
                          <c:if test="${c.categoryId == p.categoryId}">${c.name}</c:if>
                        </c:forEach>
                      </td>
                      <td class="text-break">${p.name}</td>
                      <td><span class="text-danger font-weight-bold"><c:out value="${p.price}"/>₫</span></td>
                      <td>
                        <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}" class="img-size-50 img-fluid rounded" onerror="this.src='https://placehold.co/60x60?text=No+Img'">
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="btn btn-sm btn-primary">
                          <i class="fas fa-pen"></i> Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}" class="btn btn-sm btn-danger"
                           onclick="return confirm('Xoá sản phẩm này?');">
                          <i class="fas fa-trash"></i> Xoá
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty products}">
                    <tr><td colspan="6" class="text-center text-muted py-3">Chưa có sản phẩm.</td></tr>
                  </c:if>
                </tbody>
              </table>
            </div>
          </div>
        </div>

      </div>
    </section>
  </div>

  <footer class="main-footer">
    <strong>Light Admin</strong>
    <div class="float-right d-none d-sm-inline-block"><b>AdminLTE</b> 3</div>
  </footer>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/overlayscrollbars@1.13.1/js/jquery.overlayScrollbars.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>