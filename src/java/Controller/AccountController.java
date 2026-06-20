package Controller;

import Model.Account;
import Model.dao.AccountDAO;
import Utilities.PasswordUtils;
import Utilities.ValidationUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
@WebServlet(name = "MainController", urlPatterns = {"/AccountController"})
public class AccountController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MainController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MainController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        String msg;
        switch (action) {
            case "displayAccount":
                Account login = (Account) session.getAttribute("login");
                if(login == null){
                    msg = "Please Login or Regist new account!";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
                String firstName = login.getFirstname();
                String lastName = login.getLastname();

                boolean firstEmpty = (firstName == null || firstName.isEmpty());
                boolean lastEmpty = (lastName == null || lastName.isEmpty());

                String fullName;
                if (firstEmpty && lastEmpty) {
                    fullName = login.getAccount();
                } else {
                    fullName = firstName + ", " + lastName;
                }

                request.setAttribute("fullName", fullName);
                request.getRequestDispatcher("account.jsp").forward(request, response);
                break;

            case "listAccount":
                List<Account> listAccount = AccountDAO.getInstance().listAll();
                request.setAttribute("listAccounts", listAccount);
                request.getRequestDispatcher("listAccount.jsp").forward(request, response);
                break;

            case "activeAccount":
                Account active = AccountDAO.getInstance().getObjectById(request.getParameter("id"));
                if (active != null) {
                    active.setIsUse(true);   // explicitly activate
                    AccountDAO.getInstance().updateIsUse(active);
                }
                response.sendRedirect("AccountController?action=listAccount");
                break;

            case "deactiveAccount":
                Account deactive = AccountDAO.getInstance().getObjectById(request.getParameter("id"));
                if (deactive != null) {
                    deactive.setIsUse(false);  // explicitly deactivate
                    AccountDAO.getInstance().updateIsUse(deactive);
                }
                response.sendRedirect("AccountController?action=listAccount");
                break;

            case "deleteAccount":
                Account del = AccountDAO.getInstance().getObjectById(request.getParameter("id"));
                AccountDAO.getInstance().deleteRec(del);
                response.sendRedirect("index.jsp");
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String msg;
        String action = request.getParameter("action");
        String account = request.getParameter("Account");
        String pw = request.getParameter("Password");
        String firstName = request.getParameter("fn");
        String lastName = request.getParameter("ln");
        String phone = request.getParameter("phone");
        boolean gender = Boolean.parseBoolean(request.getParameter("gender"));
        String roleParam = request.getParameter("role");

        int role = 3;
        if (roleParam != null && !roleParam.trim().isEmpty()) {
            try {
                role = Integer.parseInt(roleParam);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        } 
        // convert dob into date
        String dobString = request.getParameter("dob");
        java.sql.Date dob = null;
        if (dobString != null && !dobString.isEmpty()) {
            dob = java.sql.Date.valueOf(dobString);
        }
        Account obj = new Account(account, pw, firstName, lastName, dob, gender, phone, true, role);

        switch (action) {
            case "updateProfile":
                //check email
                if (!ValidationUtils.isValidEmail(account)) {
                    request.setAttribute("error_msg", "Invalid email!");
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }
                //chekc phone                
                if (!ValidationUtils.isValidPhone(phone)) {
                    request.setAttribute("error_msg", "Invalid phone number!");
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }
                AccountDAO.getInstance().updateRec(obj);
                request.setAttribute("success_msg", "Profile updated successfully!");
                request.getRequestDispatcher("account.jsp").forward(request, response);
                break;

            case "addAccount": {
                String errorMsg = null;
                if (!ValidationUtils.isValidEmail(account)) {
                    errorMsg = "Invalid email address.";
                } else if (!ValidationUtils.isStrongPassword(pw)) {
                    errorMsg = "Password must be at least 8 characters, contain an uppercase letter and a digit.";
                } else if (!ValidationUtils.isValidPhone(phone)) {
                    errorMsg = "Invalid Vietnamese phone number.";
                }

                if (errorMsg != null) {
                    request.setAttribute("error_msg", errorMsg);
                    request.setAttribute("prev_account", account);
                    request.setAttribute("prev_fn", firstName);
                    request.setAttribute("prev_ln", lastName);
                    request.setAttribute("prev_phone", phone);
                    request.setAttribute("prev_dob", dob);
                    request.setAttribute("prev_gender", gender);
                    request.getRequestDispatcher("addAccount.jsp").forward(request, response);
                    return;
                }

                AccountDAO.getInstance().insertRec(obj);
                response.sendRedirect("index.jsp");
                break;
            }

            case "changePassword":
                msg = "Change Password successfully!";
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                String accountToChangeP = request.getParameter("accountToChangeP");
                Account change = AccountDAO.getInstance().getObjectById(accountToChangeP);

                if (change == null) {
                    msg = "Account not found!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                if (!PasswordUtils.verify(currentPassword, change.getPass())) {
                    msg = "Incorrect current password!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                // Validate null
                if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                    msg = "Missing required fields!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                if (!ValidationUtils.isStrongPassword(newPassword)) {
                    msg = "The new password must contain more than 8 characters, which includes both uppercase character and number!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                if (!newPassword.equals(confirmPassword)) {
                    msg = "New Password doesn't match confirm Password!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                AccountDAO.getInstance().updatePassword(change, newPassword);
                request.setAttribute("success_msg", msg);
                request.getRequestDispatcher("account.jsp").forward(request, response);
                break;

            case "updateAccount":
                String newUpPassword = request.getParameter("newPassword");
                String confirmUpPassword = request.getParameter("confirmPassword");
                String pass = request.getParameter("Password");

                if (newUpPassword == null) {
                    newUpPassword = "";
                }
                if (confirmUpPassword == null) {
                    confirmUpPassword = "";
                }

                if (!newUpPassword.equals(confirmUpPassword)) {
                    msg = "Password doesn't match!";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("updateAccount.jsp").forward(request, response);
                    return;
                }

                Account update = new Account(account, pass, firstName, lastName, dob, gender, phone, true, role);
                AccountDAO.getInstance().updateRec(update);
                if (!newUpPassword.isEmpty()) {
                    AccountDAO.getInstance().updatePassword(update, newUpPassword);
                }
                response.sendRedirect("AccountController?action=listAccount");
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
