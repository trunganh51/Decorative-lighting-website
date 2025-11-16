<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận mua hàng</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            .payment-content * {
                box-sizing: border-box;
            }
            body.payment-page {
                background: #f5f6f7;
                font-family: "Inter","Segoe UI",Arial,sans-serif;
                color: #1f2937;
            }
            .payment-content {
                max-width: 1100px;
                margin: 24px auto;
                padding: 0 16px 40px;
            }
            .content-main-cart {
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }
            .content-left,.content-right {
                flex: 1;
                background: #fff;
                border-radius: 12px;
                padding: 28px;
                border: 1px solid #ececec;
            }
            .title-header h2,.background-white .title {
                font-size: 1.4rem;
                font-weight: 700;
                margin-bottom: 8px;
                color: #111827;
            }
            .header-actions {
                display: flex;
                gap: 12px;
                margin-left: 12px;
                font-size: 0.95rem;
                align-items: center;
            }
            .header-actions a {
                color: #374151;
                text-decoration: none;
                display: inline-flex;
                gap: 8px;
                align-items: center;
                padding: 6px 8px;
                border-radius: 8px;
                transition: 0.12s;
                background: transparent;
            }
            .header-actions a:hover {
                background: #f3f4f6;
                color: #111827;
            }

            .content-input-form {
                display: flex;
                flex-wrap: wrap;
                gap: 16px;
            }
            .item-input {
                flex: 1 1 calc(50% - 8px);
            }
            .item-input.full {
                flex: 1 1 100%;
            }
            label {
                font-weight: 600;
                margin-bottom: 6px;
                display: block;
                font-size: 0.92rem;
                color: #111827;
            }
            .required {
                color: #dc2626;
                margin-left: 4px;
                font-weight: 700;
            }
            input,select,textarea {
                width: 100%;
                padding: 10px 12px;
                border-radius: 8px;
                border: 1px solid #d8d8d8;
                background: #fafafa;
                transition: 0.18s;
                font-size: 0.95rem;
                color: #111827;
            }
            input:focus,select:focus,textarea:focus {
                background: #fff;
                border-color: #2563eb;
                outline: none;
                box-shadow: 0 6px 18px rgba(37,99,235,0.08);
            }
            textarea {
                resize: vertical;
            }
            .select-wrapper {
                position: relative;
                display: block;
            }
            .select-wrapper .form-control {
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                padding: 8px 36px 8px 10px;
                height: 38px;
                line-height: 18px;
                background-color: #fafafa;
                border: 1px solid #d1d5db;
                transition: 0.18s;
                font-size: 0.92rem;
                border-radius: 8px;
            }
            .select-wrapper::after {
                content: "";
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                width: 0;
                height: 0;
                border-left: 5px solid transparent;
                border-right: 5px solid transparent;
                border-top: 6px solid #6b7280;
                pointer-events: none;
            }
            select.form-control option {
                padding: 6px 10px;
                font-size: 0.92rem;
            }

            .form-group.tax {
                padding: 12px 14px;
                background: #fafafa;
                border-radius: 10px;
                margin-top: 10px;
                cursor: pointer;
                border: 1px solid #e6e6e6;
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .form-group.tax input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }
            .form-group.tax label {
                cursor: pointer;
                margin: 0;
                user-select: none;
            }
            .content-tax {
                display: none;
                flex-direction: column;
                gap: 10px;
                margin-top: 10px;
            }
            .content-tax.active {
                display: flex;
            }

            .box-pay-method {
                margin-top: 20px;
                display: flex;
                flex-direction: column;
                gap: 12px;
            }
            .item-radio-custom {
                padding: 14px;
                border-radius: 10px;
                border: 1px solid #dcdcdc;
                background: #fafafa;
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
            }
            .item-radio-custom:hover {
                border-color: #3b82f6;
            }
            .item-radio-custom input {
                width: 18px;
                height: 18px;
            }
            .content-info-pay {
                display: none;
                background: #f0f4ff;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: 0.9rem;
                margin-top: -5px;
            }
            .content-info-pay.active {
                display: block;
            }

            .product-item {
                display: flex;
                gap: 10px;
                padding: 10px;
                border-radius: 8px;
                background: #fafafa;
                border: 1px solid #e6e6e6;
                margin-bottom: 12px;
            }
            .product-item img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 6px;
            }
            .product-name {
                font-weight: 600;
            }
            .product-details {
                font-size: 0.9rem;
                display: flex;
                justify-content: space-between;
            }

            .total-price {
                border-top: 1px solid #e5e7eb;
                margin-top: 16px;
                padding-top: 16px;
            }
            .total-price .item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .total-price .item:last-child {
                font-weight: 700;
                color: #2563eb;
            }

            .button-send-cart {
                width: 100%;
                margin-top: 20px;
                padding: 14px;
                border-radius: 10px;
                border: none;
                background: #2563eb;
                color: #fff;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .button-send-cart:hover {
                background: #1e40af;
            }

            .info-policy {
                background: #fafafa;
                border-radius: 12px;
                padding: 16px;
                border: 1px solid #e6e6e6;
                margin-top: 20px;
            }
            .info-policy .item {
                display: flex;
                gap: 10px;
                margin-bottom: 10px;
                font-size: 0.9rem;
                color: #555;
            }
            .info-policy i {
                color: #2563eb;
            }

            .background-white .title-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
            }
            @media (max-width: 900px) {
                .content-main-cart {
                    flex-direction: column;
                }
                .item-input {
                    flex: 1 1 100%;
                }
                .background-white .title-row {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .header-actions {
                    margin-left: 0;
                }
            }
        </style>
        <script>
            function toggleTaxContainer() {
                var cb = document.getElementById("tax_checkbox");
                cb.checked = !cb.checked;
                document.getElementById("js-tax-group").classList.toggle("active", cb.checked);
            }
            function showPay() {
                document.getElementById("text_pay_1").classList.remove("active");
                document.getElementById("text_pay_2").classList.remove("active");
                document.getElementById("text_pay_" + this.value).classList.add("active");
                var hiddenPay = document.getElementById("paymentId");
                if (hiddenPay)
                    hiddenPay.value = this.value; // 1: chuyển khoản, 2: COD
            }
            function check_field() {
                let name = document.getElementById('buyer_name').value.trim();
                let phone = document.getElementById('buyer_tel').value.trim();
                let addr = document.getElementById('buyer_address').value.trim();
                let province = document.getElementById('buyer_province').value;
                if (!name || !phone || !addr || !province) {
                    alert("Vui lòng nhập đầy đủ thông tin giao hàng!");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body class="payment-page">
        <%@ include file="partials/header.jsp" %>
        <%
            java.util.Map<Integer, model.OrderDetail> cart = (java.util.Map<Integer, model.OrderDetail>) session.getAttribute("cart");
            double cartTotal = 0;
            int cartCount = 0;
            if (cart != null) {
                for (model.OrderDetail it : cart.values()) {
                    cartTotal += it.getSubtotal();
                    cartCount += it.getQuantity();
                }
            }
            request.setAttribute("cartTotal", cartTotal);
        %>

        <div class="payment-content">
            <!-- ĐỔI action -> /orders và thêm action=checkout -->
            <form method="post" onsubmit="return check_field()" action="${pageContext.request.contextPath}/orders" class="content-main-cart" id="checkoutForm">
                <input type="hidden" name="action" value="checkout"/>
                <input type="hidden" name="paymentId" id="paymentId" value="1"/>
                <input type="hidden" name="shippingMethod" id="shippingMethodHidden" value="standard"/>

                <!-- LEFT -->
                <div class="content-left">
                    <div class="title-header"><h2>Thông tin giao hàng</h2></div>

                    <div class="content-input-form">
                        <div class="item-input">
                            <label>Họ và tên<span class="required">*</span></label>
                            <!-- đổi name -> receiverName -->
                            <input type="text" id="buyer_name" name="receiverName" placeholder="Họ tên người nhận" required>
                        </div>
                        <div class="item-input">
                            <label>Số điện thoại<span class="required">*</span></label>
                            <!-- đổi name -> phone -->
                            <input type="text" id="buyer_tel" name="phone" placeholder="Số điện thoại liên lạc" required>
                        </div>

                        <div class="item-input full">
                            <label>Tỉnh/thành phố<span class="required">*</span></label>
                            <div class="select-wrapper">
                                <!-- đổi name -> provinceId -->
                                <select name="provinceId" id="buyer_province" class="form-control" required>
                                    <option value="">Chọn tỉnh/thành phố</option>
                                    <option value="1">TP Hà Nội</option>
                                    <option value="2">TP Huế</option>
                                    <option value="3">Quảng Ninh</option>
                                    <option value="4">Cao Bằng</option>
                                    <option value="5">Lạng Sơn</option>
                                    <option value="6">Lai Châu</option>
                                    <option value="7">Điện Biên</option>
                                    <option value="8">Sơn La</option>
                                    <option value="9">Thanh Hóa</option>
                                    <option value="10">Nghệ An</option>
                                    <option value="11">Hà Tĩnh</option>
                                    <option value="12">Tuyên Quang</option>
                                    <option value="13">Lào Cai</option>
                                    <option value="14">Thái Nguyên</option>
                                    <option value="15">Phú Thọ</option>
                                    <option value="16">Bắc Ninh</option>
                                    <option value="17">Hưng Yên</option>
                                    <option value="18">TP Hải Phòng</option>
                                    <option value="19">Ninh Bình</option>
                                    <option value="20">Quảng Trị</option>
                                    <option value="21">TP Đà Nẵng</option>
                                    <option value="22">Quảng Ngãi</option>
                                    <option value="23">Gia Lai</option>
                                    <option value="24">Khánh Hòa</option>
                                    <option value="25">Lâm Đồng</option>
                                    <option value="26">Đắk Lắk</option>
                                    <option value="27">TP Hồ Chí Minh</option>
                                    <option value="28">Đồng Nai</option>
                                    <option value="29">Tây Ninh</option>
                                    <option value="30">TP Cần Thơ</option>
                                    <option value="31">Vĩnh Long</option>
                                    <option value="32">Đồng Tháp</option>
                                    <option value="33">Cà Mau</option>
                                    <option value="34">An Giang</option>
                                </select>
                            </div>
                        </div>

                        <div class="item-input full">
                            <label>Địa chỉ<span class="required">*</span></label>
                            <!-- đổi name -> address -->
                            <textarea id="buyer_address" name="address" rows="2" placeholder="Nhập địa chỉ chi tiết" required></textarea>
                        </div>

                        <!-- Phương thức giao hàng -->
                        <div class="item-input">
                            <label>Phương thức giao hàng</label>
                            <div class="select-wrapper">
                                <select id="shippingMethodSelect" class="form-control">
                                    <option value="standard" selected>Tiêu chuẩn (30.000₫)</option>
                                    <option value="express">Nhanh (60.000₫)</option>
                                    <option value="overnight">Hỏa tốc (120.000₫)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Ghi chú đơn hàng -->
                        <div class="item-input full">
                            <label>Ghi chú</label>
                            <!-- giữ name -> note -->
                            <textarea id="note" name="note" rows="2" placeholder="Ghi chú cho đơn hàng (nếu có)"></textarea>
                        </div>

                        <!-- Mã giảm giá (tùy chọn) -->
                        <div class="item-input full">
                            <label>Mã giảm giá</label>
                            <input type="text" id="couponCode" name="couponCode" placeholder="Nhập mã coupon (nếu có)">
                        </div>
                    </div>

                    <!-- Xuất hóa đơn công ty -->
                    <div id="tax_box_click" class="form-group tax" role="button" aria-expanded="false" onclick="toggleTaxContainer()">
                        <input type="checkbox" id="tax_checkbox">
                        <label for="tax_checkbox">Xuất hóa đơn công ty</label>
                    </div>
                    <div id="js-tax-group" class="content-tax" aria-hidden="true">
                        <input type="text" name="tax_name" placeholder="Tên công ty">
                        <input type="text" name="tax_address" placeholder="Địa chỉ công ty">
                        <input type="text" name="tax_code" placeholder="Mã số thuế">
                        <input type="email" name="tax_email" placeholder="Email công ty">
                    </div>

                    <!-- PHƯƠNG THỨC THANH TOÁN (HIỂN THỊ) -->
                    <div class="box-pay-method">
                        <label class="item-radio-custom">
                            <input type="radio" name="pay_method_display" value="1" checked onclick="showPay.call(this)">
                            <span>Thanh toán chuyển khoản</span>
                        </label>
                        <div class="content-info-pay active" id="text_pay_1">
                            <p><b>Ngân hàng MB Bank - Chi nhánh Tràng An</b></p>
                            <p>Số TK: 282468888</p>
                            <p>Tên TK: CT TNHH TM & Tin Học Từ Nguyệt</p>
                        </div>

                        <label class="item-radio-custom">
                            <input type="radio" name="pay_method_display" value="2" onclick="showPay.call(this)">
                            <span>Thanh toán khi nhận hàng (COD)</span>
                        </label>
                        <div class="content-info-pay" id="text_pay_2">
                            <p>Thanh toán khi nhận hàng (COD).</p>
                        </div>
                    </div>
                </div>

                <!-- RIGHT -->
                <div class="content-right">
                    <div class="background-white">
                        <div class="title-row">
                            <h2 class="title">Thông tin giỏ hàng</h2>
                            <div class="header-actions">
                                <a href="#" id="btnDownloadQuote"><i class="fa-solid fa-download"></i> Tải báo giá</a>
                                <a href="#" id="btnPrintQuote"><i class="fa-solid fa-print"></i> In báo giá</a>
                            </div>
                        </div>

                        <div class="content-product">
                            <c:forEach var="item" items="${sessionScope.cart.values()}">
                                <div class="product-item">
                                    <img src="${pageContext.request.contextPath}/${item.product.imagePath}" alt="thumb">
                                    <div class="product-info">
                                        <div class="product-name">${item.product.name}</div>
                                        <div class="product-details">
                                            <span class="product-quantity">x${item.quantity}</span>
                                            <span class="product-price">${item.subtotal}₫</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="total-price">
                            <div class="item">
                                <span>Tổng số lượng</span>
                                <span><c:out value="${sessionScope.cartSize != null ? sessionScope.cartSize : 0}"/></span>
                            </div>
                            <div class="item">
                                <span>Số mặt hàng</span>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.cart}"><c:out value="${sessionScope.cart.size()}"/></c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="item">
                                <span>Tổng chi phí</span>
                                <span>${cartTotal}₫</span>
                            </div>
                            <div class="vat">Đã bao gồm VAT (nếu có)</div>
                        </div>
                        <button type="submit" class="button-send-cart"><i class="fa-solid fa-lock"></i> Xác nhận mua hàng</button>
                        <div class="icon-pay" style="margin-top:12px;">
                            <img src="${pageContext.request.contextPath}/images/pay_cart.png" alt="pay" style="max-width:160px;">
                        </div>
                        <div class="info-policy">
                            <div class="item"><i class="fa-solid fa-credit-card"></i><span>Hỗ trợ trả góp 0%</span></div>
                            <div class="item"><i class="fa-solid fa-money-bill"></i><span>Hoàn tiền 200% nếu hàng giả</span></div>
                            <div class="item"><i class="fa-solid fa-bolt"></i><span>Giao hàng nhanh toàn quốc</span></div>
                            <div class="item"><i class="fa-solid fa-headset"></i><span>Hỗ trợ kỹ thuật 24/7</span></div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- JS cho In/Tải báo giá: POST dữ liệu hiện có -->
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // đồng bộ shippingMethod hidden với select
                const sel = document.getElementById('shippingMethodSelect');
                const hidden = document.getElementById('shippingMethodHidden');
                if (sel && hidden) {
                    sel.addEventListener('change', () => hidden.value = sel.value);
                    hidden.value = sel.value;
                }

                function addHidden(form, name, value) {
                    const i = document.createElement('input');
                    i.type = 'hidden';
                    i.name = name;
                    i.value = value || '';
                    form.appendChild(i);
                }
                function postTo(path) {
                    const f = document.createElement('form');
                    f.method = 'post';
                    f.action = '${pageContext.request.contextPath}' + path;
                    f.target = '_blank';
                    addHidden(f, 'receiverName', document.getElementById('buyer_name').value.trim());
                    addHidden(f, 'phone', document.getElementById('buyer_tel').value.trim());
                    addHidden(f, 'address', document.getElementById('buyer_address').value.trim());
                    addHidden(f, 'provinceId', document.getElementById('buyer_province').value);
                    addHidden(f, 'shippingMethod', document.getElementById('shippingMethodHidden').value);
                    addHidden(f, 'paymentId', document.getElementById('paymentId').value);
                    addHidden(f, 'note', document.getElementById('note').value.trim());
                    addHidden(f, 'couponCode', document.getElementById('couponCode')?.value.trim() || '');
                    document.body.appendChild(f);
                    f.submit();
                    document.body.removeChild(f);
                }
                document.getElementById('btnPrintQuote')?.addEventListener('click', e => {
                    e.preventDefault();
                    postTo('/invoice/print');
                });
                document.getElementById('btnDownloadQuote')?.addEventListener('click', e => {
                    e.preventDefault();
                    postTo('/quote/download');
                });
            });
        </script>

        <%@ include file="partials/footer.jsp" %>
    </body>
</html>