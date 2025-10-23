<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="org.groupprojects.securevault.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile - SecureVault</title>
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
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h2 {
            color: #2c3e50;
            font-size: 28px;
        }

        .profile-card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .user-header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
            margin-bottom: 25px;
        }

        .avatar {
            width: 60px;
            height: 60px;
            background: #3498db;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
            margin: 0 auto 15px;
        }

        .user-header h3 {
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .user-header p {
            color: #7f8c8d;
            font-size: 14px;
        }

        .info-list {
            list-style: none;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f1f1f1;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            color: #2c3e50;
        }

        .info-value {
            color: #34495e;
            text-align: right;
        }

        .back-button {
            display: block;
            width: 100%;
            text-align: center;
            background: #3498db;
            color: white;
            padding: 12px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: background 0.3s;
        }

        .back-button:hover {
            background: #2980b9;
        }

        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>

<%
    User user = (User) request.getAttribute("user");
    Integer accountNo = (Integer) request.getAttribute("accountNo");
    Double balance = (Double) request.getAttribute("balance");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userInitial = user.getName() != null && !user.getName().isEmpty() ?
            user.getName().substring(0, 1).toUpperCase() : "U";
%>

<div class="container">
    <div class="header">
        <h2>Profile</h2>
    </div>

    <% if (success != null) { %>
    <div class="alert alert-success">
        <%= success %>
    </div>
    <% } %>

    <% if (error != null) { %>
    <div class="alert alert-error">
        <%= error %>
    </div>
    <% } %>

    <div class="profile-card">
        <div class="user-header">
            <div class="avatar">
                <%= userInitial %>
            </div>
            <h3><%= user.getName() %></h3>
            <p>Account: <%= accountNo %> | Balance: ₹<%= String.format("%.2f", balance) %></p>
        </div>

        <ul class="info-list">
            <li class="info-item">
                <span class="info-label">Name</span>
                <span class="info-value"><%= user.getName() %></span>
            </li>
            <li class="info-item">
                <span class="info-label">Age</span>
                <span class="info-value"><%= user.getAge() %> years</span>
            </li>
            <li class="info-item">
                <span class="info-label">Email</span>
                <span class="info-value"><%= user.getEmail() %></span>
            </li>
            <li class="info-item">
                <span class="info-label">Mobile</span>
                <span class="info-value"><%= user.getPhone() %></span>
            </li>
            <li class="info-item">
                <span class="info-label">Address</span>
                <span class="info-value"><%= user.getAddress() %></span>
            </li>
            <li class="info-item">
                <span class="info-label">PAN</span>
                <span class="info-value">
                    <%= user.getPanNo() != null ? user.getPanNo() : "Not Available" %>
                </span>
            </li>
            <li class="info-item">
                <span class="info-label">Aadhaar</span>
                <span class="info-value">
                    <%= user.getAadhaarNo() != null ?
                            "XXXX-XXXX-" + user.getAadhaarNo().substring(8) : "Not Available" %>
                </span>
            </li>
        </ul>
    </div>

    <a href="DashboardServlet" class="back-button">← Back to Dashboard</a>
</div>

</body>
</html>