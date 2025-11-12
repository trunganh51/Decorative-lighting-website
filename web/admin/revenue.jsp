<%@ include file="admin_check.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>📊 Thống kê doanh thu</title>
  <link rel="stylesheet" href="../assets/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      font-family: "Poppins", sans-serif;
      background-color: #0a192f;
      color: white;
      margin: 0;
      padding: 0;
      overflow-x: hidden; /* ✅ Không tràn ngang */
    }
    .container {
      width: 100%;
      max-width: 900px;
      margin: 50px auto;
      background: rgba(255,255,255,0.05);
      padding: 25px 20px;
      border-radius: 16px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.4);
      text-align: center;
    }
    h2 {
      color: #00d9ff;
      margin-bottom: 10px;
    }
    canvas {
      width: 100% !important;
      max-width: 650px;
      height: 300px !important;
      margin: 0 auto;
      display: block;
    }
    a.button {
      display: inline-block;
      background: #00d9ff;
      color: #0a192f;
      padding: 10px 18px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      margin-top: 20px;
    }
    a.button:hover {
      background: #00b8e6;
    }
  </style>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>

<div class="container">
  <h2>📊 Thống kê doanh thu theo tuần</h2>
  <canvas id="revenueChart"></canvas>

  <a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">
    ⬅ Quay lại quản lý sản phẩm
  </a>
</div>

<script>
  // ✅ Lấy contextPath đúng từ JSP ra JavaScript
  const contextPath = '<%= request.getContextPath() %>';

  // ✅ Dữ liệu doanh thu từ servlet
  const weeklyRevenue = [
    <c:forEach var="wr" items="${weeklyRevenue}" varStatus="loop">
      {
        weekLabel: '<c:out value="${wr[0]}"/>',
        revenue: Number('<c:out value="${wr[1]}"/>'),
        weekCode: '<c:out value="${wr[2]}"/>'
      }<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];

  const ctx = document.getElementById('revenueChart').getContext('2d');
  const chart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: weeklyRevenue.map(w => w.weekLabel),
      datasets: [{
        label: 'Doanh thu (VND)',
        data: weeklyRevenue.map(w => w.revenue),
        backgroundColor: 'rgba(0,217,255,0.5)',
        borderColor: 'rgba(0,217,255,0.9)',
        borderWidth: 1,
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: ctx => ctx.raw.toLocaleString('vi-VN') + ' VND'
          }
        }
      },
      scales: {
        x: { ticks: { color: '#fff' } },
        y: { beginAtZero: true, ticks: { color: '#fff', callback: v => v.toLocaleString('vi-VN') } }
      },
      // ✅ Khi click vào cột -> sang trang chi tiết
      onClick: (evt) => {
        const points = chart.getElementsAtEventForMode(evt, 'nearest', {intersect:true}, true);
        if (points.length > 0) {
          const index = points[0].index;
          const weekCode = weeklyRevenue[index].weekCode;
          console.log("🟦 Click week:", weekCode);
          // ✅ Chuyển đúng link có contextPath thật
          window.location.href = contextPath + '/admin/products?action=revenueDetail&week=' + weekCode;
        }
      }
    }
  });
</script>

<%@ include file="../partials/footer.jsp" %>
</body>
</html>
