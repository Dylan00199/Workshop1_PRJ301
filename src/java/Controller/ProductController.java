package Controller;

import Model.Account;
import Model.Category;
import Model.Product;
import Model.dao.ProductDAO;
import Model.dao.CategoryDAO; // Thêm import này để lấy list Category
import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // RẤT QUAN TRỌNG
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "listProduct";
        }
        
        switch (action) {
            case "listProduct":
                List<Product> list = ProductDAO.getInstance().listAll();
                request.setAttribute("products", list); // Đổi tên attribute cho khớp với JSTL
                request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                break;

            case "deleteProduct":
                String delId = request.getParameter("id");
                if (delId != null && !delId.isEmpty()) {
                    Product del = ProductDAO.getInstance().getObjectById(delId);
                    if(del != null) {
                        ProductDAO.getInstance().deleteRec(del);
                    }
                }
                response.sendRedirect("ProductController?action=listProduct");
                break;

            case "home":
                List<Product> listPublic = ProductDAO.getInstance().listAll();
                request.setAttribute("list", listPublic);
                request.getRequestDispatcher("index.jsp").forward(request, response);
                break;

            case "updateProduct":
                // Chuẩn MVC: Fetch data ở Servlet rồi ném sang JSP
                String updateId = request.getParameter("id");
                Product p = ProductDAO.getInstance().getObjectById(updateId);
                List<Category> cats = CategoryDAO.getInstance().listAll();
                
                request.setAttribute("p", p);
                request.setAttribute("cats", cats);
                request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        
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

                    // ĐÃ FIX LỖI UPLOAD ẢNH
                    String imageUrl = null;
                    Part filePart = request.getPart("image");
                    if (filePart != null && filePart.getSize() > 0) {
                        String originalFileName = filePart.getSubmittedFileName();
                        // Fix path: Đưa hẳn vào thư mục /images/sanPham/ để frontend gọi lên được
                        String uploadPath = getServletContext().getRealPath("/images/sanPham");
                        File uploadFolder = new File(uploadPath);
                        if (!uploadFolder.exists()) uploadFolder.mkdirs();
                        
                        filePart.write(uploadPath + File.separator + originalFileName);
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
                    // Nên redirect về trang quản lý thay vì index
                    response.sendRedirect("ProductController?action=listProduct");
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

                    int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
                    int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;
                    int discount = (discountStr != null && !discountStr.isEmpty()) ? Integer.parseInt(discountStr) : 0;

                    java.sql.Date postDate = null;
                    if (postDateString != null && !postDateString.isEmpty()) {
                        postDate = java.sql.Date.valueOf(postDateString);
                    }

                    // ĐÃ FIX LỖI UPLOAD ẢNH
                    String imageUrl = null;
                    Part filePart = request.getPart("image");
                    if (filePart != null && filePart.getSize() > 0) {
                        String originalFileName = filePart.getSubmittedFileName();
                        // Fix path
                        String uploadPath = getServletContext().getRealPath("/images/sanPham");
                        File uploadFolder = new File(uploadPath);
                        if (!uploadFolder.exists()) uploadFolder.mkdirs();
                        
                        filePart.write(uploadPath + File.separator + originalFileName);
                        imageUrl = "/images/sanPham/" + originalFileName;
                    } else {
                        String imageUrlParam = request.getParameter("imageUrl");
                        if (imageUrlParam != null && !imageUrlParam.trim().isEmpty()) {
                            imageUrl = imageUrlParam.trim();
                        } else {
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
                    // Nên redirect về trang quản lý thay vì index
                    response.sendRedirect("ProductController?action=listProduct");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                    // Nếu lỗi, điều hướng lại về trang update kèm theo ID để load lại form
                    response.sendRedirect("ProductController?action=updateProduct&id=" + request.getParameter("id") + "&error=System Error");
                }
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Product Controller - Handled Multipart & MVC";
    }
}