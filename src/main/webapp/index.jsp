<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureVault - Banking Services</title>
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
            display: flex;
            flex-direction: column;
        }

        header {
            background-color: #2c3e50;
            color: white;
            padding: 20px 0;
            text-align: center;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            flex: 1;
        }

        .welcome-section {
            background: white;
            padding: 40px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .welcome-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 28px;
        }

        .btn {
            background-color: #3498db;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background-color: #2980b9;
        }

        .btn-register {
            background-color: #27ae60;
        }

        .btn-register:hover {
            background-color: #229954;
        }

        .info-section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .info-section h3 {
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .info-section p {
            color: #666;
            line-height: 1.6;
        }

        footer {
            background-color: #34495e;
            color: white;
            text-align: center;
            padding: 20px 0;
            margin-top: auto;
        }

        .footer-links {
            margin-bottom: 10px;
        }

        .footer-links a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header>
        <h1>🏦 SecureVault</h1>
    </header>

    <main class="container">
        <div class="welcome-section">
            <h2>Welcome to SecureVault Banking</h2>
            <p style="margin-bottom: 30px; color: #666;">Your trusted partner for secure and reliable banking services</p>

            <form action="LandingServlet" method="post">
                <button type="submit" name="action" value="login" class="btn">Login</button>
                <button type="submit" name="action" value="register" class="btn btn-register">Register</button>
            </form>
        </div>

        <div class="info-section">
            <h3>About SecureVault</h3>
            <p>We provide fast, secure, and customer-friendly banking services to make your financial life simpler. Experience modern banking with complete security and convenience.</p>
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

