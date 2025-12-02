<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                background:#f5f6f7;
                font-family:"Inter","Segoe UI",Arial,sans-serif;
                color:#1f2937;
            }
            .payment-content {
                max-width:1100px;
                margin:24px auto;
                padding:0 16px 40px;
            }
            .content-main-cart {
                display:flex;
                gap:24px;
                align-items:flex-start;
            }
            .content-left,.content-right {
                flex:1;
                background:#fff;
                border-radius:12px;
                padding:28px;
                border:1px solid #ececec;
            }
            .title-header h2,.background-white .title {
                font-size:1.4rem;
                font-weight:700;
                margin-bottom:8px;
                color:#111827;
            }
            .header-actions {
                display:flex;
                gap:12px;
                margin-left:12px;
                font-size:.95rem;
                align-items:center;
            }
            .header-actions a {
                color:#374151;
                text-decoration:none;
                display:inline-flex;
                gap:8px;
                align-items:center;
                padding:6px 8px;
                border-radius:8px;
                transition:.12s;
                background:transparent;
            }
            .header-actions a:hover {
                background:#f3f4f6;
                color:#111827;
            }
            .content-input-form {
                display:flex;
                flex-wrap:wrap;
                gap:16px;
            }
            .item-input {
                flex:1 1 calc(50% - 8px);
            }
            .item-input.full {
                flex:1 1 100%;
            }
            label {
                font-weight:600;
                margin-bottom:6px;
                display:block;
                font-size:.92rem;
                color:#111827;
            }
            .required {
                color:#dc2626;
                margin-left:4px;
                font-weight:700;
            }
            input,select,textarea {
                width:100%;
                padding:10px 12px;
                border-radius:8px;
                border:1px solid #d8d8d8;
                background:#fafafa;
                transition:.18s;
                font-size:.95rem;
                color:#111827;
            }
            input:focus,select:focus,textarea:focus {
                background:#fff;
                border-color:#2563eb;
                outline:none;
                box-shadow:0 6px 18px rgba(37,99,235,0.08);
            }
            textarea {
                resize:vertical;
            }
            .select-wrapper {
                position:relative;
                display:block;
            }
            .select-wrapper .form-control {
                appearance:none;
                padding:8px 36px 8px 10px;
                height:38px;
                background:#fafafa;
                border:1px solid #d1d5db;
                transition:.18s;
                font-size:.92rem;
                border-radius:8px;
            }
            .select-wrapper::after {
                content:"";
                position:absolute;
                right:12px;
                top:50%;
                transform:translateY(-50%);
                width:0;
                height:0;
                border-left:5px solid transparent;
                border-right:5px solid transparent;
                border-top:6px solid #6b7280;
                pointer-events:none;
            }
            .form-group.tax {
                padding:12px 14px;
                background:#fafafa;
                border-radius:10px;
                margin-top:10px;
                cursor:pointer;
                border:1px solid #e6e6e6;
                display:flex;
                gap:10px;
                align-items:center;
            }
            .form-group.tax input[type="checkbox"] {
                width:18px;
                height:18px;
                cursor:pointer;
            }
            .content-tax {
                display:none;
                flex-direction:column;
                gap:10px;
                margin-top:10px;
            }
            .content-tax.active {
                display:flex;
            }

            .box-pay-method {
                margin-top:20px;
                display:flex;
                flex-direction:column;
                gap:12px;
            }
            .item-radio-custom {
                padding:14px;
                border-radius:10px;
                border:1px solid #dcdcdc;
                background:#fafafa;
                display:flex;
                align-items:center;
                gap:10px;
                cursor:pointer;
            }
            .item-radio-custom:hover {
                border-color:#3b82f6;
            }
            .item-radio-custom input {
                width:18px;
                height:18px;
            }
            .content-info-pay {
                display:none;
                background:#f0f4ff;
                border-radius:8px;
                padding:12px 16px;
                font-size:.9rem;
                margin-top:-5px;
            }
            .content-info-pay.active {
                display:block;
            }

            .product-item {
                display:flex;
                gap:10px;
                padding:10px;
                border-radius:8px;
                background:#fafafa;
                border:1px solid #e6e6e6;
                margin-bottom:12px;
            }
            .product-item img {
                width:60px;
                height:60px;
                object-fit:cover;
                border-radius:6px;
            }
            .product-name {
                font-weight:600;
            }
            .product-details {
                font-size:.9rem;
                display:flex;
                justify-content:space-between;
            }
            .total-price {
                border-top:1px solid #e5e7eb;
                margin-top:16px;
                padding-top:16px;
            }
            .total-price .item {
                display:flex;
                justify-content:space-between;
                margin-bottom:10px;
            }
            .total-price .item:last-child {
                font-weight:700;
                color:#2563eb;
            }
            .button-send-cart {
                width:100%;
                margin-top:20px;
                padding:14px;
                border-radius:10px;
                border:none;
                background:#2563eb;
                color:#fff;
                font-size:1rem;
                font-weight:600;
                cursor:pointer;
                transition:.2s;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:8px;
            }
            .button-send-cart:hover {
                background:#1e40af;
            }
            .info-policy {
                background:#fafafa;
                border-radius:12px;
                padding:16px;
                border:1px solid #e6e6e6;
                margin-top:20px;
            }
            .info-policy .item {
                display:flex;
                gap:10px;
                margin-bottom:10px;
                font-size:.9rem;
                color:#555;
            }
            .info-policy i {
                color:#2563eb;
            }
            .background-white .title-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:12px;
            }
            @media (max-width:900px){
                .content-main-cart {
                    flex-direction:column;
                }
                .item-input {
                    flex:1 1 100%;
                }
                .background-white .title-row {
                    flex-direction:column;
                    align-items:flex-start;
                }
                .header-actions {
                    margin-left:0;
                }
            }

            /* QR chuyển khoản (tĩnh) */
            .qr-box {
                margin-top:14px;
                background:#ffffff;
                border:1px solid #e5e7eb;
                border-radius:12px;
                padding:16px 18px 20px;
                position:relative;
                display:none;
            }
            .qr-header {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:10px;
            }
            .qr-header h3 {
                font-size:1rem;
                margin:0;
                font-weight:600;
                color:#111827;
            }
            .qr-image-wrap {
                text-align:center;
                margin:10px 0 12px;
            }
            .qr-image-wrap img {
                max-width:240px;
                width:100%;
                height:auto;
                display:block;
                margin:0 auto;
            }
            .qr-ref {
                font-size:.75rem;
                text-align:center;
                color:#555;
                margin-top:4px;
            }
            .qr-actions {
                display:flex;
                justify-content:center;
                gap:10px;
                margin-top:8px;
            }
            .qr-actions button {
                padding:8px 14px;
                border-radius:8px;
                border:none;
                background:#2563eb;
                color:#fff;
                font-size:.8rem;
                font-weight:600;
                cursor:pointer;
                display:inline-flex;
                align-items:center;
                gap:6px;
            }
            .qr-actions button:hover {
                background:#1e40af;
            }

            /* Popup thanh toán thành công */
            .pay-modal{
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.45);
                display:none;
                align-items:center;
                justify-content:center;
                z-index:99999;
            }
            .pay-modal.show{
                display:flex;
            }
            .pay-modal__dialog{
                width:min(92vw, 420px);
                background:#fff;
                border-radius:14px;
                padding:22px 18px;
                box-shadow:0 16px 50px rgba(0,0,0,.2);
                text-align:center;
                animation:pmfade .2s ease;
            }
            .pay-modal__icon{
                font-size:42px;
                margin-bottom:8px;
            }
            .pay-modal__title{
                font-weight:800;
                font-size:1.15rem;
                margin-bottom:6px;
                color:#111827;
            }
            .pay-modal__desc{
                font-size:.95rem;
                color:#374151;
                margin-bottom:14px;
            }
            .pay-modal__btn{
                padding:10px 16px;
                border:none;
                border-radius:10px;
                background:#2563eb;
                color:#fff;
                font-weight:700;
                cursor:pointer;
            }
            .pay-modal__btn:hover{
                background:#1e40af;
            }
            @keyframes pmfade{
                from{
                    opacity:0;
                    transform:translateY(6px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }
        </style>
        <script>
            function toggleTaxContainer() {
                var cb = document.getElementById("tax_checkbox");
                cb.checked = !cb.checked;
                document.getElementById("js-tax-group").classList.toggle("active", cb.checked);
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
            function showPay() {
                document.getElementById("text_pay_1").classList.remove("active");
                document.getElementById("text_pay_2").classList.remove("active");
                document.getElementById("text_pay_" + this.value).classList.add("active");
                var hiddenPay = document.getElementById("paymentId");
                if (hiddenPay)
                    hiddenPay.value = this.value;
                var qrBox = document.getElementById('qrBox');
                if (this.value === '1') {
                    qrBox.style.display = 'block';
                } else {
                    qrBox.style.display = 'none';
                }
            }
            function openPaySuccessPopup(title, desc) {
                const m = document.getElementById('paySuccessModal');
                document.getElementById('payModalTitle').textContent = title || 'Thanh toán thành công';
                document.getElementById('payModalDesc').textContent = desc || 'Cảm ơn bạn đã mua hàng!';
                m.classList.add('show');
            }
            function closePaySuccessPopup() {
                document.getElementById('paySuccessModal').classList.remove('show');
            }
            document.addEventListener('DOMContentLoaded', () => {
                const sel = document.getElementById('shippingMethodSelect');
                const hidden = document.getElementById('shippingMethodHidden');
                if (sel && hidden) {
                    sel.addEventListener('change', () => hidden.value = sel.value);
                    hidden.value = sel.value;
                }
                const payRadio = document.querySelector('input[name="pay_method_display"][value="1"]');
                if (payRadio && payRadio.checked) {
                    document.getElementById('qrBox').style.display = 'block';
                }
                document.getElementById('btnCopyInfo')?.addEventListener('click', () => {
                    const acc = document.getElementById('bankAccountStatic')?.textContent || 'SỐ TÀI KHOẢN';
                    navigator.clipboard.writeText(acc).then(() => alert('Đã copy: ' + acc)).catch(() => alert('Không copy được, thử lại.'));
                });
                document.getElementById('payModalBtn')?.addEventListener('click', closePaySuccessPopup);
                document.getElementById('paySuccessModal')?.addEventListener('click', e => {
                    if (e.target.id === 'paySuccessModal')
                        closePaySuccessPopup();
                });
                document.addEventListener('keydown', e => {
                    if (e.key === 'Escape')
                        closePaySuccessPopup();
                });
                const params = new URLSearchParams(location.search);
                const success = params.get('success');
                if (success === '1' || success === 'true') {
                    const method = document.querySelector('input[name="pay_method_display"]:checked')?.value;
                    if (method === '2') {
                        openPaySuccessPopup('Đặt hàng thành công', 'Bạn sẽ thanh toán khi nhận hàng (COD).');
                    } else {
                        openPaySuccessPopup('Thanh toán thành công', 'Cảm ơn bạn đã mua hàng!');
                    }
                }
            });
        </script>
    </head>
    <body class="payment-page">
        <%@ include file="partials/header.jsp" %>
        <%
            java.util.Map<Integer, model.OrderDetail> cart
                    = (java.util.Map<Integer, model.OrderDetail>) session.getAttribute("cart");
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
            <form method="post" onsubmit="return check_field()" action="${pageContext.request.contextPath}/orders"
                  class="content-main-cart" id="checkoutForm">
                <input type="hidden" name="action" value="checkout"/>
                <input type="hidden" name="paymentId" id="paymentId" value="1"/>
                <input type="hidden" name="shippingMethod" id="shippingMethodHidden" value="standard"/>

                <!-- LEFT -->
                <div class="content-left">
                    <div class="title-header"><h2>Thông tin giao hàng</h2></div>

                    <div class="content-input-form">
                        <div class="item-input">
                            <label>Họ và tên<span class="required">*</span></label>
                            <input type="text" id="buyer_name" name="receiverName" placeholder="Họ tên người nhận" required>
                        </div>
                        <div class="item-input">
                            <label>Số điện thoại<span class="required">*</span></label>
                            <input type="text" id="buyer_tel" name="phone" placeholder="Số điện thoại liên lạc" required>
                        </div>

                        <div class="item-input full">
                            <label>Tỉnh/thành phố<span class="required">*</span></label>
                            <div class="select-wrapper">
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
                            <textarea id="buyer_address" name="address" rows="2" placeholder="Nhập địa chỉ chi tiết" required></textarea>
                        </div>

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

                        <div class="item-input full">
                            <label>Ghi chú</label>
                            <textarea id="note" name="note" rows="2" placeholder="Ghi chú cho đơn hàng (nếu có)"></textarea>
                        </div>

                        <!-- Mã giảm giá: TỰ ĐIỀN LẠI TỪ CART -->
                        <div class="item-input full">
                            <label>Mã giảm giá</label>
                            <input type="text" id="couponCode" name="couponCode" placeholder="Nhập mã coupon (nếu có)"
                                   value="${appliedCouponCode}"/>
                            <c:if test="${not empty appliedCouponCode}">
                                <c:choose>
                                    <c:when test="${couponValid}">
                                        <div class="alert success">
                                            Mã <strong>${appliedCouponCode}</strong> đã áp dụng:
                                            giảm <strong><c:out value='${couponDiscount}'/>₫</strong>.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert error">
                                            <c:out value='${couponMessage != null ? couponMessage : "Mã coupon không hợp lệ"}'/>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>

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

                    <div class="box-pay-method">
                        <label class="item-radio-custom">
                            <input type="radio" name="pay_method_display" value="1" checked onclick="showPay.call(this)">
                            <span>Thanh toán chuyển khoản</span>
                        </label>
                        <div class="content-info-pay active" id="text_pay_1">
                            <p><b>Ngân hàng ? - Chi nhánh ?</b></p>
                            <p>Số TK: ?<span id="bankAccountStatic"> ? </span></p>
                            <p>Tên TK: ?</p>
                            <p style="margin-top:6px;font-size:.85rem;color:#555;">Quét mã QR bên dưới để chuyển khoản nhanh.</p>
                        </div>

                        <div class="qr-box" id="qrBox">
                            <div class="qr-header">
                                <h3>Mã QR chuyển khoản</h3>
                            </div>
                            <div class="qr-image-wrap">
                                <img id="qrImage" src="${pageContext.request.contextPath}/images/qr.jpg" alt="QR chuyển khoản" loading="lazy">
                            </div>
                            <div class="qr-ref">(Nếu không quét được, hãy nhập số tài khoản ở trên)</div>
                            <div class="qr-actions">
                                <button type="button" id="btnCopyInfo"><i class="fa-solid fa-copy"></i> Copy STK</button>
                            </div>
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

                        <!-- TÓM TẮT TÍNH TIỀN THEO COUPON -->
                        <div class="total-price">
                            <!-- Tạm tính luôn lấy từ server (PaymentServlet đã set cartSubtotalServer) -->
                            <div class="item">
                                <span>Tạm tính</span>
                                <span>
                                    <fmt:formatNumber value="${cartSubtotalServer != null ? cartSubtotalServer : cartTotal}" type="number" groupingUsed="true"/>₫
                                </span>
                            </div>

                            <!-- Chỉ hiển thị dòng giảm nếu coupon hợp lệ -->
                            <c:if test="${couponValid}">
                                <div class="item">
                                    <span>Giảm theo coupon (<strong><c:out value='${appliedCouponCode}'/></strong>)</span>
                                    <span>-<fmt:formatNumber value="${couponDiscount}" type="number" groupingUsed="true"/>₫</span>
                                </div>
                            </c:if>

                            <!-- Tổng tiền: nếu có coupon hợp lệ thì dùng discountedTotal, ngược lại là tạm tính -->
                            <div class="item">
                                <span>Tổng tiền</span>
                                <span>
                                    <fmt:formatNumber
                                        value="${couponValid ? discountedTotal : (cartSubtotalServer != null ? cartSubtotalServer : cartTotal)}"
                                        type="number" groupingUsed="true"
                                        />₫
                                </span>
                            </div>

                            <div class="vat" style="margin-top:6px;color:#6b7280;font-size:.9rem;">
                                Lưu ý: Phí vận chuyển/thuế sẽ được tính khi tạo đơn.
                            </div>
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

            <!-- Popup thanh toán thành công -->
            <div id="paySuccessModal" class="pay-modal" aria-hidden="true">
                <div class="pay-modal__dialog">
                    <div class="pay-modal__icon">✅</div>
                    <div class="pay-modal__title" id="payModalTitle">Thanh toán thành công</div>
                    <div class="pay-modal__desc" id="payModalDesc">Cảm ơn bạn đã mua hàng!</div>
                    <button type="button" class="pay-modal__btn" id="payModalBtn">Đóng</button>
                </div>
            </div>
        </div>

        <script>
            // In/Download báo giá
            document.addEventListener('DOMContentLoaded', () => {
                function addHidden(form, name, value) {
                    const i = document.createElement('input');
                    i.type = 'hidden'; i.name = name; i.value = value || '';
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