<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="org.groupprojects.securevault.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
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

    String initial = user.getName() != null && !user.getName().isEmpty()
            ? user.getName().substring(0, 1).toUpperCase()
            : "U";
%>

<header>
    <h1>🏦 SecureVault - Profile</h1>
</header>

<main class="container">

    <% if (success != null) { %>
    <div class="alert success"><%= success %></div>
    <% } else if (error != null) { %>
    <div class="alert error"><%= error %></div>
    <% } %>

    <div class="profile-card">
        <div class="user-header">
            <h3><%= user.getName() %></h3>
            <p>Account: <%= accountNo %> | Balance: ₹<%= String.format("%.2f", balance) %></p>
        </div>

        <table class="info-table">
            <tr><td>Name:</td><td><%= user.getName() %></td></tr>
            <tr><td>Age:</td><td><%= user.getAge() %> years</td></tr>
            <tr><td>Email:</td><td><%= user.getEmail() %></td></tr>
            <tr><td>Mobile:</td><td><%= user.getPhone() %></td></tr>
            <tr><td>Address:</td><td><%= user.getAddress() %></td></tr>
            <tr><td>PAN:</td><td><%= user.getPanNo() != null ? user.getPanNo() : "Not Available" %></td></tr>
            <tr><td>Aadhaar:</td><td><%= user.getAadhaarNo() != null ?
                    "XXXX-XXXX-" + user.getAadhaarNo().substring(8) : "Not Available" %></td></tr>
        </table>
    </div>

    <div class="nav-links">
        <a href="DashboardServlet">← Back to Dashboard</a>
    </div>
</main>

<footer>
    <p>&copy; 2025 SecureVault. All rights reserved.</p>
</footer>

</body>
</html>
