<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Statements - SecureVault</title>
    <link rel="stylesheet" href="assets/css/main.css">
    <style>
        .statement-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .statement-info span {
            font-weight: bold;
        }
        .transaction-list {
            background: white;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .transaction-header {
            background: #2c3e50;
            color: white;
            padding: 15px;
            font-weight: bold;
        }
        .transaction-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: grid;
            grid-template-columns: 100px 1fr 100px 1fr;
            gap: 15px;
            align-items: center;
        }
        .transaction-item:last-child {
            border-bottom: none;
        }
        .transaction-item:hover {
            background: #f9f9f9;
        }
        .transaction-date {
            font-size: 14px;
            color: #666;
        }
        .transaction-type {
            font-weight: bold;
        }
        .transaction-amount {
            text-align: right;
            font-weight: bold;
        }
        .amount-positive {
            color: #28a745;
        }
        .amount-negative {
            color: #dc3545;
        }
        .no-transactions {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .back-link {
            margin-top: 20px;
            text-align: center;
        }
        .back-link a {
            color: #2c3e50;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>

<%
    String userName = (String) request.getAttribute("userName");
    Integer accountNo = (Integer) request.getAttribute("accountNo");
    Double balance = (Double) request.getAttribute("balance");
    List<String> transactions = (List<String>) request.getAttribute("transactions");
%>

<header>
    <div class="container">
        <h1>🏦 Account Statements</h1>
    </div>
</header>

<main class="container">
    <div class="welcome-section">
        <div class="statement-info">
            <span>Account: <%= userName != null ? userName : "-" %> (#<%= accountNo != null ? accountNo : "-" %>)</span>
            <span>Balance: ₹ <%= balance != null ? String.format("%.2f", balance) : "0.00" %></span>
        </div>

        <div class="transaction-list">
            <div class="transaction-header">Recent Transactions</div>

            <% if (transactions != null && !transactions.isEmpty()) { %>
                <% for (String transaction : transactions) { %>
                    <%
                        String[] parts = transaction.split(" \\| ");
                        if (parts.length >= 4) {
                            String date = parts[0];
                            String type = parts[1];
                            String amount = parts[2];
                            String description = parts[3];

                            String amountClass = "";
                            if (type.contains("Deposit") || type.contains("Transfer In")) {
                                amountClass = "amount-positive";
                            } else {
                                amountClass = "amount-negative";
                            }
                    %>
                    <div class="transaction-item">
                        <div class="transaction-date"><%= date %></div>
                        <div class="transaction-type"><%= type %></div>
                        <div class="transaction-amount <%= amountClass %>"><%= amount %></div>
                        <div class="transaction-description"><%= description %></div>
                    </div>
                    <% } %>
                <% } %>
            <% } else { %>
                <div class="no-transactions">
                    <p>No transactions found.</p>
                </div>
            <% } %>
        </div>

        <div class="back-link">
            <a href="DashboardServlet">← Back to Dashboard</a>
        </div>
    </div>
</main>

<footer>
    <div class="container">
        <p>&copy; 2025 SecureVault. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
