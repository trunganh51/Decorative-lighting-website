<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<meta charset="UTF-8">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<header class="main-header" id="main-header">
    <div class="header-inner">
        <!-- Logo -->
        <div class="header-left">
            <a class="logo" href="${pageContext.request.contextPath}/products?action=list">
                <i class="fas fa-lightbulb"></i>
                <span>WEB BÁN ĐÈN TRANG TRÍ</span>
            </a>
        </div>

        <!-- Search -->
        <div class="header-center">
            <form method="get" action="${pageContext.request.contextPath}/products" class="search-form" autocomplete="off" accept-charset="UTF-8">
                <input type="hidden" name="action" value="search"/>
                <input type="text" name="keyword" class="search-input"
                       placeholder="Tìm sản phẩm, đèn led, đèn trang trí..." 
                       value="${fn:escapeXml(param.keyword != null ? param.keyword : '')}" 
                       maxlength="100" />
                <button type="submit" class="search-btn"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <!-- Account + Cart -->
        <div class="header-right">
            <!-- Account -->
            <div class="dropdown account-dropdown">
                <button class="dropdown-toggle" type="button">
                    <i class="fas fa-user"></i>
                    <c:if test="${not empty sessionScope.user}">
                        <span class="hello">Xin chào, ${fn:substring(sessionScope.user.fullName, 0, 15)}<c:if test="${fn:length(sessionScope.user.fullName) > 15}">...</c:if></span>
                    </c:if>
                </button>
                <div class="dropdown-menu account-menu">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/orders?action=list">
                                <i class="fas fa-box"></i> Đơn hàng của tôi
                            </a>
                            <a href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user-edit"></i> Thông tin cá nhân
                            </a>
                            <a href="${pageContext.request.contextPath}/auth?action=logout">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth?action=login">
                                <i class="fas fa-right-to-bracket"></i> Đăng nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/auth?action=register">
                                <i class="fas fa-user-plus"></i> Đăng ký
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Cart -->
            <div class="dropdown cart-dropdown">
                <button class="dropdown-toggle" type="button">
                    <i class="fas fa-shopping-cart"></i>
                    <span class="cart-count">${sessionScope.cartSize != null ? sessionScope.cartSize : 0}</span>
                </button>
                <div class="dropdown-menu cart-menu">
                    <div class="cart-header">
                        <h4><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h4>
                    </div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.cart}">
                            <div class="cart-items">
                                <c:forEach var="entry" items="${sessionScope.cart}">
                                    <c:set var="item" value="${entry.value}" />
                                    <div class="cart-item">
                                        <img src="${pageContext.request.contextPath}/${item.product.imagePath}" alt="${item.product.name}" />
                                        <div class="cart-info">
                                            <div class="name">${item.product.name}</div>
                                            <div class="price">${item.product.price}₫ × ${item.quantity}</div>
                                            <div class="subtotal">Tổng: ${item.subtotal}₫</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="cart-total">
                                <span>Tổng cộng:</span>
                                <strong>
                                    <c:set var="sum" value="0"/>
                                    <c:forEach var="entry" items="${sessionScope.cart}">
                                        <c:set var="sum" value="${sum + entry.value.subtotal}"/>
                                    </c:forEach>
                                    ${sum}₫
                                </strong>
                            </div>
                            <div class="cart-actions">
                                <a href="${pageContext.request.contextPath}/cart" class="btn-view-cart">
                                    <i class="fas fa-eye"></i> Xem giỏ hàng
                                </a>
                                <a href="${pageContext.request.contextPath}/payment" class="btn-checkout">
                                    <i class="fas fa-credit-card"></i> Thanh toán
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-cart">
                                <i class="fas fa-shopping-cart"></i>
                                <p>Giỏ hàng trống</p>
                                <a href="${pageContext.request.contextPath}/products?action=list" class="btn-shopping">
                                    Tiếp tục mua sắm
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="main-nav">
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/products?action=list">TRANG CHỦ</a></li>
            <li><a href="${pageContext.request.contextPath}/about.jsp">GIỚI THIỆU</a></li>

            <li class="dropdown nav-dropdown">
                <a href="#">CHIẾU SÁNG TRONG NHÀ <i class="fas fa-caret-down"></i></a>
                <ul class="sub-menu">
                    <c:forEach var="c" items="${categories}">
                        <c:if test="${c.parentId == 1}">
                            <li><a href="${pageContext.request.contextPath}/products?action=list&category=${c.categoryId}">${c.name}</a></li>
                            </c:if>
                        </c:forEach>
                </ul>
            </li>

            <li class="dropdown nav-dropdown">
                <a href="#">CHIẾU SÁNG NGOÀI TRỜI <i class="fas fa-caret-down"></i></a>
                <ul class="sub-menu">
                    <c:forEach var="c" items="${categories}">
                        <c:if test="${c.parentId == 2}">
                            <li><a href="${pageContext.request.contextPath}/products?action=list&category=${c.categoryId}">${c.name}</a></li>
                            </c:if>
                        </c:forEach>
                </ul>
            </li>

            <li><a href="${pageContext.request.contextPath}/contact.jsp">LIÊN HỆ</a></li>
        </ul>
    </nav>
