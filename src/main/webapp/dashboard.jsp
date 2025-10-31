<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
    <style>
        /* Override quick-actions to display 3 cards per row */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin: 20px 0;
        }

        .quick-action-card {
            text-decoration: none;
            color: inherit;
        }

        .quick-action-card:hover {
            text-decoration: none;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .quick-actions {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
    <h1>🏦 SecureVault Dashboard</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Welcome, <%= name %></h3>
        <p>Account Number: <%= accountNo %></p>
    </div>

    <div class="balance-card">
        <h3>Current Balance</h3>
        <div class="balance-amount">₹ <%= String.format("%.2f", balance) %></div>
    </div>

    <div class="quick-actions">
        <a href="deposit.jsp" class="quick-action-card">
            <img src="icons/deposit.png" alt="Deposit">
            <h4>Deposit</h4>
            <p>Add money to your account</p>
        </a>

        <a href="transfer.jsp" class="quick-action-card">
            <img src="icons/money.png" alt="Transfer">
            <h4>Transfer</h4>
            <p>Send money to others</p>
        </a>

        <a href="UserStatementsServlet" class="quick-action-card">
            <img src="icons/bank-statement.png" alt="Statements">
            <h4>Statements</h4>
            <p>View transaction history</p>
        </a>

        <a href="my-loans.jsp" class="quick-action-card">
            <img src="icons/loan.png" alt="Loan">
            <h4>Loans</h4>
            <p>Manage your loans</p>
        </a>

        <a href="kyc.jsp" class="quick-action-card">
            <img src="icons/kyc.png" alt="KYC">
            <h4>Update KYC</h4>
            <p>Update your information</p>
        </a>

        <a href="ProfileServlet" class="quick-action-card">
            <img src="icons/person.png" alt="Profile">
            <h4>Profile</h4>
            <p>View and edit profile</p>
        </a>
    </div>

    <div class="content-section">
        <a href="index.jsp" class="btn btn-danger">Logout</a>
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
