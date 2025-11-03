package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.User;
import org.groupprojects.securevault.model.Loan;
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

            // FIXED: Changed from 'accounts' to 'personal_account' to match your database schema
            String accountSql = "SELECT account_no FROM personal_account WHERE user_id = ?";
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
                    String otherAccount = (rs.getInt("from_account") == accountNo) ?
                        String.valueOf(rs.getInt("to_account")) :
                        String.valueOf(rs.getInt("from_account"));

                    String statement = String.format("TXN ID: %d | %s | %s: %s | Amount: ₹%.2f | Date: %s | Status: %s",
                            rs.getInt("transaction_id"),
                            rs.getTimestamp("transaction_date").toString().substring(0, 16),
                            type,
                            otherAccount.equals("0") ? "System" : ("Account " + otherAccount),
                            rs.getDouble("amount"),
                            rs.getTimestamp("transaction_date").toString().substring(0, 16),
                            rs.getString("status"));
                    statements.add(statement);
                }

                // Close current result set and statement before next query
                if (rs != null) rs.close();
                if (ps != null) ps.close();

                // Try to get deposits for this account
                try {
                    String depositSql = "SELECT * FROM deposits WHERE account_no = ? ORDER BY deposit_date DESC LIMIT 25";
                    ps = con.prepareStatement(depositSql);
                    ps.setInt(1, accountNo);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        String statement = String.format("DEP ID: %d | %s | DEPOSIT | Method: %s | Amount: ₹%.2f | Status: %s",
                                rs.getInt("deposit_id"),
                                rs.getTimestamp("deposit_date").toString().substring(0, 16),
                                rs.getString("payment_method"),
                                rs.getDouble("amount"),
                                rs.getString("status"));
                        statements.add(statement);
                    }
                } catch (Exception e) {
                    // Deposits table might not exist or no deposits found
                    System.out.println("No deposits found for account " + accountNo + ": " + e.getMessage());
                }

                // If no statements found, add informative message
                if (statements.isEmpty()) {
                    statements.add("No transaction history found for Account #" + accountNo);
                    statements.add("This user has not performed any banking transactions yet.");
                }
            } else {
                statements.add("ERROR: No account found for User ID: " + userId);
                statements.add("This user may not have a bank account created.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            statements.add("ERROR: Failed to retrieve user statements - " + e.getMessage());
            statements.add("Please check database connection and ensure tables exist.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return statements;
    }

    // FIXED: Complete deleteUser method that handles all related data
    public boolean deleteUser(int userId) throws SQLException {
        boolean flag = false;
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        PreparedStatement ps4 = null;
        PreparedStatement ps5 = null;
        PreparedStatement ps6 = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            System.out.println("DEBUG: Starting delete process for user ID: " + userId);

            // First, get the account number for this user to delete related data
            String getAccountQuery = "SELECT account_no FROM personal_account WHERE user_id = ?";
            PreparedStatement psGetAccount = con.prepareStatement(getAccountQuery);
            psGetAccount.setInt(1, userId);
            ResultSet accountRs = psGetAccount.executeQuery();

            int accountNo = 0;
            if (accountRs.next()) {
                accountNo = accountRs.getInt("account_no");
                System.out.println("DEBUG: Found account number: " + accountNo);
            }
            accountRs.close();
            psGetAccount.close();

            // Delete in proper order to avoid foreign key constraint violations

            // 1. Delete transactions involving this account
            if (accountNo > 0) {
                ps1 = con.prepareStatement("DELETE FROM transactions WHERE from_account = ? OR to_account = ?");
                ps1.setInt(1, accountNo);
                ps1.setInt(2, accountNo);
                int transactionDeletes = ps1.executeUpdate();
                System.out.println("DEBUG: Deleted " + transactionDeletes + " transactions");
            }

            // 2. Delete deposits for this account
            if (accountNo > 0) {
                try {
                    ps2 = con.prepareStatement("DELETE FROM deposits WHERE account_no = ?");
                    ps2.setInt(1, accountNo);
                    int depositDeletes = ps2.executeUpdate();
                    System.out.println("DEBUG: Deleted " + depositDeletes + " deposits");
                } catch (Exception e) {
                    System.out.println("DEBUG: No deposits table or no deposits to delete: " + e.getMessage());
                }
            }

            // 3. Delete loans for this user
            try {
                ps3 = con.prepareStatement("DELETE FROM loans WHERE user_id = ?");
                ps3.setInt(1, userId);
                int loanDeletes = ps3.executeUpdate();
                System.out.println("DEBUG: Deleted " + loanDeletes + " loans");
            } catch (Exception e) {
                System.out.println("DEBUG: No loans table or no loans to delete: " + e.getMessage());
            }

            // 4. Delete personal account
            if (accountNo > 0) {
                ps4 = con.prepareStatement("DELETE FROM personal_account WHERE user_id = ?");
                ps4.setInt(1, userId);
                int accountDeletes = ps4.executeUpdate();
                System.out.println("DEBUG: Deleted " + accountDeletes + " personal accounts");
            }

            // 5. Delete login credentials
            ps5 = con.prepareStatement("DELETE FROM login WHERE user_id = ?");
            ps5.setInt(1, userId);
            int loginDeletes = ps5.executeUpdate();
            System.out.println("DEBUG: Deleted " + loginDeletes + " login records");

            // 6. Finally, delete the user record
            ps6 = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
            ps6.setInt(1, userId);
            int userDeletes = ps6.executeUpdate();
            System.out.println("DEBUG: Deleted " + userDeletes + " user records");

            if (userDeletes > 0) {
                flag = true;
                System.out.println("DEBUG: User deletion successful!");
            } else {
                System.out.println("DEBUG: User deletion failed - no user record deleted");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR: Exception during user deletion: " + e.getMessage());
        } finally {
            try {
                if (flag == true) {
                    con.commit();
                    System.out.println("DEBUG: Transaction committed successfully");
                } else {
                    con.rollback();
                    System.out.println("DEBUG: Transaction rolled back due to failure");
                }

                // Close all prepared statements
                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (ps3 != null) ps3.close();
                if (ps4 != null) ps4.close();
                if (ps5 != null) ps5.close();
                if (ps6 != null) ps6.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return flag;
    }

    // Get all pending loans for admin approval
    public List<Loan> getAllPendingLoans() throws SQLException {
        List<Loan> loans = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            String query = "SELECT l.*, lt.loan_name, u.name as user_name, u.email " +
                          "FROM loans l " +
                          "JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id " +
                          "JOIN users u ON l.user_id = u.user_id " +
                          "WHERE l.status = 'PENDING' " +
                          "ORDER BY l.application_date DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Loan loan = new Loan();
                loan.setLoanId(rs.getInt("loan_id"));
                loan.setUserId(rs.getInt("user_id"));
                loan.setAccountNo(rs.getInt("account_no"));
                loan.setLoanTypeId(rs.getInt("loan_type_id"));
                loan.setLoanTypeName(rs.getString("loan_name"));
                loan.setLoanAmount(rs.getDouble("loan_amount"));
                loan.setInterestRate(rs.getDouble("interest_rate"));
                loan.setTenureMonths(rs.getInt("tenure_months"));
                loan.setMonthlyEmi(rs.getDouble("monthly_emi"));
                loan.setTotalAmount(rs.getDouble("total_amount"));
                loan.setStatus(rs.getString("status"));
                loan.setApplicationDate(rs.getTimestamp("application_date"));
                loan.setPurpose(rs.getString("purpose"));
                // Additional user info for admin view
                loan.setUserName(rs.getString("user_name"));
                loan.setUserEmail(rs.getString("email"));
                loans.add(loan);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
        return loans;
    }

    // Approve or reject a loan
    public boolean updateLoanStatus(int loanId, String status) throws SQLException {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            // First get loan details
            String getLoanQuery = "SELECT account_no, loan_amount FROM loans WHERE loan_id = ?";
            ps1 = con.prepareStatement(getLoanQuery);
            ps1.setInt(1, loanId);
            rs = ps1.executeQuery();

            int accountNo = 0;
            double loanAmount = 0;
            if (rs.next()) {
                accountNo = rs.getInt("account_no");
                loanAmount = rs.getDouble("loan_amount");
            }
            rs.close();
            ps1.close();

            // Update loan status
            String updateLoanQuery = "UPDATE loans SET status = ?, approval_date = CURRENT_TIMESTAMP";
            if ("APPROVED".equals(status)) {
                updateLoanQuery += ", disbursement_date = CURRENT_TIMESTAMP";
            }
            updateLoanQuery += " WHERE loan_id = ?";

            ps2 = con.prepareStatement(updateLoanQuery);
            ps2.setString(1, status);
            ps2.setInt(2, loanId);
            int result1 = ps2.executeUpdate();

            // If approved, add amount to account balance
            if ("APPROVED".equals(status) && result1 > 0 && accountNo > 0) {
                String updateBalanceQuery = "UPDATE personal_account SET balance = balance + ? WHERE account_no = ?";
                ps3 = con.prepareStatement(updateBalanceQuery);
                ps3.setDouble(1, loanAmount);
                ps3.setInt(2, accountNo);
                int result2 = ps3.executeUpdate();

                if (result2 > 0) {
                    con.commit();
                    success = true;
                } else {
                    con.rollback();
                }
            } else if ("REJECTED".equals(status) && result1 > 0) {
                con.commit();
                success = true;
            } else {
                con.rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                con.rollback();
            }
        } finally {
            if (rs != null) rs.close();
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (ps3 != null) ps3.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
        return success;
    }
}
