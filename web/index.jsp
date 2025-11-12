<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Web bán đèn trang trí</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Arial', sans-serif;
                background-color: #f8f9fa;
                color: #333;
                line-height: 1.6;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            /* Banner Slider */
            .banner {
                width: 100%;
                margin: 20px 0;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .banner-slider {
                position: relative;
                height: 400px;
            }

            .slide {
                position: absolute;
                width: 100%;
                height: 100%;
                opacity: 0;
                transition: opacity 1s ease;
            }

            .slide.active {
                opacity: 1;
            }

            .slide img {
                width: 100%;
                height: 400px;
                object-fit: cover;
            }

            .prev, .next {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background: rgba(0,0,0,0.5);
                color: white;
                border: none;
                padding: 15px 20px;
                cursor: pointer;
                font-size: 18px;
                transition: background 0.3s ease;
            }

            .prev:hover, .next:hover {
                background: rgba(0,0,0,0.8);
            }

            .prev {
                left: 10px;
            }
            .next {
                right: 10px;
            }

            .banner-thumbs {
                display: flex;
                justify-content: center;
                gap: 10px;
                padding: 15px;
                background: #f8f9fa;
            }

            .banner-thumbs img {
                width: 80px;
                height: 60px;
                object-fit: cover;
                border-radius: 5px;
                cursor: pointer;
                opacity: 0.6;
                transition: opacity 0.3s ease;
            }

            .banner-thumbs img.active,
            .banner-thumbs img:hover {
                opacity: 1;
            }

            /* Main Content */
            .main-content {
                display: flex;
                gap: 30px;
                margin-top: 30px;
            }

            .products-section {
                flex: 3;
            }

            .bestseller-box {
                flex: 1;
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: fit-content;
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 2rem;
            }

            h3 {
                color: #2c3e50;
                margin-bottom: 20px;
                text-align: center;
            }

            /* Product Grid */
            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .product-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }

            .product-card:hover {
                transform: translateY(-5px);
            }

            .product-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
                border-radius: 8px;
                margin-bottom: 15px;
            }

            .product-card h3 {
                font-size: 1.1rem;
                margin-bottom: 10px;
                text-align: center;
            }

            .product-card .price {
                color: #007bff;
                font-weight: bold;
                font-size: 1.1rem;
                margin-bottom: 15px;
            }

            .button {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                margin: 5px;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .button:hover {
                background-color: #0056b3;
                text-decoration: none;
                color: white;
                transform: translateY(-2px);
            }

            .button:disabled {
                background-color: #6c757d;
                cursor: not-allowed;
                transform: none;
            }

            .button.loading {
                color: transparent;
            }

            .button.loading::after {
                content: "";
                position: absolute;
                width: 16px;
                height: 16px;
                top: 50%;
                left: 50%;
                margin-left: -8px;
                margin-top: -8px;
                border-radius: 50%;
                border: 2px solid transparent;
                border-top-color: #ffffff;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            .button.secondary {
                background-color: #6c757d;
            }

            .button.secondary:hover {
                background-color: #545b62;
            }

            /* Bestseller */
            .bestseller-item {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }

            .bestseller-item:last-child {
                border-bottom: none;
            }

            .bestseller-item img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 5px;
            }

            .bestseller-info h4 {
                color: #2c3e50;
                font-size: 0.9rem;
                margin-bottom: 5px;
            }

            .bestseller-info .price {
                color: #007bff;
                font-weight: bold;
            }

            /* Pagination */
            .pagination {
                text-align: center;
                margin: 30px 0;
            }

            .pagination .button {
                margin: 0 2px;
            }

            .pagination .button.active {
                background-color: #28a745;
            }

            /* ✅ ENHANCED SUCCESS POPUP */
            .success-popup {
                position: fixed;
                top: 20px;
                right: 20px;
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(40, 167, 69, 0.4);
                z-index: 10000;
                display: none;
                font-weight: 600;
                font-size: 14px;
                min-width: 280px;
                text-align: center;
            }

            .success-popup.show {
                display: block;
                animation: slideInRight 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            }

            .success-popup.hide {
                animation: slideOutRight 0.3s ease-in-out forwards;
            }

            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            @keyframes slideOutRight {
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-content {
                    flex-direction: column;
                }

                .product-grid {
                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    gap: 15px;
                }

                .banner-slider {
                    height: 250px;
                }

                .slide img {
                    height: 250px;
                }

                .success-popup {
                    right: 10px;
                    left: 10px;
                    min-width: unset;
                }
            }

            /* ==== POPUP XÁC NHẬN === */
            .success-form {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.4);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 9999;
            }

            .success-form.active {
                display: flex;
                animation: fadeIn 0.3s ease;
            }

            .content-container {
                background: #fff;
                border-radius: 12px;
                padding: 30px 40px;
                text-align: center;
                box-shadow: 0 4px 15px rgba(0,0,0,0.15);
                animation: zoomIn 0.4s ease;
            }

            .text-center {
                text-align: center;
            }

            .text-24 {
                font-size: 18px;
                font-weight: 600;
                color: #000;
                margin-top: 12px;
            }

            /* Checkmark icon */
            .success-checkmark {
                width: 80px;
                height: 115px;
                margin: 0 auto;
            }

            .success-checkmark .check-icon {
                width: 80px;
                height: 80px;
                position: relative;
                border-radius: 50%;
                box-sizing: content-box;
                border: 4px solid #3b82f6; /* xanh dương nhẹ */
            }

            .success-checkmark .icon-line {
                height: 5px;
                background-color: #3b82f6;
                display: block;
                border-radius: 2px;
                position: absolute;
                z-index: 10;
            }

            .success-checkmark .line-tip {
                top: 46px;
                left: 14px;
                width: 25px;
                transform: rotate(45deg);
                animation: icon-line-tip 0.75s forwards;
            }

            .success-checkmark .line-long {
                top: 38px;
                right: 8px;
                width: 47px;
                transform: rotate(-45deg);
                animation: icon-line-long 0.75s forwards;
            }

            .success-checkmark .icon-circle {
                top: -4px;
                left: -4px;
                width: 80px;
                height: 80px;
                border-radius: 50%;
                position: absolute;
                box-sizing: content-box;
                border: 4px solid rgba(59,130,246,0.2);
            }

            .success-checkmark .icon-fix {
                top: 8px;
                width: 5px;
                left: 26px;
                height: 85px;
                position: absolute;
                transform: rotate(-45deg);
                background-color: #fff;
            }

            @keyframes icon-line-tip {
                0% {
                    width: 0;
                    left: 1px;
                    top: 19px;
                }
                54% {
                    width: 0;
                    left: 1px;
                    top: 19px;
                }
                70% {
                    width: 50px;
                    left: -8px;
                    top: 37px;
                }
                84% {
                    width: 17px;
                    left: 21px;
                    top: 48px;
                }
                100% {
                    width: 25px;
                    left: 14px;
                    top: 46px;
                }
            }

            @keyframes icon-line-long {
                0% {
                    width: 0;
                    right: 46px;
                    top: 54px;
                }
                65% {
                    width: 0;
                    right: 46px;
                    top: 54px;
                }
                84% {
                    width: 55px;
                    right: 0px;
                    top: 35px;
                }
                100% {
                    width: 47px;
                    right: 8px;
                    top: 38px;
                }
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes zoomIn {
                from {
                    transform: scale(0.8);
                    opacity: 0;
                }
                to {
                    transform: scale(1);
                    opacity: 1;
                }
            }

        </style>
    </head>

    <body>
        <%@ include file="partials/header.jsp" %>

        <!-- Banner Slider -->
        <div class="container">
            <div class="banner">
                <div class="banner-slider">
                    <div class="slide active">
                        <img src="${pageContext.request.contextPath}/images/banner1.jpg" alt="Đèn trang trí phòng khách">
                    </div>
                    <div class="slide">
                        <img src="${pageContext.request.contextPath}/images/banner2.jpg" alt="Đèn ngủ cao cấp">
                    </div>
                    <div class="slide">
                        <img src="${pageContext.request.contextPath}/images/banner3.jpg" alt="Đèn chùm sang trọng">
                    </div>
                    <button class="prev">❮</button>
                    <button class="next">❯</button>
                </div>
                <div class="banner-thumbs">
                    <img src="${pageContext.request.contextPath}/images/banner1.jpg" class="thumb active">
                    <img src="${pageContext.request.contextPath}/images/banner2.jpg" class="thumb">
                    <img src="${pageContext.request.contextPath}/images/banner3.jpg" class="thumb">
                </div>
            </div>

            <div class="main-content">
                <!-- Products Section -->
                <div class="products-section">
                    <h2>💡 Danh sách sản phẩm</h2>

                    <div class="product-grid">
                        <c:forEach var="p" items="${products}">
                            <div class="product-card">
                                <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}">
                                <h3>${p.name}</h3>
                                <p class="price">${p.price}₫</p>

                                <button type="button" class="button add-to-cart-btn" data-product-id="${p.id}">
                                    🛒 Thêm vào giỏ
                                </button>

                                <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.id}"
                                   class="button secondary">Xem chi tiết</a>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination">
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <a href="${pageContext.request.contextPath}/products?action=list&page=${pageNum}"
                               class="button ${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
                        </c:forEach>
                    </div>
                </div>

                <!-- Bestseller Sidebar -->
                <div class="bestseller-box">
                    <h3>🔥 Sản phẩm bán chạy</h3>
                    <c:forEach var="sp" items="${bestSellers}">
                        <div class="bestseller-item">
                            <img src="${pageContext.request.contextPath}/${sp.imagePath}" alt="${sp.name}">
                            <div class="bestseller-info">
                                <h4>${sp.name}</h4>
                                <span class="price">${sp.price}₫</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <!-- ✅ POPUP XÁC NHẬN THÀNH CÔNG -->
        <div id="successPopup" class="success-form" style="display: none;">
            <div class="content-container">
                <div class="success-checkmark">
                    <div class="check-icon">
                        <span class="icon-line line-tip"></span>
                        <span class="icon-line line-long"></span>
                        <div class="icon-circle"></div>
                        <div class="icon-fix"></div>
                    </div>
                </div>
                <div class="text-center content-text text-24">
                    Thêm sản phẩm vào giỏ hàng thành công !
                </div>
            </div>
        </div>



        <%@ include file="partials/footer.jsp" %>


        <script>
            // Banner Slider
            const slides = document.querySelectorAll('.slide');
            const thumbs = document.querySelectorAll('.thumb');
            let current = 0;

            function showSlide(index) {
                slides.forEach((s, i) => s.classList.toggle('active', i === index));
                thumbs.forEach((t, i) => t.classList.toggle('active', i === index));
                current = index;
            }

            document.querySelector('.next').onclick = () => showSlide((current + 1) % slides.length);
            document.querySelector('.prev').onclick = () => showSlide((current - 1 + slides.length) % slides.length);
            thumbs.forEach((t, i) => t.addEventListener('click', () => showSlide(i)));

            // Auto slide
            setInterval(() => document.querySelector('.next').click(), 5000);

            // ✅ ENHANCED ADD TO CART FUNCTIONALITY
            document.addEventListener('DOMContentLoaded', function () {
                const cartCountElement = document.querySelector('.cart-count');
                const successPopup = document.getElementById('successPopup');

                function updateCartCount(newCount) {
                    if (cartCountElement) {
                        cartCountElement.textContent = newCount;
                        cartCountElement.style.animation = 'pulse 0.6s ease';
                        setTimeout(() => cartCountElement.style.animation = '', 600);
                    }
                }

                function showSuccessPopup() {
                    successPopup.style.display = "flex";
                    successPopup.classList.add("active");

                    setTimeout(() => {
                        successPopup.classList.remove("active");
                        window.location.reload();
                        successPopup.style.display = "none";
                    }, 900);
                }

                // Thêm sản phẩm vào giỏ
                document.querySelectorAll('.add-to-cart-btn').forEach(button => {
                    button.addEventListener('click', async function (e) {
                        e.preventDefault();
                        const productId = this.dataset.productId;
                        const originalText = this.textContent;

                        if (this.disabled)
                            return;
                        this.disabled = true;
                        this.classList.add('loading');

                        try {
                            const response = await fetch('${pageContext.request.contextPath}/cart', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                    'X-Requested-With': 'XMLHttpRequest'
                                },
                                body: new URLSearchParams({
                                    action: 'add',
                                    productId: productId,
                                    quantity: 1
                                })
                            });

                            const result = await response.json();
                            if (result.success) {
                                showSuccessPopup();

                                if (result.cartCount !== undefined) {
                                    updateCartCount(result.cartCount);
                                }

                                this.textContent = '✅ Đã thêm!';
                                this.style.backgroundColor = '#28a745';
                                setTimeout(() => {
                                    this.textContent = originalText;
                                    this.style.backgroundColor = '';
                                }, 1500);
                            } else {
                                throw new Error('Không thể thêm sản phẩm');
                            }
                        } catch (err) {
                            console.error(err);
                            this.textContent = '❌ Lỗi!';
                            this.style.backgroundColor = '#dc3545';
                            setTimeout(() => {
                                this.textContent = originalText;
                                this.style.backgroundColor = '';
                            }, 1500);
                        } finally {
                            this.disabled = false;
                            this.classList.remove('loading');
                        }
                    });
                });

                // 🧩 Ngăn popup tự hiện khi reload
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('added') === 'true') {
                    urlParams.delete('added');
                    const newUrl = window.location.pathname + (urlParams.toString() ? '?' + urlParams.toString() : '');
                    window.history.replaceState({}, document.title, newUrl);
                }
            });
        </script>

    </body>
</html>