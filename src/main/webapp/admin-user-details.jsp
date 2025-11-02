<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.groupprojects.securevault.model.User" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureVault - User Details</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>
    <header>
        <h1>SecureVault - User Details</h1>
    </header>

    <div class="container">
        <!-- Messages -->
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert success">
            <%= request.getAttribute("success") %>
        </div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert error">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <%
        User user = (User) request.getAttribute("user");
        if (user != null) {
            // Fetch all user details including account info, username, password
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            int accountNo = 0;
            double balance = 0.0;
            String username = "";
            String password = "";
            String panNo = "";
            String aadhaarNo = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartbank_db", "root", "password");

                // Get complete user info with login details
                String userQuery = "SELECT u.*, l.username, l.password FROM users u " +
                                  "LEFT JOIN login l ON u.user_id = l.user_id " +
                                  "WHERE u.user_id = ?";
                ps = con.prepareStatement(userQuery);
                ps.setInt(1, user.getUserId());
                rs = ps.executeQuery();

                if (rs.next()) {
                    username = rs.getString("username");
                    password = rs.getString("password");
                    panNo = rs.getString("pan_no");
                    aadhaarNo = rs.getString("aadhaar_no");
                }
                rs.close();
                ps.close();

                // Get account details
                String accountQuery = "SELECT account_no, balance FROM personal_account WHERE user_id = ?";
                ps = con.prepareStatement(accountQuery);
                ps.setInt(1, user.getUserId());
                rs = ps.executeQuery();

                if (rs.next()) {
                    accountNo = rs.getInt("account_no");
                    balance = rs.getDouble("balance");
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>

        <div class="card">
            <div class="card-header">
                <h2>User Information - <%= user.getName() %> (ID: <%= user.getUserId() %>)</h2>
            </div>

            <div class="card-body">
                <table class="simple-table">
                    <tr>
                        <td><strong>Full Name:</strong></td>
                        <td><%= user.getName() %></td>
                    </tr>
                    <tr>
                        <td><strong>Email:</strong></td>
                        <td><%= user.getEmail() %></td>
                    </tr>
                    <tr>
                        <td><strong>Age:</strong></td>
                        <td><%= user.getAge() %> years</td>
                    </tr>
                    <tr>
                        <td><strong>Phone:</strong></td>
                        <td><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></td>
                    </tr>
                    <tr>
                        <td><strong>Address:</strong></td>
                        <td><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></td>
                    </tr>
                    <tr>
                        <td><strong>Username:</strong></td>
                        <td><%= username != null && !username.isEmpty() ? username : "Not available" %></td>
                    </tr>
                    <tr>
                        <td><strong>Password:</strong></td>
                        <td><%= password != null && !password.isEmpty() ? password : "Not available" %></td>
                    </tr>
                    <tr>
                        <td><strong>PAN Number:</strong></td>
                        <td><%= panNo != null && !panNo.isEmpty() ? panNo : "Not provided" %></td>
                    </tr>
                    <tr>
                        <td><strong>Aadhaar Number:</strong></td>
                        <td><%= aadhaarNo != null && !aadhaarNo.isEmpty() ? aadhaarNo : "Not provided" %></td>
                    </tr>
                    <tr>
                        <td><strong>Account Number:</strong></td>
                        <td><%= accountNo > 0 ? accountNo : "Not Available" %></td>
                    </tr>
                    <tr class="balance-row">
                        <td><strong>Current Balance:</strong></td>
                        <td class="balance-amount">₹<%= String.format("%.2f", balance) %></td>
                    </tr>
                </table>

                <div class="button-group">
                    <a href="AdminServlet?action=getAllUsers" class="btn btn-secondary">Back to Users</a>
                    <a href="AdminServlet?action=viewUserStatements&userId=<%= user.getUserId() %>" class="btn btn-primary">View Statements</a>
                    <button onclick="updateBalance(<%= user.getUserId() %>, <%= balance %>)" class="btn btn-success">Update Balance</button>
                    <a href="AdminServlet?action=deleteUser&userId=<%= user.getUserId() %>"
                       onclick="return confirm('Delete user <%= user.getName() %>?')"
                       class="btn btn-danger">Delete User</a>
                </div>
            </div>
        </div>

        <% } else { %>
        <div class="card">
            <div class="card-body">
                <h3>User Not Found</h3>
                <p>The requested user could not be found.</p>
                <a href="AdminServlet?action=getAllUsers" class="btn btn-primary">Back to Users</a>
            </div>
        </div>
        <% } %>
    </div>

    <style>
        .simple-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        .simple-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
        }

        .simple-table td:first-child {
            background-color: #f8f9fa;
            width: 200px;
            font-weight: bold;
        }

        .balance-row {
            background-color: #e8f5e8;
        }

        .balance-amount {
            font-size: 18px;
            font-weight: bold;
            color: #28a745;
        }

        .button-group {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #eee;
        }

        .button-group .btn {
            margin: 0 5px;
        }
    </style>

    <script>
        function updateBalance(userId, currentBalance) {
            var newBalance = prompt("Enter new balance:", currentBalance);
            if (newBalance !== null && !isNaN(newBalance) && parseFloat(newBalance) >= 0) {
                if (confirm("Update balance to ₹" + parseFloat(newBalance).toFixed(2) + "?")) {
                    window.location.href = "AdminServlet?action=updateBalance&userId=" + userId + "&balance=" + newBalance;
                }
            } else if (newBalance !== null) {
                alert("Please enter a valid amount.");
            }
        }
    </script>
</body>
</html>
