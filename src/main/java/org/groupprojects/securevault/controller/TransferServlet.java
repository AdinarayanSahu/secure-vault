package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.TransferDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {

    // Database connection method
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    // Verify user password for transaction security
    private boolean verifyUserPassword(int userId, String password) {
        String sql = "SELECT l.password FROM login l WHERE l.user_id = ? AND l.password = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Returns true if password matches
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accountNo = (Integer) session.getAttribute("accountNo");

        if (accountNo == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("transfer.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer fromAccountNo = (Integer) session.getAttribute("accountNo");
        Integer userId = (Integer) session.getAttribute("userId");

        if (fromAccountNo == null || userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String toAccountNoStr = request.getParameter("toAccountNo");
            String amountStr = request.getParameter("amount");
            String transactionPassword = request.getParameter("transactionPassword");

            // Verify password for security
            if (transactionPassword == null || transactionPassword.trim().isEmpty()) {
                request.setAttribute("error", "Please enter your password to confirm the transfer");
                request.getRequestDispatcher("transfer.jsp").forward(request, response);
                return;
            }

            if (!verifyUserPassword(userId, transactionPassword)) {
                request.setAttribute("error", "Invalid password. Transfer cancelled for security reasons.");
                request.getRequestDispatcher("transfer.jsp").forward(request, response);
                return;
            }

            int toAccountNo = Integer.parseInt(toAccountNoStr);
            double amount = Double.parseDouble(amountStr);

            if (amount <= 0) {
                request.setAttribute("error", "Amount must be greater than 0");
                request.getRequestDispatcher("transfer.jsp").forward(request, response);
                return;
            }

            if (fromAccountNo == toAccountNo) {
                request.setAttribute("error", "Cannot transfer money to your own account");
                request.getRequestDispatcher("transfer.jsp").forward(request, response);
                return;
            }

            boolean transferSuccess = TransferDao.processTransfer(fromAccountNo, toAccountNo, amount);

            if (transferSuccess) {
                double newBalance = TransferDao.getAccountBalance(fromAccountNo);
                session.setAttribute("balance", newBalance);

                request.setAttribute("success", "Transfer successful! ₹" + String.format("%.2f", amount) + " transferred to account " + toAccountNo);
                request.setAttribute("newBalance", newBalance);
            } else {
                request.setAttribute("error", "Transfer failed. Please check recipient account number and your balance.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid account number or amount format");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during transfer: " + e.getMessage());
        }

        request.getRequestDispatcher("transfer.jsp").forward(request, response);
    }
}