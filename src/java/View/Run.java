/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package View;

import Model.Account;
import Model.Category;
import Model.Product;
import Model.dao.AccountDAO;
import Model.dao.CategoryDAO;
import Model.dao.ProductDAO;
import Utilities.ConnectDB;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author PC
 */
public class Run {

    public static void main(String[] args) {
        try {
            List<Product> temp = ProductDAO.getInstance().listSeconPage();
            for (Product p : temp) {
                System.out.println(p.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
