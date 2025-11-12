<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận mua hàng</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{font-family:"Segoe UI",Arial,sans-serif;background:#f5f7fa;color:#333;}
        .page{max-width:1200px;margin:36px auto;padding:0 16px;}
        .content-main-cart{display:flex;gap:28px;align-items:flex-start;}
        .content-left{flex:2;background:#fff;border-radius:10px;padding:22px;box-shadow:0 2px 8px rgba(0,0,0,0.05);}
        .content-right{flex:1;background:#fff;border-radius:10px;padding:22px;box-shadow:0 2px 8px rgba(0,0,0,0.05);position:sticky;top:24px;height:fit-content;}
        h2.title{font-size:1.3rem;margin-bottom:12px;color:#222;border-bottom:1px solid #eee;padding-bottom:8px;}
        label{display:block;font-weight:600;margin-bottom:6px;}
        input,select,textarea{width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;margin-bottom:12px;font-size:0.95rem;}
        textarea{resize:none;}
        .form-control:focus{border-color:#007bff;outline:none;}
        .note-error{color:#d63031;font-size:0.85rem;}
        .button-send-cart{width:100%;background:#007bff;color:#fff;font-weight:700;padding:12px;border:none;border-radius:8px;cursor:pointer;}
        .button-send-cart:hover{background:#0056d2;}
        .background-white{background:#fff;padding:16px;border-radius:10px;margin-bottom:18px;}
        .item-input{width:48%;}
        .content-input-form{display:flex;flex-wrap:wrap;gap:16px;}
        .tax{cursor:pointer;}
        .content-tax{display:none;}
        .content-tax.active{display:flex;flex-wrap:wrap;gap:16px;}
        .box-pay-method .item-radio{margin-right:24px;cursor:pointer;}
        .box-pay-method input[type=radio]{margin-right:8px;}
        .content-info-pay{display:none;padding:8px 0 0 8px;}
        .content-info-pay.active{display:block;}
        .total-price .item{margin-bottom:8px;}
        .vat{font-size:0.85rem;color:#777;}
        .icon-pay img{width:100%;margin-top:16px;}
        .info-policy{margin-top:12px;}
        .info-policy .item{display:flex;align-items:center;gap:8px;font-size:0.9rem;margin-bottom:6px;}
        .info-policy i{color:#007bff;}
        @media(max-width:900px){.content-main-cart{flex-direction:column;}.content-right{position:relative;top:auto;}}
    </style>
    <script>
        function showPay(){
            document.getElementById("text_pay_1").classList.remove("active");
            document.getElementById("text_pay_2").classList.remove("active");
            document.getElementById("text_pay_"+this.value).classList.add("active");
        }
        function toggleTax(){
            document.getElementById("js-tax-group").classList.toggle("active");
        }
        function check_field(){
            let name=document.getElementById('buyer_name').value.trim();
            let phone=document.getElementById('buyer_tel').value.trim();
            let addr=document.getElementById('buyer_address').value.trim();
            if(!name||!phone||!addr){
                alert("Vui lòng nhập đầy đủ thông tin giao hàng!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<%@ include file="partials/header.jsp" %>

<div class="page">
    <form method="post" onsubmit="return check_field()" action="${pageContext.request.contextPath}/order-confirmed" class="content-main-cart">
        <!-- LEFT -->
        <div class="content-left">
            <div class="background-white">
                <div class="title d-flex align-items space-between">
                    <h2>Thông tin giao hàng</h2>
                </div>

                <div class="content-input-form">
                    <div class="item-input">
                        <label>Họ và tên người nhận<span>*</span></label>
                        <input type="text" id="buyer_name" name="buyer_name" placeholder="Nhập họ tên người nhận">
                    </div>

                    <div class="item-input">
                        <label>Số điện thoại<span>*</span></label>
                        <input type="text" id="buyer_tel" name="buyer_tel" placeholder="Số điện thoại liên lạc">
                    </div>

                    <div class="item-input" style="width:100%">
                        <label>Tỉnh/thành phố<span>*</span></label>
                        <select name="buyer_province" class="form-control">
                            <option value="">Chọn tỉnh/thành phố</option>
                            <option>Hà Nội</option>
                            <option>TP HCM</option>
                            <option>Đà Nẵng</option>
                            <option>Cần Thơ</option>
                            <option>Hải Phòng</option>
                        </select>
                    </div>

                    <div class="item-input" style="width:100%">
                        <label>Địa chỉ<span>*</span></label>
                        <textarea id="buyer_address" name="buyer_address" rows="3" placeholder="Nhập địa chỉ giao hàng"></textarea>
                    </div>

                    <div class="form-group" style="width:100%;padding-bottom:16px;" onclick="toggleTax()">
                        <label class="d-flex align-items tax">
                            <input type="checkbox" style="margin-right:8px;width:18px;height:18px;"> Xuất hóa đơn công ty
                        </label>
                    </div>

                    <div id="js-tax-group" class="content-tax">
                        <div class="item-input">
                            <label>Tên công ty</label>
                            <input type="text" id="txtTaxName" name="tax_name" placeholder="Nhập tên công ty">
                        </div>
                        <div class="item-input">
                            <label>Địa chỉ công ty</label>
                            <input type="text" id="txtTaxAddress" name="tax_address" placeholder="Nhập địa chỉ công ty">
                        </div>
                        <div class="item-input">
                            <label>Mã số thuế</label>
                            <input type="text" id="txtTaxCode" name="tax_code" placeholder="Nhập mã số thuế">
                        </div>
                        <div class="item-input">
                            <label>Email công ty</label>
                            <input type="email" id="txtTaxEmail" name="tax_email" placeholder="Nhập email công ty">
                        </div>
                    </div>
                </div>

                <div class="box-pay-method" style="margin-top:18px;">
                    <h2 class="title">Hình thức thanh toán</h2>
                    <div class="content-select-radio d-flex align-items">
                        <label class="item-radio d-flex align-items">
                            <input type="radio" id="pay_method_1" name="pay_method" value="1" checked onclick="showPay.call(this)">
                            <span>Thanh toán bằng chuyển khoản</span>
                        </label>
                        <label class="item-radio d-flex align-items">
                            <input type="radio" id="pay_method_2" name="pay_method" value="2" onclick="showPay.call(this)">
                            <span>Thanh toán khi nhận hàng</span>
                        </label>
                    </div>
                    <div class="content-info-pay active" id="text_pay_1">
                        <div class="item">
                            <b>Ngân hàng MB Bank - Chi nhánh Tràng An - PGD Láng Thượng</b>
                            <p>Số TK: 282468888</p>
                            <p>Tên TK: CT TNHH TM & Tin Học Từ Nguyệt</p>
                        </div>
                    </div>
                    <div class="content-info-pay" id="text_pay_2">
                        <p>Thanh toán khi nhận hàng (COD).</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT -->
        <div class="content-right">
            <div class="ground-info-product background-white">
                <h2 class="title">Thông tin giỏ hàng</h2>

                <div class="content-product">
                    <c:forEach var="item" items="${sessionScope.cart.values()}">
                        <div class="item-product" style="display:flex;gap:12px;margin-bottom:10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/no-image.png" alt="thumb" style="width:64px;height:64px;object-fit:cover;border-radius:6px;">
                            <div class="info" style="flex:1;">
                                <div class="name">${item.product.name}</div>
                                <div class="d-flex align-items space-between" style="margin-top:6px;display:flex;justify-content:space-between;">
                                    <b>x${item.quantity}</b>
                                    <div class="price">${item.subtotal}₫</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="total-price" style="margin-top:12px;">
                    <div class="item d-flex space-between">
                        <b>Tổng sản phẩm</b>
                        <b><c:out value="${fn:length(sessionScope.cart)}"/></b>
                    </div>
                    <div class="item d-flex space-between">
                        <b>Tổng chi phí</b>
                        <div>${cartTotal}₫</div>
                    </div>
                    <span class="vat">Đã bao gồm VAT (nếu có)</span>
                </div>

                <div class="btn" style="margin-top:18px;">
                    <button type="submit" class="button-send-cart">Xác nhận mua hàng</button>
                </div>

                <div class="icon-pay"><img src="${pageContext.request.contextPath}/assets/images/pay_cart.png" alt="pay"></div>

                <div class="info-policy">
                    <div class="item"><i class="fa-solid fa-credit-card"></i> Hỗ trợ trả góp 0%</div>
                    <div class="item"><i class="fa-solid fa-money-bill"></i> Hoàn tiền 200% nếu hàng giả</div>
                    <div class="item"><i class="fa-solid fa-bolt"></i> Giao hàng nhanh toàn quốc</div>
                    <div class="item"><i class="fa-solid fa-headset"></i> Hỗ trợ kỹ thuật 24/7</div>
                </div>
            </div>
        </div>
    </form>
</div>

<%@ include file="partials/footer.jsp" %>
</body>
</html>
