<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="admin_check.jsp" %>
<%
    dao.ProductDAO productDAO = new dao.ProductDAO();
    dao.OrderDAO orderDAO = new dao.OrderDAO();
    dao.UserDAO userDAO = new dao.UserDAO();
    dao.ReviewDAO reviewDAO = new dao.ReviewDAO();

    int totalProducts = productDAO.countProducts();
    double totalRevenue = orderDAO.getTotalRevenue();
    request.setAttribute("totalProducts", totalProducts);
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("lowStockProducts", productDAO.getLowStockProducts());
    request.setAttribute("inStockProducts", productDAO.getInStockProducts());
    request.setAttribute("topUsers", userDAO.getTopUsers(5));

    // NEW: đánh giá mới nhất (8 bản ghi)
    request.setAttribute("latestReviews", reviewDAO.getReviewsPaged(null, null, null, 1, 8));
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - Quản trị hệ thống</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            .scroll-pane { max-height: 420px; overflow: auto; }
            .table td, .table th { vertical-align: middle; }
            .truncate { max-width: 260px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        </style>
    </head>
    <body class="hold-transition sidebar-mini">
        <div class="wrapper">
            <%@ include file="../partials/admin_navbar.jspf" %>
            <c:set var="activeMenu" value="dashboard" scope="request"/>
            <%@ include file="../partials/admin_sidebar.jspf" %>

            <div class="content-wrapper">
                <section class="content-header">
                    <div class="container-fluid">
                        <div class="row mb-2">
                            <div class="col-sm-6"><h1>Dashboard</h1></div>
                            <div class="col-sm-6">
                                <ol class="breadcrumb float-sm-right"><li class="breadcrumb-item active">Dashboard</li></ol>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="content">
                    <div class="container-fluid">
                        <!-- Info boxes -->
                        <div class="row">
                            <div class="col-12 col-sm-4">
                                <div class="small-box bg-info">
                                    <div class="inner">
                                        <h3><fmt:formatNumber value="${totalProducts}" type="number"/></h3>
                                        <p>Tổng sản phẩm</p>
                                    </div>
                                    <div class="icon"><i class="fas fa-boxes"></i></div>
                                    <a href="${pageContext.request.contextPath}/admin/products?action=list" class="small-box-footer">Xem chi tiết <i class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                            <div class="col-12 col-sm-4">
                                <div class="small-box bg-success">
                                    <div class="inner">
                                        <h3><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h3>
                                        <p>Tổng doanh thu</p>
                                    </div>
                                    <div class="icon"><i class="fas fa-sack-dollar"></i></div>
                                    <a href="${pageContext.request.contextPath}/admin/products?action=revenue" class="small-box-footer">Chi tiết doanh thu <i class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                            <div class="col-12 col-sm-4">
                                <div class="small-box bg-warning">
                                    <div class="inner">
                                        <h3><fmt:formatNumber value="${totalRevenue * 0.2}" type="currency" currencySymbol="₫"/></h3>
                                        <p>Ước tính lãi (20%)</p>
                                    </div>
                                    <div class="icon"><i class="fas fa-chart-line"></i></div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Tab gộp: Sản phẩm sắp hết / còn hàng -->
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header p-2">
                                        <ul class="nav nav-pills" id="stockTabs" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="tab-low-tab" data-toggle="tab" href="#tab-low" role="tab">
                                                    <i class="fas fa-exclamation-triangle text-danger"></i> Sản phẩm sắp hết (<= 20)
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="tab-instock-tab" data-toggle="tab" href="#tab-instock" role="tab">
                                                    <i class="fas fa-box"></i> Sản phẩm còn hàng (> 20)
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="tab-content">
                                            <div class="tab-pane fade show active" id="tab-low" role="tabpanel">
                                                <div class="table-responsive scroll-pane">
                                                    <table class="table table-striped mb-0">
                                                        <thead>
                                                        <tr>
                                                            <th style="width:60px">Ảnh</th>
                                                            <th>Tên</th>
                                                            <th style="width:120px">Số lượng</th>
                                                            <th style="width:360px">Điều chỉnh nhanh</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach var="p" items="${lowStockProducts}">
                                                            <tr>
                                                                <td><img src="${pageContext.request.contextPath}/${p.imagePath}" class="img-size-50 img-fluid rounded" onerror="this.src='https://placehold.co/60x60?text=No+Img'"></td>
                                                                <td class="text-break">${p.name}</td>
                                                                <td><span class="badge badge-danger">${p.quantity}</span></td>
                                                                <td>
                                                                    <!-- các form điều chỉnh nhanh giữ nguyên -->
                                                                    <!-- ... -->
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty lowStockProducts}">
                                                            <tr><td colspan="4" class="text-center text-muted py-3">Không có sản phẩm nào sắp hết.</td></tr>
                                                        </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="tab-pane fade" id="tab-instock" role="tabpanel">
                                                <div class="table-responsive scroll-pane">
                                                    <table class="table table-striped mb-0">
                                                        <thead>
                                                        <tr>
                                                            <th style="width:60px">Ảnh</th>
                                                            <th>Tên</th>
                                                            <th style="width:120px">Số lượng</th>
                                                            <th style="width:360px">Điều chỉnh nhanh</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach var="p" items="${inStockProducts}">
                                                            <tr>
                                                                <td><img src="${pageContext.request.contextPath}/${p.imagePath}" class="img-size-50 img-fluid rounded" onerror="this.src='https://placehold.co/60x60?text=No+Img'"></td>
                                                                <td class="text-break">${p.name}</td>
                                                                <td><span class="badge badge-success">${p.quantity}</span></td>
                                                                <td>
                                                                    <!-- các form điều chỉnh nhanh giữ nguyên -->
                                                                    <!-- ... -->
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty inStockProducts}">
                                                            <tr><td colspan="4" class="text-center text-muted py-3">Không có sản phẩm đủ hàng.</td></tr>
                                                        </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Cột phải: Top Users + Đánh giá mới nhất -->
                            <div class="col-lg-4">
                                <div class="card card-outline card-primary">
                                    <div class="card-header"><h3 class="card-title mb-0"><i class="fas fa-crown"></i> Top 5 Khách hàng</h3></div>
                                    <div class="card-body p-2">
                                        <c:forEach var="u" items="${topUsers}" varStatus="vs">
                                            <div class="d-flex align-items-center border-bottom py-2 mb-2">
                                                <div class="mr-2">
                                                    <span class="img-circle bg-info text-white d-flex align-items-center justify-content-center" style="width:40px;height:40px;font-size:18px;">
                                                        <c:out value="${fn:substring(u.full_name,0,1)}" />
                                                    </span>
                                                </div>
                                                <div class="flex-fill">
                                                    <strong><span class="text-warning">#${vs.index + 1}</span> ${u.full_name}</strong><br>
                                                    <small class="text-muted">${u.email}</small><br>
                                                    <small class="text-muted"><i class="fas fa-shopping-cart"></i>
                                                        <c:choose><c:when test="${u.orderCount > 0}">${u.orderCount} đơn</c:when><c:otherwise>Chưa có đơn</c:otherwise></c:choose>
                                                    </small>
                                                </div>
                                                <div>
                                                    <span class="font-weight-bold text-success" style="font-size:16px;">
                                                        <fmt:formatNumber value="${u.totalSpent}" type="currency" currencySymbol="₫"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${empty topUsers}"><p class="text-muted mb-0">Chưa có dữ liệu.</p></c:if>
                                    </div>
                                </div>

                                <!-- NEW: Đánh giá mới nhất -->
                                <div class="card card-outline card-warning">
                                    <div class="card-header">
                                        <h3 class="card-title mb-0"><i class="fas fa-star"></i> Đánh giá mới nhất</h3>
                                        <div class="card-tools">
                                            <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-tool" title="Tất cả"><i class="fas fa-external-link-alt"></i></a>
                                        </div>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-striped mb-0">
                                                <thead class="thead-light">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Sản phẩm</th>
                                                    <th>User</th>
                                                    <th>Điểm</th>
                                                    <th>TT</th>
                                                    <th>Ngày</th>
                                                    <th></th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="rv" items="${latestReviews}">
                                                    <tr>
                                                        <td>${rv.productReviewId}</td>
                                                        <td class="truncate" title="${fn:escapeXml(rv.productName)}">
                                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${rv.productId}" target="_blank">#${rv.productId}</a>
                                                        </td>
                                                        <td class="truncate" title="${fn:escapeXml(rv.userName)}">${fn:escapeXml(rv.userName)}</td>
                                                        <td><span class="badge badge-info"><i class="fas fa-star"></i> ${rv.rating}</span></td>
                                                        <td>
                                                            <span class="badge ${rv.approved ? 'badge-success' : 'badge-warning'}">
                                                                ${rv.approved ? 'Duyệt' : 'Chờ'}
                                                            </span>
                                                        </td>
                                                        <td><fmt:formatDate value="${rv.createdAt}" pattern="MM-dd HH:mm"/></td>
                                                        <td class="text-nowrap">
                                                            <a class="btn btn-xs btn-outline-primary" href="${pageContext.request.contextPath}/admin/reviews?detail=${rv.productReviewId}" title="Chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty latestReviews}">
                                                    <tr><td colspan="7" class="text-center text-muted py-3">Chưa có đánh giá.</td></tr>
                                                </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
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

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
    </body>
</html>