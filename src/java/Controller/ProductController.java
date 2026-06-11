/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Account;
import Model.Category;
import Model.Product;
import Model.dao.ProductDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author PC
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
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
        switch (action) {
            case "listProduct":
                List<Product> list = ProductDAO.getInstance().listAll();
                request.setAttribute("list", list);
                request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                break;

            case "deleteProduct":
                String delId = request.getParameter("id");
                if (delId == null || delId.isEmpty()) {
                    return;
                }
                Product del = ProductDAO.getInstance().getObjectById(delId);
                ProductDAO.getInstance().deleteRec(del);
                response.sendRedirect("ProductController?action=listProduct");
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
                    Account account = (Account) session.getAttribute("login");

                    int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
                    int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;
                    int discount = (discountStr != null && !discountStr.isEmpty()) ? Integer.parseInt(discountStr) : 0;

                    java.sql.Date postDate = null;
                    if (postDateString != null && !postDateString.isEmpty()) {
                        postDate = java.sql.Date.valueOf(postDateString);
                    }

                    // ERRORRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
                    String imageUrl = null;
                    Part filePart = request.getPart("image");
                    if (filePart != null && filePart.getSize() > 0) {
                        String originalFileName = filePart.getSubmittedFileName();
                        String uploadDir = getServletContext().getRealPath("/uploads/");
                        File uploadFolder = new File(uploadDir);
                        if (!uploadFolder.exists()) uploadFolder.mkdirs();
                        filePart.write(uploadDir + originalFileName);
                        imageUrl = "/images/sanPham/" + originalFileName;
                    }

                    Product obj = new Product();
                    obj.setProductId(productId);
                    obj.setProductName(productName);
                    obj.setBrief(brief);
                    obj.setPrice(price);
                    obj.setDiscount(discount);
                    obj.setPostedDate(postDate);
                    obj.setAccount(account);
                    obj.setProductImage(imageUrl);

                    Category cat = new Category();
                    cat.setTypeId(categoryId);
                    obj.setType(cat);

                    ProductDAO.getInstance().insertRec(obj);
                    response.sendRedirect("index.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                    request.getRequestDispatcher("addProduct.jsp").forward(request, response);
                }
                break;

            case "updateProduct":
                try {
                    String id = request.getParameter("id");
                    String productName = request.getParameter("productName");
                    String categoryIdStr = request.getParameter("categoryId");
                    String postDateString = request.getParameter("postDate");
                    String brief = request.getParameter("brief");
                    String priceStr = request.getParameter("price");
                    String discountStr = request.getParameter("discount");
                    Account account = (Account) session.getAttribute("login");

                    String activeParam = request.getParameter("active");
                    boolean active = (activeParam != null) ? Boolean.parseBoolean(activeParam) : false;

                    int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
                    int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;
                    int discount = (discountStr != null && !discountStr.isEmpty()) ? Integer.parseInt(discountStr) : 0;

                    java.sql.Date postDate = null;
                    if (postDateString != null && !postDateString.isEmpty()) {
                        postDate = java.sql.Date.valueOf(postDateString);
                    }

                    //ERRORRRRRRRRRRRRRRRRRRRRRRR
                    String imageUrl = null;
                    Part filePart = request.getPart("image");
                    if (filePart != null && filePart.getSize() > 0) {
                        // Có file upload mới
                        String originalFileName = filePart.getSubmittedFileName();
                        String uploadDir = getServletContext().getRealPath("/uploads/");
                        File uploadFolder = new File(uploadDir);
                        if (!uploadFolder.exists()) uploadFolder.mkdirs();
                        filePart.write(uploadDir + originalFileName);
                        imageUrl = "/images/sanPham/" + originalFileName;
                    } else {
                        // Không có file → thử lấy URL text
                        String imageUrlParam = request.getParameter("imageUrl");
                        if (imageUrlParam != null && !imageUrlParam.trim().isEmpty()) {
                            imageUrl = imageUrlParam.trim();
                        } else {
                            // Giữ ảnh cũ từ DB
                            Product existing = ProductDAO.getInstance().getObjectById(id);
                            if (existing != null) imageUrl = existing.getProductImage();
                        }
                    }

                    Product obj = new Product();
                    obj.setProductId(id);
                    obj.setProductName(productName);
                    obj.setBrief(brief);
                    obj.setPrice(price);
                    obj.setDiscount(discount);
                    obj.setPostedDate(postDate);
                    obj.setAccount(account);
                    obj.setProductImage(imageUrl);

                    Category cat = new Category();
                    cat.setTypeId(categoryId);
                    obj.setType(cat);

                    ProductDAO.getInstance().updateRec(obj);
                    response.sendRedirect("index.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                    request.getRequestDispatcher("updateProduct.jsp?id=" + request.getParameter("id")).forward(request, response);
                }
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
