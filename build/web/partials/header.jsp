<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<meta charset="UTF-8">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<button id="backToTop" aria-label="Lên đầu trang">
    <i class="fas fa-arrow-up"></i>
</button>

<header class="main-header" id="main-header">
    <div class="header-inner">
        <!-- Logo -->
        <div class="header-left">
            <a class="logo" href="${pageContext.request.contextPath}/products?action=list" aria-label="Trang chủ">
                <i class="fas fa-lightbulb" aria-hidden="true"></i>
                <span class="logo-text">WEB BÁN ĐÈN TRANG TRÍ</span>
            </a>
        </div>

        <!-- Search -->
        <div class="header-center">
            <form method="get" action="${pageContext.request.contextPath}/products" class="search-form"
                  autocomplete="off" accept-charset="UTF-8" role="search" aria-label="Tìm kiếm sản phẩm">
                <input type="hidden" name="action" value="search"/>
                <input
                    type="text"
                    name="keyword"
                    class="search-input"
                    placeholder="Tìm sản phẩm, đèn led, đèn trang trí..."
                    aria-label="Từ khóa tìm kiếm"
                    value="${fn:escapeXml(param.keyword != null ? param.keyword : '')}"
                    maxlength="100" />
                <button type="submit" class="search-btn" aria-label="Tìm kiếm">
                    <i class="fas fa-search" aria-hidden="true"></i>
                </button>
            </form>
        </div>

        <!-- Account + Cart + Notifications + Messages -->
        <div class="header-right">
            <!-- Account -->
            <div class="dropdown account-dropdown">
                <button class="dropdown-toggle" type="button" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-user" aria-hidden="true"></i>
                    <c:if test="${not empty sessionScope.user}">
                        <span class="hello">
                            Xin chào,
                            ${fn:substring(sessionScope.user.fullName, 0, 15)}
                            <c:if test="${fn:length(sessionScope.user.fullName) > 15}">...</c:if>
                            </span>
                    </c:if>
                </button>
                <div class="dropdown-menu account-menu" role="menu" aria-label="Tài khoản">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/orders?action=list">
                                <i class="fas fa-box" aria-hidden="true"></i> Đơn hàng của tôi
                            </a>
                            <a href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user-edit" aria-hidden="true"></i> Thông tin cá nhân
                            </a>
                            <a href="${pageContext.request.contextPath}/auth?action=logout">
                                <i class="fas fa-sign-out-alt" aria-hidden="true"></i> Đăng xuất
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth?action=login">
                                <i class="fas fa-right-to-bracket" aria-hidden="true"></i> Đăng nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/auth?action=register">
                                <i class="fas fa-user-plus" aria-hidden="true"></i> Đăng ký
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Cart -->
            <div class="dropdown cart-dropdown">
                <button class="dropdown-toggle" type="button" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-shopping-cart" aria-hidden="true"></i>
                    <span class="cart-count" aria-label="Số lượng sản phẩm trong giỏ">
                        ${sessionScope.cartSize != null ? sessionScope.cartSize : 0}
                    </span>
                </button>
                <div class="dropdown-menu cart-menu" role="menu" aria-label="Giỏ hàng">
                    <div class="cart-header">
                        <h4><i class="fas fa-shopping-cart" aria-hidden="true"></i> Giỏ hàng của bạn</h4>
                    </div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.cart}">
                            <div class="cart-items">
                                <c:forEach var="entry" items="${sessionScope.cart}">
                                    <c:set var="item" value="${entry.value}" />
                                    <div class="cart-item" data-id="${item.product.id}">
                                        <img src="${pageContext.request.contextPath}/${item.product.imagePath}" alt="${item.product.name}" loading="lazy" />
                                        <div class="cart-info">
                                            <div class="name">${item.product.name}</div>
                                            <div class="price">
                                                <fmt:formatNumber value="${item.product.price}" type="number"/>₫
                                            </div>
                                            <div class="quantity-controls" aria-label="Điều chỉnh số lượng">
                                                <button class="qty-btn decrease-btn" onclick="updateCartItem(${item.product.id}, -1)" aria-label="Giảm số lượng">-</button>
                                                <span class="quantity" aria-live="polite">${item.quantity}</span>
                                                <button class="qty-btn increase-btn" onclick="updateCartItem(${item.product.id}, 1)" aria-label="Tăng số lượng">+</button>
                                                <button class="qty-btn remove-btn" onclick="removeCartItem(${item.product.id}, this)" aria-label="Xóa sản phẩm">x</button>
                                            </div>
                                            <div class="subtotal">Tổng: <fmt:formatNumber value="${item.subtotal}" type="number"/>₫</div>
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
                                    <fmt:formatNumber value="${sum}" type="number"/>₫
                                </strong>
                            </div>
                            <div class="cart-actions">
                                <a href="${pageContext.request.contextPath}/cart" class="btn-view-cart">
                                    <i class="fas fa-eye" aria-hidden="true"></i> Xem giỏ hàng
                                </a>
                                <a href="${pageContext.request.contextPath}/payment" class="btn-checkout">
                                    <i class="fas fa-credit-card" aria-hidden="true"></i> Thanh toán
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-cart">
                                <i class="fas fa-shopping-cart" aria-hidden="true"></i>
                                <p>Giỏ hàng trống</p>
                                <a href="${pageContext.request.contextPath}/products?action=list" class="btn-shopping">
                                    Tiếp tục mua sắm
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Notifications -->
            <div class="dropdown notifications-dropdown">
                <button class="dropdown-toggle" type="button" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-bell" aria-hidden="true"></i>
                    <span class="notification-count" aria-label="Số thông báo chưa đọc">
                        <c:choose>
                            <c:when test="${not empty sessionScope.notifications}">
                                <c:set var="unreadCount" value="0"/>
                                <c:forEach var="n" items="${sessionScope.notifications}">
                                    <c:if test="${!n.read}">
                                        <c:set var="unreadCount" value="${unreadCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${unreadCount}
                            </c:when>
                            <c:otherwise>3</c:otherwise>
                        </c:choose>
                    </span>
                </button>
                <div class="dropdown-menu notifications-menu" role="menu" aria-label="Thông báo">
                    <div class="dropdown-header">
                        <span>Thông báo</span>
                        <button class="mark-read-btn" type="button">Đánh dấu đã đọc</button>
                    </div>
                    <div class="notifications-list">
                        <c:if test="${not empty sessionScope.notifications}">
                            <c:forEach var="n" items="${sessionScope.notifications}">
                                <div class="notification-item ${!n.read ? 'unread' : ''}">
                                    <p>${n.content}</p>
                                    <span class="time">${n.time}</span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty sessionScope.notifications}">
                            <div class="notification-item unread">
                                <p>Đơn hàng #123 đã được xử lý</p>
                                <span class="time">10 phút trước</span>
                            </div>
                            <div class="notification-item">
                                <p>Có khuyến mãi mới cho đèn led</p>
                                <span class="time">1 giờ trước</span>
                            </div>
                            <div class="notification-item">
                                <p>Đơn hàng #122 đã được giao</p>
                                <span class="time">Hôm qua</span>
                            </div>
                        </c:if>
                    </div>
                    <div class="dropdown-footer">
                        <a href="${pageContext.request.contextPath}/notifications">Xem tất cả</a>
                    </div>
                </div>
            </div>

            <!-- Messages -->
            <div class="dropdown messages-dropdown">
                <button class="dropdown-toggle" type="button" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-envelope" aria-hidden="true"></i>
                    <span class="message-count" aria-label="Số tin nhắn chưa đọc">
                        <c:choose>
                            <c:when test="${not empty sessionScope.messages}">
                                <c:set var="unreadMsg" value="0"/>
                                <c:forEach var="m" items="${sessionScope.messages}">
                                    <c:if test="${!m.read}">
                                        <c:set var="unreadMsg" value="${unreadMsg + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${unreadMsg}
                            </c:when>
                            <c:otherwise>2</c:otherwise>
                        </c:choose>
                    </span>
                </button>
                <div class="dropdown-menu messages-menu" role="menu" aria-label="Tin nhắn">
                    <div class="dropdown-header">
                        <span>Tin nhắn</span>
                        <button class="mark-read-btn" type="button">Đánh dấu đã đọc</button>
                    </div>
                    <div class="messages-list">
                        <c:if test="${not empty sessionScope.messages}">
                            <c:forEach var="m" items="${sessionScope.messages}">
                                <div class="message-item ${!m.read ? 'unread' : ''}">
                                    <p><strong>${m.sender}</strong>: ${m.content}</p>
                                    <span class="time">${m.time}</span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty sessionScope.messages}">
                            <div class="message-item unread">
                                <p><strong>Admin</strong>: Chào bạn, đơn hàng của bạn đã được xác nhận.</p>
                                <span class="time">5 phút trước</span>
                            </div>
                            <div class="message-item">
                                <p><strong>Shop</strong>: Khuyến mãi mới đã cập nhật.</p>
                                <span class="time">2 giờ trước</span>
                            </div>
                        </c:if>
                    </div>
                    <div class="dropdown-footer">
                        <a href="${pageContext.request.contextPath}/messages">Xem tất cả</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="main-nav" aria-label="Điều hướng chính">
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/products?action=list">TRANG CHỦ</a></li>
            <li><a href="${pageContext.request.contextPath}/about.jsp">GIỚI THIỆU</a></li>

            <li class="nav-dropdown">
                <a href="#" class="nav-link has-sub">CHIẾU SÁNG TRONG NHÀ <i class="fas fa-caret-down" aria-hidden="true"></i></a>
                <ul class="sub-menu" aria-label="Chiếu sáng trong nhà">
                    <c:forEach var="c" items="${categories}">
                        <c:if test="${c.parentId == 1}">
                            <li><a href="${pageContext.request.contextPath}/products?action=list&category=${c.categoryId}">${c.name}</a></li>
                            </c:if>
                        </c:forEach>
                </ul>
            </li>

            <li class="nav-dropdown">
                <a href="#" class="nav-link has-sub">CHIẾU SÁNG NGOÀI TRỜI <i class="fas fa-caret-down" aria-hidden="true"></i></a>
                <ul class="sub-menu" aria-label="Chiếu sáng ngoài trời">
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
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');
    :root{
        --gold:#d4af37;
        --gold-soft:#e6c763;
        --text-dark:#1a1a1a;
        --text-muted:#666;
        --bg-white:#fff;
        --bg-soft:#fafafa;
        --border:#e6e6e6;
        --radius-xs:4px;
        --radius-sm:8px;
        --radius-md:12px;
        --radius-lg:14px;
        --shadow:0 8px 24px rgba(0,0,0,0.06);
        --transition:.25s ease;
        --focus-ring:0 0 0 3px rgba(212,175,55,.35);
        --font-main:'Inter', system-ui, -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif
    }

    .main-header{
        background:var(--bg-white);
        border-bottom:1px solid var(--border);
        position:sticky;
        top:0;
        z-index:1000;
        font-family:var(--font-main);
        backdrop-filter:blur(6px)
    }
    .header-inner{
        max-width:1320px;
        margin:0 auto;
        padding:10px 18px;
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:28px
    }
    .header-left,.header-center,.header-right{
        display:flex;
        align-items:center
    }

    .logo{
        font-size:20px;
        font-weight:600;
        text-decoration:none;
        color:var(--text-dark);
        display:inline-flex;
        align-items:center;
        gap:8px;
        letter-spacing:.5px
    }
    .logo i{
        font-size:24px;
        color:var(--gold);
        filter:drop-shadow(0 0 4px rgba(212,175,55,.4))
    }
    .logo-text{
        background:linear-gradient(90deg,var(--gold) 0%,#f4e3a4 50%,var(--gold) 100%);
        -webkit-background-clip:text;
        color:transparent
    }

    .search-form{
        position:relative;
        display:flex;
        align-items:center
    }
    .search-input{
        width:360px;
        padding:9px 16px 9px 44px;
        border-radius:50px;
        background:#f5f5f5;
        border:1px solid var(--border);
        font-size:14px;
        transition:var(--transition)
    }
    .search-input:hover{
        background:#f1f1f1
    }
    .search-input:focus{
        outline:none;
        background:var(--bg-white);
        border-color:var(--gold);
        box-shadow:var(--focus-ring)
    }
    .search-btn{
        position:absolute;
        left:16px;
        top:50%;
        transform:translateY(-50%);
        border:none;
        background:transparent;
        font-size:16px;
        color:var(--text-muted);
        cursor:pointer;
        transition:var(--transition)
    }
    .search-btn:hover{
        color:var(--gold)
    }

    .header-right{
        display:flex;
        align-items:center;
        gap:22px
    }

    /* Dropdowns: fix hover → clickable with pointer-events + visibility */
    .dropdown{
        position:relative
    }
    .dropdown-toggle{
        background:none;
        border:none;
        cursor:pointer;
        font-size:20px;
        color:var(--text-dark);
        position:relative;
        padding:6px;
        line-height:1;
        border-radius:var(--radius-sm);
        transition:var(--transition)
    }
    .dropdown-toggle:hover,.dropdown-toggle:focus{
        color:var(--gold)
    }
    .dropdown-toggle:focus-visible{
        outline:none;
        box-shadow:var(--focus-ring)
    }

    .cart-count,.notification-count,.message-count{
        position:absolute;
        top:-4px;
        right:-4px;
        background:var(--gold);
        color:#fff;
        font-size:11px;
        padding:2px 6px;
        border-radius:50px;
        font-weight:600;
        line-height:1;
        min-width:20px;
        text-align:center
    }

    .dropdown-menu{
        position:absolute;
        right:0;
        top:100%;
        width:320px;
        background:var(--bg-white);
        border-radius:var(--radius-lg);
        border:1px solid var(--border);
        padding:0;
        box-shadow:var(--shadow);
        visibility:hidden;
        opacity:0;
        transform:translateY(8px);
        pointer-events:none;
        transition:opacity .2s ease,transform .2s ease,visibility 0s linear .2s;
        overflow:hidden;
        z-index:9999;
        will-change:transform,opacity
    }
    .dropdown:hover>.dropdown-menu,.dropdown:focus-within>.dropdown-menu,.dropdown.open>.dropdown-menu{
        visibility:visible;
        opacity:1;
        transform:translateY(0);
        pointer-events:auto;
        transition-delay:0s
    }

    .account-menu a{
        display:flex;
        align-items:center;
        gap:8px;
        padding:12px 18px;
        font-size:14px;
        text-decoration:none;
        color:var(--text-dark);
        transition:var(--transition)
    }
    .account-menu a:hover{
        background:#f7f7f7;
        color:var(--gold)
    }

    .cart-header{
        padding:12px 16px;
        font-weight:600;
        background:var(--bg-soft);
        border-bottom:1px solid var(--border);
        letter-spacing:.3px
    }
    .cart-items{
        max-height:260px;
        overflow-y:auto;
        scrollbar-width:thin;
        scrollbar-color:#ccc transparent
    }
    .cart-items::-webkit-scrollbar{
        width:6px
    }
    .cart-items::-webkit-scrollbar-thumb{
        background:#c9c9c9;
        border-radius:10px
    }
    .cart-item{
        display:flex;
        gap:12px;
        padding:12px 14px;
        border-bottom:1px solid #f1f1f1;
        align-items:flex-start;
        background:#fff;
        transition:var(--transition)
    }
    .cart-item:hover{
        background:#fafafa
    }
    .cart-item img{
        width:60px;
        height:60px;
        border-radius:var(--radius-sm);
        object-fit:cover;
        flex-shrink:0;
        border:1px solid #eee
    }
    .cart-info .name{
        font-size:14px;
        font-weight:500;
        line-height:1.35
    }
    .cart-info .price{
        color:var(--gold);
        font-weight:600;
        margin:4px 0 2px;
        font-size:13px
    }
    .subtotal{
        font-size:12px;
        color:var(--text-muted);
        margin-top:6px
    }
    .quantity-controls{
        display:flex;
        align-items:center;
        gap:6px;
        margin-top:6px;
        flex-wrap:wrap
    }
    .qty-btn{
        padding:4px 8px;
        border:none;
        background:var(--gold);
        color:#fff;
        font-size:13px;
        border-radius:var(--radius-xs);
        cursor:pointer;
        line-height:1;
        transition:var(--transition)
    }
    .qty-btn:hover{
        filter:brightness(1.1)
    }
    .remove-btn{
        background:#ff5a5a !important
    }
    .remove-btn:hover{
        filter:brightness(1.15)
    }
    .cart-total{
        padding:12px 16px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        border-top:1px solid var(--border);
        font-size:15px;
        background:#fff
    }
    .cart-actions{
        display:flex;
        padding:12px;
        gap:10px;
        background:#fff
    }
    .btn-view-cart,.btn-checkout{
        flex:1;
        text-align:center;
        background:var(--gold);
        color:#fff;
        padding:10px 12px;
        border-radius:var(--radius-sm);
        font-weight:600;
        text-decoration:none;
        font-size:14px;
        letter-spacing:.4px;
        transition:var(--transition)
    }
    .btn-view-cart:hover,.btn-checkout:hover{
        background:var(--gold-soft)
    }
    .empty-cart{
        padding:26px 20px;
        text-align:center
    }
    .empty-cart i{
        font-size:42px;
        color:#bbb;
        margin-bottom:10px
    }
    .btn-shopping{
        display:inline-block;
        margin-top:10px;
        background:var(--gold);
        color:#fff;
        padding:8px 18px;
        border-radius:50px;
        font-size:14px;
        text-decoration:none;
        font-weight:500;
        transition:var(--transition)
    }
    .btn-shopping:hover{
        background:var(--gold-soft)
    }

    .notifications-menu .dropdown-header,.messages-menu .dropdown-header{
        padding:12px 16px;
        font-weight:600;
        background:var(--bg-soft);
        border-bottom:1px solid var(--border);
        display:flex;
        justify-content:space-between;
        align-items:center
    }
    .mark-read-btn{
        background:none;
        border:none;
        font-size:12px;
        color:var(--gold);
        cursor:pointer;
        font-weight:600;
        padding:4px 6px;
        border-radius:var(--radius-xs);
        transition:var(--transition)
    }
    .mark-read-btn:hover{
        background:rgba(212,175,55,.12)
    }
    .notifications-list,.messages-list{
        max-height:260px;
        overflow-y:auto;
        scrollbar-width:thin;
        scrollbar-color:#ccc transparent
    }
    .notifications-list::-webkit-scrollbar,.messages-list::-webkit-scrollbar{
        width:6px
    }
    .notifications-list::-webkit-scrollbar-thumb,.messages-list::-webkit-scrollbar-thumb{
        background:#c9c9c9;
        border-radius:10px
    }
    .notification-item,.message-item{
        padding:12px 16px;
        border-bottom:1px solid #f4f4f4;
        transition:var(--transition);
        cursor:pointer;
        font-size:13.5px;
        line-height:1.4;
        background:#fff
    }
    .notification-item:hover,.message-item:hover{
        background:#f7f7f7
    }
    .notification-item.unread,.message-item.unread{
        background:#fff9e6;
        border-left:3px solid var(--gold)
    }
    .time{
        display:block;
        font-size:11px;
        color:var(--text-muted);
        margin-top:4px;
        letter-spacing:.3px
    }

    .dropdown-footer{
        text-align:center;
        padding:10px 0;
        border-top:1px solid var(--border);
        background:#fff
    }
    .dropdown-footer a{
        text-decoration:none;
        color:var(--gold);
        font-weight:600;
        font-size:13px
    }

    /* Navigation */
    .main-nav{
        background:var(--bg-white);
        border-top:1px solid var(--border);
        position:relative;
        z-index:999
    }
    .menu{
        max-width:1320px;
        margin:0 auto;
        display:flex;
        gap:30px;
        padding:12px 18px;
        list-style:none;
        align-items:center;
        position:relative
    }
    .menu>li{
        position:relative
    }
    .menu a{
        text-decoration:none;
        color:var(--text-dark);
        font-weight:500;
        font-size:14px;
        position:relative;
        letter-spacing:.5px;
        padding:6px 2px;
        display:inline-flex;
        align-items:center;
        gap:4px;
        transition:var(--transition)
    }
    .menu a:hover{
        color:var(--gold)
    }
    .menu a::after{
        content:"";
        position:absolute;
        left:0;
        bottom:-4px;
        width:0%;
        height:2px;
        background:var(--gold);
        transition:width .3s ease;
        border-radius:3px
    }
    .menu a:hover::after{
        width:100%
    }

    /* Sub-menu: unified (remove duplicated long styles) */
    .nav-dropdown{
        position:relative
    }
    .nav-link.has-sub{
        cursor:pointer
    }
    .nav-dropdown .sub-menu{
        list-style:none;
        padding:0;
        margin:0;
        position:absolute;
        top:100%;
        left:0;
        min-width:230px;
        background:var(--bg-white);
        border-radius:var(--radius-md);
        border:1px solid var(--border);
        box-shadow:var(--shadow);
        overflow:hidden;
        visibility:hidden;
        opacity:0;
        transform:translateY(8px);
        pointer-events:none;
        transition:opacity .2s ease,transform .2s ease,visibility 0s linear .2s;
        z-index:1000
    }
    .nav-dropdown:hover .sub-menu,.nav-dropdown:focus-within .sub-menu,.nav-dropdown.open .sub-menu{
        visibility:visible;
        opacity:1;
        transform:translateY(0);
        pointer-events:auto;
        transition-delay:0s
    }
    .sub-menu li a{
        padding:12px 18px;
        display:block;
        font-size:14px;
        line-height:1.3;
        background:#fff;
        transition:var(--transition)
    }
    .sub-menu li a:hover{
        background:#f7f7f7;
        color:var(--gold)
    }

    /* Responsive */
    @media (max-width:992px){
        .header-inner{
            flex-wrap:wrap;
            gap:14px
        }
        .search-input{
            width:260px
        }
        .menu{
            flex-wrap:wrap;
            gap:18px
        }
    }
    @media (max-width:640px){
        .header-right{
            gap:14px
        }
        .search-input{
            width:100%
        }
        .main-nav{
            border-top:none
        }
        .menu{
            padding-top:4px
        }
        .dropdown-menu{
            width:90vw;
            right:auto;
            left:50%;
            transform:translateX(-50%) translateY(8px)
        }
        .dropdown:hover>.dropdown-menu,.dropdown.open>.dropdown-menu,.dropdown:focus-within>.dropdown-menu{
            transform:translateX(-50%) translateY(0)
        }
    }
    /* Back To Top */
    #backToTop{
        position: fixed;
        bottom: 28px;
        right: 28px;
        width: 44px;
        height: 44px;
        border-radius: 50%;
        border: none;
        background: var(--gold);
        color: #fff;
        font-size: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: var(--shadow);
        opacity: 0;
        visibility: hidden;
        transform: translateY(15px);
        transition: opacity .25s ease, transform .25s ease, visibility .25s;
        z-index: 9999;
    }

    #backToTop:hover{
        background: var(--gold-soft);
        filter: brightness(1.05);
    }

    #backToTop.show{
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

