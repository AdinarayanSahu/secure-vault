package org.groupprojects.securevault.dao;

import java.sql.*;

public class DepositDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    public static boolean processDeposit(int accountNo, double amount, String paymentMethod, String description) {
        boolean flag = false;
        Connection con = null;
        PreparedStatement st1 = null;
        PreparedStatement st2 = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            st1 = con.prepareStatement("UPDATE personal_account SET balance = balance + ? WHERE account_no = ?");
            st1.setDouble(1, amount);
            st1.setInt(2, accountNo);
            int balanceUpdated = st1.executeUpdate();

            if (balanceUpdated > 0) {
                st2 = con.prepareStatement("INSERT INTO deposits (account_no, amount, payment_method, description, status) VALUES (?, ?, ?, ?, ?)");
                st2.setInt(1, accountNo);
                st2.setDouble(2, amount);
                st2.setString(3, paymentMethod);
                st2.setString(4, description);
                st2.setString(5, "COMPLETED");

                int depositInserted = st2.executeUpdate();
                if (depositInserted > 0) {
                    flag = true;
                }
            }

            if (flag) {
                con.commit();
            } else {
                con.rollback();
            }

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (st1 != null) st1.close();
                if (st2 != null) st2.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return flag;
    }

    public static double getUpdatedBalance(int accountNo) {
        double balance = 0.0;
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement("SELECT balance FROM personal_account WHERE account_no = ?")) {

            st.setInt(1, accountNo);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    balance = rs.getDouble("balance");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return balance;
    }

    public static boolean verifyAccountExists(int accountNo) {
        boolean exists = false;
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement("SELECT account_no FROM personal_account WHERE account_no = ?")) {

            st.setInt(1, accountNo);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    exists = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
}
