package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    public boolean createAccount(Account account) {
        String sql = "INSERT INTO personal_account (user_id, name, balance) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, account.getUserId());
            ps.setString(2, account.getName());
            ps.setDouble(3, account.getBalance());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Account> getAccountsByUser(int userId) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM personal_account WHERE user_id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Account account = mapResultSetToAccount(rs);
                    accounts.add(account);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return accounts;
    }

    public Account getAccountByUserId(int userId) {
        Account account = null;
        String sql = "SELECT * FROM personal_account WHERE user_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    account = mapResultSetToAccount(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return account;
    }

    public Account getAccountByAccountNo(int accountNo) {
        Account account = null;
        String sql = "SELECT * FROM personal_account WHERE account_no = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, accountNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    account = mapResultSetToAccount(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return account;
    }

    public boolean depositMoney(int accountNo, double amount, String paymentMethod) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            Account account = getAccountByAccountNo(accountNo);
            if (account == null) {
                con.rollback();
                return false;
            }

            String updateSql = "UPDATE personal_account SET balance = balance + ? WHERE account_no = ?";
            try (PreparedStatement ps1 = con.prepareStatement(updateSql)) {
                ps1.setDouble(1, amount);
                ps1.setInt(2, accountNo);
                ps1.executeUpdate();
            }

            String transactionSql = "INSERT INTO transactions (from_account, to_account, amount, transaction_date, transaction_type, payment_method, description) VALUES (?, ?, ?, NOW(), 'DEPOSIT', ?, ?)";
            try (PreparedStatement ps2 = con.prepareStatement(transactionSql)) {
                ps2.setInt(1, accountNo);
                ps2.setInt(2, accountNo);
                ps2.setDouble(3, amount);
                ps2.setString(4, paymentMethod);
                ps2.setString(5, "Money deposited via " + paymentMethod);
                ps2.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean depositMoney(int accountNo, double amount) {
        return depositMoney(accountNo, amount, "ONLINE");
    }

    // Helper method to map ResultSet to Account object
    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountNo(rs.getInt("account_no"));
        account.setUserId(rs.getInt("user_id"));
        account.setName(rs.getString("name"));
        account.setBalance(rs.getDouble("balance"));
        return account;
    }
}
