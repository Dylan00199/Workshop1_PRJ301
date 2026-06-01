<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Account" %> 
<%
    Account acc = (Account) session.getAttribute("updateAccount");

    String pass = acc.getPass();
    String firstName = acc.getFirstname();
    String lastName = acc.getLastname();
    String fullName = acc.getFirstname() + ", " + acc.getLastname();
    String phone = acc.getPhone();
    String dob = String.valueOf(acc.getDob());
    boolean isGender = acc.isGender();
    boolean isActive = acc.isUse();
    String gender = "Male";

    String AccountRole = null;
    String AccountUser = null;
    if (acc != null) {
        AccountUser = acc.getAccount();
        int role = acc.getRoleInSystem();
        if (role == 1) {
            AccountRole = "Admin";
        }
        if (role == 2) {
            AccountRole = "Manager";
        }
        if (role == 3) {
            AccountRole = "User";
        }
    }
    if (AccountUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Fallback values for display
    if (fullName == null || fullName.isEmpty()) {
        fullName = acc.getAccount();
    }
    if (phone == null) {
        phone = "—";
    }
    if (dob == null) {
        dob = "—";
    }
    if (!isGender) {
        gender = "Female";
    }

    String errorMsg = (String) request.getAttribute("error");
    String successMsg = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Update Account</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }

            /* ===== BREADCRUMB ===== */
            .breadcrumb {
                font-size: 13px;
                color: #aaa;
                margin-bottom: 16px;
            }
            .breadcrumb a {
                color: #2980b9;
                text-decoration: none;
            }
            .breadcrumb a:hover {
                text-decoration: underline;
            }
            .breadcrumb span {
                margin: 0 6px;
            }

            h1.page-title {
                font-size: 26px;
                font-weight: 400;
                color: #222;
                margin-bottom: 24px;
            }

            /* ===== ALERTS ===== */
            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
                max-width: 860px;
            }
            .alert-success {
                background: #eafaf1;
                border: 1px solid #a9dfbf;
                color: #1e8449;
            }
            .alert-error   {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                color: #c0392b;
            }

            /* ===== FORM LAYOUT ===== */
            .form-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0 40px;
                max-width: 860px;
            }

            .form-section-title {
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #aaa;
                margin: 0 0 14px;
                padding-bottom: 6px;
                border-bottom: 1px solid #eee;
                grid-column: 1 / -1;
            }
            .form-section-title.mt {
                margin-top: 10px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 14px;
            }
            .form-group.full {
                grid-column: 1 / -1;
            }

            .form-group label {
                font-size: 13px;
                font-weight: 600;
                color: #444;
                margin-bottom: 5px;
            }
            .form-group label .required {
                color: #e74c3c;
                margin-left: 2px;
            }

            .form-group input[type="text"],
            .form-group input[type="password"],
            .form-group input[type="date"],
            .form-group select {
                padding: 7px 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                box-sizing: border-box;
                width: 100%;
                font-family: Arial, sans-serif;
                transition: border-color 0.15s;
            }
            .form-group input:focus,
            .form-group select:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .form-group input[readonly] {
                background: #f8f8f8;
                color: #999;
                cursor: not-allowed;
            }

            /* ===== GENDER ROW ===== */
            .radio-group {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-top: 4px;
            }
            .radio-label {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
                color: #333;
                cursor: pointer;
            }
            .radio-label input[type="radio"] {
                width: 16px;
                height: 16px;
                accent-color: #2980b9;
                cursor: pointer;
            }

            /* ===== CHECKBOX ===== */
            .checkbox-label {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: #333;
                cursor: pointer;
                margin-top: 4px;
            }
            .checkbox-label input[type="checkbox"] {
                width: 16px;
                height: 16px;
                accent-color: #2980b9;
                cursor: pointer;
            }

            /* ===== HINT ===== */
            .hint {
                font-size: 12px;
                color: #aaa;
                margin-top: 3px;
            }

            /* ===== ACTIONS ===== */
            .form-actions {
                grid-column: 1 / -1;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 8px;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }
            .btn-save {
                padding: 8px 26px;
                background: #2980b9;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #1f6fa0;
            }
            .btn-cancel {
                padding: 8px 18px;
                background: #fff;
                color: #555;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 14px;
                text-decoration: none;
                cursor: pointer;
            }
            .btn-cancel:hover {
                background: #f5f5f5;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">

            <div class="breadcrumb">
                <a href="AccountController?action=viewList">Accounts</a>
                <span>›</span> Update account
            </div>

            <h1 class="page-title">Update account</h1>

            <% if (successMsg != null) {%>
            <div class="alert alert-success"><%= successMsg%></div>
            <% } %>
            <% if (errorMsg != null) {%>
            <div class="alert alert-error">e<%= errorMsg%></div>
            <% }%>

            <form action="AccountController" method="POST">
                <input type="hidden" name="action" value="updateAccount">
                <input type="hidden" name="id"     value="<%=AccountUser%>">

                <div class="form-layout">

                    <%-- ===== BASIC INFO ===== --%>
                    <div class="form-section-title">Account information</div>

                    <div class="form-group full">
                        <label>Account (Email) <span class="required">*</span></label>
                        <input type="text" name="Account"
                               value="<%=AccountUser%>"
                               placeholder="Enter email"
                               readonly>
                        <span class="hint">Email cannot be changed after creation</span>
                    </div>

                    <div class="form-group">
                        <label>First name <span class="required">*</span></label>
                        <input type="text" name="fn"
                               value="<%= firstName%>"
                               placeholder="First name">
                    </div>

                    <div class="form-group">
                        <label>Last name <span class="required">*</span></label>
                        <input type="text" name="ln"
                               value="<%= lastName%>"
                               placeholder="Last name">
                    </div>

                    <div class="form-group">
                        <label>Phone number</label>
                        <input type="text" name="phone"
                               value="<%= phone%>"
                               placeholder="Phone number">
                    </div>

                    <div class="form-group">
                        <label>Date of birth</label>
                        <input type="date" name="dob"
                               value="<%= dob%>">
                    </div>

                    <div class="form-group">
                        <label>Gender</label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="gender" value="true"
                                       <%= "true".equals(gender) ? "checked" : ""%>> Male
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gender" value="false"
                                       <%= "false".equals(gender) ? "checked" : ""%>> Female
                            </label>
                        </div>
                    </div>

                    <%-- ===== ROLE & STATUS ===== --%>
                    <div class="form-section-title mt">Role &amp; Status</div>

                    <div class="form-group">
                        <label>Role in system</label>
                        <select name="role">
                            <option value="Administrator" <%= "Administrator".equals(AccountRole) ? "selected" : ""%>>Administrator</option>
                            <option value="Staff"         <%= "Staff".equals(AccountRole) ? "selected" : ""%>>Staff</option>
                            <option value="User"          <%= "User".equals(AccountRole) ? "selected" : ""%>>User</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Account status</label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="active" value="true"
                                   <%= isActive ? "checked" : ""%>>
                            Is active
                        </label>
                    </div>

                    <%-- ===== RESET PASSWORD ===== --%>
                    <input type="hidden" name="action" value="updateAccount">
                    <div class="form-section-title mt">Reset password (optional)</div>

                    <div class="form-group">
                        <label>New password</label>
                        <input type="password" name="newPassword"
                               placeholder="Leave blank to keep current">
                    </div>

                    <div class="form-group">
                        <label>Confirm new password</label>
                        <input type="password" name="confirmPassword"
                               placeholder="Repeat new password">
                    </div>

                    <%-- ===== ACTIONS ===== --%>
                    <div class="form-actions">
                        <button type="submit" class="btn-save">Save changes</button>
                        <input type="hidden" name="Password"     value="<%=pass%>">
                        <a href="AccountController?action=updateAccount" class="btn-cancel">Cancel</a>
                    </div>

                </div>
            </form>
        </div>

    </body>
</html>
