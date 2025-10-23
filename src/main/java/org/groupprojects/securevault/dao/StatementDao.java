package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StatementDao {

    public static List<String> getStatementsByAccount(int accountNo) {
        List<String> statements = new ArrayList<>();

        String sql = "SELECT 'Transfer Out' as type, amount, transaction_date, " +
                "CONCAT('To Account: ', to_account, ' - ', COALESCE(description, '')) as description " +
                "FROM transactions WHERE from_account = ? AND status = 'COMPLETED' " +
                "UNION ALL " +
                "SELECT 'Transfer In' as type, amount, transaction_date, " +
                "CONCAT('From Account: ', from_account, ' - ', COALESCE(description, '')) as description " +
                "FROM transactions WHERE to_account = ? AND status = 'COMPLETED' " +
                "UNION ALL " +
                "SELECT 'Deposit' as type, amount, deposit_date as transaction_date, " +
                "CONCAT(payment_method, ' - ', COALESCE(description, 'Money deposited')) as description " +
                "FROM deposits WHERE account_no = ? AND status = 'COMPLETED' " +
                "ORDER BY transaction_date DESC LIMIT 50";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, accountNo); // for transfers out
            ps.setInt(2, accountNo); // for transfers in
            ps.setInt(3, accountNo); // for deposits

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String formattedDate = rs.getTimestamp("transaction_date").toString().substring(0, 16);
                    String statement = String.format("%s | %s | ₹%.2f | %s",
                            formattedDate,
                            rs.getString("type"),
                            rs.getDouble("amount"),
                            rs.getString("description"));
                    statements.add(statement);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getStatementsByAccount: " + e.getMessage());
        }

        return statements;
    }

    public static List<String> getStatementsByType(int accountNo, String type) {
        List<String> statements = new ArrayList<>();
        String sql = "";

        if ("DEBIT".equalsIgnoreCase(type)) {
            sql = "SELECT 'Transfer Out' as type, amount, transaction_date, " +
                    "CONCAT('To Account: ', to_account, ' - ', COALESCE(description, '')) as description " +
                    "FROM transactions WHERE from_account = ? AND status = 'COMPLETED' " +
                    "ORDER BY transaction_date DESC";
        } else if ("CREDIT".equalsIgnoreCase(type)) {
            sql = "SELECT 'Transfer In' as type, amount, transaction_date, " +
                    "CONCAT('From Account: ', from_account, ' - ', COALESCE(description, '')) as description " +
                    "FROM transactions WHERE to_account = ? AND status = 'COMPLETED' " +
                    "UNION ALL " +
                    "SELECT 'Deposit' as type, amount, deposit_date as transaction_date, " +
                    "CONCAT(payment_method, ' - ', COALESCE(description, 'Money deposited')) as description " +
                    "FROM deposits WHERE account_no = ? AND status = 'COMPLETED' " +
                    "ORDER BY transaction_date DESC";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, accountNo);
            if ("CREDIT".equalsIgnoreCase(type)) {
                ps.setInt(2, accountNo);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String formattedDate = rs.getTimestamp("transaction_date").toString().substring(0, 16);
                    String statement = String.format("%s | %s | ₹%.2f | %s",
                            formattedDate,
                            rs.getString("type"),
                            rs.getDouble("amount"),
                            rs.getString("description"));
                    statements.add(statement);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getStatementsByType: " + e.getMessage());
        }

        return statements;
    }

    public static double getTotalCredits(int accountNo) {
        double total = 0.0;
        String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM ( " +
                "SELECT amount FROM transactions WHERE to_account = ? AND status = 'COMPLETED' " +
                "UNION ALL " +
                "SELECT amount FROM deposits WHERE account_no = ? AND status = 'COMPLETED' " +
                ") as credits";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, accountNo);
            ps.setInt(2, accountNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getDouble("total");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    public static double getTotalDebits(int accountNo) {
        double total = 0.0;
        String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM transactions " +
                "WHERE from_account = ? AND status = 'COMPLETED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, accountNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getDouble("total");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    public static int getTransactionCountByType(int accountNo, String transactionType) {
        int count = 0;
        String sql = "";

        switch (transactionType.toUpperCase()) {
            case "DEPOSIT":
                sql = "SELECT COUNT(*) as count FROM deposits WHERE account_no = ? AND status = 'COMPLETED'";
                break;
            case "TRANSFER":
                sql = "SELECT COUNT(*) as count FROM transactions WHERE (from_account = ? OR to_account = ?) AND status = 'COMPLETED'";
                break;
            case "WITHDRAWAL":
                sql = "SELECT COUNT(*) as count FROM transactions WHERE from_account = ? AND status = 'COMPLETED'";
                break;
            default:
                return 0;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, accountNo);
            if ("TRANSFER".equals(transactionType.toUpperCase())) {
                ps.setInt(2, accountNo);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("count");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
}