</style>

<script>
    // Detect touch/mobile vs desktop
    var __IS_TOUCH__ = ('ontouchstart' in window) || (navigator.maxTouchPoints || 0) > 0;

    // Prevent double init if included twice
    if (!window.__HEADER_INIT__) {
        window.__HEADER_INIT__ = true;

        document.addEventListener('DOMContentLoaded', function () {
            var header = document.getElementById('main-header');

            // Subtle shadow on scroll
            window.addEventListener('scroll', function () {
                header.style.boxShadow = window.scrollY > 20
                        ? '0 8px 32px rgba(0,0,0,0.12)'
                        : '0 2px 8px rgba(0,0,0,0.08)';
            });

            // Helper: close all open dropdowns (for touch/mobile)
            function closeAllDropdowns(except) {
                var opened = document.querySelectorAll('.dropdown.open, .nav-dropdown.open');
                for (var i = 0; i < opened.length; i++) {
                    var d = opened[i];
                    if (d !== except)
                        d.classList.remove('open');
                    var btn = d.querySelector('.dropdown-toggle');
                    if (btn)
                        btn.setAttribute('aria-expanded', 'false');
                }
            }

            // Desktop (PC): use pure CSS hover/focus-within (no click JS)
            // Mobile/Touch: use click to toggle
            if (__IS_TOUCH__) {
                // Top-right dropdowns (account/cart/notifications/messages)
                var dropdowns = document.querySelectorAll('.dropdown');
                for (var i = 0; i < dropdowns.length; i++) {
                    (function (dd) {
                        var btn = dd.querySelector('.dropdown-toggle');
                        if (!btn)
                            return;

                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var willOpen = !dd.classList.contains('open');
                            closeAllDropdowns(dd);
                            if (willOpen) {
                                dd.classList.add('open');
                                btn.setAttribute('aria-expanded', 'true');
                            } else {
                                dd.classList.remove('open');
                                btn.setAttribute('aria-expanded', 'false');
                            }
                        });

                        var menu = dd.querySelector('.dropdown-menu');
                        if (menu) {
                            menu.addEventListener('click', function (e) {
                                e.stopPropagation();
                            });
                        }
                    })(dropdowns[i]);
                }

                // Nav sub-menus (mobile)
                var navDDs = document.querySelectorAll('.nav-dropdown');
                for (var j = 0; j < navDDs.length; j++) {
                    (function (nd) {
                        var link = nd.querySelector('.nav-link.has-sub');
                        if (!link)
                            return;
                        link.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var willOpen = !nd.classList.contains('open');
                            closeAllDropdowns(nd);
                            if (willOpen)
                                nd.classList.add('open');
                            else
                                nd.classList.remove('open');
                        });
                    })(navDDs[j]);
                }

                // Close on outside click or ESC (mobile only)
                document.addEventListener('click', function () {
                    closeAllDropdowns(null);
                });
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape')
                        closeAllDropdowns(null);
                });
            }

            // Mark-as-read buttons
            var markBtns = document.querySelectorAll('.mark-read-btn');
            for (var k = 0; k < markBtns.length; k++) {
                markBtns[k].addEventListener('click', function (e) {
                    e.stopPropagation();
                    var wrap = e.currentTarget.closest('.dropdown-menu');
                    if (!wrap)
                        return;
                    var unread = wrap.querySelectorAll('.notification-item.unread, .message-item.unread');
                    for (var m = 0; m < unread.length; m++)
                        unread[m].classList.remove('unread');
                });
            }

            // Vietnamese search handling (compact)
            var searchForm = document.querySelector('.search-form');
            var searchInput = document.querySelector('.search-input');

            function normalizeVietnamese(text) {
                if (!text)
                    return text;
                try {
                    text = text.normalize('NFC');
                } catch (e) {
                }
                text = text.replace(/[^\u0000-\u007F\u0080-\u00FF\u0100-\u017F\u1E00-\u1EFF\u0102\u0103\u0110\u0111\u0128\u0129\u0168\u0169\u01A0\u01A1\u01AF\u01B0\u1EA0-\u1EF9\s\-_.]/g, '');
                text = text.replace(/\s+/g, ' ').trim();
                return text;
            }

            if (searchForm && searchInput) {
                var isSubmitting = false;
                var composing = false;

                searchInput.addEventListener('compositionstart', function () {
                    composing = true;
                });
                searchInput.addEventListener('compositionend', function () {
                    composing = false;
                    setTimeout(function () {
                        var normalized = normalizeVietnamese(searchInput.value);
                        if (normalized !== searchInput.value) {
                            try {
                                var pos = searchInput.selectionStart || 0;
                                searchInput.value = normalized;
                                searchInput.setSelectionRange(pos, pos);
                            } catch (e) {
                                searchInput.value = normalized;
                            }
                        }
                    }, 0);
                });
                searchInput.addEventListener('input', function () {
                    if (composing)
                        return;
                    var orig = searchInput.value;
                    var norm = normalizeVietnamese(orig);
                    if (norm !== orig) {
                        try {
                            var pos2 = searchInput.selectionStart || 0;
                            searchInput.value = norm;
                            var offset = orig.length - norm.length;
                            searchInput.setSelectionRange(Math.max(0, pos2 - offset), Math.max(0, pos2 - offset));
                        } catch (e) {
                            searchInput.value = norm;
                        }
                    }
                });
                searchForm.addEventListener('submit', function (e) {
                    if (isSubmitting || composing) {
                        e.preventDefault();
                        return false;
                    }
                    var keyword = normalizeVietnamese(searchInput.value);
                    if (!keyword) {
                        e.preventDefault();
                        searchInput.focus();
                        return false;
                    }
                    searchInput.value = keyword;
                    isSubmitting = true;
                    setTimeout(function () {
                        isSubmitting = false;
                    }, 800);
                    return true;
                });
            }
        });
    }

    // Vietnamese utils (optional global)
    window.VietnameseUtils = {
        isVietnamese: function (text) {
            var re = /[\u00C0-\u00FF\u0100-\u017F\u1E00-\u1EFF\u0102\u0103\u0110\u0111\u0128\u0129\u0168\u0169\u01A0\u01A1\u01AF\u01B0\u1EA0-\u1EF9]/;
            return re.test(text || '');
        },
        cleanForSearch: function (text) {
            if (!text)
                return '';
            try {
                text = text.normalize('NFC');
            } catch (e) {
            }
            return text
                    .replace(/[^\w\s\u00C0-\u00FF\u0100-\u017F\u1E00-\u1EFF\u0102\u0103\u0110\u0111\u0128\u0129\u0168\u0169\u01A0\u01A1\u01AF\u01B0\u1EA0-\u1EF9\-_.]/g, '')
                    .replace(/\s+/g, ' ')
                    .trim();
        },
        validate: function (text) {
            var cleaned = this.cleanForSearch(text);
            return {isValid: cleaned.length > 0, cleaned: cleaned, hasVietnamese: this.isVietnamese(cleaned)};
        }
    };

    // Helper: context path
    function hdrGetContextPath() {
        return '${pageContext.request.contextPath}';
    }

    // Badge helper (in case you update badge elsewhere)
    function updateCartBadge(count) {
        var cartBadge = document.querySelector('.cart-count');
        if (cartBadge) {
            cartBadge.textContent = count;
            cartBadge.style.animation = 'pulse 0.6s ease';
            setTimeout(function () {
                cartBadge.style.animation = '';
            }, 600);
        }
    }
    window.updateCartBadge = updateCartBadge;

    // ===== Cart actions in dropdown (POST form-url-encoded + reload) =====
    function updateCartItem(id, change) {
        try {
            var item = document.querySelector(".cart-item[data-id='" + id + "']");
            var qtyEl = item ? item.querySelector('.quantity') : null;
            var current = qtyEl ? parseInt(qtyEl.textContent, 10) : 1;
            if (isNaN(current) || current < 1)
                current = 1;
            var newQty = current + (parseInt(change, 10) || 0);
            if (newQty < 1)
                newQty = 1;

            var body = new URLSearchParams();
            body.append('action', 'update');
            body.append('productId', id);
            body.append('quantity', newQty); // compatible with cart.jsp

            fetch(hdrGetContextPath() + '/cart', {
                method: 'POST',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                body: body
            }).then(function () {
                location.reload();
            }).catch(function () {
                location.reload();
            });
        } catch (e) {
            console.error(e);
            location.reload();
        }
    }

    function removeCartItem(id /*, btn */) {
        try {
            var body = new URLSearchParams();
            body.append('action', 'remove');
            body.append('productId', id);

            fetch(hdrGetContextPath() + '/cart', {
                method: 'POST',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                body: body
            }).then(function () {
                location.reload();
            }).catch(function () {
                location.reload();
            });
        } catch (e) {
            console.error(e);
            location.reload();
        }
    }

    const backToTop = document.getElementById("backToTop");

    window.addEventListener("scroll", () => {
        if (window.scrollY > 300) {
            backToTop.classList.add("show");
        } else {
            backToTop.classList.remove("show");
        }
    });

    backToTop.addEventListener("click", () => {
        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    });
</script>