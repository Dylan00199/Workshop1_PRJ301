package Controller;

import Model.Account;
import Model.dao.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
            /* TODO output your page here. You may use following sample code. */
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
        String action = request.getParameter("action");
        switch (action) {
            case "listAccount":
                List<Account> listAccount = AccountDAO.getInstance().listAll();
                request.setAttribute("listAccounts", listAccount);
                request.getRequestDispatcher("listAccount.jsp").forward(request, response);
                break;
            case "activeAccount":
                Account active = AccountDAO.getInstance().getObjectById(request.getParameter("id"));
                AccountDAO.getInstance().updateIsUse(active);
                break;
            case "deactiveAccount":
                Account deactive = AccountDAO.getInstance().getObjectById(request.getParameter("id"));
                AccountDAO.getInstance().updateIsUse(deactive);
                break;
            case "deleteAccount":
                Account del = AccountDAO.getInstance().getObjectById(request.getParameter("id"));
                AccountDAO.getInstance().deleteRec(del);
                response.sendRedirect("AccountController?action=listAccount");
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        String account = request.getParameter("Account");
        String pw = request.getParameter("Password");
        String firstName = request.getParameter("fn");
        String lastName = request.getParameter("ln");
        String phone = request.getParameter("phone");
        boolean gender = Boolean.parseBoolean(request.getParameter("gender"));
        boolean active = Boolean.parseBoolean(request.getParameter("active"));

        //convert role into int
        int roleSystem = 3;
        String role = request.getParameter("role");
        if ("Administrator".equalsIgnoreCase(role)) {
            roleSystem = 1;
        } else if ("Manager".equals(role)) {
            roleSystem = 2;
        }
        //convert dob into date
        String dobString = request.getParameter("dob");
        java.sql.Date dob = null;
        if (dobString != null && !dobString.isEmpty()) {
            dob = java.sql.Date.valueOf(dobString);
        }
        Account obj = new Account(account, pw, firstName, lastName, dob, gender, phone, active, roleSystem);

        switch (action) {
            case "updateProfile":
                AccountDAO.getInstance().updateRec(obj);
                break;
            case "addAccount":
                AccountDAO.getInstance().insertRec(obj);
                break;
            case "changePassword":
                String msg = "";
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                String accountToChangeP = request.getParameter("accountToChangeP");

                // Validate null
                if (currentPassword == null || newPassword == null || confirmPassword == null) {
                    msg = "Missing required fields!";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }
                //case new pass doesn't match confirm pass
                if (!newPassword.equals(confirmPassword)) {
                    msg = "New Password doesn't match!";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return; // dùng return thay vì break để chắc chắn dừng
                }
                //case account = null
                Account change = AccountDAO.getInstance().getObjectById(accountToChangeP);
                if (change == null) {
                    msg = "Account not found!";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                // Nếu password được hash thì so sánh hash ở đây
                if (!currentPassword.equals(change.getPass())) {
                    msg = "Incorrect current password!";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    return;
                }

                AccountDAO.getInstance().updatePassword(change, newPassword);
                response.sendRedirect("index.jsp"); // redirect đúng chỗ
                return;
            case "updateAccount":
                String newUpPassword = request.getParameter("newPassword");
                String confirmUpPassword = request.getParameter("confirmPassword");
                String pass = request.getParameter("Password");

                //case new pass doesn't match confirm pass
                if (!newUpPassword.equals(confirmUpPassword)) {
                    msg = "Password doesn't match!";
                    request.setAttribute("error", msg);
                    request.getRequestDispatcher("updateAccount.jsp").forward(request, response);
                    return; // dùng return thay vì break để chắc chắn dừng
                }

                Account update = new Account(account, pass, firstName, lastName, dob, gender, phone, active, roleSystem);
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
    }// </editor-fold>

}
