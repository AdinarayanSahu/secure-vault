<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="org.groupprojects.securevault.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    <h1>🏦 SecureVault - My Profile</h1>
</header>

<main class="container">

    <% if (success != null) { %>
    <div class="alert alert-success"><%= success %></div>
    <% } else if (error != null) { %>
    <div class="alert alert-error"><%= error %></div>
    <% } %>

    <div class="user-info">
        <h3><%= user.getName() %></h3>
        <p>Account: <%= accountNo %> | Balance: ₹<%= String.format("%.2f", balance) %></p>
    </div>

    <div class="content-section">
        <h3>Personal Information</h3>
        <table style="width: 100%; border-collapse: collapse;">
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold; width: 30%;">Name:</td>
                <td style="padding: 10px; border-bottom: 1px solid #ddd;"><%= user.getName() %></td>
            </tr>
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold;">Age:</td>
                <td style="padding: 10px; border-bottom: 1px solid #ddd;"><%= user.getAge() %> years</td>
            </tr>
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold;">Email:</td>
                <td style="padding: 10px; border-bottom: 1px solid #ddd;"><%= user.getEmail() %></td>
            </tr>
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold;">Mobile:</td>
                <td style="padding: 10px; border-bottom: 1px solid #ddd;"><%= user.getPhone() %></td>
            </tr>
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold;">Address:</td>
                <td style="padding: 10px; border-bottom: 1px solid #ddd;"><%= user.getAddress() %></td>
            </tr>
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold;">PAN:</td>
                <td style="padding: 10px; border-bottom: 1px solid #ddd;"><%= user.getPanNo() != null ? user.getPanNo() : "Not Available" %></td>
            </tr>
            <tr>
                <td style="padding: 10px; font-weight: bold;">Aadhaar:</td>
                <td style="padding: 10px;">
                    <% if (user.getAadhaarNo() != null && user.getAadhaarNo().length() >= 4) { %>
                        XXXX-XXXX-<%= user.getAadhaarNo().substring(user.getAadhaarNo().length() - 4) %>
                    <% } else { %>
                        Not Available
                    <% } %>
                </td>
            </tr>
        </table>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="DashboardServlet" class="btn"> Back to Dashboard</a>
            <a href="user-statements.jsp" class="btn btn-primary"> Statements</a>
            <a href="my-loans.jsp" class="btn btn-loan"> My Loans</a>
        </div>
    </div>
</main>

<footer>
    <div class="footer-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="profile.jsp">Profile</a>
        <a href="my-loans.jsp">My Loans</a>
        <a href="user-statements.jsp">Statements</a>
    </div>
    <p>&copy; 2024 SecureVault. All rights reserved.</p>
</footer>

</body>
</html>
