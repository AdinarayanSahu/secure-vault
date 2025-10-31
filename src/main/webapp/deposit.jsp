<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deposit Money - SecureVault</title>
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
    <h1>🏦 SecureVault - Deposit</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Deposit Money</h3>
        <p>Account: <%= accountNo %> | Current Balance: ₹ <%= String.format("%.2f", balance) %></p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
            <br>New Balance: ₹ <%= request.getAttribute("newBalance") %>
        </div>
    <% } %>

    <div class="content-section">
        <h2>Add Money to Your Account</h2>

        <form action="DepositServlet" method="post">
            <div class="form-group">
                <label>Amount to Deposit:</label>
                <input type="number" name="amount" placeholder="Enter amount" required min="1" max="100000" step="0.01">
            </div>

            <div class="form-group">
                <label>Payment Method:</label>
                <select name="paymentMethod" required>
                    <option value="">Select Payment Method</option>
                    <option value="UPI">UPI</option>
                    <option value="NET_BANKING">Net Banking</option>
                    <option value="DEBIT_CARD">Debit Card</option>
                    <option value="CREDIT_CARD">Credit Card</option>
                    <option value="CASH">Cash</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Deposit Money</button>
        </form>
    </div>


    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp">Back to Dashboard</a>
            <a href="transfer.jsp">Transfer Money</a>
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