</header>

<style>
    /* ===== ROOT VARIABLES ===== */
    :root {
        --primary: #007bff;
        --primary-dark: #0056b3;
        --secondary: #6c757d;
        --success: #28a745;
        --warning: #ffc107;
        --danger: #dc3545;
        --light: #f8f9fa;
        --dark: #343a40;
        --white: #ffffff;
        --border-color: #e6e6e6;
        --shadow-light: 0 2px 8px rgba(0,0,0,0.08);
        --shadow-medium: 0 4px 12px rgba(0,0,0,0.15);
        --shadow-heavy: 0 8px 24px rgba(0,0,0,0.2);
        --transition: all 0.3s ease;
        --border-radius: 8px;
    }

    /* ===== MAIN HEADER ===== */
    .main-header {
        position: sticky;
        top: 0;
        background: var(--white);
        z-index: 9999;
        box-shadow: var(--shadow-light);
        font-family: "Segoe UI", "Roboto", "Helvetica", Arial, sans-serif;
        border-bottom: 1px solid var(--border-color);
    }

    .header-inner {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px 32px;
        gap: 24px;
        max-width: 1400px;
        margin: 0 auto;
    }

    /* ===== LOGO ===== */
    .logo {
        font-weight: 700;
        color: var(--primary);
        text-decoration: none;
        font-size: 18px;
        display: flex;
        align-items: center;
        gap: 10px;
        transition: var(--transition);
        white-space: nowrap;
        flex-shrink: 0;
    }

    .logo:hover {
        color: var(--primary-dark);
        transform: scale(1.02);
    }

    .logo i {
        font-size: 24px;
        color: var(--warning);
    }

    /* ===== SEARCH FORM ===== */
    .header-center {
        flex: 1;
        display: flex;
        justify-content: center;
        max-width: 600px;
        margin: 0 20px;
    }

    .search-form {
        display: flex;
        width: 100%;
        max-width: 580px;
        border: 2px solid var(--border-color);
        border-radius: 30px;
        background: var(--white);
        overflow: hidden;
        box-shadow: var(--shadow-light);
        transition: var(--transition);
    }

    .search-form:focus-within {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(0,123,255,0.1), var(--shadow-medium);
        transform: translateY(-1px);
    }

    /* ===== ✅ ENHANCED VIETNAMESE INPUT FIELD ===== */
    .search-input {
        flex: 1;
        padding: 14px 20px;
        border: none;
        outline: none;
        font-size: 15px;
        font-family: 'Segoe UI', 'Roboto', 'Arial', 'Liberation Sans', 'DejaVu Sans', 'Noto Sans', sans-serif !important;
        font-weight: 400 !important;
        color: #333 !important;
        background-color: #fff !important;
        caret-color: var(--primary) !important;
        line-height: 1.4 !important;
        letter-spacing: 0.01em !important;
        word-spacing: normal !important;
        text-rendering: optimizeLegibility !important;
        -webkit-font-smoothing: antialiased !important;
        -moz-osx-font-smoothing: grayscale !important;
        /* Enhanced Unicode support for Vietnamese */
        unicode-bidi: normal !important;
        direction: ltr !important;
        writing-mode: horizontal-tb !important;
        text-decoration: none !important;
        text-transform: none !important;
    }

    .search-input::placeholder {
        color: #999 !important;
        font-style: italic;
        opacity: 0.7;
        font-family: inherit !important;
    }

    /* Enhanced focus state for Vietnamese input */
    .search-input:focus {
        font-family: 'Segoe UI', 'Roboto', 'Noto Sans', 'Liberation Sans', 'Arial Unicode MS', sans-serif !important;
        box-shadow: none !important;
    }

    /* Better text selection for Vietnamese */
    .search-input::selection {
        background-color: rgba(0,123,255,0.25);
        color: inherit;
    }

    /* Fix for composition events (Vietnamese input methods) */
    .search-input[data-composing="true"] {
        background-color: #fffacd !important;
        border-bottom: 2px solid var(--primary) !important;
    }

    .search-btn {
        background: var(--primary);
        color: var(--white);
        border: 0;
        width: 56px;
        height: 56px;
        cursor: pointer;
        border-radius: 0;
        transition: var(--transition);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }

    .search-btn:hover {
        background: var(--primary-dark);
        transform: scale(1.05);
    }

    .search-btn i {
        font-size: 16px;
    }

    /* ===== HEADER RIGHT ===== */
    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
        min-width: 200px;
        justify-content: flex-end;
        flex-shrink: 0;
    }

    /* ===== DROPDOWN BASE ===== */
    .dropdown {
        position: relative;
    }

    .dropdown-toggle {
        background: none;
        border: 0;
        font-size: 16px;
        cursor: pointer;
        color: var(--dark);
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 10px 12px;
        border-radius: var(--border-radius);
        transition: var(--transition);
        white-space: nowrap;
        max-width: 200px;
    }

    .dropdown-toggle:hover {
        background: var(--light);
        color: var(--primary);
    }

    /* ===== ✅ FIXED GREETING TEXT WIDTH ===== */
    .dropdown-toggle .hello {
        font-size: 12px;
        color: var(--primary);
        font-weight: 600;
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        display: inline-block;
    }

    /* ===== CART COUNT ===== */
    .cart-count {
        background: var(--danger);
        color: var(--white);
        font-size: 11px;
        font-weight: 700;
        padding: 3px 7px;
        border-radius: 12px;
        position: absolute;
        top: -6px;
        right: -8px;
        min-width: 18px;
        text-align: center;
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.1);
        }
    }

    /* ===== DROPDOWN MENU ===== */
    .dropdown-menu {
        display: none;
        position: absolute;
        top: calc(100% + 8px);
        right: 0;
        background: var(--white);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow-heavy);
        min-width: 280px;
        overflow: hidden;
        animation: fadeDown 0.3s ease;
        border: 1px solid var(--border-color);
        z-index: 1000;
    }

    @keyframes fadeDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .dropdown:hover .dropdown-menu {
        display: block;
    }

    .dropdown-menu:hover {
        display: block;
    }

    /* ===== ACCOUNT MENU ===== */
    .account-menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 16px;
        color: var(--dark);
        text-decoration: none;
        transition: var(--transition);
        border-bottom: 1px solid #f0f0f0;
    }

    .account-menu a:last-child {
        border-bottom: none;
    }

    .account-menu a:hover {
        background: #f8f9ff;
        color: var(--primary);
        padding-left: 20px;
    }

    .account-menu a i {
        width: 16px;
        color: var(--primary);
    }

    /* ===== CART MENU ===== */
    .cart-menu {
        width: 360px;
        max-height: 480px;
        overflow-y: auto;
        padding: 0;
    }

    .cart-header {
        background: var(--primary);
        color: var(--white);
        padding: 12px 16px;
        border-bottom: 1px solid var(--border-color);
    }

    .cart-header h4 {
        margin: 0;
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .cart-items {
        max-height: 300px;
        overflow-y: auto;
    }

    .cart-item {
        display: flex;
        gap: 12px;
        align-items: flex-start;
        padding: 12px 16px;
        border-bottom: 1px solid #f0f0f0;
        transition: var(--transition);
    }

    .cart-item:hover {
        background: #f8f9fa;
    }

    .cart-item img {
        width: 64px;
        height: 64px;
        border-radius: 6px;
        object-fit: cover;
        border: 1px solid var(--border-color);
        flex-shrink: 0;
    }

    .cart-info {
        flex: 1;
        min-width: 0;
    }

    .cart-info .name {
        font-size: 14px;
        font-weight: 600;
        color: var(--dark);
        margin-bottom: 4px;
        line-height: 1.3;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .cart-info .price {
        font-size: 13px;
        color: var(--secondary);
        margin-bottom: 2px;
    }

    .cart-info .subtotal {
        font-size: 13px;
        font-weight: 600;
        color: var(--primary);
    }

    .cart-total {
        padding: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 700;
        border-top: 2px solid var(--border-color);
        background: #f8f9fa;
        font-size: 16px;
    }

    .cart-total strong {
        color: var(--primary);
        font-size: 18px;
    }

    .cart-actions {
        display: flex;
        gap: 8px;
        padding: 12px 16px;
        background: #f8f9fa;
    }

    .btn-view-cart, .btn-checkout {
        flex: 1;
        text-align: center;
        padding: 10px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
        transition: var(--transition);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
    }

    .btn-view-cart {
        background: var(--light);
        color: var(--dark);
        border: 1px solid var(--border-color);
    }

    .btn-view-cart:hover {
        background: var(--white);
        border-color: var(--primary);
        color: var(--primary);
    }

    .btn-checkout {
        background: var(--primary);
        color: var(--white);
    }

    .btn-checkout:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
    }

    /* ===== EMPTY CART ===== */
    .empty-cart {
        text-align: center;
        padding: 40px 20px;
        color: var(--secondary);
    }

    .empty-cart i {
        font-size: 48px;
        margin-bottom: 16px;
        color: var(--border-color);
    }

    .empty-cart p {
        margin: 0 0 16px;
        font-size: 16px;
    }

    .btn-shopping {
        background: var(--primary);
        color: var(--white);
        padding: 10px 20px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 600;
        transition: var(--transition);
    }

    .btn-shopping:hover {
        background: var(--primary-dark);
    }

    /* ===== NAVIGATION ===== */
    .main-nav {
        background: var(--primary);
        border-top: 1px solid var(--primary-dark);
    }

    .menu {
        display: flex;
        list-style: none;
        justify-content: center;
        margin: 0;
        padding: 0;
        gap: 0;
        max-width: 1400px;
        margin: 0 auto;
    }

    .menu li {
        position: relative;
    }

    .menu > li > a {
        color: var(--white);
        text-decoration: none;
        font-weight: 600;
        padding: 16px 24px;
        display: block;
        transition: var(--transition);
        font-size: 14px;
        letter-spacing: 0.5px;
    }

    .menu > li > a:hover,
    .menu > li:hover > a {
        background: var(--primary-dark);
        color: var(--warning);
    }

    /* ===== SUB MENU ===== */
    .sub-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background: var(--white);
        border-radius: 0 0 var(--border-radius) var(--border-radius);
        box-shadow: var(--shadow-medium);
        min-width: 220px;
        list-style: none;
        padding: 8px 0;
        margin: 0;
        border: 1px solid var(--border-color);
        z-index: 1000;
    }

    .nav-dropdown:hover .sub-menu {
        display: block;
    }

    .sub-menu li a {
        display: block;
        padding: 12px 20px;
        color: var(--dark);
        text-decoration: none;
        transition: var(--transition);
        font-weight: 500;
    }

    .sub-menu li a:hover {
        background: #f8f9ff;
        color: var(--primary);
        padding-left: 24px;
    }

    /* ===== ✅ ENHANCED RESPONSIVE DESIGN ===== */
    @media (max-width: 1024px) {
        .header-inner {
            padding: 12px 20px;
            gap: 16px;
        }

        .logo span {
            font-size: 16px;
        }

        .search-form {
            max-width: 400px;
        }

        .header-right {
            min-width: 160px;
        }
    }

    @media (max-width: 768px) {
        .header-inner {
            padding: 12px 16px;
            gap: 12px;
        }

        .logo span {
            font-size: 14px;
        }

        .search-form {
            max-width: 300px;
        }

        .dropdown-toggle .hello {
            display: none;
        }

        .cart-menu {
            width: 320px;
        }

        .menu {
            flex-wrap: wrap;
            justify-content: center;
        }

        .menu > li > a {
            padding: 12px 16px;
            font-size: 13px;
        }
    }

    @media (max-width: 640px) {
        .header-inner {
            flex-direction: column;
            gap: 12px;
            padding: 12px;
        }

        .header-center {
            order: 2;
            width: 100%;
            margin: 0;
        }

        .search-form {
            max-width: 100%;
        }

        .header-right {
            order: 1;
            justify-content: center;
            min-width: auto;
        }

        .logo {
            justify-content: center;
        }

        .cart-menu {
            width: 300px;
            right: -50px;
        }

        .account-menu {
            right: -50px;
        }
    }

    @media (max-width: 480px) {
        .dropdown-menu {
            min-width: 250px;
        }

        .cart-menu {
            width: 280px;
            right: -80px;
        }

        .account-menu {
            min-width: 200px;
            right: -80px;
        }
    }
