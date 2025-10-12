<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome to SecureVault</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #283E51, #485563);
            color: white;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: rgba(0, 0, 0, 0.3);
            padding: 20px;
            font-size: 30px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        main {
            margin-top: 80px;
        }
        h2 {
            font-size: 26px;
            margin-bottom: 10px;
        }
        p {
            font-size: 18px;
            color: #f1f1f1;
        }
        .btn {
            background-color: #fff;
            color: #333;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            margin: 15px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn:hover {
            background-color: #f1c40f;
            transform: scale(1.05);
        }
        section {
            margin-top: 60px;
            padding: 20px;
        }
        footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            background-color: rgba(0, 0, 0, 0.3);
            padding: 10px 0;
            font-size: 14px;
        }
        a {
            color: #f1c40f;
            margin: 0 10px;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>🏦 SecureVault Banking Services</header>

<main>
    <h2>Welcome to SecureVault</h2>
    <p>Your trusted partner for safe and reliable banking.</p>

    <form action="LandingServlet" method="post">
        <button type="submit" name="action" value="login" class="btn">Login</button>
        <button type="submit" name="action" value="register" class="btn">Register</button>
    </form>


    <section id="about">
        <h3>About SecureVault</h3>
        <p>At SecureVault, we provide secure, fast, and customer-friendly banking services to make your financial life simpler.</p>
    </section>

    <section id="contact">
        <h3>Contact Us</h3>
        <p>Email: support@securevault.com</p>
        <p>Phone: +91 98765 43210</p>
    </section>
</main>

<footer>
    <a href="#about">About Us</a> |
    <a href="#contact">Contact</a> |
    <a href="#">Help</a> |
    <a href="#">Privacy Policy</a>
</footer>

</body>
</html>
