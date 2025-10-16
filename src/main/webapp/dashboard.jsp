<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SecureVault</title>
    <link rel="stylesheet" href="assets/css/main.css">
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
    <div class="container">
        <h1>🏦 SecureVault Dashboard</h1>
    </div>
</header>

<main class="container">
    <div class="dashboard-header">
        <h2>Welcome, <%= name %></h2>
        <p class="account-info">Account No: <strong><%= accountNo %></strong></p>
    </div>

    <div class="balance-card">
        <h3>Current Balance</h3>
        <div class="balance-amount">₹ <%= String.format("%.2f", balance) %></div>
    </div>

    <div class="dashboard-actions">
        <h3>Quick Actions</h3>
        <div class="action-grid">
            <a href="deposit.jsp" class="action-btn">
                <span class="icon">💰</span>
                <span>Deposit</span>
            </a>
            <a href="transfer.jsp" class="action-btn">
                <span class="icon">💸</span>
                <span>Transfer</span>
            </a>
            <a href="statements.jsp" class="action-btn">
                <span class="icon">📄</span>
                <span>Statements</span>
            </a>
            <a href="loan.jsp" class="action-btn">
                <span class="icon">🏠</span>
                <span>Loan</span>
            </a>
            <a href="kyc.jsp" class="action-btn">
                <span class="icon">📋</span>
                <span>Update KYC</span>
            </a>
            <a href="profile.jsp" class="action-btn">
                <span class="icon">👤</span>
                <span>Profile</span>
            </a>
        </div>
    </div>

    <div class="logout-section">
        <a href="index.jsp" class="logout-btn">Logout</a>
    </div>
</main>

<footer>
    <div class="container">
        <p>&copy; 2025 SecureVault. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