</style>

<script>
    /* ✅ ENHANCED VIETNAMESE SEARCH & HEADER FUNCTIONALITY */
    document.addEventListener('DOMContentLoaded', function () {
        const header = document.getElementById('main-header');

        // Dynamic shadow on scroll
        window.addEventListener('scroll', function () {
            if (window.scrollY > 20) {
                header.style.boxShadow = '0 8px 32px rgba(0,0,0,0.12)';
            } else {
                header.style.boxShadow = '0 2px 8px rgba(0,0,0,0.08)';
            }
        });

        // Enhanced dropdown functionality for touch devices
        const isTouch = ('ontouchstart' in window) || navigator.maxTouchPoints > 0;

        if (isTouch) {
            document.querySelectorAll('.dropdown').forEach(dropdown => {
                const toggle = dropdown.querySelector('.dropdown-toggle');
                const menu = dropdown.querySelector('.dropdown-menu');

                if (!toggle || !menu)
                    return;

                toggle.addEventListener('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    document.querySelectorAll('.dropdown .dropdown-menu').forEach(m => {
                        if (m !== menu)
                            m.style.display = 'none';
                    });

                    const isOpen = menu.style.display === 'block';
                    menu.style.display = isOpen ? 'none' : 'block';
                });
            });

            document.addEventListener('click', function () {
                document.querySelectorAll('.dropdown .dropdown-menu').forEach(menu => {
                    menu.style.display = 'none';
                });
            });
        } else {
            document.querySelectorAll('.dropdown').forEach(dropdown => {
                const menu = dropdown.querySelector('.dropdown-menu');
                if (!menu)
                    return;

                let hoverTimeout;

                dropdown.addEventListener('mouseenter', function () {
                    clearTimeout(hoverTimeout);
                    menu.style.display = 'block';
                });

                dropdown.addEventListener('mouseleave', function () {
                    hoverTimeout = setTimeout(() => {
                        menu.style.display = 'none';
                    }, 100);
                });
            });
        }

        // ===== ✅ ENHANCED VIETNAMESE SEARCH FUNCTIONALITY =====
        const searchForm = document.querySelector('.search-form');
        const searchInput = document.querySelector('.search-input');

        if (searchForm && searchInput) {
            let isSubmitting = false;
            let composing = false;

            // Enhanced Vietnamese character validation and normalization
            function normalizeVietnamese(text) {
                if (!text)
                    return text;

                // Normalize Unicode (NFD -> NFC)
                text = text.normalize('NFC');

                // Remove invalid characters but keep Vietnamese
                text = text.replace(/[^\u0000-\u007F\u0080-\u00FF\u0100-\u017F\u1E00-\u1EFF\u0102\u0103\u0110\u0111\u0128\u0129\u0168\u0169\u01A0\u01A1\u01AF\u01B0\u1EA0-\u1EF9\s\-_.]/g, '');

                // Clean up whitespace
                text = text.replace(/\s+/g, ' ').trim();

                return text;
            }

            // Handle Vietnamese input composition
            searchInput.addEventListener('compositionstart', function () {
                composing = true;
                this.setAttribute('data-composing', 'true');
                console.log('Vietnamese composition started');
            });

            searchInput.addEventListener('compositionupdate', function (e) {
                console.log('Vietnamese composition update:', e.data);
            });

            searchInput.addEventListener('compositionend', function (e) {
                composing = false;
                this.removeAttribute('data-composing');
                console.log('Vietnamese composition ended:', e.data);

                // Normalize the final input
                setTimeout(() => {
                    const normalized = normalizeVietnamese(this.value);
                    if (normalized !== this.value) {
                        const cursorPos = this.selectionStart;
                        this.value = normalized;
                        this.setSelectionRange(cursorPos, cursorPos);
                    }
                }, 0);
            });

            // Enhanced input validation (only when not composing)
            searchInput.addEventListener('input', function (e) {
                if (composing)
                    return; // Don't interfere with composition

                const originalValue = this.value;
                const normalizedValue = normalizeVietnamese(originalValue);

                if (normalizedValue !== originalValue) {
                    const cursorPos = this.selectionStart;
                    this.value = normalizedValue;

                    // Restore cursor position
                    const offset = originalValue.length - normalizedValue.length;
                    this.setSelectionRange(Math.max(0, cursorPos - offset), Math.max(0, cursorPos - offset));
                }

                console.log('Vietnamese input processed:', this.value);
            });

            // Enhanced form submission with Vietnamese support
            searchForm.addEventListener('submit', function (e) {
                if (isSubmitting || composing) {
                    e.preventDefault();
                    return false;
                }

                const keyword = normalizeVietnamese(searchInput.value);

                if (!keyword) {
                    e.preventDefault();
                    searchInput.focus();
                    return false;
                }

                // Final validation and encoding
                console.log('Submitting Vietnamese search:', keyword);
                searchInput.value = keyword;

                isSubmitting = true;
                setTimeout(() => {
                    isSubmitting = false;
                }, 1000);

                return true;
            });

            // Force proper font rendering for Vietnamese
            searchInput.addEventListener('focus', function () {
                this.style.fontFamily = "'Segoe UI', 'Roboto', 'Noto Sans', 'Liberation Sans', 'Arial Unicode MS', sans-serif";
            });

            searchInput.addEventListener('blur', function () {
                // Final normalization on blur
                const normalized = normalizeVietnamese(this.value);
                if (normalized !== this.value) {
                    this.value = normalized;
                }
            });

            // Handle paste events
            searchInput.addEventListener('paste', function (e) {
                setTimeout(() => {
                    const normalized = normalizeVietnamese(this.value);
                    if (normalized !== this.value) {
                        this.value = normalized;
                    }
                }, 0);
            });
        }

        // ===== CART COUNT UPDATE FUNCTIONALITY =====
        function updateCartBadge(count) {
            const cartBadge = document.querySelector('.cart-count');
            if (cartBadge) {
                cartBadge.textContent = count;
                cartBadge.style.animation = 'pulse 0.6s ease';
                setTimeout(() => {
                    cartBadge.style.animation = '';
                }, 600);
            }
        }

        // Expose function globally for use by other scripts
        window.updateCartBadge = updateCartBadge;
    });

