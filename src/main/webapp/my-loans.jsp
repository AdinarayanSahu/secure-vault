<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.Loan" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Loans - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");

    if (name == null || accountNo == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - My Loans</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>My Loans</h3>
        <p>Account: <%= accountNo %> | Name: <%= name %></p>
    </div>

    <%
        List<Loan> userLoans = (List<Loan>) request.getAttribute("userLoans");
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        if (userLoans != null && !userLoans.isEmpty()) {
            for (Loan loan : userLoans) {
                String statusClass = "";
                switch(loan.getStatus().toLowerCase()) {
                    case "approved": statusClass = "alert-success"; break;
                    case "rejected": statusClass = "alert-error"; break;
                    case "pending": statusClass = "alert-warning"; break;
                    default: statusClass = "alert-info"; break;
                }
    %>
    <div class="content-section">
        <div class="table-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h4><%= loan.getLoanTypeName() %></h4>
                <span class="alert <%= statusClass %>" style="padding: 5px 15px; margin: 0; display: inline-block;">
                    <%= loan.getStatus() %>
                </span>
            </div>

            <table>
                <tr>
                    <td><strong>Loan Amount</strong></td>
                    <td>₹<%= String.format("%.2f", loan.getLoanAmount()) %></td>
                </tr>
                <tr>
                    <td><strong>Interest Rate</strong></td>
                    <td><%= loan.getInterestRate() %>% p.a.</td>
                </tr>
                <tr>
                    <td><strong>Tenure</strong></td>
                    <td><%= loan.getTenureMonths() %> months</td>
                </tr>
                <tr>
                    <td><strong>Monthly EMI</strong></td>
                    <td>₹<%= String.format("%.2f", loan.getMonthlyEmi()) %></td>
                </tr>
                <tr>
                    <td><strong>Total Amount</strong></td>
                    <td>₹<%= String.format("%.2f", loan.getTotalAmount()) %></td>
                </tr>
                <tr>
                    <td><strong>Application Date</strong></td>
                    <td><%= sdf.format(loan.getApplicationDate()) %></td>
                </tr>
                <% if (loan.getApprovalDate() != null) { %>
                <tr>
                    <td><strong>Approval Date</strong></td>
                    <td><%= sdf.format(loan.getApprovalDate()) %></td>
                </tr>
                <% } %>
            </table>

            <% if (loan.getPurpose() != null && !loan.getPurpose().isEmpty()) { %>
            <div style="margin-top: 15px; padding: 15px; background: #f8f9fa; border-radius: 5px; border-left: 4px solid #3498db;">
                <strong>Purpose:</strong> <%= loan.getPurpose() %>
            </div>
            <% } %>
        </div>
    </div>
    <%
        }
    } else {
    %>
    <div class="content-section">
        <h3>📋 No Loans Found</h3>
        <p>You haven't applied for any loans yet.</p>
        <a href="LoanServlet?action=apply" class="btn btn-success">Apply for Loan</a>
    </div>
    <%
        }
    %>

    <div class="navigation">
        <div class="nav-links">
            <a href="LoanServlet?action=apply" class="btn btn-success">Apply for New Loan</a>
            <a href="dashboard.jsp">Back to Dashboard</a>
        </div>
    </div>
</main>

<footer>
    <div class="footer-links">
        <a href="#about">About Us</a>
        <a href="#contact">Contact</a>
        <a href="#help">Help</a>
        <a href="#privacy">Privacy Policy</a>
    </div>
    <p>&copy; 2025 SecureVault. All rights reserved.</p>
</footer>

</body>
</html>
