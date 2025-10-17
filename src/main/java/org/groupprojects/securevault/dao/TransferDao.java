package org.groupprojects.securevault.dao;

import java.sql.*;

public class TransferDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    public static boolean processTransfer(int fromAccountNo, int toAccountNo, double amount) throws SQLException {
        boolean flag = false;
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        PreparedStatement ps4 = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            ps1 = con.prepareStatement("SELECT balance FROM personal_account WHERE account_no = ?");
            ps1.setInt(1, fromAccountNo);
            ResultSet rs1 = ps1.executeQuery();

            double currentBalance = 0;
            if (rs1.next()) {
                currentBalance = rs1.getDouble("balance");
            } else {
                System.out.println("ERROR: From account not found: " + fromAccountNo);
                rs1.close();
                return false;
            }
            rs1.close();

            if (currentBalance < amount) {
                System.out.println("ERROR: Insufficient balance. Current: " + currentBalance + ", Required: " + amount);
                return false;
            }

            ps2 = con.prepareStatement("SELECT account_no FROM personal_account WHERE account_no = ?");
            ps2.setInt(1, toAccountNo);
            ResultSet rs2 = ps2.executeQuery();

            if (!rs2.next()) {
                System.out.println("ERROR: To account not found: " + toAccountNo);
                rs2.close();
                return false;
            }
            rs2.close();

            ps3 = con.prepareStatement("UPDATE personal_account SET balance = balance - ? WHERE account_no = ?");
            ps3.setDouble(1, amount);
            ps3.setInt(2, fromAccountNo);
            int debitRows = ps3.executeUpdate();

            ps4 = con.prepareStatement("UPDATE personal_account SET balance = balance + ? WHERE account_no = ?");
            ps4.setDouble(1, amount);
            ps4.setInt(2, toAccountNo);
            int creditRows = ps4.executeUpdate();

            if (debitRows > 0 && creditRows > 0) {
                flag = true;
                System.out.println("DEBUG: Transfer successful - ₹" + amount + " from " + fromAccountNo + " to " + toAccountNo);
            }

        } catch (Exception e) {
            System.out.println("ERROR in processTransfer: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (flag) {
                    con.commit();
                } else {
                    con.rollback();
                }

                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (ps3 != null) ps3.close();
                if (ps4 != null) ps4.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return flag;
    }

    public static double getAccountBalance(int accountNo) throws SQLException {
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
            con.close();
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
            con.close();
        }
        return exists;
    }
}