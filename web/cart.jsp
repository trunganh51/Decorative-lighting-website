<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Map, model.OrderDetail" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng của bạn</title>
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
            input.qty-input {
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
            .continue {
                margin-left:auto;
            }
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
            .checkout-full:disabled {
                background:#ccc;
                cursor:not-allowed;
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
            Map<Integer, OrderDetail> cart = (Map<Integer, OrderDetail>) session.getAttribute("cart");
            double total = 0;
            int totalQty = 0;
            if (cart != null) {
                for (OrderDetail it : cart.values()) {
                    total += it.getSubtotal();
                    totalQty += it.getQuantity();
                }
            }
            request.setAttribute("cartTotal", total);
            request.setAttribute("cartTotalQty", totalQty);
        %>

        <div class="page">
            <div class="layout">
                <!-- LEFT -->
                <div class="left">
                    <h1>🛒 Giỏ hàng của bạn</h1>

                    <c:choose>
                        <c:when test="${empty sessionScope.cart}">
                            <div class="empty">
                                <h3>Giỏ hàng trống</h3>
                                <p>Bạn chưa thêm sản phẩm nào vào giỏ.</p>
                                <br>
                                <a href="${pageContext.request.contextPath}/products?action=list" class="btn primary">
                                    Tiếp tục mua sắm
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <form id="cartForm" method="post" action="${pageContext.request.contextPath}/cart" onsubmit="return false;">
                                <input type="hidden" name="action" value="">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>
                                                <input type="checkbox" id="selectAll" style="transform:scale(1.2); margin-right:4px;">
                                                <label for="selectAll">Chọn tất cả</label>
                                            </th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th>Tổng</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody id="cartBody">
                                        <c:forEach var="item" items="${sessionScope.cart.values()}">
                                            <tr id="item-row-${item.product.id}">
                                                <td style="text-align:left;">
                                                    <div class="product-cell">
                                                        <input type="checkbox" class="item-checkbox"
                                                               value="${item.product.id}" checked
                                                               style="margin-right:8px; transform:scale(1.2);">
                                                        <img src="${pageContext.request.contextPath}/${item.product.imagePath}"
                                                             alt="${item.product.name}" class="product-thumb">
                                                        <div>
                                                            <div class="product-name">${item.product.name}</div>
                                                            <div style="font-size:0.9rem; color:#666;">Mã: ${item.product.id}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="item-price" data-price="${item.product.price}">
                                                    <span class="price-text"><script>document.write(new Intl.NumberFormat('vi-VN').format(${item.product.price}));</script>₫</span>
                                                </td>
                                                <td>
                                                    <div style="display:inline-flex; align-items:center; gap:6px;">
                                                        <button type="button" class="btn ghost qty-btn" data-action="minus"
                                                                data-id="${item.product.id}">−</button>
                                                        <input type="number" name="quantity_${item.product.id}"
                                                               value="${item.quantity}" min="1" class="qty-input"
                                                               data-id="${item.product.id}">
                                                        <button type="button" class="btn ghost qty-btn" data-action="plus"
                                                                data-id="${item.product.id}">+</button>
                                                    </div>
                                                </td>
                                                <td class="item-subtotal" data-id="${item.product.id}">
                                                    <span class="subtotal-text"><script>document.write(new Intl.NumberFormat('vi-VN').format(${item.subtotal}));</script>₫</span>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn danger remove-btn"
                                                            data-id="${item.product.id}">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </form>

                            <div class="promo">
                                <strong>Khuyến mãi áp dụng:</strong><br>
                                - Giảm 4% trên tổng đơn hàng.<br>
                                - Tặng bàn di chuột, miễn phí vận chuyển.<br>
                                - Hỗ trợ đổi trả 1:1.
                            </div>

                            <div style="display:flex; gap:12px; align-items:center; margin-top:12px;">
                                <div class="continue" style="margin-left:auto;">
                                    <a href="${pageContext.request.contextPath}/products?action=list" class="btn ghost">
                                        ⬅ Tiếp tục mua sắm
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- RIGHT -->
                <div class="right">
                    <div class="summary-title">Tóm tắt đơn hàng</div>
                    <div class="summary-row"><span>Tổng số lượng</span><span id="totalQty">${cartTotalQty}</span></div>
                    <div class="summary-row"><span>Tạm tính</span><span id="totalAmount"><script>document.write(new Intl.NumberFormat('vi-VN').format(${cartTotal}));</script>₫</span></div>
                    <div class="summary-row total"><span>Tổng cộng</span><span id="grandTotal"><script>document.write(new Intl.NumberFormat('vi-VN').format(${cartTotal}));</script>₫</span></div>

                    <form action="${pageContext.request.contextPath}/payment" method="post" id="toPaymentForm" style="margin-top: 14px;">
                        <div class="voucher">
                            <label for="voucher">Nhập mã voucher</label>
                            <input type="text" id="voucher" name="couponCode" placeholder="Nhập mã khuyến mãi...">
                        </div>
                        <button type="submit" class="checkout-full" id="checkoutBtn">Tiến hành thanh toán</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function formatVnd(n) {
                return new Intl.NumberFormat('vi-VN').format(n) + '₫';
            }

            document.addEventListener('DOMContentLoaded', () => {
                const contextPath = "${pageContext.request.contextPath}";
                const cartBody = document.getElementById('cartBody');
                const selectAll = document.getElementById('selectAll');
                const checkoutBtn = document.getElementById('checkoutBtn');

                const totalQtyEl = document.getElementById('totalQty');
                const totalAmountEl = document.getElementById('totalAmount');
                const grandTotalEl = document.getElementById('grandTotal');

                function log(...a) {
                    console.debug('[CART]', ...a);
                }

                function getRows() {
                    return Array.from(cartBody.querySelectorAll('tr[id^="item-row-"]'));
                }

                function updateCartTotals() {
                    let totalQty = 0;
                    let totalAmount = 0;
                    getRows().forEach(row => {
                        const checkbox = row.querySelector('.item-checkbox');
                        if (!checkbox || !checkbox.checked)
                            return;
                        const qtyInput = row.querySelector('.qty-input');
                        const priceCell = row.querySelector('.item-price');
                        const price = parseFloat(priceCell.dataset.price);
                        const qty = parseInt(qtyInput.value) || 0;
                        totalQty += qty;
                        totalAmount += price * qty;
                    });
                    totalQtyEl.textContent = totalQty;
                    totalAmountEl.textContent = formatVnd(totalAmount);
                    grandTotalEl.textContent = formatVnd(totalAmount);
                    log('Totals recalculated:', {totalQty, totalAmount});
                }

                function syncSelectAll() {
                    const allChecked = getRows().every(r => {
                        const cb = r.querySelector('.item-checkbox');
                        return cb && cb.checked;
                    });
                    selectAll.checked = allChecked;
                    toggleCheckoutButton();
                }

                function toggleCheckoutButton() {
                    const anyChecked = getRows().some(r => {
                        const cb = r.querySelector('.item-checkbox');
                        return cb && cb.checked;
                    });
                    checkoutBtn.disabled = !anyChecked;
                }

                function updateRowSubtotal(row) {
                    const qtyInput = row.querySelector('.qty-input');
                    const priceCell = row.querySelector('.item-price');
                    const subtotalCell = row.querySelector('.item-subtotal .subtotal-text');
                    const price = parseFloat(priceCell.dataset.price);
                    const qty = parseInt(qtyInput.value) || 1;
                    const subtotal = price * qty;
                    subtotalCell.textContent = formatVnd(subtotal);
                    log('Row subtotal updated', {id: row.id, qty, subtotal});
                }

                // Event delegation cho plus/minus, remove, checkbox, input change
                cartBody.addEventListener('click', async (e) => {
                    const btn = e.target.closest('button');
                    if (!btn)
                        return;

                    // Remove
                    if (btn.classList.contains('remove-btn')) {
                        const id = btn.dataset.id;
                        if (!confirm('Bạn có chắc muốn xóa sản phẩm này?'))
                            return;
                        try {
                            const fd = new URLSearchParams({action: 'remove', productId: id});
                            const res = await fetch(contextPath + '/cart', {
                                method: 'POST',
                                headers: {'X-Requested-With': 'XMLHttpRequest'},
                                body: fd
                            });
                            const data = await res.json().catch(() => ({success: false}));
                            if (data.success) {
                                const row = document.getElementById('item-row-' + id);
                                if (row)
                                    row.remove();
                                updateCartTotals();
                                syncSelectAll();
                            } else {
                                alert(data.message || 'Không thể xóa.');
                            }
                        } catch (err) {
                            console.error(err);
                            alert('Lỗi mạng.');
                        }
                        return;
                    }

                    // Plus / Minus
                    if (btn.classList.contains('qty-btn')) {
                        const id = btn.dataset.id;
                        const row = document.getElementById('item-row-' + id);
                        if (!row) {
                            log('Row not found for id', id);
                            return;
                        }
                        const input = row.querySelector('.qty-input');
                        let val = parseInt(input.value) || 1;
                        if (btn.dataset.action === 'plus')
                            val++;
                        else if (btn.dataset.action === 'minus' && val > 1)
                            val--;
                        input.value = val;
                        updateRowSubtotal(row);
                        updateCartTotals();

                        // Gửi server (async nhưng UI vẫn cập nhật)
                        try {
                            const fd = new URLSearchParams({action: 'update', productId: id, quantity: val});
                            const res = await fetch(contextPath + '/cart', {
                                method: 'POST',
                                headers: {'X-Requested-With': 'XMLHttpRequest'},
                                body: fd
                            });
                            const data = await res.json().catch(() => ({success: false}));
                            if (!data.success) {
                                alert(data.message || 'Cập nhật server thất bại. Giỏ hàng sẽ được đồng bộ lại.');
                                location.reload();
                            }
                        } catch (err) {
                            console.error(err);
                            alert('Lỗi kết nối. Trang sẽ reload để đồng bộ.');
                            location.reload();
                        }
                    }
                });

                cartBody.addEventListener('change', (e) => {
                    const target = e.target;
                    // Checkbox item
                    if (target.classList.contains('item-checkbox')) {
                        syncSelectAll();
                        updateCartTotals();
                    }
                    // Sửa trực tiếp số lượng
                    if (target.classList.contains('qty-input')) {
                        const row = target.closest('tr');
                        if (!row)
                            return;
                        let val = parseInt(target.value) || 1;
                        if (val < 1) {
                            val = 1;
                            target.value = val;
                        }
                        updateRowSubtotal(row);
                        updateCartTotals();

                        const id = target.dataset.id;
                        // Async update server
                        (async () => {
                            try {
                                const fd = new URLSearchParams({action: 'update', productId: id, quantity: val});
                                const res = await fetch(contextPath + '/cart', {
                                    method: 'POST',
                                    headers: {'X-Requested-With': 'XMLHttpRequest'},
                                    body: fd
                                });
                                const data = await res.json().catch(() => ({success: false}));
                                if (!data.success) {
                                    alert(data.message || 'Cập nhật số lượng thất bại.');
                                    location.reload();
                                }
                            } catch (err) {
                                console.error(err);
                                alert('Lỗi cập nhật server.');
                                location.reload();
                            }
                        })();
                    }
                });

                // Chọn tất cả
                selectAll.addEventListener('change', () => {
                    getRows().forEach(r => {
                        const cb = r.querySelector('.item-checkbox');
                        if (cb)
                            cb.checked = selectAll.checked;
                    });
                    toggleCheckoutButton();
                    updateCartTotals();
                });

                // Khởi tạo
                updateCartTotals();
                syncSelectAll();
            });
        </script>

        <%@ include file="partials/footer.jsp" %>
    </body>
</html>