<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureVault - Banking Services</title>
    <link rel="stylesheet" href="styles/style.css">
</head>
<body>
    <header>
        <div class="container">
            <h1> SecureVault</h1>
        </div>
    </header>

    <main class="container">
        <div class="welcome-section">
            <h2>Welcome to SecureVault Banking</h2>

            <form action="LandingServlet" method="post">
                <button type="submit" name="action" value="login" class="btn">Login</button>
                <button type="submit" name="action" value="register" class="btn btn-register">Register</button>
            </form>
        </div>

        <div class="info-section">
            <h3>About SecureVault</h3>
            <p>We provide fast, secure, and customer-friendly banking services to make your financial life simpler.</p>
        </div>
    </main>

    <footer>
        <div class="container">
            <div class="footer-links">
                <a href="#about">About Us</a>
                <a href="#contact">Contact</a>
                <a href="#help">Help</a>
                <a href="#privacy">Privacy Policy</a>
            </div>
            <p>&copy; 2025 SecureVault. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
