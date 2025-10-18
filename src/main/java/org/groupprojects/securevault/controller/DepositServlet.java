package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.DepositDao;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DepositServlet")
public class DepositServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accountNo = (Integer) session.getAttribute("accountNo");

        if (accountNo == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("deposit.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accountNo = (Integer) session.getAttribute("accountNo");

        if (accountNo == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String isQuickAdd = request.getParameter("isQuickAdd");

            if (amount <= 0) {
                request.setAttribute("error", "Please enter a valid amount greater than 0");
                request.getRequestDispatcher("deposit.jsp").forward(request, response);
                return;
            }

            if (amount > 100000) {
                request.setAttribute("error", "Maximum deposit limit is ₹1,00,000 per transaction");
                request.getRequestDispatcher("deposit.jsp").forward(request, response);
                return;
            }

            if ("true".equals(isQuickAdd) && "DIRECT_ADD".equals(paymentMethod)) {

                boolean accountExists = DepositDao.verifyAccountExists(accountNo);
                if (!accountExists) {
                    request.setAttribute("error", "Account not found. Please contact support.");
                    request.getRequestDispatcher("deposit.jsp").forward(request, response);
                    return;
                }

                String description = "Money added directly to account";
                boolean success = DepositDao.processDeposit(accountNo, amount, "DIRECT_ADD", description);

                if (success) {
                    double newBalance = DepositDao.getUpdatedBalance(accountNo);
                    session.setAttribute("balance", newBalance);

                    request.setAttribute("success", "₹" + String.format("%.2f", amount) + " added directly to your account!");
                    request.setAttribute("newBalance", newBalance);
                } else {
                    request.setAttribute("error", "Failed to add money. Please check console logs for details.");
                }
            } else {
                if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                    request.setAttribute("error", "Please select a payment method");
                    request.getRequestDispatcher("deposit.jsp").forward(request, response);
                    return;
                }

                boolean accountExists = DepositDao.verifyAccountExists(accountNo);
                if (!accountExists) {
                    request.setAttribute("error", "Account not found. Please contact support.");
                    request.getRequestDispatcher("deposit.jsp").forward(request, response);
                    return;
                }

                String description = "Money deposited via " + paymentMethod;
                boolean success = DepositDao.processDeposit(accountNo, amount, paymentMethod, description);

                if (success) {
                    double newBalance = DepositDao.getUpdatedBalance(accountNo);
                    session.setAttribute("balance", newBalance);

                    request.setAttribute("success", "₹" + String.format("%.2f", amount) + " deposited successfully via " + paymentMethod);
                    request.setAttribute("newBalance", newBalance);
                } else {
                    request.setAttribute("error", "Deposit failed. Please check console logs for details.");
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid amount");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("deposit.jsp").forward(request, response);
    }
}
