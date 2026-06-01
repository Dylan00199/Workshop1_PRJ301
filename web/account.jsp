<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Account" %> 
<%
    Account ac = (Account) session.getAttribute("login");
    String msg = (String) request.getAttribute("msg");
    String AccountRole = null;
    String AccountUser = null;
    if (ac != null) {
        AccountUser = ac.getAccount();
        int role = ac.getRoleInSystem();
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
    String firstName = ac.getFirstname();
    String lastName = ac.getLastname();
    String fullName = ac.getFirstname() + ", " + ac.getLastname();
    String phone = ac.getPhone();
    String dob = String.valueOf(ac.getDob());
    boolean isGender = ac.isGender();
    boolean isActive = ac.isUse();
    String gender = "Male";
    // Fallback values for display
    if (fullName == null || fullName.isEmpty()) {
        fullName = AccountUser;
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
//    boolean active = !"false".equalsIgnoreCase(isActive);

    // Build initials avatar (up to 2 chars)
    String[] parts = fullName.trim().split("\\s+");
    String initials = "";
    if (parts.length >= 2) {
        initials = String.valueOf(parts[0].charAt(0)) + String.valueOf(parts[parts.length - 1].charAt(0));
    } else if (parts.length == 1 && parts[0].length() > 0) {
        initials = String.valueOf(parts[0].charAt(0));
    }
    initials = initials.toUpperCase();

    // Error / success message from update action
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Account</title>
        <style>
            .page-content {
                padding: 32px;
                max-width: 860px;
            }

            h1.page-title {
                font-size: 26px;
                font-weight: 400;
                color: #222;
                margin-bottom: 28px;
            }

            /* ===== ALERT MESSAGES ===== */
            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .alert-success {
                background: #eafaf1;
                border: 1px solid #a9dfbf;
                color: #1e8449;
            }
            .alert-error {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                color: #c0392b;
            }

            /* ===== LAYOUT: SIDEBAR + MAIN ===== */
            .profile-wrap {
                display: grid;
                grid-template-columns: 220px 1fr;
                gap: 28px;
                align-items: start;
            }

            /* ===== SIDEBAR CARD ===== */
            .sidebar-card {
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 28px 20px;
                text-align: center;
                background: #fff;
            }

            .avatar-circle {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: #2980b9;
                color: #fff;
                font-size: 28px;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 14px;
                letter-spacing: 1px;
            }

            .sidebar-name {
                font-size: 16px;
                font-weight: 700;
                color: #222;
                margin-bottom: 4px;
                word-break: break-word;
            }
            .sidebar-username {
                font-size: 13px;
                color: #888;
                margin-bottom: 10px;
            }
            .badge-role {
                display: inline-block;
                padding: 3px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 700;
                letter-spacing: 0.3px;
            }
            .badge-admin {
                background: #fde8e8;
                color: #c0392b;
            }
            .badge-staff {
                background: #e8f4fd;
                color: #1a6fa0;
            }
            .badge-user {
                background: #eafaf1;
                color: #1e8449;
            }

            .status-row {
                margin-top: 14px;
                font-size: 12px;
                color: #aaa;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
            }
            .status-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #27ae60;
                display: inline-block;
            }
            .status-dot.inactive {
                background: #e74c3c;
            }

            .sidebar-divider {
                border: none;
                border-top: 1px solid #eee;
                margin: 18px 0;
            }

            .sidebar-nav {
                list-style: none;
                text-align: left;
            }
            .sidebar-nav li {
                margin-bottom: 2px;
            }
            .sidebar-nav a {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 7px 10px;
                border-radius: 5px;
                font-size: 13px;
                color: #444;
                text-decoration: none;
                cursor: pointer;
            }
            .sidebar-nav a:hover  {
                background: #f5f5f5;
            }
            .sidebar-nav a.active-tab {
                background: #e8f4fd;
                color: #1a6fa0;
                font-weight: 600;
            }
            .sidebar-nav .icon {
                font-size: 15px;
                width: 18px;
                text-align: center;
            }

            /* ===== MAIN PANEL ===== */
            .main-panel {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .info-card {
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                background: #fff;
                overflow: hidden;
            }
            .info-card-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 20px;
                border-bottom: 1px solid #f0f0f0;
                background: #fafafa;
            }
            .info-card-header h2 {
                font-size: 14px;
                font-weight: 700;
                color: #333;
                margin: 0;
                text-transform: uppercase;
                letter-spacing: 0.4px;
            }
            .btn-edit {
                font-size: 12px;
                padding: 4px 14px;
                border: 1px solid #2980b9;
                border-radius: 4px;
                color: #2980b9;
                background: #fff;
                cursor: pointer;
                text-decoration: none;
                font-weight: 600;
            }
            .btn-edit:hover {
                background: #e8f4fd;
            }

            /* ===== INFO GRID ===== */
            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                padding: 20px;
                gap: 18px 32px;
            }
            .info-item {
            }
            .info-item.full {
                grid-column: 1 / -1;
            }
            .info-label {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.4px;
                color: #aaa;
                margin-bottom: 4px;
            }
            .info-value {
                font-size: 14px;
                color: #222;
                font-weight: 500;
            }
            .info-value.muted {
                color: #aaa;
                font-weight: 400;
                font-style: italic;
            }

            /* ===== EDIT FORM (hidden by default) ===== */
            .edit-form {
                display: none;
                padding: 20px;
                border-top: 1px solid #f0f0f0;
            }
            .edit-form.open {
                display: block;
            }

            .edit-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px 24px;
            }
            .edit-group {
                display: flex;
                flex-direction: column;
            }
            .edit-group.full {
                grid-column: 1 / -1;
            }
            .edit-group label {
                font-size: 12px;
                font-weight: 600;
                color: #555;
                margin-bottom: 4px;
                text-transform: uppercase;
                letter-spacing: 0.3px;
            }
            .edit-group input,
            .edit-group select {
                padding: 7px 11px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                box-sizing: border-box;
            }
            .edit-group input:focus,
            .edit-group select:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .edit-actions {
                display: flex;
                gap: 10px;
                margin-top: 16px;
            }
            .btn-save {
                padding: 7px 22px;
                background: #2980b9;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #1f6fa0;
            }
            .btn-cancel-edit {
                padding: 7px 16px;
                background: #fff;
                color: #555;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 13px;
                cursor: pointer;
            }
            .btn-cancel-edit:hover {
                background: #f5f5f5;
            }

            /* ===== CHANGE PASSWORD CARD ===== */
            .pw-form {
                padding: 20px;
            }
            .pw-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px 24px;
            }
            .pw-group {
                display: flex;
                flex-direction: column;
            }
            .pw-group.full {
                grid-column: 1 / -1;
            }
            .pw-group label {
                font-size: 12px;
                font-weight: 600;
                color: #555;
                margin-bottom: 4px;
                text-transform: uppercase;
                letter-spacing: 0.3px;
            }
            .pw-group input {
                padding: 7px 11px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
            }
            .pw-group input:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .hint {
                font-size: 11px;
                color: #aaa;
                margin-top: 3px;
            }

            /* ===== DANGER ZONE ===== */
            .danger-card .info-card-header {
                background: #fff9f9;
                border-bottom-color: #fde8e8;
            }
            .danger-card .info-card-header h2 {
                color: #c0392b;
            }
            .danger-body {
                padding: 16px 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 16px;
            }
            .danger-desc {
                font-size: 13px;
                color: #666;
                line-height: 1.5;
            }
            .btn-danger {
                padding: 7px 18px;
                background: #fff;
                color: #e74c3c;
                border: 1px solid #e74c3c;
                border-radius: 5px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                white-space: nowrap;
            }
            .btn-danger:hover {
                background: #fdf2f2;
            }

            /* ===== ERROR ===== */
            .error-box {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                border-radius: 5px;
                padding: 10px 14px;
                font-size: 13px;
                color: #c0392b;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            @media (max-width: 680px) {
                .profile-wrap {
                    grid-template-columns: 1fr;
                }
                .info-grid, .edit-grid, .pw-grid {
                    grid-template-columns: 1fr;
                }
                .info-item.full, .edit-group.full, .pw-group.full {
                    grid-column: 1;
                }
            }

        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="page-title">My account</h1>

            <%-- ===== ALERTS ===== --%>
            <% if (successMsg != null) {%>
            <div class="alert alert-success">✔ <%= successMsg%></div>
            <% } %>
            <% if (errorMsg != null) {%>
            <div class="alert alert-error">✕ <%= errorMsg%></div>
            <% }%>

            <div class="profile-wrap">

                <%-- =========================================
                     SIDEBAR
                ========================================= --%>
                <div class="sidebar-card">
                    <div class="avatar-circle"><%= initials%></div>
                    <div class="sidebar-name"><%= fullName%></div>
                    <div class="sidebar-username"><%= AccountUser%></div>

                    <%
                        String roleClass = "badge-user";
                        if ("Administrator".equalsIgnoreCase(AccountRole))
                            roleClass = "badge-admin";
                        else if ("Staff".equalsIgnoreCase(AccountRole))
                            roleClass = "badge-staff";
                    %>
                    <span class="badge-role <%= roleClass%>"><%= AccountRole != null ? AccountRole : "User"%></span>

                    <div class="status-row">
                        <span class="status-dot <%= isActive ? "" : "inactive"%>"></span>
                        <%= isActive ? "Active" : "Inactive"%>
                    </div>

                    <hr class="sidebar-divider">

                    <ul class="sidebar-nav">
                        <li>
                            <a class="active-tab" onclick="showTab('info')">
                                <span class="icon">&#128100;</span> Profile info
                            </a>
                        </li>
                        <li>
                            <a onclick="showTab('password')">
                                <span class="icon">&#128274;</span> Change password
                            </a>
                        </li>
                    </ul>
                </div>

                <%-- =========================================
                     MAIN PANEL
                ========================================= --%>
                <div class="main-panel">

                    <%-- ===== TAB: PROFILE INFO ===== --%>
                    <div id="tab-info">

                        <%-- Personal info card --%>
                        <div class="info-card">
                            <div class="info-card-header">
                                <h2>Personal information</h2>
                                <a class="btn-edit" onclick="toggleEdit('personal')">Edit</a>
                            </div>

                            <%-- Display view --%>
                            <div class="info-grid" id="view-personal">
                                <div class="info-item">
                                    <div class="info-label">Full name</div>
                                    <div class="info-value"><%= fullName%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Username (email)</div>
                                    <div class="info-value"><%= AccountUser%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Phone number</div>
                                    <div class="info-value <%= phone.equals("—") ? "muted" : ""%>"><%= phone%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Date of birth</div>
                                    <div class="info-value <%= dob.equals("—") ? "muted" : ""%>"><%= dob%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value"><%= gender%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Role</div>
                                    <div class="info-value"><%= AccountRole != null ? AccountRole : "—"%></div>
                                </div>
                            </div>

                            <%-- Edit form --%>
                            <div class="edit-form" id="edit-personal">
                                <form action="AccountController" method="POST">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <div class="edit-grid">
                                        <div class="edit-group">
                                            <label>First name</label>
                                            <input type="text" name="fn" placeholder="First name" value="<%= firstName.equals("—") ? "" : firstName%>">
                                        </div>
                                        <div class="edit-group">
                                            <label>Last name</label>
                                            <input type="text" name="ln" placeholder="Last name" value="<%= lastName.equals("—") ? "" : lastName%>">
                                        </div>
                                        <div class="edit-group">
                                            <label>Phone number</label>
                                            <input type="text" name="phone"
                                                   placeholder="Phone number"
                                                   value="<%= phone.equals("—") ? "" : phone%>">
                                        </div>
                                        <div class="edit-group">
                                            <label>Date of birth</label>
                                            <input type="date" name="dob"
                                                   value="<%= dob.equals("—") ? "" : dob%>">
                                        </div>
                                        <div class="edit-group">
                                            <label>Gender</label>
                                            <select name="gender">
                                                <option value="true"  <%= "Male".equalsIgnoreCase(gender) ? "selected" : ""%>>Male</option>
                                                <option value="false" <%= "Female".equalsIgnoreCase(gender) ? "selected" : ""%>>Female</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="edit-actions">
                                        <button type="submit" class="btn-save">Save changes</button>
                                        <button type="button" class="btn-cancel-edit" onclick="toggleEdit('personal')">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <%-- Account status card --%>
                        <div class="info-card">
                            <div class="info-card-header">
                                <h2>Account status</h2>
                            </div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label">Status</div>
                                    <div class="info-value">
                                        <% if (isActive) { %>
                                        <span style="color:#27ae60; font-weight:700;">&#9679; Active</span>
                                        <% } else { %>
                                        <span style="color:#e74c3c; font-weight:700;">&#9679; Inactive</span>
                                        <% }%>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Role in system</div>
                                    <div class="info-value"><%= AccountRole != null ? AccountRole : "—"%></div>
                                </div>
                            </div>
                        </div>

                    </div><%-- end tab-info --%>

                    <%-- ===== TAB: CHANGE PASSWORD ===== --%>
                    <div id="tab-password" style="display:none">
                        <div class="info-card">
                            <div class="info-card-header">
                                <h2>Change password</h2>
                            </div>
                            <% if (msg != null) {%>
                            <div class="error-box"><%= msg%></div>
                            <% }%>

                            <div class="pw-form">
                                <form action="AccountController" method="POST">
                                    <input type="hidden" name="action" value="changePassword">
                                    <input type="hidden" name="accountToChangeP" value="<%=AccountUser%>">
                                    <div class="pw-grid">
                                        <div class="pw-group full">
                                            <label>Current password</label>
                                            <input type="password" name="currentPassword" placeholder="Enter current password" autocomplete="current-password">
                                        </div>
                                        <div class="pw-group">
                                            <label>New password</label>
                                            <input type="password" name="newPassword" id="newPw" placeholder="New password" autocomplete="new-password" oninput="checkStrength(this.value)">
                                            <div class="hint" id="pwStrength"></div>
                                        </div>
                                        <div class="pw-group">
                                            <label>Confirm new password</label>
                                            <input type="password" name="confirmPassword" placeholder="Repeat new password" autocomplete="new-password">
                                        </div>
                                    </div>
                                    <div class="edit-actions">
                                        <button type="submit" class="btn-save">Update password</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div><%-- end tab-password --%>

                    <%-- ===== DANGER ZONE ===== --%>
                    <div class="info-card danger-card" id="danger-zone" style="display:none">
                        <div class="info-card-header">
                            <h2>Danger zone</h2>
                        </div>
                        <div class="danger-body">
                            <div class="danger-desc">
                                Once you delete your account, all data will be permanently removed.<br>
                                This action cannot be undone.
                            </div>
                            <button class="btn-danger"
                                    onclick="return confirm('Are you sure you want to delete your account? This cannot be undone.')">
                                Delete account
                            </button>
                        </div>
                    </div>

                </div><%-- end main-panel --%>
            </div><%-- end profile-wrap --%>
        </div>

        <script>
            // ===== TAB SWITCHING =====
            function showTab(tab) {
                document.getElementById('tab-info').style.display = tab === 'info' ? 'flex' : 'none';
                document.getElementById('tab-password').style.display = tab === 'password' ? 'block' : 'none';
                document.getElementById('danger-zone').style.display = tab === 'password' ? 'block' : 'none';

                document.querySelectorAll('.sidebar-nav a').forEach(function (a) {
                    a.classList.remove('active-tab');
                });
                event.currentTarget.classList.add('active-tab');
            }

            // Fix initial tab-info display
            document.getElementById('tab-info').style.display = 'flex';
            document.getElementById('tab-info').style.flexDirection = 'column';
            document.getElementById('tab-info').style.gap = '20px';

            // ===== EDIT TOGGLE =====
            function toggleEdit(section) {
                var view = document.getElementById('view-' + section);
                var form = document.getElementById('edit-' + section);
                var isOpen = form.classList.contains('open');
                if (isOpen) {
                    form.classList.remove('open');
                } else {
                    form.classList.add('open');
                    form.scrollIntoView({behavior: 'smooth', block: 'nearest'});
                }
            }

            // ===== PASSWORD STRENGTH =====
            function checkStrength(val) {
                var el = document.getElementById('pwStrength');
                if (!val) {
                    el.textContent = '';
                    return;
                }
                var strong = val.length >= 8 && /[A-Z]/.test(val) && /[0-9]/.test(val);
                var medium = val.length >= 6;
                if (strong) {
                    el.textContent = '✔ Strong password';
                    el.style.color = '#27ae60';
                } else if (medium) {
                    el.textContent = '~ Medium — add numbers or uppercase';
                    el.style.color = '#e67e22';
                } else {
                    el.textContent = '✕ Too short (min 6 characters)';
                    el.style.color = '#e74c3c';
                }
            }

            <% if (msg != null) { %>
            showTab('password');
            document.querySelectorAll('.sidebar-nav a').forEach(function (a) {
                if (a.getAttribute('onclick') && a.getAttribute('onclick').includes('password')) {
                    a.classList.add('active-tab');
                }
            });
            <% }%>
        </script>

    </body>
</html>
