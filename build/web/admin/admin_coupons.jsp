<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <title>Quản lý Coupon</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css"/>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>

<body class="hold-transition sidebar-mini">
<div class="wrapper">

  <%@ include file="../partials/admin_navbar.jspf" %>
  <c:set var="activeMenu" value="coupons" scope="request"/>
  <%@ include file="../partials/admin_sidebar.jspf" %>

  <div class="content-wrapper">

    <!-- HEADER -->
    <section class="content-header">
      <div class="container-fluid">
        <h1>Quản lý Coupon</h1>
      </div>
    </section>

    <!-- MAIN -->
    <section class="content">
      <div class="container-fluid">
        <div class="row">

          <!-- ======================
               FORM THÊM COUPON
          ======================= -->
          <div class="col-lg-4">
            <div class="card card-primary">
              <div class="card-header">
                <h3 class="card-title">
                  <i class="fas fa-ticket-alt"></i> Thêm coupon
                </h3>
              </div>

              <form action="${pageContext.request.contextPath}/admin/coupons" method="post">
                <input type="hidden" name="action" value="add"/>

                <div class="card-body">

                  <div class="form-group">
                    <label>Mã coupon</label>
                    <input type="text" name="code" class="form-control"
                           placeholder="VD: SAVE10" required>
                  </div>

                  <div class="form-group">
                    <label>Mô tả</label>
                    <input type="text" name="description" class="form-control"
                           placeholder="Mô tả ngắn">
                  </div>

                  <div class="form-group">
                    <label>Loại giảm giá</label>
                    <select name="discountType" class="form-control" required>
                      <option value="percent">Giảm theo %</option>
                      <option value="fixed">Giảm tiền cố định</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label>Giá trị giảm</label>
                    <input type="number" name="value" class="form-control"
                           placeholder="VD: 10 (percent) hoặc 30000 (fixed)"
                           step="0.01" min="0" required>
                  </div>

                  <div class="form-group">
                    <label>Hiệu lực từ</label>
                    <input type="date" name="startDate" class="form-control">
                  </div>

                  <div class="form-group">
                    <label>Hiệu lực đến</label>
                    <input type="date" name="endDate" class="form-control">
                  </div>

                  <div class="form-group">
                    <label>Đơn tối thiểu (VND)</label>
                    <input type="number" name="minSubtotal" class="form-control"
                           step="1" min="0">
                  </div>

                  <div class="form-group">
                    <label>Giảm tối đa (VND)</label>
                    <input type="number" name="maxDiscount" class="form-control"
                           step="1" min="0">
                  </div>

                  <div class="form-group">
                    <label>Giới hạn lượt dùng</label>
                    <input type="number" name="usageLimit" class="form-control"
                           step="1" min="0">
                  </div>

                  <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="active" name="active">
                    <label class="form-check-label" for="active">Kích hoạt ngay</label>
                  </div>

                </div>

                <div class="card-footer">
                  <button class="btn btn-primary">
                    <i class="fas fa-plus"></i> Thêm
                  </button>
                </div>

              </form>
            </div>
          </div>


          <!-- ======================
               DANH SÁCH COUPON
          ======================= -->
          <div class="col-lg-8">
            <div class="card">
              <div class="card-header d-flex align-items-center">
                <h3 class="card-title">
                  <i class="fas fa-list"></i> Danh sách coupon
                </h3>
              </div>

              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-striped mb-0">
                    <thead>
                      <tr>
                        <th style="width:80px">ID</th>
                        <th>Mã</th>
                        <th>Mô tả</th>
                        <th>Loại</th>
                        <th>Giá trị</th>
                        <th>Hiệu lực</th>
                        <th>Tối thiểu</th>
                        <th>Tối đa</th>
                        <th>Giới hạn</th>
                        <th>Đã dùng</th>
                        <th>Trạng thái</th>
                        <th style="width:220px">Hành động</th>
                      </tr>
                    </thead>

                    <tbody>
                      <c:forEach var="c" items="${coupons}">
                        <tr>
                          <td>${c.id}</td>
                          <td><strong>${c.code}</strong></td>
                          <td class="text-break">${c.description}</td>

                          <!-- LOẠI -->
                          <td>
                            <span class="badge badge-info">
                              <c:choose>
                                <c:when test="${c.discountType == 'percent'}">Phần trăm</c:when>
                                <c:otherwise>Cố định</c:otherwise>
                              </c:choose>
                            </span>
                          </td>

                          <!-- GIÁ TRỊ -->
                          <td>
                            <c:choose>
                              <c:when test="${c.discountType == 'percent'}">
                                ${c.value}% 
                              </c:when>
                              <c:otherwise>
                                ${c.value} VND
                              </c:otherwise>
                            </c:choose>
                          </td>

                          <!-- HIỆU LỰC -->
                          <td>
                            <small>${c.startDate != null ? c.startDate : '-'}</small>
                            →
                            <small>${c.endDate != null ? c.endDate : '-'}</small>
                          </td>

                          <!-- MIN - MAX -->
                          <td>${c.minSubtotal != null ? c.minSubtotal : '-'}</td>
                          <td>${c.maxDiscount != null ? c.maxDiscount : '-'}</td>

                          <!-- LIMIT -->
                          <td>${c.usageLimit != null ? c.usageLimit : '-'}</td>
                          <td>${c.usedCount != null ? c.usedCount : 0}</td>

                          <!-- TRẠNG THÁI -->
                          <td>
                            <span class="badge ${c.active ? 'badge-success' : 'badge-secondary'}">
                              ${c.active ? 'Đang kích hoạt' : 'Đã tắt'}
                            </span>
                          </td>

                          <!-- ACTION -->
                          <td>
                            <!-- Toggle -->
                            <form action="${pageContext.request.contextPath}/admin/coupons"
                                  method="post"
                                  class="d-inline">
                              <input type="hidden" name="action" value="toggle"/>
                              <input type="hidden" name="id" value="${c.id}"/>
                              <input type="hidden" name="active" value="${c.active ? '0' : '1'}"/>
                              <button class="btn btn-sm ${c.active ? 'btn-warning' : 'btn-success'}">
                                <i class="fas ${c.active ? 'fa-toggle-off' : 'fa-toggle-on'}"></i>
                                ${c.active ? 'Tắt' : 'Bật'}
                              </button>
                            </form>

                            <!-- DELETE -->
                            <form action="${pageContext.request.contextPath}/admin/coupons"
                                  method="post"
                                  class="d-inline"
                                  onsubmit="return confirm('Xoá coupon này?');">
                              <input type="hidden" name="action" value="delete"/>
                              <input type="hidden" name="id" value="${c.id}"/>
                              <button class="btn btn-sm btn-danger">
                                <i class="fas fa-trash"></i> Xoá
                              </button>
                            </form>

                          </td>

                        </tr>
                      </c:forEach>

                      <c:if test="${empty coupons}">
                        <tr><td colspan="12" class="text-center text-muted py-3">Chưa có coupon.</td></tr>
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

  <footer class="main-footer"><strong>Light Admin</strong></footer>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

</body>
</html>
