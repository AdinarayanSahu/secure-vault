<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update KYC - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    String currentPhone = (String) session.getAttribute("phone");
    String currentAddress = (String) session.getAttribute("address");
    String currentAadhaar = (String) session.getAttribute("aadhaarNo");
    String currentEmail = (String) session.getAttribute("email");
    String currentPan = (String) session.getAttribute("panNo");

    if (name == null || accountNo == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - Update KYC</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Update KYC Information</h3>
        <p>Account: <%= accountNo %> | Name: <%= name %></p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>

    <div class="content-section">
        <h2>Update Your Information</h2>
        <p>Keep your KYC information up to date for secure banking</p>

        <form action="KYCServlet" method="post">
            <div class="form-group">
                <label>Email Address:</label>
                <input type="email" name="email" placeholder="Enter email address"
                       value="<%= currentEmail != null ? currentEmail : "" %>"
                       maxlength="100" required>
                <small style="color: #666;">Valid email address for notifications</small>
            </div>

            <div class="form-group">
                <label>Mobile Number:</label>
                <input type="tel" name="phone" placeholder="Enter mobile number"
                       value="<%= currentPhone != null ? currentPhone : "" %>"
                       pattern="[0-9]{10}" maxlength="10" required>
                <small style="color: #666;">10-digit mobile number</small>
            </div>

            <div class="form-group">
                <label>PAN Card Number:</label>
                <input type="text" name="panNo" placeholder="Enter PAN number"
                       value="<%= currentPan != null ? currentPan : "" %>"
                       pattern="[A-Z]{5}[0-9]{4}[A-Z]{1}" maxlength="10" required
                       style="text-transform: uppercase;">
                <small style="color: #666;">10-character PAN number (e.g., ABCDE1234F)</small>
            </div>

            <div class="form-group">
                <label>Aadhaar Number:</label>
                <input type="text" name="aadhaarNo" placeholder="Enter Aadhaar number"
                       value="<%= currentAadhaar != null ? currentAadhaar : "" %>"
                       pattern="[0-9]{12}" maxlength="12" required>
                <small style="color: #666;">12-digit Aadhaar number</small>
            </div>

            <div class="form-group">
                <label>Address:</label>
                <textarea name="address" placeholder="Enter complete address"
                          rows="4" maxlength="200" required><%= currentAddress != null ? currentAddress : "" %></textarea>
                <small style="color: #666;">Complete residential address</small>
            </div>

            <button type="submit" class="btn btn-primary">Update KYC Information</button>
        </form>
    </div>

    <div class="content-section">
        <h3>Important Notes</h3>
        <ul style="text-align: left; color: #666; max-width: 500px; margin: 0 auto;">
            <li>Ensure all information is accurate and up to date</li>
            <li>Email will be used for account notifications and statements</li>
            <li>Mobile number will be used for transaction alerts</li>
            <li>PAN card is required for tax and compliance purposes</li>
            <li>Aadhaar number is required for identity verification</li>
            <li>Address should match your current residential address</li>
        </ul>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp">Back to Dashboard</a>
            <a href="ProfileServlet">View Profile</a>
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