// ===== UTILITY FUNCTIONS FOR VIETNAMESE TEXT =====
    window.VietnameseUtils = {
        // Test if string contains Vietnamese characters
        isVietnamese: function (text) {
            const vietnamesePattern = /[\u00C0-\u00FF\u0100-\u017F\u1E00-\u1EFF\u0102\u0103\u0110\u0111\u0128\u0129\u0168\u0169\u01A0\u01A1\u01AF\u01B0\u1EA0-\u1EF9]/;
            return vietnamesePattern.test(text);
        },

        // Clean Vietnamese text for search
        cleanForSearch: function (text) {
            if (!text)
                return '';
            return text.normalize('NFC')
                    .replace(/[^\w\s\u00C0-\u00FF\u0100-\u017F\u1E00-\u1EFF\u0102\u0103\u0110\u0111\u0128\u0129\u0168\u0169\u01A0\u01A1\u01AF\u01B0\u1EA0-\u1EF9\-_.]/g, '')
                    .replace(/\s+/g, ' ')
                    .trim();
        },

        // Validate Vietnamese input
        validate: function (text) {
            const cleaned = this.cleanForSearch(text);
            return {
                isValid: cleaned.length > 0,
                cleaned: cleaned,
                hasVietnamese: this.isVietnamese(cleaned)
            };
        }
    };
</script>