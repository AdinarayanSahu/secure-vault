package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.StatementDao;
import org.groupprojects.securevault.model.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

@WebServlet("/UserStatementsServlet")
public class UserStatementsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String filterValue = request.getParameter("filterValue");

        try {
            // Get user account details
            Connection con = DBConnection.getConnection();
            if (con == null) {
                System.out.println("ERROR: Database connection is null!");
                response.sendRedirect("DashboardServlet");
                return;
            }

            String query = "SELECT account_no, name, balance FROM personal_account WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int accountNo = rs.getInt("account_no");
                String userName = rs.getString("name");
                double balance = rs.getDouble("balance");

                System.out.println("DEBUG: Found account " + accountNo + " for user " + userName + " with balance " + balance);

                // Set account details
                request.setAttribute("accountNo", accountNo);
                request.setAttribute("userName", userName);
                request.setAttribute("balance", balance);

                // Get transactions based on filter
                List<String> transactions;
                if (filterValue != null && !filterValue.isEmpty()) {
                    System.out.println("DEBUG: Getting filtered transactions for type: " + filterValue);
                    transactions = StatementDao.getStatementsByType(accountNo, filterValue);
                } else {
                    System.out.println("DEBUG: Getting all transactions for account: " + accountNo);
                    transactions = StatementDao.getStatementsByAccount(accountNo);
                }

                System.out.println("DEBUG: Found " + transactions.size() + " transactions");
                if (transactions.size() == 0) {
                    System.out.println("DEBUG: No transactions found - check if data exists in database tables");
                }

                request.setAttribute("transactions", transactions);
                request.setAttribute("filterValue", filterValue);

                // Calculate totals for display
                double totalCredits = 0.0;
                double totalDebits = 0.0;
                int depositCount = 0;
                int transferCount = 0;

                for (String transaction : transactions) {
                    String[] parts = transaction.split(" \\| ");
                    if (parts.length >= 3) {
                        String type = parts[1];
                        String amountStr = parts[2].replace("₹", "").trim();
                        try {
                            double amount = Double.parseDouble(amountStr);
                            if (type.contains("Deposit") || type.contains("Transfer In")) {
                                totalCredits += amount;
                                if (type.contains("Deposit")) depositCount++;
                                if (type.contains("Transfer")) transferCount++;
                            } else {
                                totalDebits += amount;
                                if (type.contains("Transfer")) transferCount++;
                            }
                        } catch (NumberFormatException e) {
                            System.out.println("DEBUG: Error parsing amount: " + amountStr);
                        }
                    }
                }

                request.setAttribute("totalCredits", totalCredits);
                request.setAttribute("totalDebits", totalDebits);
                request.setAttribute("depositCount", depositCount);
                request.setAttribute("transferCount", transferCount);

            } else {
                System.out.println("DEBUG: No account found for userId: " + userId);
                response.sendRedirect("login.jsp");
                return;
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            System.out.println("ERROR in UserStatementsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
            return;
        }

        // Forward to the JSP
        request.getRequestDispatcher("user-statements.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}