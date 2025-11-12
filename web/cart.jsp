<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Map, model.CartItem" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng của bạn</title>

        <!-- ✅ CSS bạn gửi -->
        <style>
            * {
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            body {
                font-family:"Segoe UI", Arial, sans-serif;
                background:#f5f7fa;
                color:#333;
            }
            .page {
                max-width:1200px;
                margin:36px auto;
                padding:0 16px;
            }
            .layout {
                display:flex;
                gap:28px;
                align-items:flex-start;
            }
            .left {
                flex:2;
                background:#fff;
                border-radius:10px;
                padding:22px;
                box-shadow:0 2px 8px rgba(0,0,0,0.05);
            }
            .right {
                flex:1;
                background:#fff;
                border-radius:10px;
                padding:22px;
                box-shadow:0 2px 8px rgba(0,0,0,0.05);
                height:fit-content;
                position:sticky;
                top:28px;
            }
            h1 {
                font-size:1.6rem;
                margin-bottom:14px;
                color:#222;
            }
            table {
                width:100%;
                border-collapse:collapse;
                margin-bottom:18px;
            }
            th, td {
                padding:12px;
                border-bottom:1px solid #eee;
                text-align:center;
                vertical-align:middle;
            }
            th {
                background:#fbfcfe;
                color:#666;
                font-weight:600;
            }
            .product-cell {
                text-align:left;
                display:flex;
                gap:12px;
                align-items:center;
            }
            .product-thumb {
                width:72px;
                height:72px;
                object-fit:cover;
                border-radius:6px;
                background:#f2f2f2;
            }
            .product-name {
                font-weight:600;
                color:#222;
            }
            input[type="number"]{
                width:66px;
                padding:6px;
                border:1px solid #ddd;
                border-radius:6px;
                text-align:center;
            }
            .btn {
                display:inline-block;
                padding:8px 12px;
                border-radius:6px;
                border:0;
                cursor:pointer;
                font-weight:600;
            }
            .btn.primary {
                background:#007bff;
                color:#fff;
            }
            .btn.danger {
                background:#dc3545;
                color:#fff;
            }
            .btn.ghost {
                background:transparent;
                border:1px solid #ddd;
                color:#333;
            }
            .promo {
                background:#fff8e6;
                border:1px dashed #f2c94c;
                padding:12px;
                border-radius:8px;
                margin:12px 0;
                font-size:0.95rem;
            }
            .order-actions {
                display:flex;
                gap:12px;
                margin-top:16px;
                align-items:center;
            }
            .continue {
                margin-left:auto;
            }

            /* Right summary */
            .summary-title {
                font-size:1.15rem;
                font-weight:700;
                margin-bottom:12px;
            }
            .summary-row {
                display:flex;
                justify-content:space-between;
                padding:8px 0;
                font-size:0.98rem;
            }
            .summary-row.total {
                font-size:1.15rem;
                font-weight:800;
                color:#d63031;
                border-top:1px solid #eee;
                padding-top:12px;
                margin-top:8px;
            }
            .voucher {
                margin-top:14px;
            }
            .voucher input {
                width:100%;
                padding:10px;
                border-radius:8px;
                border:1px solid #ddd;
            }
            .checkout-full {
                width:100%;
                margin-top:18px;
                padding:12px 10px;
                border-radius:8px;
                background:#007bff;
                color:#fff;
                border:0;
                font-weight:700;
                cursor:pointer;
            }

            .empty {
                text-align:center;
                padding:54px 16px;
                color:#666;
            }
            .empty h3 {
                font-size:1.3rem;
                margin-bottom:8px;
            }

            @media (max-width:900px){
                .layout{
                    flex-direction:column;
                }
                .right{
                    position:relative;
                    top:auto;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="partials/header.jsp" %>

        <%
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            double total = 0;
            int totalQty = 0;
            if (cart != null) {
                for (CartItem it : cart.values()) {
                    total += it.getSubtotal();
                    totalQty += it.getQuantity();
                }
            }
            request.setAttribute("cartTotal", total);
        %>

        <div class="page">
            <div class="layout">
                <!-- LEFT: Cart detail -->
                <div class="left">
                    <h1>🛒 Giỏ hàng của bạn</h1>

                    <c:choose>
                        <c:when test="${empty sessionScope.cart}">
                            <div class="empty">
                                <h3>Giỏ hàng trống</h3>
                                <p>Bạn chưa thêm sản phẩm nào vào giỏ.</p>
                                <br>
                                <a href="${pageContext.request.contextPath}/products?action=list" class="btn primary">Tiếp tục mua sắm</a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th style="text-align:left;">Sản phẩm</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Tổng</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${sessionScope.cart.values()}">
                                        <tr>
                                            <td style="text-align:left;">
                                                <div class="product-cell">
                                                    <img src="${pageContext.request.contextPath}/${item.product.imagePath}" alt="${item.product.name}" class="product-thumb">
                                                    <div>
                                                        <div class="product-name">${item.product.name}</div>
                                                        <div style="font-size:0.9rem; color:#666;">Mã: ${item.product.id}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${item.product.price}₫</td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline-flex; gap:6px; align-items:center;">
                                                    <input type="hidden" name="action" value="update"/>
                                                    <input type="hidden" name="productId" value="${item.product.id}"/>
                                                    <input type="number" name="quantity" min="1" value="${item.quantity}"/>
                                                    <button class="btn ghost" type="submit">Cập nhật</button>
                                                </form>
                                            </td>
                                            <td>${item.subtotal}₫</td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                                    <input type="hidden" name="action" value="remove"/>
                                                    <input type="hidden" name="productId" value="${item.product.id}"/>
                                                    <button class="btn danger" type="submit">Xóa</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div class="promo">
                                <strong>Khuyến mãi áp dụng:</strong><br>
                                - Giảm 4% trên tổng đơn hàng (đã trừ thẳng vào giá).<br>
                                - Tặng 01 bàn di chuột; miễn phí vận chuyển đèn toàn quốc.<br>
                                - Hỗ trợ 1 đổi 1
                            </div>

                            <div style="display:flex; gap:12px; align-items:center; margin-top:12px;">
                                <div class="continue" style="margin-left:auto;">
                                    <a href="${pageContext.request.contextPath}/products?action=list" class="btn ghost">⬅ Tiếp tục mua sắm</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- RIGHT: Short summary -->
                <div class="right">
                    <div class="summary-title">Tóm tắt đơn hàng</div>
                    <div class="summary-row">
                        <span>Tổng số lượng</span>
                        <span><c:out value="${fn:length(sessionScope.cart)}" /></span>
                    </div>
                    <div class="summary-row">
                        <span>Tạm tính</span>
                        <span>${cartTotal}₫</span>
                    </div>
                    <div class="summary-row total">
                        <span>Tổng cộng</span>
                        <span>${cartTotal}₫</span>
                    </div>

                    <div class="voucher">
                        <label for="voucher">Nhập mã voucher</label>
                        <input type="text" id="voucher" placeholder="Nhập mã khuyến mãi...">
                    </div>

                    <!-- Chuyển sang PaymentConfirmed.jsp -->
                    <form action="${pageContext.request.contextPath}/payment" method="post" style="margin-top: 14px;">
                        <button type="submit" class="checkout-full">Tiến hành thanh toán</button>
                    </form>
                </div>
            </div>
        </div>

        <%@ include file="partials/footer.jsp" %>
    </body>
</html>
