<%@page import="Model.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%-- <%@ page import="model.Product" %> --%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>List of Products</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }

            /* ===== HEADER ===== */
            .page-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20px;
            }
            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                color: #222;
            }
            .btn-add {
                display: inline-block;
                padding: 7px 18px;
                background: #27ae60;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
            }
            .btn-add:hover {
                background: #1e9050;
            }

            /* ===== FILTER BAR ===== */
            .filter-bar {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 18px;
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
            .filter-bar input[type="text"]:focus {
                border-color: #2980b9;
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

            /* ===== TABLE ===== */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .data-table th {
                text-align: left;
                padding: 9px 12px;
                border-bottom: 2px solid #dee2e6;
                color: #555;
                font-weight: 600;
                font-size: 13px;
                background: #f8f9fa;
                white-space: nowrap;
            }
            .data-table td {
                padding: 9px 12px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }
            .data-table tr:last-child td {
                border-bottom: none;
            }
            .data-table tr:hover td {
                background: #f8f9fa;
            }

            /* ===== PRODUCT THUMB ===== */
            .product-thumb {
                width: 48px;
                height: 48px;
                object-fit: cover;
                border-radius: 5px;
                background: #eee;
                display: block;
            }
            .no-img {
                width: 48px;
                height: 48px;
                background: #f0f0f0;
                border-radius: 5px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: #bbb;
            }

            /* ===== BADGES ===== */
            .badge-cat {
                display: inline-block;
                padding: 2px 8px;
                background: #e8f4fd;
                color: #1a6fa0;
                border-radius: 10px;
                font-size: 12px;
                font-weight: 600;
            }
            .price-cell {
                font-weight: 700;
                color: #e74c3c;
                white-space: nowrap;
            }
            .price-original {
                font-size: 12px;
                color: #aaa;
                text-decoration: line-through;
                display: block;
            }
            .discount-badge {
                display: inline-block;
                background: #e74c3c;
                color: #fff;
                font-size: 11px;
                padding: 1px 5px;
                border-radius: 3px;
                font-weight: 600;
                margin-left: 4px;
            }

            /* ===== ACTION BUTTONS ===== */
            .btn {
                display: inline-block;
                padding: 4px 10px;
                border: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                color: #fff;
                margin-right: 3px;
                white-space: nowrap;
            }
            .btn-update {
                background: #2980b9;
            }
            .btn-update:hover {
                background: #1f6fa0;
            }
            .btn-delete {
                background: #e74c3c;
            }
            .btn-delete:hover {
                background: #c0392b;
            }

            /* ===== EMPTY ===== */
            .empty-row td {
                text-align: center;
                padding: 48px 0;
                color: #aaa;
                font-size: 14px;
            }

            /* ===== PAGINATION ===== */
            .pagination {
                display: flex;
                gap: 4px;
                margin-top: 20px;
                justify-content: flex-end;
            }
            .page-btn {
                min-width: 32px;
                height: 32px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 13px;
                text-decoration: none;
                color: #333;
                background: #fff;
                cursor: pointer;
                padding: 0 8px;
            }
            .page-btn:hover {
                background: #f0f0f0;
            }
            .page-btn.active {
                background: #2980b9;
                color: #fff;
                border-color: #2980b9;
            }
            .page-btn.disabled {
                color: #ccc;
                cursor: default;
                pointer-events: none;
            }

            /* ===== PRODUCT NAME ===== */
            .product-name {
                font-weight: 600;
                color: #222;
            }
            .product-brief {
                font-size: 12px;
                color: #888;
                margin-top: 2px;
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <div class="page-header">
                <h1 class="page-title">List of products</h1>
                <a href="addProduct.jsp" class="btn-add">+ Add product</a>
            </div>

            <%-- ===== FILTER ===== --%>
            <form class="filter-bar" method="GET" action="MainController">
                <input type="hidden" name="action" value="listProduct">
                <input type="text" name="keyword"
                       placeholder="Search product name..."
                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : ""%>">
                <select name="category">
                    <option value="">All categories</option>
                    <%-- TODO: loop categories from request attribute --%>
                    <option value="1" <%= "1".equals(request.getParameter("category")) ? "selected" : ""%>>Electronics</option>
                    <option value="2" <%= "2".equals(request.getParameter("category")) ? "selected" : ""%>>Outdoor &amp; Travel</option>
                    <option value="3" <%= "3".equals(request.getParameter("category")) ? "selected" : ""%>>Clothing</option>
                    <option value="4" <%= "4".equals(request.getParameter("category")) ? "selected" : ""%>>Sports &amp; Fitness</option>
                </select>
                <button type="submit">Search</button>
                <a href="MainController?action=listProduct"><button type="button">Reset</button></a>
            </form>

            <%-- ===== TABLE ===== --%>
            <%
                List<Product> products = (List<Product>) request.getAttribute("list");
                boolean hasData = products != null && !products.isEmpty();
            %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width:36px">#</th>
                        <th style="width:56px">Image</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Post date</th>
                        <th style="width:140px">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (!hasData) { %>
                    <tr class="empty-row"><td colspan="8">No products found.</td></tr>
                    <% } else { %>

                    <%
                        int idx = 1;
                        for (Product p : products) {%>
                    <tr>
                        <td><%= idx++%></td>
                        <td>
                            <% if (p.getProductImage() != null && !p.getProductImage().isEmpty()) {%>
                            <img class="product-thumb"
                                 src="<%= request.getContextPath() + p.getProductImage()%>"
                                 alt="<%= p.getProductName()%>"
                                 loading="lazy"
                                 onerror="this.style.display='none'">
                            <% } else { %>
                            <div class="no-img">N/A</div>
                            <% }%>
                        </td>
                        <td>
                            <div class="product-name"><%= p.getProductName()%></div>
                            <div class="product-brief"><%= p.getBrief()%></div>
                        </td>
                        <td><span class="badge-cat"><%= p.getType().getCategoryName()%></span></td>
                        <td class="price-cell">
                            <%= String.format("%,.0f ₫", p.getPrice() * (1 - p.getDiscount() / 100.0))%>
                            <% if (p.getDiscount() > 0) {%>
                            <span class="price-original"><%= String.format("%,.0f ₫", p.getPrice())%></span>
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getDiscount() > 0) {%>
                            <span class="discount-badge">-<%= p.getDiscount()%>%</span>
                            <% } else { %>—<% }%>
                        </td>
                        <td><%= p.getPostedDate()%></td>
                        <td>
                            <a href="MainController?action=updateProduct&id=<%= p.getProductId()%>" class="btn btn-update">Update</a>
                            <a href="MainController?action=deleteProduct&id=<%= p.getProductId()%>"
                               class="btn btn-delete"
                               onclick="return confirm('Delete product \"<%= p.getProductName()%>\"?')">Delete</a>
                        </td>
                    </tr>
                    <% }%>


                    <% } %>
                </tbody>
            </table>

            <%-- ===== PAGINATION ===== --%>
            <%
                int currentPage = 1;
                String p = request.getParameter("page");
                if (p != null) try {
                    currentPage = Integer.parseInt(p);
                } catch (Exception ignored) {
                }
                int totalPages = 3;
            %>
            <div class="pagination">
                <a href="?action=listProduct&page=<%= currentPage - 1%>"
                   class="page-btn <%= currentPage <= 1 ? "disabled" : ""%>">&#8592;</a>
                <% for (int i = 1; i <= totalPages; i++) {%>
                <a href="?action=listProduct&page=<%= i%>"
                   class="page-btn <%= i == currentPage ? "active" : ""%>"><%= i%></a>
                <% }%>
                <a href="?action=listProduct&page=<%= currentPage + 1%>"
                   class="page-btn <%= currentPage >= totalPages ? "disabled" : ""%>">&#8594;</a>
            </div>
        </div>

    </body>
</html>
