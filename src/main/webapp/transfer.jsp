<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transfer Money</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 3px;
            box-sizing: border-box;
        }
        .btn {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            width: 100%;
        }
        .btn:hover {
            background: #0056b3;
        }
        .error {
            color: red;
            margin: 10px 0;
            padding: 10px;
            background: #ffebee;
            border: 1px solid #f5c6cb;
            border-radius: 3px;
        }
        .success {
            color: green;
            margin: 10px 0;
            padding: 10px;
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 3px;
        }
        .balance-info {
            background: #e9ecef;
            padding: 10px;
            border-radius: 3px;
            margin-bottom: 20px;
            text-align: center;
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
        <h2>Transfer Money</h2>
        <p>From Account: <%= accountNo %></p>
    </div>

    <div class="balance-info">
        <strong>Available Balance: ₹ <%= String.format("%.2f", balance) %></strong>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
    <div class="success">
        <%= request.getAttribute("success") %>
        <% if (request.getAttribute("newBalance") != null) { %>
        <br><strong>New Balance: ₹ <%= request.getAttribute("newBalance") %></strong>
        <% } %>
    </div>
    <% } %>

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
            <button type="submit" class="btn">Transfer Money</button>
        </div>
    </form>

    <div style="text-align: center; margin-top: 20px;">
        <a href="DashboardServlet">Back to Dashboard</a>
    </div>
</div>

</body>
</html>