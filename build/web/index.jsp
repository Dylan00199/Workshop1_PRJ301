<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Product" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Product Portfolio</title>
        <style>
            /* ===== LAYOUT ===== */
            .page-content {
                padding: 28px 32px;
            }

            .section-title {
                font-size: 24px;
                font-weight: 400;
                color: #222;
                margin-bottom: 8px;
            }
            .section-sub {
                font-size: 13px;
                color: #888;
                margin-bottom: 24px;
            }

            /* ===== FILTER BAR ===== */
            .filter-bar {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 24px;
                flex-wrap: wrap;
            }
            .filter-bar input[type="text"] {
                padding: 6px 12px;
                font-size: 13px;
                border: 1px solid #ccc;
                border-radius: 5px;
                width: 220px;
                outline: none;
            }
            .filter-bar select {
                padding: 6px 10px;
                font-size: 13px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                cursor: pointer;
            }
            .filter-bar button {
                padding: 6px 16px;
                font-size: 13px;
                border: 1px solid #bbb;
                border-radius: 5px;
                background: #fff;
                cursor: pointer;
            }
            .filter-bar button:hover {
                background: #f0f0f0;
            }

            /* ===== PRODUCT GRID ===== */
            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 20px;
            }

            /* ===== PRODUCT CARD ===== */
            .product-card {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                overflow: hidden;
                background: #fff;
                transition: box-shadow 0.2s;
                cursor: pointer;
                text-decoration: none;
                color: inherit;
                display: block;
            }
            .product-card:hover {
                box-shadow: 0 4px 16px rgba(0,0,0,0.12);
            }

            .card-img {
                width: 100%;
                height: 160px;
                object-fit: cover;
                background: #f5f5f5;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #bbb;
                font-size: 13px;
            }
            .card-img img {
                width: 100%;
                height: 160px;
                object-fit: cover;
            }

            .card-body {
                padding: 12px 14px;
            }

            .card-type {
                font-size: 11px;
                text-transform: uppercase;
                color: #2980b9;
                font-weight: 600;
                letter-spacing: 0.5px;
                margin-bottom: 4px;
            }

            .card-name {
                font-size: 15px;
                font-weight: 600;
                color: #222;
                margin-bottom: 6px;
                line-height: 1.3;
            }

            .card-brief {
                font-size: 13px;
                color: #666;
                margin-bottom: 10px;
                line-height: 1.5;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .card-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-top: 6px;
            }

            .card-price {
                font-size: 16px;
                font-weight: 700;
                color: #e74c3c;
            }

            .card-original-price {
                font-size: 12px;
                color: #aaa;
                text-decoration: line-through;
                margin-right: 4px;
            }

            .card-discount {
                font-size: 11px;
                background: #e74c3c;
                color: #fff;
                padding: 2px 6px;
                border-radius: 3px;
                font-weight: 600;
            }

            .card-postdate {
                font-size: 11px;
                color: #aaa;
            }

            /* ===== DETAIL MODAL ===== */
            .modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.45);
                z-index: 500;
                align-items: center;
                justify-content: center;
            }
            .modal-overlay.open {
                display: flex;
            }

            .modal {
                background: #fff;
                border-radius: 10px;
                max-width: 620px;
                width: 90%;
                max-height: 88vh;
                overflow-y: auto;
                padding: 28px;
                position: relative;
            }

            .modal-close {
                position: absolute;
                top: 14px;
                right: 18px;
                font-size: 22px;
                cursor: pointer;
                color: #888;
                border: none;
                background: none;
                line-height: 1;
            }
            .modal-close:hover {
                color: #333;
            }

            .modal-img {
                width: 100%;
                height: 240px;
                object-fit: cover;
                border-radius: 6px;
                background: #f5f5f5;
                margin-bottom: 18px;
            }

            .modal-meta {
                display: grid;
                grid-template-columns: 110px 1fr;
                row-gap: 8px;
                font-size: 14px;
                margin-top: 14px;
            }
            .modal-meta dt {
                color: #888;
                font-weight: 600;
            }
            .modal-meta dd {
                color: #333;
                margin: 0;
            }

            .modal-name {
                font-size: 20px;
                font-weight: 700;
                color: #222;
                margin-bottom: 6px;
            }
            .modal-brief {
                font-size: 14px;
                color: #555;
                line-height: 1.6;
                margin-bottom: 10px;
            }
            .modal-price-row {
                display: flex;
                align-items: center;
                gap: 10px;
                margin: 10px 0;
            }
            .modal-price {
                font-size: 22px;
                font-weight: 700;
                color: #e74c3c;
            }
            .modal-original {
                font-size: 14px;
                color: #aaa;
                text-decoration: line-through;
            }
            .modal-discount {
                font-size: 13px;
                background: #e74c3c;
                color: #fff;
                padding: 3px 8px;
                border-radius: 4px;
            }

            /* ===== EMPTY STATE ===== */
            .empty-state {
                text-align: center;
                padding: 60px 0;
                color: #aaa;
                font-size: 15px;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="section-title">Product Portfolio</h1>
            <p class="section-sub">Browse our latest products</p>

            <%
                List<Product> products = (List<Product>) session.getAttribute("list");
                boolean hasProducts = products != null && !products.isEmpty();
                if (request.getAttribute("list") == null) {
                    request.getRequestDispatcher("ProductController?action=home")
                            .forward(request, response);
                    return;
                }
            %>

            <% if (!hasProducts) { %>
            <div class="empty-state">No products found.</div>
            <% } else { %>
            <div class="product-grid" id="productGrid">


                <% for (Product p : products) {%>
                <div class="product-card" onclick="openModal(
                                '<%= p.getProductName()%>',
                                '<%= p.getType().getCategoryName()%>',
                                '<%= p.getBrief()%>',
                                '<%= p.getProductImage()%>',
                                '<%= String.format("%,.0f ₫", p.getPrice() * (1 - p.getDiscount() / 100.0))%>',
                                '<%= String.format("%,.0f ₫", p.getPrice())%>',
                                '-<%= p.getDiscount()%>%',
                                '<%= p.getPostedDate()%>')">
                    <div class="card-img"><img src="<%= p.getProductImage()%>" alt="<%= p.getProductName()%>" onerror="this.parentElement.textContent='No image'"></div>
                    <div class="card-body">
                        <div class="card-type"><%= p.getType().getCategoryName()%></div>
                        <div class="card-name"><%= p.getProductName()%></div>
                        <div class="card-brief"><%= p.getBrief()%></div>
                        <div class="card-footer">
                            <div>
                                <% if (p.getDiscount() > 0) {%>
                                <span class="card-original-price"><%= String.format("%,.0f ₫", p.getPrice())%></span>
                                <% }%>
                                <span class="card-price"><%= String.format("%,.0f ₫", p.getPrice() * (1 - p.getDiscount() / 100.0))%></span>
                            </div>
                            <% if (p.getDiscount() > 0) {%>
                            <span class="card-discount">-<%= p.getDiscount()%>%</span>
                            <% }%>
                        </div>
                        <div class="card-postdate">Posted: <%= p.getPostedDate()%></div>
                    </div>
                </div>
                <% } %>
            </div>
            <%}%>
        </div>

        <%-- ===== PRODUCT DETAIL MODAL ===== --%>
        <div class="modal-overlay" id="modalOverlay" onclick="closeModalOutside(event)">
            <div class="modal" id="modalBox">
                <button class="modal-close" onclick="closeModal()">✕</button>
                <img id="modalImg" class="modal-img" src="" alt="">
                <div class="modal-name" id="modalName"></div>
                <div class="modal-brief" id="modalBrief"></div>
                <div class="modal-price-row">
                    <span class="modal-price" id="modalPrice"></span>
                    <span class="modal-original" id="modalOriginal"></span>
                    <span class="modal-discount" id="modalDiscount"></span>
                </div>
                <dl class="modal-meta">
                    <dt>Type</dt>    <dd id="modalType"></dd>
                    <dt>Post date</dt><dd id="modalPostdate"></dd>
                </dl>
            </div>
        </div>

        <script>
            function openModal(name, type, brief, img, price, original, discount, postdate) {
                document.getElementById('modalName').textContent = name;
                document.getElementById('modalType').textContent = type;
                document.getElementById('modalBrief').textContent = brief;
                document.getElementById('modalImg').src = img;
                document.getElementById('modalImg').alt = name;
                document.getElementById('modalPrice').textContent = price;
                document.getElementById('modalOriginal').textContent = original || '';
                document.getElementById('modalDiscount').textContent = discount || '';
                document.getElementById('modalDiscount').style.display = discount ? 'inline' : 'none';
                document.getElementById('modalPostdate').textContent = postdate;
                document.getElementById('modalOverlay').classList.add('open');
                document.body.style.overflow = 'hidden';
            }
            function closeModal() {
                document.getElementById('modalOverlay').classList.remove('open');
                document.body.style.overflow = '';
            }
            function closeModalOutside(e) {
                if (e.target === document.getElementById('modalOverlay'))
                    closeModal();
            }
            document.addEventListener('keydown', e => {
                if (e.key === 'Escape')
                    closeModal();
            });
        </script>

    </body>
</html>
