<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Account" %> 
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>List of Accounts</title>
        <style>
            /* ===== LAYOUT ===== */
            .page-content {
                padding: 24px 32px;
            }

            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                margin-bottom: 20px;
                color: #222;
            }

            /* ===== TABLE ===== */
            .account-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .account-table th {
                text-align: left;
                padding: 8px 12px;
                border-bottom: 1px solid #dee2e6;
                color: #555;
                font-weight: 600;
            }
            .account-table td {
                padding: 10px 12px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }
            .account-table tr:last-child td {
                border-bottom: none;
            }
            .account-table tr:hover td {
                background: #f8f9fa;
            }

            /* ===== ACTION BUTTONS ===== */
            .btn {
                display: inline-block;
                padding: 4px 12px;
                border: none;
                border-radius: 4px;
                font-size: 13px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                color: #fff;
                margin-right: 4px;
            }
            .btn-update  {
                background: #2980b9;
            }
            .btn-update:hover  {
                background: #1f6fa0;
            }
            .btn-deactive {
                background: #e67e22;
            }
            .btn-deactive:hover {
                background: #cf6d17;
            }
            .btn-active  {
                background: #27ae60;
            }
            .btn-active:hover  {
                background: #1e9050;
            }
            .btn-delete  {
                background: #e74c3c;
            }
            .btn-delete:hover  {
                background: #c0392b;
            }

            /* ===== STATUS BADGE ===== */
            .badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 10px;
                font-size: 12px;
            }
            .badge-active   {
                background: #d4edda;
                color: #155724;
            }
            .badge-inactive {
                background: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>

        <%-- ===== NAVBAR ===== --%>
        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="page-title">List of account in system</h1>

            <table class="account-table">
                <thead>
                    <tr>
                        <th>Account</th>
                        <th>Full name</th>
                        <th>Birth day</th>
                        <th>Gender</th>
                        <th>Phone</th>
                        <th>Role in system</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Account> listAccounts = (List<Account>) request.getAttribute("listAccounts");
                        String roleAccountList = "User";
                        if (listAccounts != null && !listAccounts.isEmpty()) {

                            for (Account acc : listAccounts) {%>
                    <%
                        if (acc.getRoleInSystem() == 1) {
                            roleAccountList = "Administrator";
                        } else if (acc.getRoleInSystem() == 2) {
                            roleAccountList = "Manager";
                        }
                        session.setAttribute("updateAccount", acc);

                    %>
                    <tr>
                        <td><%= acc.getAccount()%></td>
                        <td><%= acc.getFirstname()%>, <%= acc.getLastname()%></td>
                        <td><%= acc.getDob()%></td>
                        <td><%= acc.isGender() ? "Male" : "Female"%></td>
                        <td><%= acc.getPhone()%></td>
                        <td><%= roleAccountList%></td>
                        <td>
                            <a href="updateAccount.jsp" class="btn btn-update">Update</a>
                            <% if (acc.isUse()) {%>
                            <a href="AccountController?action=deactiveAccount&id=<%= acc.getAccount()%>" class="btn btn-deactive">Deactive</a>
                            <% } else {%>
                            <a href="AccountController?action=activeAccount&id=<%= acc.getAccount()%>" class="btn btn-active">Active</a>
                            <% }%>
                            <a href="AccountController?action=deleteAccount&id=<%= acc.getAccount()%>"class="btn btn-delete">Delete</a>
                        </td>
                    </tr>
                    <% }
                        }%>
                </tbody>
            </table>
        </div>

    </body>
</html>
