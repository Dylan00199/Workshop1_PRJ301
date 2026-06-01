/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Account;
import Model.Category;
import Model.Product;
import Model.dao.ProductDAO;
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
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "";
        }
        int page = 1;
        switch (action) {
            case "listProduct":
                List<Product> list = ProductDAO.getInstance().listAll();
                request.setAttribute("list", list);
                request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                break;
            case "updateProduct":
                String id = request.getParameter("id");
                Product temp = ProductDAO.getInstance().getObjectById(id);
                ProductDAO.getInstance().updateRec(temp);
                response.sendRedirect("index.jsp");
                break;
            case "deleteProduct":
                String delId = request.getParameter("id");
                if (delId == null || delId.isEmpty()) {
                    return;
                }
                Product del = ProductDAO.getInstance().getObjectById(delId);
                ProductDAO.getInstance().deleteRec(del);
                response.sendRedirect("index.jsp");
                break;
            case "home":
                List<Product> listPublic = ProductDAO.getInstance().listAll();
                request.setAttribute("list", listPublic);
                request.getRequestDispatcher("index.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "";
        }
        int page = 1;
        switch (action) {
            case "addProduct":
                try {
                String productId = "SP" + (System.currentTimeMillis() % 100000);
                String productName = request.getParameter("productName");
                String categoryIdStr = request.getParameter("categoryId");
                String postDateString = request.getParameter("postDate");
                String brief = request.getParameter("brief");
                String priceStr = request.getParameter("price");
                String discountStr = request.getParameter("discount");
                String imageUrl = request.getParameter("imageUrl");

                String activeParam = request.getParameter("active");
                boolean active = (activeParam != null) ? Boolean.parseBoolean(activeParam) : false;

                int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
                int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;
                int discount = (discountStr != null && !discountStr.isEmpty()) ? Integer.parseInt(discountStr) : 0;

                java.sql.Date postDate = null;
                if (postDateString != null && !postDateString.isEmpty()) {
                    postDate = java.sql.Date.valueOf(postDateString);
                }

                Account account = (Account) session.getAttribute("login");

                Product obj = new Product();
                obj.setProductId(productId);
                obj.setProductName(productName);
                obj.setBrief(brief);
                obj.setPrice(price);
                obj.setDiscount(discount);
                obj.setPostedDate(postDate);
                obj.setAccount(account);

                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageUrl = "/images/sanPham/icon.jpg";
                }
                obj.setProductImage(imageUrl);

                Category cat = new Category();
                cat.setTypeId(categoryId);
                obj.setType(cat);

                ProductDAO.getInstance().insertRec(obj);
                response.sendRedirect("index.jsp");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
                request.getRequestDispatcher("addProduct.jsp").forward(request, response);
            }
            break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
