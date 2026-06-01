/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Category;
import Model.dao.CategoryDAO;
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
@WebServlet(name = "CategoryController", urlPatterns = {"/CategoryController"})
public class CategoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CategoryController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CategoryController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "listCategory":
                List<Category> list = CategoryDAO.getInstance().listAll();
                request.setAttribute("categoryList", list);
                request.getRequestDispatcher("listCategory.jsp").forward(request, response);
                break;
            case "deleteCategory":
                Category obj = CategoryDAO.getInstance().getObjectById(request.getParameter("id"));
                CategoryDAO.getInstance().deleteRec(obj);
                response.sendRedirect("CategoryController?action=listCategory");
                break;
            case "updateCategory":
                Category up = CategoryDAO.getInstance().getObjectById(request.getParameter("id"));
                CategoryDAO.getInstance().updateRec(up);
                response.sendRedirect("CategoryController?action=listCategory");
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
        String categoryName = request.getParameter("categoryName");
        String memo = request.getParameter("memo");
        Category obj = new Category(1, categoryName, memo);

        switch (action) {
            case "addCategory":
                CategoryDAO.getInstance().insertRec(obj);
                String msg = "";
                response.sendRedirect("CategoryController?action=listCategory");
                break;
            case "updateCategory":
                CategoryDAO.getInstance().updateRec(obj);
                response.sendRedirect("CategoryController?action=listCategory");
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
