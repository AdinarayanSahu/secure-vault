package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.Loan;
import org.groupprojects.securevault.model.LoanType;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanDao {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    // Get all loan types
    public static List<LoanType> getAllLoanTypes() throws SQLException {
        List<LoanType> loanTypes = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            String query = "SELECT * FROM loan_types ORDER BY loan_name";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                LoanType loanType = new LoanType(
                    rs.getInt("loan_type_id"),
                    rs.getString("loan_name"),
                    rs.getDouble("interest_rate"),
                    rs.getDouble("max_amount"),
                    rs.getDouble("min_amount"),
                    rs.getInt("max_tenure_months"),
                    rs.getString("description")
                );
                loanTypes.add(loanType);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
        return loanTypes;
    }

    // Get loan type by ID
    public static LoanType getLoanTypeById(int loanTypeId) throws SQLException {
        LoanType loanType = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            String query = "SELECT * FROM loan_types WHERE loan_type_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, loanTypeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                loanType = new LoanType(
                    rs.getInt("loan_type_id"),
                    rs.getString("loan_name"),
                    rs.getDouble("interest_rate"),
                    rs.getDouble("max_amount"),
                    rs.getDouble("min_amount"),
                    rs.getInt("max_tenure_months"),
                    rs.getString("description")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
        return loanType;
    }

    // Apply for a loan
    public static boolean applyForLoan(Loan loan) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            con = getConnection();
            String query = "INSERT INTO loans (user_id, account_no, loan_type_id, loan_amount, " +
                          "interest_rate, tenure_months, monthly_emi, total_amount, purpose, status) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

            ps = con.prepareStatement(query);
            ps.setInt(1, loan.getUserId());
            ps.setInt(2, loan.getAccountNo());
            ps.setInt(3, loan.getLoanTypeId());
            ps.setDouble(4, loan.getLoanAmount());
            ps.setDouble(5, loan.getInterestRate());
            ps.setInt(6, loan.getTenureMonths());
            ps.setDouble(7, loan.getMonthlyEmi());
            ps.setDouble(8, loan.getTotalAmount());
            ps.setString(9, loan.getPurpose());

            int result = ps.executeUpdate();
            success = result > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
        return success;
    }

    // Get loans by user ID
    public static List<Loan> getLoansByUserId(int userId) throws SQLException {
        List<Loan> loans = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            String query = "SELECT l.*, lt.loan_name FROM loans l " +
                          "JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id " +
                          "WHERE l.user_id = ? ORDER BY l.application_date DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, userId);
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
                loan.setApprovalDate(rs.getTimestamp("approval_date"));
                loan.setPurpose(rs.getString("purpose"));
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

    // Get all pending loans (for admin)
    public static List<Loan> getAllPendingLoans() throws SQLException {
        List<Loan> loans = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            String query = "SELECT DISTINCT l.loan_id, l.user_id, l.account_no, l.loan_type_id, " +
                          "l.loan_amount, l.interest_rate, l.tenure_months, l.monthly_emi, " +
                          "l.total_amount, l.status, l.application_date, l.approval_date, " +
                          "l.purpose, lt.loan_name FROM loans l " +
                          "JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id " +
                          "WHERE l.status = 'PENDING' ORDER BY l.application_date DESC";
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
                loan.setApprovalDate(rs.getTimestamp("approval_date"));
                loan.setPurpose(rs.getString("purpose"));
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

    // Approve or reject loan (for admin)
    public static boolean updateLoanStatus(int loanId, String status, int accountNo, double amount) throws SQLException {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        boolean success = false;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            // Update loan status
            String updateLoanQuery = "UPDATE loans SET status = ?, approval_date = CURRENT_TIMESTAMP";
            if ("APPROVED".equals(status)) {
                updateLoanQuery += ", disbursement_date = CURRENT_TIMESTAMP";
            }
            updateLoanQuery += " WHERE loan_id = ?";

            ps1 = con.prepareStatement(updateLoanQuery);
            ps1.setString(1, status);
            ps1.setInt(2, loanId);
            int result1 = ps1.executeUpdate();

            // If approved, add amount to account balance
            if ("APPROVED".equals(status) && result1 > 0) {
                String updateBalanceQuery = "UPDATE personal_account SET balance = balance + ? WHERE account_no = ?";
                ps2 = con.prepareStatement(updateBalanceQuery);
                ps2.setDouble(1, amount);
                ps2.setInt(2, accountNo);
                int result2 = ps2.executeUpdate();

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
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
        return success;
    }
}
