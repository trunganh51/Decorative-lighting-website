<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận mua hàng</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            /* === RESET CHỈ CHO PAYMENT PAGE CONTENT === */
            .payment-content * {
                box-sizing: border-box;
            }

            /* === BODY OVERRIDE ONLY FOR PAYMENT === */
            body.payment-page {
                background: #f8f9fa !important;
                font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            }

            /* === KHÔNG ẢNH HƯỞNG ĐỀN HEADER === */
            /* Header giữ nguyên styling từ header.jsp */

            /* === PAYMENT PAGE CONTAINER === */
            .payment-content {
                max-width: 1200px;
                margin: 20px auto;
                padding: 0 16px 40px;
            }

            .payment-content .content-main-cart {
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }

            /* === LEFT FORM === */
            .payment-content .content-left {
                flex: 1.4;
                background: #fff;
                border-radius: 20px;
                padding: 32px;
                box-shadow: 0 8px 30px rgba(0,0,0,0.12);
                animation: slideInLeft 0.5s ease-out;
            }

            /* === RIGHT CART === */
            .payment-content .content-right {
                flex: 1;
                background: #fff;
                border-radius: 20px;
                padding: 32px;
                box-shadow: 0 8px 30px rgba(0,0,0,0.12);
                animation: slideInRight 0.5s ease-out;
            }

            /* === ANIMATIONS === */
            @keyframes slideInLeft {
                from {
                    opacity: 0;
                    transform: translateX(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            @keyframes slideInRight {
                from {
                    opacity: 0;
                    transform: translateX(20px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            /* === TITLE HEADER === */
            .payment-content .title-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
            }

            .payment-content .title-header h2 {
                font-size: 1.6rem;
                font-weight: 700;
                color: #1a202c;
                margin: 0;
            }

            .payment-content .header-actions {
                display: flex;
                gap: 12px;
            }

            .payment-content .header-actions a {
                font-size: 0.9rem;
                color: #007bff;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                border-radius: 8px;
                background: #f8f9fa;
                transition: all 0.3s ease;
                border: 1px solid #e6e6e6;
            }

            .payment-content .header-actions a:hover {
                background: #007bff;
                color: #fff;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,123,255,0.3);
            }

            /* === FORM INPUT === */
            .payment-content .content-input-form {
                display: flex;
                flex-wrap: wrap;
                gap: 16px;
            }

            .payment-content .item-input {
                flex: 1 1 calc(50% - 8px);
                min-width: 200px;
            }

            .payment-content .item-input.full {
                flex: 1 1 100%;
            }

            .payment-content label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #4a5568;
                font-size: 0.95rem;
            }

            .payment-content .required {
                color: #dc3545;
                margin-left: 2px;
            }

            .payment-content input, 
            .payment-content select, 
            .payment-content textarea {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #e2e8f0;
                border-radius: 10px;
                margin-bottom: 16px;
                font-size: 0.95rem;
                transition: all 0.3s ease;
                background: #f7fafc;
                font-family: inherit;
            }

            .payment-content input:focus, 
            .payment-content select:focus, 
            .payment-content textarea:focus {
                border-color: #007bff;
                outline: none;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(0,123,255,0.1);
                transform: translateY(-1px);
            }

            .payment-content textarea {
                resize: none;
                min-height: 80px;
            }

            /* === TAX === */
            .payment-content .form-group.tax {
                display: flex;
                align-items: center;
                margin: 20px 0;
                padding: 16px;
                background: #f7fafc;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: 1px solid #e2e8f0;
            }

            .payment-content .form-group.tax:hover {
                background: #edf2f7;
                border-color: #007bff;
            }

            .payment-content .form-group.tax input[type="checkbox"] {
                margin: 0 8px 0 0;
                width: 20px;
                height: 20px;
                cursor: pointer;
                accent-color: #007bff;
            }

            .payment-content .form-group.tax label {
                cursor: pointer;
                font-size: 1rem;
                margin-bottom: 0;
            }

            .payment-content .content-tax {
                display: none;
                flex-direction: column;
                gap: 12px;
                margin-top: 12px;
                padding: 20px;
                background: #f7fafc;
                border-radius: 10px;
                border: 2px dashed #cbd5e0;
            }

            .payment-content .content-tax.active {
                display: flex;
            }

            /* === PAYMENT METHOD === */
            .payment-content .box-pay-method {
                display: flex;
                flex-direction: column;
                gap: 12px;
                margin-top: 24px;
            }

            .payment-content .item-radio-custom {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 1rem;
                padding: 16px;
                border: 2px solid #e2e8f0;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                background: #f7fafc;
            }

            .payment-content .item-radio-custom:hover {
                border-color: #007bff;
                background: #fff;
            }

            .payment-content .item-radio-custom input[type="radio"] {
                width: 20px;
                height: 20px;
                cursor: pointer;
                margin: 0;
                accent-color: #007bff;
            }

            .payment-content .item-radio-custom input[type="radio"]:checked + span {
                color: #007bff;
                font-weight: 600;
            }

            .payment-content .content-info-pay {
                display: none;
                padding: 16px 20px 16px 46px;
                margin-top: -8px;
                font-size: 0.9rem;
                background: #edf2f7;
                border-radius: 0 0 10px 10px;
                color: #4a5568;
                border: 2px solid #007bff;
                border-top: none;
            }

            .payment-content .content-info-pay.active {
                display: block;
            }

            /* === CART ITEMS === */
            .payment-content .content-product {
                max-height: none;
                overflow-y: visible;
                padding-right: 0;
            }

            .payment-content .product-item {
                display: flex;
                gap: 12px;
                margin-bottom: 16px;
                padding: 12px;
                background: #f8f9fa;
                border-radius: 10px;
                transition: all 0.3s ease;
                border: 1px solid #e6e6e6;
            }

            .payment-content .product-item:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                transform: translateX(2px);
                background: #fff;
            }

            .payment-content .product-item img {
                width: 70px;
                height: 70px;
                object-fit: cover;
                border-radius: 8px;
                border: 2px solid #edf2f7;
            }

            .payment-content .product-info {
                flex: 1;
            }

            .payment-content .product-name {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 8px;
                font-size: 0.95rem;
            }

            .payment-content .product-details {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .payment-content .product-quantity {
                font-weight: 600;
                color: #007bff;
            }

            .payment-content .product-price {
                font-weight: 700;
                color: #2d3748;
            }

            /* === TOTAL === */
            .payment-content .total-price {
                margin-top: 20px;
                padding-top: 20px;
                border-top: 2px solid #e2e8f0;
            }

            .payment-content .total-price .item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                font-size: 1rem;
            }

            .payment-content .total-price .item:last-of-type {
                font-size: 1.2rem;
                color: #007bff;
                font-weight: 700;
            }

            .payment-content .vat {
                font-size: 0.85rem;
                color: #718096;
                font-style: italic;
                margin-top: 8px;
            }

            /* === POLICY / ICON === */
            .payment-content .icon-pay {
                margin-top: 20px;
                text-align: center;
            }

            .payment-content .icon-pay img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
            }

            .payment-content .info-policy {
                margin-top: 20px;
                padding: 20px;
                background: linear-gradient(135deg,#f7fafc,#edf2f7);
                border-radius: 12px;
                border: 1px solid #e6e6e6;
            }

            .payment-content .info-policy .item {
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 0.9rem;
                margin-bottom: 12px;
                color: #4a5568;
            }

            .payment-content .info-policy .item:last-child {
                margin-bottom: 0;
            }

            .payment-content .info-policy i {
                color: #007bff;
                font-size: 1.1rem;
                width: 24px;
                text-align: center;
            }

            /* === BUTTON === */
            .payment-content .button-send-cart {
                width: 100%;
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: #fff;
                font-weight: 700;
                padding: 16px;
                border: none;
                border-radius: 12px;
                cursor: pointer;
                margin-top: 16px;
                font-size: 1.05rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(0,123,255,0.3);
            }

            .payment-content .button-send-cart:hover {
                background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,123,255,0.4);
            }

            .payment-content .button-send-cart:active {
                transform: translateY(0);
            }

            /* === TITLE CONSISTENCY === */
            .payment-content .background-white .title {
                font-size: 1.6rem;
                font-weight: 700;
                color: #1a202c;
                margin-bottom: 24px;
                text-align: center;
            }

            /* === RESPONSIVE === */
            @media (max-width: 900px) {
                .payment-content .content-main-cart {
                    flex-direction: column;
                }
                .payment-content .content-right {
                    position: relative;
                    top: auto;
                    margin-top: 24px;
                }
                .payment-content .item-input {
                    flex: 1 1 100%;
                }
                .payment-content .header-actions {
                    flex-direction: column;
                }
                .payment-content .title-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 12px;
                }
            }

            @media (max-width: 768px) {
                .payment-content {
                    margin: 10px auto;
                    padding: 0 12px 40px;
                }
                
                .payment-content .content-left,
                .payment-content .content-right {
                    padding: 20px;
                }
                
                .payment-content .title-header h2,
                .payment-content .background-white .title {
                    font-size: 1.4rem;
                }
            }

            @media (max-width: 640px) {
                .payment-content .header-actions {
                    gap: 8px;
                }
                
                .payment-content .header-actions a {
                    padding: 6px 12px;
                    font-size: 0.8rem;
                }
                
                .payment-content .product-item {
                    padding: 8px;
                    gap: 8px;
                }
                
                .payment-content .product-item img {
                    width: 60px;
                    height: 60px;
                }
            }
        </style>
        <script>
            function showPay() {
                document.getElementById("text_pay_1").classList.remove("active");
                document.getElementById("text_pay_2").classList.remove("active");
                document.getElementById("text_pay_" + this.value).classList.add("active");
            }

            function toggleTax() {
                document.getElementById("js-tax-group").classList.toggle("active");
            }

            function check_field() {
                let name = document.getElementById('buyer_name').value.trim();
                let phone = document.getElementById('buyer_tel').value.trim();
                let addr = document.getElementById('buyer_address').value.trim();

                if (!name || !phone || !addr) {
                    alert("Vui lòng nhập đầy đủ thông tin giao hàng!");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body class="payment-page">
        <%@ include file="partials/header.jsp" %>

        <!-- WRAP TOÀN BỘ CONTENT PAYMENT TRONG 1 CONTAINER ĐỂ CÔ LẬP CSS -->
        <div class="payment-content">
            <form method="post" onsubmit="return check_field()" action="${pageContext.request.contextPath}/order-confirmed" class="content-main-cart">
                <!-- LEFT -->
                <div class="content-left">
                    <div class="title-header">
                        <h2>Thông tin giao hàng</h2>
                        <div class="header-actions">
                            <a href="#"><i class="fa-solid fa-download"></i> Tải báo giá</a>
                            <a href="#"><i class="fa-solid fa-print"></i> In báo giá</a>
                        </div>
                    </div>

                    <div class="content-input-form">
                        <div class="item-input">
                            <label>Họ và tên<span class="required">*</span></label>
                            <input type="text" id="buyer_name" name="buyer_name" placeholder="Họ tên người nhận">
                        </div>
                        <div class="item-input">
                            <label>Số điện thoại<span class="required">*</span></label>
                            <input type="text" id="buyer_tel" name="buyer_tel" placeholder="Số điện thoại liên lạc">
                        </div>
                        <div class="item-input full">
                            <label>Tỉnh/thành phố<span class="required">*</span></label>
                            <select name="buyer_province" class="form-control">
                                <option value="">Chọn tỉnh/thành phố</option>
                                <option>Hà Nội</option>
                                <option>TP HCM</option>
                                <option>Đà Nẵng</option>
                                <option>Cần Thơ</option>
                                <option>Hải Phòng</option>
                            </select>
                        </div>
                        <div class="item-input full">
                            <label>Địa chỉ<span class="required">*</span></label>
                            <textarea id="buyer_address" name="buyer_address" rows="2" placeholder="Nhập địa chỉ chi tiết"></textarea>
                        </div>
                    </div>

                    <div class="form-group tax" onclick="toggleTax()">
                        <input type="checkbox" id="tax_checkbox">
                        <label for="tax_checkbox">Xuất hóa đơn công ty</label>
                    </div>
                    <div id="js-tax-group" class="content-tax">
                        <input type="text" name="tax_name" placeholder="Tên công ty">
                        <input type="text" name="tax_address" placeholder="Địa chỉ công ty">
                        <input type="text" name="tax_code" placeholder="Mã số thuế">
                        <input type="email" name="tax_email" placeholder="Email công ty">
                    </div>

                    <div class="box-pay-method">
                        <label class="item-radio-custom">
                            <input type="radio" name="pay_method" value="1" checked onclick="showPay.call(this)">
                            <span>Thanh toán chuyển khoản</span>
                        </label>
                        <div class="content-info-pay active" id="text_pay_1">
                            <p><b>Ngân hàng MB Bank - Chi nhánh Tràng An</b></p>
                            <p>Số TK: 282468888</p>
                            <p>Tên TK: CT TNHH TM & Tin Học Từ Nguyệt</p>
                        </div>

                        <label class="item-radio-custom">
                            <input type="radio" name="pay_method" value="2" onclick="showPay.call(this)">
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
                        <h2 class="title">Thông tin giỏ hàng</h2>
                        <div class="content-product">
                            <c:forEach var="item" items="${sessionScope.cart.values()}">
                                <div class="product-item">
                                    <img src="${pageContext.request.contextPath}/images/no-image.jpg" alt="thumb">
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
                                <span>Tổng sản phẩm</span>
                                <span><c:out value="${fn:length(sessionScope.cart)}"/></span>
                            </div>
                            <div class="item">
                                <span>Tổng chi phí</span>
                                <span>${cartTotal}₫</span>
                            </div>
                            <div class="vat">Đã bao gồm VAT (nếu có)</div>
                        </div>
                        <button type="submit" class="button-send-cart">
                            <i class="fa-solid fa-lock"></i> Xác nhận mua hàng
                        </button>
                        <div class="icon-pay">
                            <img src="${pageContext.request.contextPath}/images/pay_cart.png" alt="pay">
                        </div>
                        <div class="info-policy">
                            <div class="item">
                                <i class="fa-solid fa-credit-card"></i>
                                <span>Hỗ trợ trả góp 0%</span>
                            </div>
                            <div class="item">
                                <i class="fa-solid fa-money-bill"></i>
                                <span>Hoàn tiền 200% nếu hàng giả</span>
                            </div>
                            <div class="item">
                                <i class="fa-solid fa-bolt"></i>
                                <span>Giao hàng nhanh toàn quốc</span>
                            </div>
                            <div class="item">
                                <i class="fa-solid fa-headset"></i>
                                <span>Hỗ trợ kỹ thuật 24/7</span>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <%@ include file="partials/footer.jsp" %>
    </body>
</html>