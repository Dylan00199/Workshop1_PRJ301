
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>


    <body>
        <%-- ===== NAVBAR ===== --%>
        <%@ include file="navbar.jsp" %>
        <br>
        <h1>Add new account</h1>
        <br>

        <form action="AccountController" method="POST" class="Insert">
            <input type="hidden" name="action" value="addAccount">
            <span class="form-label">Account</span>
            <input type="text" name="Account" placeholder="Enter email" required>

            <span class="form-label">Password</span>
            <input type="password" name="Password" placeholder="Enter password" required>

            <span class="form-label">First name</span>
            <input type="text" name="fn" placeholder="First name" required>

            <span class="form-label">Last name</span>
            <input type="text" name="ln" placeholder="Last name" required>

            <span class="form-label">Phone number</span>
            <input type="text" name="phone" placeholder="Phone number" required>

            <span class="form-label">Birth day</span>
            <input type="date" name="dob" required>

            <span class="form-label">Gender</span>
            <div class="gender-group">
                <label><input type="radio" name="gender" value="True" checked> Male</label>
                <label><input type="radio" name="gender" value="False"> Female</label>
            </div>

            <span class="form-label">Role in system</span>
            <select name="role">
                <option>Administrator</option>
                <option>User</option>
                <option>Manager</option>
            </select>

            <span></span>
            <label class="active-row">
                <input type="checkbox" name="active" value="True"> Is active
            </label>

            <span></span>
            <input type="submit" value="Submit">

        </form>

        <style>
            .Insert {
                display: grid;
                grid-template-columns: 160px 1fr;
                align-items: center;
                row-gap: 12px;
                max-width: 860px;
            }

            .Insert input[type="text"],
            .Insert input[type="password"],
            .Insert input[type="date"] {
                width: 100%;
                height: 36px;
                padding: 0 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
            }

            .Insert select {
                width: 100%;
                height: 36px;
                padding: 0 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
            }

            .Insert .form-label {
                text-align: right;
                padding-right: 20px;
                font-weight: 500;
            }

            .gender-group {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .gender-group label {
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: normal;
                cursor: pointer;
            }

            .active-row {
                grid-column: 2;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .Insert input[type="submit"] {
                grid-column: 2;
                width: auto;
                padding: 6px 20px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background: #fff;
                cursor: pointer;
            }

            .Insert input[type="submit"]:hover {
                background: #f5f5f5;
            }
        </style>
    </body>
</html>
