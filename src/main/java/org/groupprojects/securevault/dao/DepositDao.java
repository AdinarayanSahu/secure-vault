package org.groupprojects.securevault.dao;

import java.sql.*;

public class DepositDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    public static boolean processDeposit(int accountNo, double amount, String paymentMethod, String description) throws SQLException {
        boolean flag = false;
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            ps1 = con.prepareStatement("UPDATE personal_account SET balance = balance + ? WHERE account_no = ?");
            ps1.setDouble(1, amount);
            ps1.setInt(2, accountNo);
            int i = ps1.executeUpdate();

            if (i > 0) {
                ps2 = con.prepareStatement("INSERT INTO deposits (account_no, amount, payment_method, description, status) VALUES (?, ?, ?, ?, ?)");
                ps2.setInt(1, accountNo);
                ps2.setDouble(2, amount);
                ps2.setString(3, paymentMethod);
                ps2.setString(4, description);
                ps2.setString(5, "COMPLETED");

                int j = ps2.executeUpdate();
                if (j > 0) {
                    flag = true;
                }
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

    public static double getUpdatedBalance(int accountNo) throws SQLException {
        double balance = 0.0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT balance FROM personal_account WHERE account_no = ?");
            ps.setInt(1, accountNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                balance = rs.getDouble("balance");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return balance;
    }

    public static boolean verifyAccountExists(int accountNo) throws SQLException {
        boolean exists = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT account_no FROM personal_account WHERE account_no = ?");
            ps.setInt(1, accountNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return exists;
    }
}