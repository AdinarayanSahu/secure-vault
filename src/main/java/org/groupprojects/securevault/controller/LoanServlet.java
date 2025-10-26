package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.LoanDao;
import org.groupprojects.securevault.model.Loan;
import org.groupprojects.securevault.model.LoanType;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoanServlet")
public class LoanServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response, request.getParameter("action"));
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response, request.getParameter("action"));
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response, String action) throws ServletException, IOException {
        if (action == null) action = "apply";

        try {
            switch (action) {
                case "apply":
                    if ("POST".equals(request.getMethod())) processLoanApplication(request, response);
                    else showLoanForm(request, response);
                    break;
                case "myloans": showUserLoans(request, response); break;
                case "admin": showAdminLoans(request, response); break;
                case "approve": approveLoan(request, response); break;
                case "reject": rejectLoan(request, response); break;
                default: showLoanForm(request, response);
            }
        } catch (Exception e) {
            showError(response, "Error: " + e.getMessage());
        }
    }

    private void showLoanForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("loanTypes", LoanDao.getAllLoanTypes());
            request.getRequestDispatcher("loan-application.jsp").forward(request, response);
        } catch (Exception e) {
            showError(response, "Error loading loan types");
        }
    }

    private void showUserLoans(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = checkSession(request, response, "userId");
        if (userId == null) return;

        try {
            request.setAttribute("userLoans", LoanDao.getLoansByUserId(userId));
            request.getRequestDispatcher("my-loans.jsp").forward(request, response);
        } catch (Exception e) {
            showError(response, "Error loading loans");
        }
    }

    private void showAdminLoans(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        try {
            request.setAttribute("pendingLoans", LoanDao.getAllPendingLoans());
            request.getRequestDispatcher("admin-loans.jsp").forward(request, response);
        } catch (Exception e) {
            showError(response, "Error loading pending loans");
        }
    }

    private void processLoanApplication(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = checkSession(request, response, "userId");
        Integer accountNo = checkSession(request, response, "accountNo");
        if (userId == null || accountNo == null) return;

        try {
            int loanTypeId = Integer.parseInt(request.getParameter("loanTypeId"));
            double loanAmount = Double.parseDouble(request.getParameter("loanAmount"));
            int tenureMonths = Integer.parseInt(request.getParameter("tenureMonths"));
            String purpose = request.getParameter("purpose");

            LoanType loanType = LoanDao.getLoanTypeById(loanTypeId);
            if (loanType == null || loanAmount < loanType.getMinAmount() || loanAmount > loanType.getMaxAmount()) {
                showMessage(response, "Invalid loan type or amount", false);
                return;
            }

            Loan loan = new Loan(userId, accountNo, loanTypeId, loanAmount, loanType.getInterestRate(), tenureMonths, purpose);
            showMessage(response, LoanDao.applyForLoan(loan) ? "Loan application submitted successfully" : "Failed to submit loan application", LoanDao.applyForLoan(loan));

        } catch (Exception e) {
            showError(response, "Error processing loan application");
        }
    }

    private void approveLoan(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        try {
            int loanId = Integer.parseInt(request.getParameter("loanId"));
            int accountNo = Integer.parseInt(request.getParameter("accountNo"));
            double amount = Double.parseDouble(request.getParameter("amount"));

            boolean success = LoanDao.updateLoanStatus(loanId, "APPROVED", accountNo, amount);
            showMessage(response, success ? "Loan approved successfully" : "Failed to approve loan", success);
        } catch (Exception e) {
            showError(response, "Error approving loan");
        }
    }

    private void rejectLoan(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        try {
            int loanId = Integer.parseInt(request.getParameter("loanId"));
            boolean success = LoanDao.updateLoanStatus(loanId, "REJECTED", 0, 0);
            showMessage(response, success ? "Loan rejected successfully" : "Failed to reject loan", success);
        } catch (Exception e) {
            showError(response, "Error rejecting loan");
        }
    }

    // Helper methods
    private Integer checkSession(HttpServletRequest request, HttpServletResponse response, String attribute) throws IOException {
        Integer value = (Integer) request.getSession().getAttribute(attribute);
        if (value == null) response.sendRedirect("login.jsp");
        return value;
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Boolean isAdmin = (Boolean) request.getSession().getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }

    private void showMessage(HttpServletResponse response, String message, boolean isSuccess) throws IOException {
        String color = isSuccess ? "#28a745" : "#dc3545";
        response.setContentType("text/html");
        response.getWriter().println("<html><head><title>Loan Status</title></head><body style='font-family: Arial; text-align: center; padding: 50px; background: #f5f5f5;'><div style='background: white; padding: 30px; border-radius: 10px; max-width: 500px; margin: 0 auto; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'><h2 style='color: " + color + ";'>" + (isSuccess ? "✓" : "✗") + " " + message + "</h2><a href='LoanServlet' style='background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin: 10px;'>Back to Loans</a><a href='DashboardServlet' style='background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin: 10px;'>Dashboard</a></div></body></html>");
    }

    private void showError(HttpServletResponse response, String error) throws IOException {
        showMessage(response, error, false);
    }
}
