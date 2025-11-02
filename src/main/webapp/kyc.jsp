<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html   >
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit KYC Request - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    Integer userId = (Integer) session.getAttribute("userId");
    Boolean hasPendingRequest = (Boolean) request.getAttribute("hasPendingRequest");

    if (name == null || accountNo == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - KYC Request</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Submit KYC Update Request</h3>
        <p>Account: <%= accountNo %> | Name: <%= name %></p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if (hasPendingRequest != null && hasPendingRequest) { %>
        <div class="alert alert-info">
            <strong>📋 Pending Request</strong><br>
            You have a pending KYC update request. Please wait for admin approval before submitting a new request.
        </div>
    <% } else { %>

    <div class="content-section">
        <h2>Submit KYC Update Request</h2>
        <p style="color: #666;">Your KYC request will be reviewed by an administrator before approval.</p>

        <form action="KYCRequestServlet" method="post">
            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" placeholder="Enter your email address" required>
            </div>

            <div class="form-group">
                <label for="phone">Phone Number:</label>
                <input type="tel" id="phone" name="phone" placeholder="10-digit phone number" maxlength="10" required>
            </div>

            <div class="form-group">
                <label for="panNo">PAN Number:</label>
                <input type="text" id="panNo" name="panNo" placeholder="ABCDE1234F" maxlength="10" style="text-transform: uppercase;" required>
            </div>

            <div class="form-group">
                <label for="aadhaarNo">Aadhaar Number:</label>
                <input type="text" id="aadhaarNo" name="aadhaarNo" placeholder="12-digit Aadhaar number" maxlength="12" required>
            </div>

            <div class="form-group">
                <label for="address">Address:</label>
                <textarea id="address" name="address" rows="3" placeholder="Enter your complete address" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Submit KYC Request</button>
        </form>
    </div>

    <% } %>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp">Back to Dashboard</a>
            <a href="profile.jsp">View Profile</a>
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

<script>
    // Format PAN input
    document.getElementById('panNo').addEventListener('input', function(e) {
        e.target.value = e.target.value.toUpperCase();
    });

    // Format phone input
    document.getElementById('phone').addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '');
    });

    // Format Aadhaar input
    document.getElementById('aadhaarNo').addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '');
    });
</script>

</body>
</html>
