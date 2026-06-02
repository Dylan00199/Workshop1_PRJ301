<%@page import="Model.Account"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Account account = (Account) session.getAttribute("login");
    String currentRole = null;
    String currentUser = null;
    if (account != null) {
        currentUser = account.getAccount();
        int role = account.getRoleInSystem();
        if (role == 1) {
            currentRole = "Admin";
        }
        if (role == 2) {
            currentRole = "Manager";
        }
        if (role == 3) {
            currentRole = "User";
        }
    }
    boolean isLoggedIn = (currentUser != null);
%>
<nav class="navbar">
    <div class="navbar-inner">
        <div class="navbar-brand">
            Welcome to
            <% if (isLoggedIn) {%>
            <strong class="role-label"><%= currentRole != null ? currentRole : "user"%></strong> [<%= currentUser%>]
            <% } else { %>
            <strong class="role-label">Guest</strong>
            <% } %>
        </div>
        <ul class="nav-links">
            <li><a href="index.jsp" class="nav-link">Home</a></li>
            <li class="dropdown">
                <a class="nav-link dropdown-toggle">Accounts</a>
                <ul class="dropdown-menu">
                    <% if ("admin".equalsIgnoreCase(currentRole)) { %>
                    <li><a href="AccountController?action=listAccount">List Accounts</a></li>
                        <% } %>
                    <li><a href="addAccount.jsp">Add Account</a></li>
                    <li><a href="account.jsp">My Account</a></li>
                </ul>
            </li>
            <li class="dropdown">
                <a class="nav-link dropdown-toggle">Categories</a>
                <ul class="dropdown-menu">
                    <li><a href="CategoryController?action=listCategory">List Categories</a></li>
                    <li><a href="addCategory.jsp">Add Category</a></li>
                </ul>
            </li>
            <li class="dropdown">
                <a class="nav-link dropdown-toggle">Products</a>
                <ul class="dropdown-menu">
                    <li><a href="ProductController?action=listProduct">List Products</a></li>
                        <% if (account != null) { %>
                    <li><a href="addProduct.jsp">Add Product</a></li>
                        <% } %>
                </ul>
            </li>
        </ul>
        <div class="nav-auth">
            <% if (isLoggedIn) { %>
            <a href="loginController?action=logout" class="btn-logout">Logout</a>
            <% } else { %>
            <a href="login.jsp" class="btn-logout">Login</a>
            <% }%>
        </div>
    </div>
</nav>

<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    body {
        font-family: Arial, sans-serif;
        font-size: 14px;
        background: #fff;
        color: #333;
    }

    .navbar {
        background: #fff;
        border-bottom: 1px solid #ddd;
        padding: 0 20px;
        position: sticky;
        top: 0;
        z-index: 100;
    }
    .navbar-inner {
        display: flex;
        align-items: center;
        height: 46px;
        gap: 12px;
    }
    .navbar-brand {
        flex: 1;
        font-size: 14px;
        white-space: nowrap;
    }
    .role-label {
        color: #c0392b;
        font-weight: bold;
    }

    .nav-links {
        display: flex;
        list-style: none;
        gap: 2px;
    }
    .nav-link {
        display: block;
        padding: 6px 12px;
        border-radius: 4px;
        text-decoration: none;
        color: #333;
        font-size: 14px;
        cursor: pointer;
    }
    .nav-link:hover {
        background: #e9ecef;
    }

    .dropdown {
        position: relative;
    }
    .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 4px;
        min-width: 160px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        z-index: 200;
    }
    .dropdown-menu li {
        list-style: none;
    }
    .dropdown-menu a {
        display: block;
        padding: 8px 14px;
        text-decoration: none;
        color: #333;
        font-size: 13px;
    }
    .dropdown-menu a:hover {
        background: #f8f9fa;
    }
    .dropdown:hover .dropdown-menu {
        display: block;
    }

    .btn-logout {
        padding: 5px 14px;
        border: 1px solid #ccc;
        border-radius: 4px;
        text-decoration: none;
        color: #333;
        font-size: 13px;
        white-space: nowrap;
    }
    .btn-logout:hover {
        background: #f0f0f0;
    }
</style>
