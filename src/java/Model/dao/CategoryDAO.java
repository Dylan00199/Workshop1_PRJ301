/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.dao;

import Model.Category;
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
import Utilities.ConnectDB;
import java.util.Date;

public class CategoryDAO implements Accessible<Category> {

    public static CategoryDAO getInstance() {
        return new CategoryDAO();
    }

    @Override
    public int insertRec(Category obj) {
        Connection c = ConnectDB.getConnection();
        int rs = 0;
        try {
            String sql = "INSERT INTO categories (categoryName, memo) VALUES (?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, obj.getCategoryName());
            ps.setString(2, obj.getMemo());
            
            rs = ps.executeUpdate();
            ConnectDB.closeConnection(c);
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rs;
    }

    @Override
    public int updateRec(Category obj) {
        int rs = 0;
        try {
            Connection conn = ConnectDB.getConnection();
            String sql = "UPDATE categories SET "
                    + "categoryName = ?, "
                    + "memo = ? "
                    + "WHERE typeId = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, obj.getCategoryName());
            ps.setString(2, obj.getMemo());
            ps.setInt(3, obj.getTypeId());

            rs = ps.executeUpdate();
            ConnectDB.closeConnection(conn);
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Category updated fail");
        return rs;
    }

    @Override
    public int deleteRec(Category obj) {
        int result = 0;
        try {
            Connection c = ConnectDB.getConnection();
            String sql = "DELETE FROM categories WHERE typeId = ?";

            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, String.valueOf(obj.getTypeId()));

            result = ps.executeUpdate();
            ConnectDB.closeConnection(c);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public Category getObjectById(String id) {
        Connection c = ConnectDB.getConnection();
        try {
            String sql = "SELECT * FROM categories WHERE typeId = ?;";

            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, id);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int typeId = rs.getInt("typeId");
                String categoryName = rs.getString("categoryName");
                String memo = rs.getString("memo");

                Category temp = new Category(typeId, categoryName, memo);
                return temp;
            }
            ConnectDB.closeConnection(c);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Can't find category with id: " + id);
        return null;
    }

    @Override
    public List<Category> listAll() {
        Connection c = ConnectDB.getConnection();
        List<Category> list = new ArrayList<Category>();
        try {
            Statement st = c.createStatement();
            String sql = "SELECT * FROM categories";
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                int typeId = rs.getInt("typeId");
                String categoryName = rs.getString("categoryName");
                String memo = rs.getString("memo");

                Category temp = new Category(typeId, categoryName, memo);
                list.add(temp);
            }
            ConnectDB.closeConnection(c);
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

}
