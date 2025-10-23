package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.Account;
import java.sql.*;

public class AccountDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    public Account getAccountByAccountNo(int accountNo) throws SQLException {
        Account account = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT * FROM personal_account WHERE account_no = ?");
            ps.setInt(1, accountNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                account = new Account();
                account.setAccountNo(rs.getInt("account_no"));
                account.setUserId(rs.getInt("user_id"));
                account.setName(rs.getString("name"));
                account.setBalance(rs.getDouble("balance"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return account;
    }

    public Account getAccountByUserId(int userId) throws SQLException {
        Account account = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT * FROM personal_account WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                account = new Account();
                account.setAccountNo(rs.getInt("account_no"));
                account.setUserId(rs.getInt("user_id"));
                account.setName(rs.getString("name"));
                account.setBalance(rs.getDouble("balance"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return account;
    }

    public boolean createAccount(Account account) throws SQLException {
        boolean flag = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);
            ps = con.prepareStatement("INSERT INTO personal_account (user_id, name, balance) VALUES (?, ?, ?)");
            ps.setInt(1, account.getUserId());
            ps.setString(2, account.getName());
            ps.setDouble(3, account.getBalance());

            int i = ps.executeUpdate();
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
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return flag;
    }

    public boolean depositMoney(int accountNo, double amount) throws SQLException {
        boolean flag = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);
            ps = con.prepareStatement("UPDATE personal_account SET balance = balance + ? WHERE account_no = ?");
            ps.setDouble(1, amount);
            ps.setInt(2, accountNo);

            int i = ps.executeUpdate();
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
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return flag;
    }
}