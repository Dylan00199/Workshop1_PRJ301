/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import Model.Category;
import Model.Account;
import Model.Product;
import Utilities.ConnectDB;
import java.util.Date;

public class ProductDAO implements Accessible<Product> {

    public static ProductDAO getInstance() {
        return new ProductDAO();
    }

    @Override
    public int insertRec(Product obj) {
        Connection c = ConnectDB.getConnection();
        String sql = "INSERT INTO products (productId, productName, productImage, brief, postedDate, typeId, account, unit, price, discount) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int rs = 0;
        try {
            PreparedStatement st = c.prepareStatement(sql);

            st.setString(1, obj.getProductId());
            st.setString(2, obj.getProductName());
            st.setString(3, obj.getProductImage());
            st.setString(4, obj.getBrief());
            st.setDate(5, java.sql.Date.valueOf(obj.getPostedDate().toString()));
            st.setInt(6, obj.getType().getTypeId());
            st.setString(7, obj.getAccount().getAccount());
            st.setString(8, obj.getUnit());
            st.setDouble(9, obj.getPrice());
            st.setDouble(10, obj.getDiscount());

            rs = st.executeUpdate();
            ConnectDB.closeConnection(c);
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rs;
    }

    @Override
    public int updateRec(Product obj) {
        int rs = 0;
        try {
            Connection conn = ConnectDB.getConnection();
            String sql = "UPDATE products SET "
                    + "productName = ?, "
                    + "productImage = ?, "
                    + "brief = ?, "
                    + "postedDate = ?, "
                    + "typeId = ?, "
                    + "account = ?, "
                    + "unit = ?, "
                    + "price = ?, "
                    + "discount = ? "
                    + "WHERE productId = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, obj.getProductName());
            ps.setString(2, obj.getProductImage());
            ps.setString(3, obj.getBrief());
            ps.setDate(4, java.sql.Date.valueOf(obj.getPostedDate().toString()));
            ps.setInt(5, obj.getType().getTypeId());
            ps.setString(6, obj.getAccount().getAccount());
            ps.setString(7, obj.getUnit());
            ps.setDouble(8, obj.getPrice());
            ps.setDouble(9, obj.getDiscount());
            ps.setString(10, obj.getProductId());

            rs = ps.executeUpdate();
            ConnectDB.closeConnection(conn);
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Account updated fail");
        return rs;
    }

    @Override
    public int deleteRec(Product obj) {
        int result = 0;
        try {
            Connection c = ConnectDB.getConnection();
            String sql = "DELETE FROM products WHERE productId = ?";

            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, obj.getProductId());

            result = ps.executeUpdate();
            ConnectDB.closeConnection(c);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public Product getObjectById(String id) {
        Connection c = ConnectDB.getConnection();
        try {
            String sql = "SELECT * FROM products WHERE productId = ?;";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, id);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String productId = rs.getString("productId");
                String productName = rs.getString("productName");
                String productImage = rs.getString("productImage");
                String brief = rs.getString("brief");
                Date postedDate = rs.getDate("postedDate");

                //transfrom these to object
                int CategoryID = rs.getInt("typeId");
                String a = rs.getString("account");

                Category type = CategoryDAO.getInstance().getObjectById(String.valueOf(CategoryID));
                Account account = AccountDAO.getInstance().getObjectById(a);

                //return Category and Account object
                String unit = rs.getString("unit");
                int price = rs.getInt("price");
                int discount = rs.getInt("discount");

                Product p = new Product(productId, productName, productImage, brief, postedDate, type, account, unit, price, discount);
                ConnectDB.closeConnection(c);
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Product> listAll() {
        List<Product> result = new ArrayList<Product>();
        Connection c = ConnectDB.getConnection();

        Statement st;
        try {
            st = c.createStatement();
            String sql = "SELECT * FROM products";
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String productId = rs.getString("productId");
                String productName = rs.getString("productName");
                String productImage = rs.getString("productImage");
                String brief = rs.getString("brief");
                Date postedDate = rs.getDate("postedDate");
                //transfrom these to object
                int CategoryID = rs.getInt("typeId");
                String a = rs.getString("account");

                Category type = CategoryDAO.getInstance().getObjectById(String.valueOf(CategoryID));
                Account account = AccountDAO.getInstance().getObjectById(a);

                //return Category and Account object
                String unit = rs.getString("unit");
                int price = rs.getInt("price");
                int discount = rs.getInt("discount");

                Product p = new Product(productId, productName, productImage, brief, postedDate, type, account, unit, price, discount);
                result.add(p);
            }
            ConnectDB.closeConnection(c);
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

}
