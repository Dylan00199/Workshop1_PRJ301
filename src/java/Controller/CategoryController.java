package Controller;

import Model.Category;
import Model.dao.CategoryDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CategoryController", urlPatterns = {"/CategoryController"})
public class CategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "listCategory"; // Mặc định nếu không có action
        }

        try {
            switch (action) {
                case "listCategory":
                    List<Category> list = CategoryDAO.getInstance().listAll();
                    request.setAttribute("categoryList", list);
                    request.getRequestDispatcher("listCategory.jsp").forward(request, response);
                    break;
                    
                case "deleteCategory":
                    String deleteId = request.getParameter("id");
                    Category delObj = CategoryDAO.getInstance().getObjectById(deleteId);
                    if (delObj != null) {
                        CategoryDAO.getInstance().deleteRec(delObj);
                    }
                    response.sendRedirect("CategoryController?action=listCategory");
                    break;
                    
                case "updateCategory":
                    // Sửa lỗi: Fetch data rồi forward sang trang JSP để hiển thị form
                    String updateId = request.getParameter("id");
                    Category upObj = CategoryDAO.getInstance().getObjectById(updateId);
                    
                    // Set attribute để JSTL/EL trong updateCategory.jsp lấy được dữ liệu
                    request.setAttribute("cat", upObj); 
                    request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                    break;
                    
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cực kì quan trọng để nhận tiếng Việt từ Form không bị lỗi font
        request.setCharacterEncoding("UTF-8"); 
        
        String action = request.getParameter("action");
        String categoryName = request.getParameter("categoryName");
        String memo = request.getParameter("memo");

        try {
            switch (action) {
                case "addCategory":
                    // Thường ID trong DB sẽ tự tăng, nên truyền ID là 0 để DB tự lo
                    Category newObj = new Category(0, categoryName, memo);
                    CategoryDAO.getInstance().insertRec(newObj);
                    response.sendRedirect("CategoryController?action=listCategory");
                    break;
                    
                case "updateCategory":
                    // Sửa lỗi: Phải lấy đúng ID từ thẻ input hidden trong JSP
                    int id = Integer.parseInt(request.getParameter("id"));
                    Category upObj = new Category(id, categoryName, memo);
                    
                    CategoryDAO.getInstance().updateRec(upObj);
                    
                    // Cập nhật thành công, set message và forward lại chính trang đó
                    request.setAttribute("success", "Category updated successfully!");
                    request.setAttribute("cat", upObj); // Giữ lại data để hiện lên form
                    request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                    break;
                    
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, quăng message ra giao diện JSP
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            if ("updateCategory".equals(action)) {
                request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
            } else {
                response.sendRedirect("CategoryController?action=listCategory");
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Category Controller - Standardized MVC";
    }
}