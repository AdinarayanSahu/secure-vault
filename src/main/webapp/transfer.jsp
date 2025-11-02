<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Money - SecureVault</title>
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
    <h1>🏦 SecureVault - Transfer</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Transfer Money</h3>
        <p>From Account: <%= accountNo %></p>
    </div>

    <div class="balance-card">
        <h3>Available Balance</h3>
        <div class="balance-amount">₹ <%= String.format("%.2f", balance) %></div>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
            <br>Remaining Balance: ₹ <%= request.getAttribute("newBalance") %>
        </div>
    <% } %>

    <div class="content-section">
        <h2>Send Money</h2>

        <form action="TransferServlet" method="post">
            <div class="form-group">
                <label for="toAccountNo">To Account Number:</label>
                <input type="number" id="toAccountNo" name="toAccountNo" placeholder="Enter recipient account number" required>
            </div>

            <div class="form-group">
                <label for="amount">Amount to Transfer:</label>
                <input type="number" id="amount" name="amount" placeholder="Enter amount" required min="1" step="0.01" max="<%= balance %>">
            </div>

            <div class="form-group">
                <label for="transactionPassword">🔒 Enter Your Password (for security):</label>
                <input type="password" id="transactionPassword" name="transactionPassword" placeholder="Enter your login password" required>
                <small style="color: #666; font-size: 12px;">Please enter your account password to confirm this transfer</small>
            </div>

            <button type="submit" class="btn btn-primary">Transfer Money</button>
        </form>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp">Back to Dashboard</a>
            <a href="deposit.jsp">Deposit Money</a>
            <a href="UserStatementsServlet">View Statements</a>
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
