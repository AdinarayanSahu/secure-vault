<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SecureVault Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #283E51, #485563);
            color: white;
            text-align: center;
            padding-top: 60px;
        }
        form {
            background-color: rgba(255, 255, 255, 0.1);
            display: inline-block;
            padding: 20px 40px;
            border-radius: 10px;
        }
        input {
            margin: 10px;
            padding: 8px;
            width: 250px;
            border: none;
            border-radius: 5px;
        }
        button {
            padding: 10px 20px;
            border: none;
            background-color: #f1c40f;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background-color: #ffd700;
        }
        .field-note {
            font-size: 12px;
            color: #f39c12;
            margin-top: -5px;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<h2>Register Your SecureVault Account</h2>

<form action="RegisterServlet" method="post">
    <input type="text" name="name" placeholder="Full Name" required><br>
    <input type="number" name="age" placeholder="Age" required><br>
    <input type="text" name="address" placeholder="Address" required><br>
    <input type="email" name="email" placeholder="Email" required><br>
    <input type="text" name="phone" placeholder="Phone Number" required><br>
    <input type="text" name="panNo" placeholder="PAN Number (e.g., ABCDE1234F)" maxlength="10" pattern="[A-Z]{5}[0-9]{4}[A-Z]{1}" required><br>
    <div class="field-note">PAN format: 5 letters + 4 digits + 1 letter</div>
    <input type="text" name="aadhaarNo" placeholder="Aadhaar Number (12 digits)" maxlength="12" pattern="[0-9]{12}" required><br>
    <div class="field-note">Aadhaar must be exactly 12 digits</div>
    <input type="text" name="username" placeholder="Username" required><br>
    <input type="password" name="password" placeholder="Password" required><br>
    <button type="submit">Register</button>
</form>

<p><a href="login.jsp">Already have an account? Login here</a></p>

</body>
</html>