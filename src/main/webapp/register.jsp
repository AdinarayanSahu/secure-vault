<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - SecureVault</title>
    <link rel="stylesheet" href="assets/css/main.css">
</head>
<body>

<header>
    <div class="container">
        <h1>🏦 SecureVault Registration</h1>
    </div>
</header>

<main class="container">
    <div class="welcome-section">
        <h2>Register Your SecureVault Account</h2>

        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
        <div class="alert error" style="color: red; background-color: #ffebee; border: 1px solid #f44336; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <%= error %>
        </div>
        <% } else if (success != null) { %>
        <div class="alert success" style="color: green; background-color: #e8f5e8; border: 1px solid #4caf50; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <%= success %>
        </div>
        <% } %>

        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <input type="text" name="name" placeholder="Full Name" required>
            </div>
            <div class="form-group">
                <input type="number" name="age" placeholder="Age (18+ required)" min="18" max="100" required>
                <div class="field-note" style="font-size: 12px; color: #666; margin-top: 5px;">
                    Minimum age: 18 years
                </div>
            </div>
            <div class="form-group">
                <input type="text" name="address" placeholder="Address" required>
            </div>
            <div class="form-group">
                <input type="email" name="email" placeholder="Email" required>
            </div>
            <div class="form-group">
                <input type="text" name="phone" placeholder="Phone Number" required>
            </div>
            <div class="form-group">
                <input type="text" name="panNo" placeholder="PAN Number (e.g., ABCDE1234F)" maxlength="10" pattern="[A-Z]{5}[0-9]{4}[A-Z]{1}" required>
                <div class="field-note" style="font-size: 12px; color: #666; margin-top: 5px;">
                    PAN format: 5 letters + 4 digits + 1 letter
                </div>
            </div>
            <div class="form-group">
                <input type="text" name="aadhaarNo" placeholder="Aadhaar Number (12 digits)" maxlength="12" pattern="[0-9]{12}" required>
                <div class="field-note" style="font-size: 12px; color: #666; margin-top: 5px;">
                    Aadhaar must be exactly 12 digits
                </div>
            </div>
            <div class="form-group">
                <input type="text" name="username" placeholder="Username" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" class="btn btn-login">Register</button>
        </form>

        <p>Already have an account? <a href="login.jsp">Login here</a></p>
        <p><a href="index.jsp">Back to Home</a></p>
    </div>
</main>

<footer>
    <div class="container">
        <p>&copy; 2025 SecureVault. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
