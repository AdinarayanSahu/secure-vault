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
        <table>
            <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Description</th>
                <th>Amount</th>
                <th>Balance After</th>
            </tr>
            </thead>
            <tbody>
            <%
                // Transactions come from DB in DESC order (newest first)
                // Start with current balance and work backwards
                double currentBalance = balance;

                for (String transaction : transactions) {
                    String[] parts = transaction.split(" \\| ");
                    if (parts.length >= 4) {
                        String date = parts[0].trim();
                        String type = parts[1].trim();
                        String amountStr = parts[2].trim();
                        String description = parts[3].trim();

                        // Parse amount
                        double amount = 0.0;
                        try {
                            String cleanAmount = amountStr.replace("₹", "").trim();
                            amount = Double.parseDouble(cleanAmount);
                        } catch (NumberFormatException e) {
                            amount = 0.0;
                        }

                        // Determine if credit or debit for display
                        boolean isCredit = false;
                        if (type.equals("Transfer In") || type.equals("Deposit")) {
                            isCredit = true;
                        } else if (type.equals("Transfer Out")) {
                            isCredit = false;
                        }

                        // Set CSS class and inline styles for color coding
                        String amountClass = isCredit ? "amount-positive" : "amount-negative";
                        String amountPrefix = isCredit ? "+" : "-";
                        String displayAmount = String.format("%.2f", amount);
                        String inlineStyle = isCredit ? "color: #27ae60 !important; font-weight: bold !important;" : "color: #e74c3c !important; font-weight: bold !important;";

                        // Display the balance AFTER this transaction (current balance for newest)
                        double balanceAfterTransaction = currentBalance;
            %>
            <tr>
                <td class="transaction-date"><%= date %></td>
                <td class="transaction-type"><%= type %></td>
                <td class="transaction-description"><%= description %></td>
                <td class="transaction-amount <%= amountClass %>" style="<%= inlineStyle %>">
                    <%= amountPrefix %>₹<%= displayAmount %>
                </td>
                <td>₹ <%= String.format("%.2f", balanceAfterTransaction) %></td>
            </tr>
            <%
                        // Calculate balance BEFORE this transaction for next iteration
                        // Since we're going backwards in time (DESC order):
                        if (type.equals("Transfer In") || type.equals("Deposit")) {
                            currentBalance -= amount; // Remove credit to get previous balance
                        } else if (type.equals("Transfer Out")) {
                            currentBalance += amount; // Add back debit to get previous balance
                        }
                    }
                }
            %>
            </tbody>
        </table>
        <%
        } else {
        %>
        <div class="no-transactions">
            <p><strong>No transactions found for your account.</strong></p>
            <p>Start by making a deposit or transfer to see your transaction history.</p>
        </div>
        <%
            }
        %>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="DashboardServlet" class="btn">Back to Dashboard</a>
            <a href="deposit.jsp" class="btn btn-success">Deposit Money</a>
            <a href="transfer.jsp" class="btn btn-warning">Transfer Money</a>
        </div>
    </div>
</main>

<footer>
    <div class="footer-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="profile.jsp">Profile</a>
        <a href="LoginServlet?action=logout">Logout</a>
    </div>
    <p>&copy; 2025 SecureVault. All rights reserved.</p>
</footer>

</body>
</html>
