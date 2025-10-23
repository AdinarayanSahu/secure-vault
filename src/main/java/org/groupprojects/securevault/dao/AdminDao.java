package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT * FROM users");
            rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setAge(rs.getInt("age"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("mobile"));
                user.setAddress(rs.getString("address"));
                users.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return users;
    }

    public User getUserById(int userId) throws SQLException {
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT * FROM users WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setAge(rs.getInt("age"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("mobile"));
                user.setAddress(rs.getString("address"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return user;
    }

    public List<String> getAllStatements() throws SQLException {
        List<String> statements = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT * FROM transactions");
            rs = ps.executeQuery();

            while (rs.next()) {
                String statement = "ID: " + rs.getInt("transaction_id") +
                        " | Account: " + rs.getInt("from_account") +
                        " | Type: " + rs.getString("transaction_type") +
                        " | Amount: ₹" + rs.getDouble("amount") +
                        " | Date: " + rs.getTimestamp("transaction_date");
                statements.add(statement);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return statements;
    }

    public boolean deleteUser(int userId) throws SQLException {
        boolean flag = false;
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            ps1 = con.prepareStatement("DELETE FROM login WHERE user_id = ?");
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            ps2 = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
            ps2.setInt(1, userId);
            int i = ps2.executeUpdate();

            if (i > 0) {
                flag = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (flag == true) {
                    con.commit();
                } else {
                    con.rollback();
                }
                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return flag;
    }
}