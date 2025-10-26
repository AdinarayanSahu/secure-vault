<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - SecureVault</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            min-height: 100vh;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .balance {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            text-align: center;
            margin: 20px 0;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .balance h3 {
            margin-bottom: 10px;
            font-size: 24px;
        }

        .dashboard-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .action-btn {
            background: white;
            padding: 30px 20px;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            color: #2c3e50;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            color: #2c3e50;
        }

        .action-btn img {
            width: 48px;
            height: 48px;
            margin-bottom: 15px;
        }

        .action-btn span {
            display: block;
            font-weight: bold;
            font-size: 16px;
        }

        .logout-section {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
        }

        .logout-btn {
            background-color: #e74c3c;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 5px;
        }

        .logout-btn:hover {
            background-color: #c0392b;
            color: white;
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

<div class="container">
    <div class="header">
        <h2>Welcome, <%= name %></h2>
        <p>Account: <%= accountNo %></p>
    </div>

    <div class="balance">
        <h3>Current Balance</h3>
        <div style="font-size: 36px; font-weight: bold;">₹ <%= String.format("%.2f", balance) %></div>
    </div>

    <div class="dashboard-actions">
        <a href="deposit.jsp" class="action-btn">
            <img src="icons/deposit.png" alt="Deposit">
            <span>Deposit</span>
        </a>

        <a href="transfer.jsp" class="action-btn">
            <img src="icons/money.png" alt="Transfer">
            <span>Transfer</span>
        </a>

        <a href="UserStatementsServlet" class="action-btn">
            <img src="icons/bank-statement.png" alt="Statements">
            <span>Statements</span>
        </a>

        <a href="my-loans.jsp" class="action-btn">
            <img src="icons/loan.png" alt="Loan">
            <span>Loan</span>
        </a>

        <a href="kyc.jsp" class="action-btn">
            <img src="icons/kyc.png" alt="KYC">
            <span>Update KYC</span>
        </a>

        <a href="ProfileServlet" class="action-btn">
            <img src="icons/person.png" alt="Profile">
            <span>Profile</span>
        </a>
    </div>

    <div class="logout-section">
        <a href="index.jsp" class="logout-btn">Logout</a>
    </div>
</div>

</body>
</html>