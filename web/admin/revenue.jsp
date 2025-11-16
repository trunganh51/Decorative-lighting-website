<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê doanh thu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family:'Poppins',Arial,sans-serif;
            background:#f6f8fb;
            margin:0;
            color:#222;
            transition: background .3s, color .3s;
        }
        .container {
            max-width:1050px;
            margin:35px auto;
            background:#fff;
            border-radius:12px;
            padding:28px 20px;
            box-shadow:0 1.5px 15px rgba(40,52,78,0.07);
            transition:background .3s, color .3s;
        }
        .overview {
            display:flex;
            justify-content:space-around;
            margin-bottom:24px;
            gap:14px;
        }
        .card {
            background:#00d9ff;
            color:#222;
            padding:26px 18px;
            border-radius:11px;
            text-align:center;
            font-weight:bold;
            min-width:170px;
            box-shadow:0 2px 16px rgba(0,217,255,0.09);
        }
        .card span {
            color:#25357e;
            font-size:1.15em;
            font-weight:500;
            display:block;
            margin-bottom:7px;
            letter-spacing:0.02em;
            /* hiệu chỉnh  */
        }
        .card-number, .card .number {
            color: #00d9ff;
            font-size: 1.28em;
            font-weight: bold;
            letter-spacing:.02em;
        }
        .switch-bar {
            display:flex;
            justify-content:center;
            gap:18px;
            margin-bottom:28px;
        }
        .switch-btn {
            background:#fff;
            color:#25357e;
            border:1px solid #00d9ff;
            border-radius:18px;
            padding:6px 28px;
            cursor:pointer;
            font-weight:600;
            transition:.22s;
        }
        .switch-btn.active,
        .switch-btn:hover {
            background:#00d9ff;
            color:#fff;
        }
        .table {
            width:100%;
            border-collapse:collapse;
            margin-top:24px;
            background:#fafbff;
            border-radius:9px;
            box-shadow:0 1px 7px rgba(36,44,62,0.09);
        }
        .table th, .table td {
            border:1px solid #e5e9f2;
            padding:9px 11px;
            text-align:center;
            color:#28344e;
        }
        .table th {
            background:#e5e9f2;
            font-weight:bold;
            color:#28344e;
            font-size:1rem;
        }
        .table tr:nth-child(even){
            background:#f0f2f7;
        }
        .table tr:hover td{
            background:#f9f1d9;
        }
        .button {
            background:#007bff;
            color:#fff;
            border:none;
            padding:9px 22px;
            border-radius:5px;
            cursor:pointer;
            font-weight:600;
            transition:background .25s;
            text-decoration:none;
            display:inline-block;
        }
        .button:hover{
            background:#0056b3;
        }

        /* ------------------ DARK MODE ----------------------- */
        body.dark-mode {
            background:linear-gradient(135deg,#0a192f,#020c1b)!important;
            color:#e0e0e0!important;
        }
        body.dark-mode .container {
            background:rgba(255,255,255,0.04)!important;
            color:#e0e0e0!important;
            box-shadow:0 1.5px 22px rgba(0,217,255,0.07)!important;
        }
        body.dark-mode .card {
            background:#232b40!important;
            color:#00d9ff!important;
            box-shadow:0 2px 19px rgba(0,217,255,0.18)!important;
        }
        body.dark-mode .card span {
            color:#4ea3ff!important;
        }
        body.dark-mode .card-number, body.dark-mode .card .number {
            color: #4ea3ff !important;
        }
        body.dark-mode .switch-bar .switch-btn,
        body.dark-mode .switch-bar button {
            background:rgba(36,48,79,0.85)!important;
            color:#fff!important;
            border:1px solid #00d9ff!important;
        }
        body.dark-mode .switch-btn.active,
        body.dark-mode .switch-btn:hover {
            background:#00d9ff!important;
            color:#fff!important;
        }
        body.dark-mode .table {
            background:rgba(255,255,255,0.09)!important;
        }
        body.dark-mode .table th, body.dark-mode .table td {
            color:#fff!important;
            background:#222d35!important;
            border-color:#34577a!important;
        }
        body.dark-mode .table th {
            background:#232b40!important;
            color:#00d9ff!important;
        }
        body.dark-mode .table tr:nth-child(even){
            background:#181838!important;
        }
        body.dark-mode .table tr:hover td{
            background:#263157!important;
        }
        body.dark-mode .button{
            background:#00d9ff!important;
            color:#222!important;
        }
        body.dark-mode .button:hover{
            background:#0099cc!important;
            color:#fff!important;
        }
        body.dark-mode h2,
        body.dark-mode .switch-bar .switch-btn,
        body.dark-mode .table th,
        body.dark-mode .table td {
            color:#fff!important;
        }
        /* ------------- END DARK MODE --------------- */
    </style>
    <script>
        function toggleMode(){
            document.body.classList.toggle('dark-mode');
        }
    </script>
</head>
<body>
<%@ include file="../partials/headeradmin.jsp" %>
<div class="container">
    <h2 style="text-align:center;margin-bottom:22px;">📊 Doanh thu hệ thống</h2>
    <div class="overview">
        <div class="card">
            <span>Doanh thu hôm nay</span>
            <span class="card-number"><fmt:formatNumber value="${todayRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/></span> VND
        </div>
        <div class="card">
            <span>Doanh thu tháng này</span>
            <span class="card-number"><fmt:formatNumber value="${thisMonthRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/></span> VND
        </div>
        <div class="card">
            <span>Doanh thu năm nay</span>
            <span class="card-number"><fmt:formatNumber value="${thisYearRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/></span> VND
        </div>
    </div>
    <div class="switch-bar">
        <button class="switch-btn active" onclick="showTab('week')">Theo tuần</button>
        <button class="switch-btn" onclick="showTab('day')">Theo ngày</button>
        <button class="switch-btn" onclick="showTab('month')">Theo tháng</button>
    </div>
    <!-- Theo tuần -->
    <div id="tab-week">
        <canvas id="weeklyRevenueChart" width="800" height="400" style="margin-top:12px;cursor:pointer"></canvas>
        <script>
            var weekLabels=[],weekData=[],weekCodes=[];
            <c:forEach var="r" items="${weeklyRevenue}">
                weekLabels.push('<c:out value="${r[0]}" />');
                weekData.push(<c:out value="${r[1]}" />);
                weekCodes.push('<c:out value="${r[2]}" />');
            </c:forEach>
            const ctxWeek=document.getElementById('weeklyRevenueChart').getContext('2d');
            const chartWeek=new Chart(ctxWeek,{
                type:'bar',
                data:{labels:weekLabels,datasets:[{label:'Doanh thu tuần (VND)',data:weekData,backgroundColor:'rgba(0,217,255,0.3)',borderColor:'rgba(0,217,255,0.8)',borderWidth:1}]},
                options:{scales:{y:{beginAtZero:true}}}
            });
            document.getElementById('weeklyRevenueChart').onclick=function(evt){
                var points=chartWeek.getElementsAtEventForMode(evt,'nearest',{intersect:true},false);
                if(points.length){
                    var index=points[0].index;
                    var weekCode=weekCodes[index];
                    window.location.href="${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode="+weekCode;
                }
            };
        </script>
        <table class="table">
            <thead>
                <tr><th>Tuần</th><th>Doanh thu (VND)</th></tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${weeklyRevenue}">
                    <tr onclick="window.location.href='${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode=${r[2]}'" style="cursor:pointer;">
                        <td>
                           <a href="${pageContext.request.contextPath}/admin/products?action=revenueDetail&weekCode=${r[2]}" style="color:#00d9ff;font-weight:bold"><c:out value="${r[0]}" /></a>
                        </td>
                        <td>
                            <fmt:formatNumber value="${r[1]}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- Theo ngày -->
    <div id="tab-day" style="display:none;">
        <canvas id="dayRevenueChart" width="800" height="400" style="margin-top:12px;cursor:pointer"></canvas>
        <script>
            var dayLabels=[],dayData=[];
            <c:forEach var="r" items="${dailyRevenue}">
                dayLabels.push('<c:out value="${r[0]}" />'); dayData.push(<c:out value="${r[1]}" />);
            </c:forEach>
            const ctxDay=document.getElementById('dayRevenueChart').getContext('2d');
            const chartDay=new Chart(ctxDay,{type:'line',data:{labels:dayLabels,datasets:[{label:'Doanh thu ngày (VND)',data:dayData,fill:0,backgroundColor:'rgba(0,217,255,0.13)',borderColor:'rgba(0,217,255,0.95)'}]},options:{scales:{y:{beginAtZero:true}}}});
            document.getElementById('dayRevenueChart').onclick=function(evt){
                var points=chartDay.getElementsAtEventForMode(evt,'nearest',{intersect:true},false);
                if(points.length){
                    var index=points[0].index;
                    var date=dayLabels[index];
                    window.location.href="${pageContext.request.contextPath}/admin/products?action=revenueDetailDay&date="+date;
                }
            };
        </script>
        <table class="table">
            <thead><tr><th>Ngày</th><th>Doanh thu (VND)</th></tr></thead>
            <tbody>
                <c:forEach var="r" items="${dailyRevenue}">
                    <tr onclick="window.location.href='${pageContext.request.contextPath}/admin/products?action=revenueDetailDay&date=${r[0]}'" style="cursor:pointer;">
                        <td><c:out value="${r[0]}" /></td>
                        <td><fmt:formatNumber value="${r[1]}" type="number" groupingUsed="true" maxFractionDigits="0"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- Theo tháng -->
    <div id="tab-month" style="display:none;">
        <canvas id="monthRevenueChart" width="800" height="400" style="margin-top:12px;cursor:pointer"></canvas>
        <script>
            var monthLabels=[],monthData=[];
            <c:forEach var="r" items="${monthlyRevenue}">
                monthLabels.push('<c:out value="${r[0]}" />'); monthData.push(<c:out value="${r[1]}" />);
            </c:forEach>
            const ctxMonth=document.getElementById('monthRevenueChart').getContext('2d');
            const chartMonth=new Chart(ctxMonth,{type:'bar',data:{labels:monthLabels,datasets:[{label:'Doanh thu tháng (VND)',data:monthData,backgroundColor:'rgba(0,217,255,0.3)',borderColor:'rgba(0,217,255,0.8)',borderWidth:1}]},options:{scales:{y:{beginAtZero:true}}}});
            document.getElementById('monthRevenueChart').onclick=function(evt){
                var points=chartMonth.getElementsAtEventForMode(evt,'nearest',{intersect:true},false);
                if(points.length){
                    var index=points[0].index;
                    var month=monthLabels[index];
                    window.location.href="${pageContext.request.contextPath}/admin/products?action=revenueDetailMonth&month="+month;
                }
            };
        </script>
        <table class="table">
            <thead><tr><th>Tháng</th><th>Doanh thu (VND)</th></tr></thead>
            <tbody>
                <c:forEach var="r" items="${monthlyRevenue}">
                    <tr onclick="window.location.href='${pageContext.request.contextPath}/admin/products?action=revenueDetailMonth&month=${r[0]}'" style="cursor:pointer;">
                        <td><c:out value="${r[0]}" /></td>
                        <td><fmt:formatNumber value="${r[1]}" type="number" groupingUsed="true" maxFractionDigits="0"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <p style="text-align:center; margin-top:20px;">
        <a href="${pageContext.request.contextPath}/admin/products?action=list" class="button">Quay lại quản lý sản phẩm</a>
    </p>
</div>
<%@ include file="../partials/footer.jsp" %>
<script>
    function showTab(tab){
        document.getElementById('tab-week').style.display = tab === 'week' ? '' : 'none';
        document.getElementById('tab-day').style.display = tab === 'day' ? '' : 'none';
        document.getElementById('tab-month').style.display = tab === 'month' ? '' : 'none';
        for(const btn of document.getElementsByClassName('switch-btn')){
            btn.classList.remove('active');
        }
        document.querySelector('.switch-btn[onclick="showTab(\''+tab+'\')"]').classList.add('active');
    }
</script>
</body>
</html>
