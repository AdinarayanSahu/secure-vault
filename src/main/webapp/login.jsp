<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - SecureVault</title>
  <link rel="stylesheet" href="assets/css/main.css">
</head>
<body>

<header>
    <div class="container">
        <h1>🏦 SecureVault Login</h1>
    </div>
</header>

<main class="container">
    <div class="welcome-section">
        <h2>Login to Your Account</h2>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <input type="text" name="username" placeholder="Username" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" class="btn btn-login">Login</button>
        </form>

        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
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
