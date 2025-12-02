<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Thống kê doanh thu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
  <%@ include file="../partials/admin_navbar.jspf" %>
  <c:set var="activeMenu" value="revenue" scope="request"/>
  <%@ include file="../partials/admin_sidebar.jspf" %>

  <div class="content-wrapper">
    <section class="content-header">
      <div class="container-fluid"><h1>📊 Doanh thu hệ thống</h1></div>
    </section>

    <section class="content">
      <div class="container-fluid">
        <!-- Overview cards -->
        <div class="row">
          <div class="col-sm-4">
            <div class="info-box">
              <span class="info-box-icon bg-info"><i class="far fa-calendar-day"></i></span>
              <div class="info-box-content">
                <span class="info-box-text">Doanh thu hôm nay</span>
                <span class="info-box-number"><fmt:formatNumber value="${todayRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
              </div>
            </div>
          </div>
          <div class="col-sm-4">
            <div class="info-box">
              <span class="info-box-icon bg-success"><i class="far fa-calendar-alt"></i></span>
              <div class="info-box-content">
                <span class="info-box-text">Doanh thu tháng này</span>
                <span class="info-box-number"><fmt:formatNumber value="${thisMonthRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
              </div>
            </div>
          </div>
          <div class="col-sm-4">
            <div class="info-box">
              <span class="info-box-icon bg-warning"><i class="far fa-calendar"></i></span>
              <div class="info-box-content">
                <span class="info-box-text">Doanh thu năm nay</span>
                <span class="info-box-number"><fmt:formatNumber value="${thisYearRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Tabs -->
        <ul class="nav nav-pills mb-3" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="tab-week-tab" data-toggle="pill" href="#tab-week" role="tab">Theo tuần</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="tab-day-tab" data-toggle="pill" href="#tab-day" role="tab">Theo ngày</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="tab-month-tab" data-toggle="pill" href="#tab-month" role="tab">Theo tháng</a>
          </li>
        </ul>

        <div class="tab-content">
          <div class="tab-pane fade show active" id="tab-week" role="tabpanel">
            <div class="card">
              <div class="card-body">
                <canvas id="weeklyRevenueChart" height="120"></canvas>
              </div>
              <div class="table-responsive">
                <table class="table table-striped mb-0">
                  <thead><tr><th>Tuần</th><th>Doanh thu (VND)</th><th>Chi tiết</th></tr></thead>
                  <tbody>
                    <c:forEach var="r" items="${weeklyRevenue}">
                      <tr onclick="window.location.href='${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode=${r[2]}'" style="cursor:pointer;">
                        <td><a href="${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode=${r[2]}"> <c:out value="${r[0]}"/> </a></td>
                        <td><fmt:formatNumber value="${r[1]}" type="number" groupingUsed="true" maxFractionDigits="0"/></td>
                        <td>
                          <a class="btn btn-sm btn-outline-primary"
                             href="${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode=${r[2]}">
                            Xem chi tiết
                          </a>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="tab-pane fade" id="tab-day" role="tabpanel">
            <div class="card">
              <div class="card-body">
                <canvas id="dayRevenueChart" height="120"></canvas>
              </div>
              <div class="table-responsive">
                <table class="table table-striped mb-0">
                  <thead><tr><th>Ngày</th><th>Doanh thu (VND)</th><th>Chi tiết</th></tr></thead>
                  <tbody>
                    <c:forEach var="r" items="${dailyRevenue}">
                      <tr onclick="window.location.href='${pageContext.request.contextPath}/admin/products?action=revenueDetailDay&date=${r[0]}'" style="cursor:pointer;">
                        <td><a href="${pageContext.request.contextPath}/admin/products?action=revenueDetailDay&date=${r[0]}"><c:out value="${r[0]}"/></a></td>
                        <td><fmt:formatNumber value="${r[1]}" type="number" groupingUsed="true" maxFractionDigits="0"/></td>
                        <td>
                          <a class="btn btn-sm btn-outline-primary"
                             href="${pageContext.request.contextPath}/admin/products?action=revenueDetailDay&date=${r[0]}">
                            Xem chi tiết
                          </a>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="tab-pane fade" id="tab-month" role="tabpanel">
            <div class="card">
              <div class="card-body">
                <canvas id="monthRevenueChart" height="120"></canvas>
              </div>
              <div class="table-responsive">
                <table class="table table-striped mb-0">
                  <thead><tr><th>Tháng</th><th>Doanh thu (VND)</th><th>Chi tiết</th></tr></thead>
                  <tbody>
                    <c:forEach var="r" items="${monthlyRevenue}">
                      <tr onclick="window.location.href='${pageContext.request.contextPath}/admin/products?action=revenueDetailMonth&month=${r[0]}'" style="cursor:pointer;">
                        <td><a href="${pageContext.request.contextPath}/admin/products?action=revenueDetailMonth&month=${r[0]}"><c:out value="${r[0]}"/></a></td>
                        <td><fmt:formatNumber value="${r[1]}" type="number" groupingUsed="true" maxFractionDigits="0"/></td>
                        <td>
                          <a class="btn btn-sm btn-outline-primary"
                             href="${pageContext.request.contextPath}/admin/products?action=revenueDetailMonth&month=${r[0]}">
                            Xem chi tiết
                          </a>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
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
<script>
  // Weekly data
  var weekLabels=[],weekData=[],weekCodes=[];
  <c:forEach var="r" items="${weeklyRevenue}">
    weekLabels.push('<c:out value="${r[0]}" />');
    weekData.push(<c:out value="${r[1]}" />);
    weekCodes.push('<c:out value="${r[2]}" />');
  </c:forEach>
  const chartWeek=new Chart(document.getElementById('weeklyRevenueChart').getContext('2d'),{
    type:'bar',
    data:{labels:weekLabels,datasets:[{label:'Doanh thu tuần (VND)',data:weekData,backgroundColor:'rgba(54,162,235,0.4)',borderColor:'rgba(54,162,235,1)',borderWidth:1}]},
    options:{scales:{y:{beginAtZero:true}}}
  });
  document.getElementById('weeklyRevenueChart').onclick=function(evt){
    const points=chartWeek.getElementsAtEventForMode(evt,'nearest',{intersect:true},false);
    if(points.length){
      window.location.href="${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode="+weekCodes[points[0].index];
    }
  };

  // Day data
  var dayLabels=[],dayData=[];
  <c:forEach var="r" items="${dailyRevenue}">
    dayLabels.push('<c:out value="${r[0]}" />'); dayData.push(<c:out value="${r[1]}" />);
  </c:forEach>
  const chartDay=new Chart(document.getElementById('dayRevenueChart').getContext('2d'),{
    type:'line',
    data:{labels:dayLabels,datasets:[{label:'Doanh thu ngày (VND)',data:dayData,fill:false,backgroundColor:'rgba(0,217,255,0.5)',borderColor:'rgba(0,217,255,0.95)'}]},
    options:{scales:{y:{beginAtZero:true}}}
  });
  document.getElementById('dayRevenueChart').onclick=function(evt){
    const pts=chartDay.getElementsAtEventForMode(evt,'nearest',{intersect:true},false);
    if(pts.length){
      const date=dayLabels[pts[0].index];
      window.location.href="${pageContext.request.contextPath}/admin/products?action=revenueDetailDay&date="+date;
    }
  };

  // Month data
  var monthLabels=[],monthData=[];
  <c:forEach var="r" items="${monthlyRevenue}">
    monthLabels.push('<c:out value="${r[0]}" />'); monthData.push(<c:out value="${r[1]}" />);
  </c:forEach>
  const chartMonth=new Chart(document.getElementById('monthRevenueChart').getContext('2d'),{
    type:'bar',
    data:{labels:monthLabels,datasets:[{label:'Doanh thu tháng (VND)',data:monthData,backgroundColor:'rgba(255,206,86,0.4)',borderColor:'rgba(255,206,86,1)',borderWidth:1}]},
    options:{scales:{y:{beginAtZero:true}}}
  });
  document.getElementById('monthRevenueChart').onclick=function(evt){
    const pts=chartMonth.getElementsAtEventForMode(evt,'nearest',{intersect:true},false);
    if(pts.length){
      const month=monthLabels[pts[0].index];
      window.location.href="${pageContext.request.contextPath}/admin/products?action=revenueDetailMonth&month="+month;
    }
  };
</script>
</body>
</html>