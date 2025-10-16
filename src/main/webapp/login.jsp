<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>SecureVault Login</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(to right, #283E51, #485563);
      color: white;
      text-align: center;
      padding-top: 80px;
    }
    form {
      background-color: rgba(255, 255, 255, 0.1);
      display: inline-block;
      padding: 30px 50px;
      border-radius: 10px;
    }
    input {
      margin: 10px;
      padding: 10px;
      width: 250px;
      border: none;
      border-radius: 5px;
    }
    button {
      padding: 12px 25px;
      border: none;
      background-color: #f1c40f;
      border-radius: 5px;
      cursor: pointer;
      font-weight: bold;
    }
    button:hover {
      background-color: #ffd700;
    }
    p a {
      color: yellow;
      text-decoration: none;
    }
    p a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<h2>Login to Your SecureVault Account</h2>

<form action="#" method="post">
  <input type="text" name="username" placeholder="Username" required><br>
  <input type="password" name="password" placeholder="Password" required><br>
  <button type="submit">Login</button>
</form>

<p>Don't have an account? <a href="register.jsp">Register here</a></p>
</body>
</html>
