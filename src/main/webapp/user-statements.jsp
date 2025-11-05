<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Statements - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    Double balance = (Double) session.getAttribute("balance");

    if (name == null || accountNo == null || balance == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - Account Statements</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Account Statements</h3>
        <p>Account: <%= accountNo %> | Name: <%= name %></p>
    </div>

    <div class="balance-card">
        <h3>Current Balance</h3>
        <div class="balance-amount">₹ <%= String.format("%.2f", balance) %></div>
    </div>

    <div class="table-container">
        <h3>Transaction History</h3>

        <%
            List<String> transactions = (List<String>) request.getAttribute("transactions");
            if (transactions != null && !transactions.isEmpty()) {
        %>
        <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <thead>
            <tr style="background-color: #2c3e50; color: white;">
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Date</th>
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Type</th>
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Description</th>
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Amount</th>
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Balance After</th>
            </tr>
            </thead>
            <tbody>
            <%
                double currentBalance = balance;
                for (String transaction : transactions) {
                    String[] parts = transaction.split(" \\| ");
                    if (parts.length >= 4) {
                        String date = parts[0].trim();
                        String type = parts[1].trim();
                        String amountStr = parts[2].trim();
                        String description = parts[3].trim();

                        double amount;
                        try {
                            String cleanAmount = amountStr.replace("₹", "").trim();
                            amount = Double.parseDouble(cleanAmount);
                        } catch (NumberFormatException e) {
                            amount = 0.0;
                        }

                        boolean isCredit;
                        if (type.equals("Transfer In") || type.equals("Deposit")) {
                            isCredit = true;
                        } else if (type.equals("Transfer Out")) {
                            isCredit = false;
                        } else {
                            isCredit = false;
                        }

                        String amountPrefix = isCredit ? "+" : "-";
                        String displayAmount = String.format("%.2f", amount);
                        String amountColor = isCredit ? "#27ae60" : "#e74c3c";
                        double balanceAfterTransaction = currentBalance;
            %>
            <tr style="border-bottom: 1px solid #ddd;">
                <td style="padding: 12px; border: 1px solid #ddd;"><%= date %></td>
                <td style="padding: 12px; border: 1px solid #ddd; font-weight: bold;"><%= type %></td>
                <td style="padding: 12px; border: 1px solid #ddd;"><%= description %></td>
                <td style="padding: 12px; border: 1px solid #ddd; color: <%= amountColor %>; font-weight: bold;">
                    <%= amountPrefix %>₹ <%= displayAmount %>
                </td>
                <td style="padding: 12px; border: 1px solid #ddd;">₹ <%= String.format("%.2f", balanceAfterTransaction) %></td>
            </tr>
            <%
                        if (isCredit) {
                            currentBalance -= amount;
                        } else {
                            currentBalance += amount;
                        }
                    }
                }
            %>
            </tbody>
        </table>
        <%
            } else {
        %>
        <div style="text-align: center; padding: 40px; color: #666; font-style: italic;">
            <p>No transactions found for your account.</p>
        </div>
        <%
            }
        %>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp" class="btn">🏠 Back to Dashboard</a>
            <a href="deposit.jsp" class="btn btn-success">💰 Make Deposit</a>
            <a href="transfer.jsp" class="btn btn-primary">💸 Transfer Money</a>
        </div>
    </div>
</main>

<footer>
    <div class="footer-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="profile.jsp">Profile</a>
        <a href="my-loans.jsp">My Loans</a>
        <a href="user-statements.jsp">Statements</a>
    </div>
    <p>&copy; 2024 SecureVault. All rights reserved.</p>
</footer>

</body>
</html>
