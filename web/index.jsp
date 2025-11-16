<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Web bán đèn trang trí</title>
    <style>
        :root{
            --bg-color:#f8f9fa;
            --text-color:#333;
            --muted:#556;
            --card-bg:#fff;
            --shadow:rgba(0,0,0,0.1);
            --heading:#2c3e50;
            --primary:#007bff;
            --success:#28a745;
            --danger:#e74c3c;
            --border:#dcdcdc;
            --input-bg:#fff;
            --input-text:#222;
            --input-border:#cfcfcf;
            --chip-bg:#eef4ff;
            --select-arrow-color: rgb(34, 34, 34); /* Màu mũi tên mặc định (Sáng) */
        }
        body.dark{
            --bg-color:#121416;
            --text-color:#e9e9e9;
            --muted:#a7b0c0;
            --card-bg:#1a1f25;
            --shadow:rgba(0,0,0,0.4);
            --heading:#cde1ff;
            --primary:#4ea3ff;
            --success:#48d06b;
            --danger:#ff6b6b;
            --border:#2b323b;
            --input-bg:#11161c;
            --input-text:#e9e9e9;
            --input-border:#2c3440;
            --chip-bg:#1e2a38;
            --select-arrow-color: rgb(233, 233, 233); /* Màu mũi tên khi tối */
        }

        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:'Arial',sans-serif;background:var(--bg-color);color:var(--text-color);line-height:1.6;transition:background .3s,color .3s}
        .container{max-width:1400px; /* ĐÃ NỚI RỘNG KHUNG TỔNG THỂ */ margin:0 auto;padding:20px}

        /* Banner */
        .banner{width:100%;margin:20px 0;border-radius:10px;overflow:hidden;box-shadow:0 2px 10px var(--shadow)}
        .banner-slider{position:relative;height:400px}
        .slide{position:absolute;width:100%;height:100%;opacity:0;transition:opacity 1s ease}
        .slide.active{opacity:1}
        .slide img{width:100%;height:400px;object-fit:cover}
        .prev,.next{position:absolute;top:50%;transform:translateY(-50%);background:rgba(0,0,0,.5);color:#fff;border:none;padding:15px 20px;cursor:pointer;font-size:18px;transition:background .3s}
        .prev:hover,.next:hover{background:rgba(0,0,0,.8)}
        .prev{left:10px}.next{right:10px}
        .banner-thumbs{display:flex;justify-content:center;gap:10px;padding:15px;background:var(--bg-color)}
        .banner-thumbs img{width:80px;height:60px;object-fit:cover;border-radius:5px;cursor:pointer;opacity:.6;transition:opacity .3s}
        .banner-thumbs img.active,.banner-thumbs img:hover{opacity:1}

        /* Layout */
        .main-content{display:flex;gap:30px;margin-top:30px}
        .products-section{flex:3} /* ĐÃ GIỮ NGUYÊN TỶ LỆ CŨ */
        .sidebar{flex:1; /* ĐÃ GIỮ NGUYÊN TỶ LỆ CŨ */ display:flex;flex-direction:column;gap:20px}

        /* Cards */
        .bestseller-box,.search-box{background:var(--card-bg);padding:20px;border-radius:12px;box-shadow:0 2px 10px var(--shadow);border:1px solid var(--border)}
        h2{color:var(--heading);text-align:center;margin-bottom:22px;font-size:2rem}
        h3{color:var(--heading);margin-bottom:14px;text-align:left}

        /* Sort */
        .products-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;gap:10px;flex-wrap:wrap}
        .sort-form{display:flex;align-items:center;gap:8px;background:var(--card-bg);padding:6px 10px;border-radius:8px;box-shadow:0 2px 6px var(--shadow);border:1px solid var(--border)}
        .sort-form label{font-weight:600;font-size:.95rem}
        .sort-form select{padding:8px 10px;border-radius:6px;border:1px solid var(--input-border);background:var(--input-bg);color:var(--input-text);cursor:pointer;font-size:.95rem;transition:border-color .2s}
        .sort-form select:hover{border-color:var(--primary)}

        /* Grid */
        .product-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;margin-bottom:30px}
        .product-card{background:var(--card-bg);border-radius:12px;padding:16px;text-align:center;box-shadow:0 2px 10px var(--shadow);transition:transform .25s;border:1px solid var(--border)}
        .product-card:hover{transform:translateY(-5px)}
        .product-card img{width:100%;height:180px;object-fit:cover;border-radius:8px;margin-bottom:12px}
        .product-card h3{font-size:1.05rem;margin-bottom:6px;color:var(--text-color)}
        .product-card .price{color:var(--primary);font-weight:bold;font-size:1.06rem;margin-bottom:6px}
        .stock{font-size:.9rem;margin-bottom:10px;color:var(--muted)}
        .stock.in{color:var(--success)}
        .stock.out{color:var(--danger)}

        /* Buttons */
        .button{background:var(--primary);color:#fff;border:none;padding:10px 16px;border-radius:8px;cursor:pointer;text-decoration:none;display:inline-block;margin:5px;transition:transform .2s,opacity .2s}
        .button:hover{transform:translateY(-2px)}
        .button.secondary{background:#6c757d}
        .button.secondary:hover{opacity:.9}

        /* Pagination */
        .pagination{text-align:center;margin:24px 0}
        .pagination .button{margin:0 2px}
        .pagination .button.active{background:#28a745}
        .pagination input{width:70px;padding:8px;border-radius:6px;border:1px solid var(--input-border);background:var(--input-bg);color:var(--input-text)}

        /* Theme toggle */
        .theme-toggle{position:fixed;bottom:20px;right:20px;background:#ffc107;color:#000;border:none;padding:10px 15px;border-radius:10px;cursor:pointer;font-weight:700;box-shadow:0 2px 8px var(--shadow)}
        .theme-toggle:hover{filter:brightness(.95)}

        /* Advanced search (nice + collapsible) */
        .search-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:8px}
        .chip{background:var(--chip-bg);color:var(--primary);padding:3px 8px;border-radius:999px;font-size:.8rem;border:1px solid var(--border)}
        .adv-toggle{background:transparent;border:1px solid var(--border);color:var(--text-color);padding:8px 12px;border-radius:8px;cursor:pointer;transition:border-color .2s}
        .adv-toggle:hover{border-color:var(--primary)}
        
        .adv-body{overflow:hidden;max-height:0;transition:max-height .35s ease,padding .25s ease}
        .adv-body.open{max-height:600px; padding-top:12px}
        .form-grid{display:grid;grid-template-columns:1fr;gap:15px; /* Tăng khoảng cách */ }
        
        /* Cải tiến form-row, BỎ CỘT 100PX để input to ra */
        .form-row{
            display: grid;
            grid-template-columns: auto 1fr; /* Label tự động, input chiếm phần còn lại */
            align-items: center;
            gap: 15px;
        }
        .form-row.price-group {
            grid-template-columns: 1fr; /* Đặt nhóm giá thành 1 cột */
        }
        .form-row.price-group label {
            grid-column: 1 / -1; /* Đưa label chiếm trọn hàng */
            margin-bottom: -5px; /* Giảm khoảng cách với input */
            font-weight: 700;
        }

        .form-row input, .form-row select {
            width: 100%;
            padding: 12px 14px; /* Tăng padding để form to hơn */
            border-radius: 8px;
            border: 1px solid var(--input-border);
            background: var(--input-bg);
            color: var(--input-text);
            outline: none;
            /* Cải thiện dropdown */
            appearance: none; /* Ẩn mũi tên mặc định */
            /* DÙNG SVG VÀ color: currentColor để tự đổi màu theo biến CSS --select-arrow-color */
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>');
            background-repeat: no-repeat;
            background-position: right 12px center;
            transition: border-color .2s;
            /* Đặt màu chữ/mũi tên dựa trên biến CSS */
            color: var(--select-arrow-color); 
        }

        .form-row input:focus, .form-row select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
        }
        body.dark .form-row input:focus, body.dark .form-row select:focus {
            box-shadow: 0 0 0 3px rgba(78, 163, 255, 0.4);
        }
        
        /* Đảm bảo text input vẫn dùng màu mặc định của text-color */
        .form-row input {
            color: var(--input-text);
        }

        /* Bố cục cho khoảng giá 2 dòng */
        .price-inputs {
            display: flex;
            flex-direction: column; /* Chia làm 2 dòng */
            gap: 10px;
        }
        .price-input-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .price-input-row span {
            font-weight: 600;
            color: var(--text-color);
            width: 50px; /* Cố định chiều rộng cho label phụ */
            flex-shrink: 0;
        }
        .search-actions{display:flex;justify-content:flex-end;gap:10px;margin-top:10px}

        @media (max-width:992px){
            .product-grid{grid-template-columns:repeat(2,1fr)}
            .sidebar{flex:1;} /* Đảm bảo sidebar vẫn dùng tỷ lệ 1 khi màn hình nhỏ */
        }
        @media (max-width:576px){
            .product-grid{grid-template-columns:1fr}
            /* Trên mobile, label chiếm 1 hàng riêng */
            .form-row{grid-template-columns:1fr; gap: 8px;}
            .form-row label{margin-bottom:4px}
            .form-row.price-group {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%@ include file="partials/header.jsp" %>

<div class="container">
    <div class="banner">
        <div class="banner-slider">
            <div class="slide active"><img src="${pageContext.request.contextPath}/images/banner1.jpg" alt=""></div>
            <div class="slide"><img src="${pageContext.request.contextPath}/images/banner2.jpg" alt=""></div>
            <div class="slide"><img src="${pageContext.request.contextPath}/images/banner3.jpg" alt=""></div>
            <button class="prev">❮</button><button class="next">❯</button>
        </div>
        <div class="banner-thumbs">
            <img src="${pageContext.request.contextPath}/images/banner1.jpg" class="thumb active" alt="">
            <img src="${pageContext.request.contextPath}/images/banner2.jpg" class="thumb" alt="">
            <img src="${pageContext.request.contextPath}/images/banner3.jpg" class="thumb" alt="">
        </div>
    </div>

    <div class="main-content">
        <div class="products-section">
            <div class="products-header">
                <h2>💡 Danh sách sản phẩm</h2>
                <form id="sortForm" method="get" action="${pageContext.request.contextPath}/products" class="sort-form">
                    <input type="hidden" name="action" value="list"/>
                    <c:if test="${param.category != null}"><input type="hidden" name="category" value="${param.category}"/></c:if>
                    <c:if test="${param.parent != null}"><input type="hidden" name="parent" value="${param.parent}"/></c:if>
                    <input type="hidden" name="page" value="1"/>
                    <label for="sortBy">Sắp xếp theo:</label>
                    <select name="sortBy" id="sortBy" onchange="this.form.submit()">
                        <option value="">-- Mặc định --</option>
                        <option value="price_asc" ${param.sortBy eq 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                        <option value="price_desc" ${param.sortBy eq 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                        <option value="name_asc" ${param.sortBy eq 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                        <option value="name_desc" ${param.sortBy eq 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                    </select>
                </form>
            </div>

            <div class="product-grid">
                <c:forEach var="p" items="${products}">
                    <div class="product-card">
                        <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.name}">
                        <h3>${p.name}</h3>
                        <p class="price">${p.price}₫</p>

                        <c:set var="stockClass" value="${p.quantity > 0 ? 'stock in' : 'stock out'}"/>
                        <p class="${stockClass}">Kho: ${p.quantity}</p>

                        <c:choose>
                            <c:when test="${p.quantity > 0}">
                                <button type="button" class="button add-to-cart-btn" data-product-id="${p.id}">🛒 Thêm vào giỏ</button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="button" disabled style="opacity:.7;cursor:not-allowed;">Hết hàng</button>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${p.id}" class="button secondary">Xem chi tiết</a>
                    </div>
                </c:forEach>
            </div>

                <c:url var="pagingUrl" value="products">
    <c:param name="action" value="list"/>
    <c:if test="${not empty param.category}">
        <c:param name="category" value="${param.category}"/>
    </c:if>
    <c:if test="${not empty param.parent}">
        <c:param name="parent" value="${param.parent}"/>
    </c:if>
    <c:if test="${not empty param.sortBy}">
        <c:param name="sortBy" value="${param.sortBy}"/>
    </c:if>
</c:url>
<div class="pagination">
    <c:if test="${currentPage > 1}">
        <a href="${pagingUrl}&page=1" class="button">« Đầu</a>
        <a href="${pagingUrl}&page=${currentPage - 1}" class="button">‹ Trước</a>
    </c:if>
    <c:forEach begin="1" end="${totalPages}" var="pageNum">
        <a href="${pagingUrl}&page=${pageNum}" class="button ${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
        <a href="${pagingUrl}&page=${currentPage + 1}" class="button">Tiếp ›</a>
        <a href="${pagingUrl}&page=${totalPages}" class="button">Cuối »</a>
    </c:if>
    <!-- Giữ lại phần form đi tới trang nếu muốn -->
    <form action="${pagingUrl}" method="get" style="display:inline-block;margin-left:15px;">
        <input type="hidden" name="action" value="list"/>
        <c:if test="${not empty param.category}">
            <input type="hidden" name="category" value="${param.category}"/>
        </c:if>
        <c:if test="${not empty param.parent}">
            <input type="hidden" name="parent" value="${param.parent}"/>
        </c:if>
        <c:if test="${not empty param.sortBy}">
            <input type="hidden" name="sortBy" value="${param.sortBy}"/>
        </c:if>
        <label for="goPage" style="margin-right:6px;">Đến trang:</label>
        <input type="number" name="page" id="goPage" min="1" max="${totalPages}" required value="${currentPage}" style="width:60px;">
        <button type="submit" class="button">Đi</button>
    </form>
</div>


        </div>

        <div class="sidebar">
            <div class="search-box">
                <div class="search-head">
                    <h3 style="margin:0;">🔍 Tìm kiếm nâng cao</h3>
                    <div style="display:flex;align-items:center;gap:8px">
                        <button id="toggleAdvBtn" type="button" class="adv-toggle" aria-expanded="false">Mở rộng</button>
                    </div>
                </div>

                <div id="advBody" class="adv-body">
                    <form action="${pageContext.request.contextPath}/products" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="form-grid">
                            <div class="form-row">
                                <label for="keyword">Tên SP:</label>
                                <input type="text" id="keyword" name="keyword" placeholder="Nhập tên sản phẩm..."
                                       value="${searchKeyword != null ? searchKeyword : ''}">
                            </div>

                            <div class="form-row price-group">
                                <label>Khoảng giá:</label>
                                <div class="price-inputs">
                                    <div class="price-input-row">
                                        <span>Từ:</span>
                                        <input type="number" id="minPrice" name="minPrice" placeholder="Ví dụ: 0"
                                                value="${param.minPrice}">
                                    </div>
                                    <div class="price-input-row">
                                        <span>Đến:</span>
                                        <input type="number" id="maxPrice" name="maxPrice" placeholder="Ví dụ: 1000000"
                                                value="${param.maxPrice}">
                                    </div>
                                </div>
                            </div>

                            
<div class="form-row">
    <label for="category">Danh mục:</label>
    <select id="category" name="category">
        <option value="">-- Chọn danh mục --</option>
        <c:forEach var="c" items="${categories}">
            <c:choose>
                <c:when test="${param.parent == '1'}">
                    <c:if test="${c.parentId == 1 || (c.categoryId >= 3 && c.categoryId <= 6)}">
                        <option value="${c.categoryId}" ${param.category eq c.categoryId ? 'selected' : ''}>${c.name}</option>
                    </c:if>
                </c:when>
                <c:when test="${param.parent == '2'}">
                    <c:if test="${c.parentId == 2 || (c.categoryId >= 7 && c.categoryId <= 9)}">
                        <option value="${c.categoryId}" ${param.category eq c.categoryId ? 'selected' : ''}>${c.name}</option>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <option value="${c.categoryId}" ${param.category eq c.categoryId ? 'selected' : ''}>${c.name}</option>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </select>
</div>


                            <div class="search-actions">
                                <button type="reset" class="adv-toggle" onclick="window.location.href='${pageContext.request.contextPath}/products?action=list'">Xóa lọc</button>
                                <button type="submit" class="button">Tìm kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="bestseller-box">
                <h3 style="margin-bottom:14px;">🔥 Sản phẩm bán chạy</h3>
                <c:forEach var="sp" items="${bestSellers}">
                    <div class="bestseller-item" style="display:flex;gap:12px;margin-bottom:16px;padding-bottom:12px;border-bottom:1px solid var(--border)">
                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${sp.id}">
                            <img src="${pageContext.request.contextPath}/${sp.imagePath}" alt="${sp.name}" style="width:80px;height:80px;object-fit:cover;border-radius:8px">
                        </a>
                        <div class="bestseller-info" style="display:flex;flex-direction:column;gap:4px;justify-content:center">
                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${sp.id}" style="text-decoration:none;color:var(--text-color)">
                                <h4 style="font-size:.95rem;margin:0">${sp.name}</h4>
                            </a>
                            <span class="price" style="color:var(--primary);font-weight:700">${sp.price}₫</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<c:if test="${not empty debugLog}">
    <div style="background:#222;color:#fff;padding:12px;border-radius:8px;margin:20px 0;font-family:consolas,monospace">
        <b>DEBUG:</b><br />${debugLog}
    </div>
</c:if>

<%@ include file="partials/footer.jsp" %>
<!-- POPUP XÁC NHẬN GIỎ HÀNG -->
<div id="successPopup" class="success-form" style="display:none;">
  <div class="content-container">
    <div class="success-checkmark">
      <div class="check-icon">
        <span class="icon-line line-tip"></span>
        <span class="icon-line line-long"></span>
        <div class="icon-circle"></div>
        <div class="icon-fix"></div>
      </div>
    </div>
    <div class="text-center content-text text-24" style="margin-bottom:13px;">
        <b>Đã thêm vào giỏ hàng!</b>
    </div>
    <button id="popup-ok-btn" style="
      padding: 10px 36px;
      background: var(--success);
      color: #fff;
      border: none;
      border-radius: 8px;
      font-size: 1.1rem;
      font-weight: 700;
      margin-top: 2px;
      cursor:pointer;
      box-shadow: 0 2px 15px 1px rgba(30,200,120,0.13);
    ">OK</button>
  </div>
</div>

<script>
    // Banner slide
    const slides = document.querySelectorAll('.slide');
    const thumbs = document.querySelectorAll('.thumb');
    let current = 0;
    function showSlide(i){
        slides.forEach((s,idx)=>s.classList.toggle('active',idx===i));
        thumbs.forEach((t,idx)=>t.classList.toggle('active',idx===i));
        current=i;
    }
    document.querySelector('.next').onclick=()=>showSlide((current+1)%slides.length);
    document.querySelector('.prev').onclick=()=>showSlide((current-1+slides.length)%slides.length);
    thumbs.forEach((t,i)=>t.addEventListener('click',()=>showSlide(i)));
    setInterval(()=>document.querySelector('.next').click(),5000);

    // Add to cart (AJAX)
    document.addEventListener('DOMContentLoaded',function(){
        document.querySelectorAll('.add-to-cart-btn').forEach(btn=>{
            btn.addEventListener('click',async function(e){
                e.preventDefault();
                const id=this.dataset.productId;
                this.disabled=true;
                try{
                    const res=await fetch('${pageContext.request.contextPath}/cart',{
                        method:'POST',
                        headers:{'Content-Type':'application/x-www-form-urlencoded','X-Requested-With':'XMLHttpRequest'},
                        body:new URLSearchParams({action:'add',productId:id,quantity:1})
                    });
                    const result=await res.json();
                   if(result.success){
    showSuccessPopupAndReload();
}

                    else{ alert(result.message||"Không thể thêm sản phẩm"); }
                }catch(err){ console.error(err); }
                finally{ this.disabled=false; }
            });
        });
    });

    // Dark / Light mode
const themeBtn = document.getElementById('themeToggle');
function applySavedTheme(){
    const saved=localStorage.getItem('theme');
    const isDark = saved==='dark';
    if(isDark){
        document.body.classList.add('dark');
        if (themeBtn) themeBtn.textContent = '🌙 Chế độ tối';
    } else {
        document.body.classList.remove('dark');
        if (themeBtn) themeBtn.textContent = '🌞 Chế độ sáng';
    }
}
applySavedTheme();
if(themeBtn){
    themeBtn.addEventListener('click',()=>{
        document.body.classList.toggle('dark');
        const dark=document.body.classList.contains('dark');
        localStorage.setItem('theme',dark?'dark':'light');
        themeBtn.textContent=dark?'🌙 Chế độ tối':'🌞 Chế độ sáng';
    });
}

    // Advanced search: expand/collapse + remember state
    const advBtn=document.getElementById('toggleAdvBtn');
    const advBody=document.getElementById('advBody');
    function setAdv(open){
        advBody.classList.toggle('open',open);
        advBtn.setAttribute('aria-expanded',String(open));
        advBtn.textContent=open?'Thu gọn':'Mở rộng';
    }
    // Giữ trạng thái mở/đóng hoặc mở mặc định nếu chưa có
    const initialOpenState = localStorage.getItem('adv_open') !== 'false';
    setAdv(initialOpenState); 

    advBtn.addEventListener('click',()=>{
        const open=!advBody.classList.contains('open');
        setAdv(open);
        localStorage.setItem('adv_open',open?'true':'false');
    });
    const successPopup = document.getElementById('successPopup');
const popupOkBtn = document.getElementById('popup-ok-btn');
function showSuccessPopupAndReload() {
    successPopup.style.display = 'flex';
    successPopup.classList.add('active');
    const timeout = setTimeout(() => { hidePopupAndReload(); }, 1200);
    popupOkBtn.onclick = function() {
        clearTimeout(timeout); hidePopupAndReload();
    }
    successPopup.onclick = function(e) {
        if(e.target === successPopup) {
            clearTimeout(timeout); hidePopupAndReload();
        }
    }
}
function hidePopupAndReload() {
    successPopup.classList.remove('active');
    successPopup.style.display = 'none';
    location.reload();
}

</script>

</body>
</html>