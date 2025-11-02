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
            
            // Simple query to get all transactions first
            String sql = "SELECT * FROM transactions ORDER BY transaction_date DESC LIMIT 100";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                String statement = String.format("TRANSACTION ID: %d | From Account: %d | To Account: %d | Type: %s | Amount: ₹%.2f | Date: %s | Status: %s",
                        rs.getInt("transaction_id"),
                        rs.getInt("from_account"),
                        rs.getInt("to_account"),
                        rs.getString("transaction_type"),
                        rs.getDouble("amount"),
                        rs.getTimestamp("transaction_date").toString().substring(0, 16),
                        rs.getString("status"));
                statements.add(statement);
            }
            
            // Close first query
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            
            // Try to get deposits if the table exists
            try {
                String depositSql = "SELECT * FROM deposits ORDER BY deposit_date DESC LIMIT 50";
                ps = con.prepareStatement(depositSql);
                rs = ps.executeQuery();
                
                while (rs.next()) {
                    String statement = String.format("DEPOSIT ID: %d | Account: %d | Amount: ₹%.2f | Method: %s | Date: %s | Status: %s",
                            rs.getInt("deposit_id"),
                            rs.getInt("account_no"),
                            rs.getDouble("amount"),
                            rs.getString("payment_method"),
                            rs.getTimestamp("deposit_date").toString().substring(0, 16),
                            rs.getString("status"));
                    statements.add(statement);
                }
            } catch (Exception e) {
                // Deposits table might not exist, that's okay
                System.out.println("Deposits table not accessible: " + e.getMessage());
            }
            
            // If no statements found, add test data
            if (statements.isEmpty()) {
                statements.add("SAMPLE | Test Transaction | Account 1001 → Account 1002 | ₹1000.00 | 2024-11-02 | COMPLETED");
                statements.add("SAMPLE | Test Deposit | Account 1001 | ₹500.00 | 2024-11-01 | COMPLETED");
                statements.add("DATABASE INFO | No actual transactions found in database | Check if transactions table has data");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Add error information
            statements.add("ERROR: " + e.getMessage());
            statements.add("DATABASE CONNECTION ISSUE: Please check if the database is running and accessible");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return statements;
    }

    public List<String> getUserStatements(int userId) throws SQLException {
        List<String> statements = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            
            // Get user's account number first
            String accountSql = "SELECT account_no FROM accounts WHERE user_id = ?";
            ps = con.prepareStatement(accountSql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            int accountNo = 0;
            if (rs.next()) {
                accountNo = rs.getInt("account_no");
            }
            rs.close();
            ps.close();
            
            if (accountNo > 0) {
                // Get transactions for this account
                String transSql = "SELECT * FROM transactions WHERE from_account = ? OR to_account = ? ORDER BY transaction_date DESC LIMIT 50";
                ps = con.prepareStatement(transSql);
                ps.setInt(1, accountNo);
                ps.setInt(2, accountNo);
                rs = ps.executeQuery();
                
                while (rs.next()) {
                    String type = (rs.getInt("from_account") == accountNo) ? "TRANSFER OUT" : "TRANSFER IN";
                    String statement = String.format("%s | %s | Account: %d | Amount: ₹%.2f | Date: %s | Status: %s",
                            rs.getTimestamp("transaction_date").toString().substring(0, 16),
                            type,
                            (rs.getInt("from_account") == accountNo) ? rs.getInt("to_account") : rs.getInt("from_account"),
                            rs.getDouble("amount"),
                            rs.getTimestamp("transaction_date").toString().substring(0, 16),
                            rs.getString("status"));
                    statements.add(statement);
                }
                
                // Try to get deposits for this account
                rs.close();
                ps.close();
                
                try {
                    String depositSql = "SELECT * FROM deposits WHERE account_no = ? ORDER BY deposit_date DESC LIMIT 25";
                    ps = con.prepareStatement(depositSql);
                    ps.setInt(1, accountNo);
                    rs = ps.executeQuery();
                    
                    while (rs.next()) {
                        String statement = String.format("%s | DEPOSIT | Method: %s | Amount: ₹%.2f | Status: %s",
                                rs.getTimestamp("deposit_date").toString().substring(0, 16),
                                rs.getString("payment_method"),
                                rs.getDouble("amount"),
                                rs.getString("status"));
                        statements.add(statement);
                    }
                } catch (Exception e) {
                    // Deposits might not exist
                    System.out.println("No deposits found for user: " + e.getMessage());
                }
            } else {
                statements.add("No account found for this user");
            }
            
            if (statements.isEmpty()) {
                statements.add("No transaction history found for this user");
            }

        } catch (Exception e) {
            e.printStackTrace();
            statements.add("Error retrieving user statements: " + e.getMessage());
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
