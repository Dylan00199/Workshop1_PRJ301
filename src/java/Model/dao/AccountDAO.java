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
import Model.Account;
import Utilities.ConnectDB;
import java.util.Date;

public class AccountDAO implements Accessible<Account> {

    public static AccountDAO getInstance() {
        return new AccountDAO();
    }

    @Override
    public int insertRec(Account obj) {
        Connection c = ConnectDB.getConnection();
        String sql = "INSERT INTO accounts (account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int rs = 0;
        try {
            PreparedStatement st = c.prepareStatement(sql);

            st.setString(1, obj.getAccount());
            st.setString(2, obj.getPass());
            st.setString(3, obj.getLastname());
            st.setString(4, obj.getFirstname());
            st.setDate(5, java.sql.Date.valueOf(obj.getDob().toString()));
            st.setBoolean(6, obj.isGender());
            st.setString(7, obj.getPhone());
            st.setBoolean(8, obj.isUse());
            st.setInt(9, obj.getRoleInSystem());

            rs = st.executeUpdate();
            ConnectDB.closeConnection(c);
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rs;
    }

    @Override
    public int updateRec(Account obj) {
        int rs = 0;
        try {
            Connection conn = ConnectDB.getConnection();
            String sql = "UPDATE accounts SET "
                    + "pass = ?, "
                    + "lastName = ?, "
                    + "firstName = ?, "
                    + "birthday = ?, "
                    + "gender = ?, "
                    + "phone = ?, "
                    + "isUse = ?, "
                    + "roleInSystem = ? "
                    + "WHERE account = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            //set value 
            ps.setString(1, obj.getPass());
            ps.setString(2, obj.getLastname());
            ps.setString(3, obj.getFirstname());
            ps.setDate(4, java.sql.Date.valueOf(obj.getDob().toString()));
            ps.setBoolean(5, obj.isGender());
            ps.setString(6, obj.getPhone());
            ps.setBoolean(7, obj.isUse());
            ps.setInt(8, obj.getRoleInSystem());
            ps.setString(9, obj.getAccount());

            rs = ps.executeUpdate();
            ConnectDB.closeConnection(conn);
            return rs;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Account updated fail");
        return rs;
    }
    
    public void updateIsUse(Account obj){
        Connection c = ConnectDB.getConnection();
        try {
            String sql = "UPDATE accounts SET isUse = ? WHERE account = ?;";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, String.valueOf(obj.isUse()));
            ps.setString(2, obj.getAccount());
            ps.executeUpdate();
            
            ConnectDB.closeConnection(c);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void updatePassword(Account obj, String newPassword){
        Connection c = ConnectDB.getConnection();
        try {
            String sql = "UPDATE accounts SET pass = ? WHERE account = ?;";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, obj.getAccount());
            ps.executeUpdate();
            
            ConnectDB.closeConnection(c);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int deleteRec(Account obj) {
        int result = 0;
        try {
            Connection c = ConnectDB.getConnection();
            String sql = "DELETE FROM accounts WHERE account = ?";

            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, obj.getAccount());

            result = ps.executeUpdate();
            ConnectDB.closeConnection(c);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public Account getObjectById(String id) {
        Connection c = ConnectDB.getConnection();
        try {
            String sql = "SELECT * FROM accounts WHERE account = ?;";

            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, id);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String accuont = rs.getString("account");
                String pass = rs.getString("pass");
                String ln = rs.getString("lastName");
                String fn = rs.getString("firstName");
                Date dob = rs.getDate("birthday");
                boolean gender = rs.getBoolean("gender");
                String phone = rs.getString("phone");
                boolean isUse = rs.getBoolean("isUse");
                int roleInSystem = rs.getInt("roleInSystem");

                Account a = new Account(accuont, pass, fn, ln, dob, gender, phone, isUse, roleInSystem);
                return a;
            }
            ConnectDB.closeConnection(c);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Account> listAll() {
        List<Account> result = new ArrayList<Account>();

        Connection c = ConnectDB.getConnection();
        try {
            Statement st = c.createStatement();
            String sql = "SELECT * FROM accounts";

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String accuont = rs.getString("account");
                String pass = rs.getString("pass");
                String ln = rs.getString("lastName");
                String fn = rs.getString("firstName");
                Date dob = rs.getDate("birthday");
                boolean gender = rs.getBoolean("gender");
                String phone = rs.getString("phone");
                boolean isUse = rs.getBoolean("isUse");
                int roleInSystem = rs.getInt("roleInSystem");

                Account a = new Account(accuont, pass, fn, ln, dob, gender, phone, isUse, roleInSystem);
                result.add(a);
            }
            ConnectDB.closeConnection(c);
        } catch (SQLException ex) {
            Logger.getLogger(AccountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

}
