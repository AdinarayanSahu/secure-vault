<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.groupprojects.securevault.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureVault - User Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: center;
        }

        .header h1 {
            color: #2c3e50;
            margin: 0 0 10px 0;
            font-size: 28px;
        }

        .breadcrumb {
            color: #7f8c8d;
            font-size: 14px;
        }

        .user-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .user-header {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .user-avatar {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
            margin: 0 auto 20px;
            border: 3px solid rgba(255,255,255,0.3);
        }

        .user-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .user-id {
            opacity: 0.9;
            font-size: 14px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            padding: 30px;
        }

        .detail-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            border-left: 5px solid #74b9ff;
        }

        .detail-section h3 {
            color: #2c3e50;
            margin: 0 0 20px 0;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-value {
            color: #2c3e50;
            font-weight: 500;
        }

        .balance-highlight {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 16px;
        }

        .actions {
            padding: 30px;
            text-align: center;
            border-top: 1px solid #e9ecef;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            margin: 0 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .details-grid {
                grid-template-columns: 1fr;
            }

            .actions {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-circle"></i> User Details</h1>
            <div class="breadcrumb">
                <i class="fas fa-home"></i> Admin Dashboard / Manage Users / User Details
            </div>
        </div>

        <!-- Messages -->
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
        </div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <%
        User user = (User) request.getAttribute("user");
        if (user != null) {
        %>
        <div class="user-card">
            <div class="user-header">
                <div class="user-avatar">
                    <%= user.getName() != null ? user.getName().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div class="user-name"><%= user.getName() %></div>
                <div class="user-id">User ID: #<%= user.getUserId() %></div>
            </div>

            <div class="details-grid">
                <!-- Personal Information -->
                <div class="detail-section">
                    <h3><i class="fas fa-user"></i> Personal Information</h3>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-signature"></i> Full Name
                        </span>
                        <span class="detail-value"><%= user.getName() %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-birthday-cake"></i> Age
                        </span>
                        <span class="detail-value"><%= user.getAge() %> years</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-envelope"></i> Email
                        </span>
                        <span class="detail-value"><%= user.getEmail() %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-phone"></i> Phone
                        </span>
                        <span class="detail-value"><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-map-marker-alt"></i> Address
                        </span>
                        <span class="detail-value"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></span>
                    </div>
                </div>

                <!-- Account Information -->
                <div class="detail-section">
                    <h3><i class="fas fa-university"></i> Account Information</h3>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-credit-card"></i> Account Number
                        </span>
                        <span class="detail-value">
                            <%= request.getAttribute("accountNo") != null ? request.getAttribute("accountNo") : "Not Available" %>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-wallet"></i> Current Balance
                        </span>
                        <span class="detail-value balance-highlight">
                            ₹<%= request.getAttribute("balance") != null ?
                                String.format("%.2f", (Double)request.getAttribute("balance")) : "0.00" %>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-calendar-alt"></i> Account Status
                        </span>
                        <span class="detail-value" style="color: #00b894; font-weight: bold;">Active</span>
                    </div>
                </div>

                <!-- KYC Information -->
                <div class="detail-section">
                    <h3><i class="fas fa-id-card"></i> KYC Information</h3>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-id-badge"></i> PAN Number
                        </span>
                        <span class="detail-value"><%= user.getPanNo() != null ? user.getPanNo() : "Not provided" %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-address-card"></i> Aadhaar Number
                        </span>
                        <span class="detail-value"><%= user.getAadhaarNo() != null ? user.getAadhaarNo() : "Not provided" %></span>
                    </div>
                </div>

                <!-- Login Information -->
                <div class="detail-section">
                    <h3><i class="fas fa-key"></i> Login Information</h3>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-user-tag"></i> Username
                        </span>
                        <span class="detail-value"><%= user.getUsername() != null ? user.getUsername() : "Not available" %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">
                            <i class="fas fa-shield-alt"></i> Account Security
                        </span>
                        <span class="detail-value" style="color: #00b894;">Secured</span>
                    </div>
                </div>
            </div>

            <div class="actions">
                <a href="AdminServlet?action=getAllUsers" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Users
                </a>
                <a href="AdminServlet?action=viewUserStatements&userId=<%= user.getUserId() %>" class="btn btn-primary">
                    <i class="fas fa-file-alt"></i> View Statements
                </a>
                <a href="#" class="btn btn-success" onclick="updateBalance(<%= user.getUserId() %>)">
                    <i class="fas fa-edit"></i> Update Balance
                </a>
                <a href="AdminServlet?action=deleteUser&userId=<%= user.getUserId() %>"
                   class="btn btn-danger"
                   onclick="return confirm('Are you sure you want to delete user: <%= user.getName() %>? This action cannot be undone.')">
                    <i class="fas fa-trash"></i> Delete User
                </a>
            </div>
        </div>
        <% } else { %>
        <div class="user-card">
            <div style="text-align: center; padding: 60px;">
                <i class="fas fa-user-slash" style="font-size: 64px; color: #bdc3c7; margin-bottom: 20px;"></i>
                <h3>User Not Found</h3>
                <p>The requested user could not be found in the system.</p>
                <a href="AdminServlet?action=getAllUsers" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Users
                </a>
            </div>
        </div>
        <% } %>
    </div>

    <script>
        function updateBalance(userId) {
            const newBalance = prompt("Enter new balance amount:");
            if (newBalance !== null && !isNaN(newBalance) && parseFloat(newBalance) >= 0) {
                if (confirm("Are you sure you want to update the balance to ₹" + parseFloat(newBalance).toFixed(2) + "?")) {
                    // This would typically call a servlet to update the balance
                    window.location.href = "AdminServlet?action=updateBalance&userId=" + userId + "&balance=" + newBalance;
                }
            } else if (newBalance !== null) {
                alert("Please enter a valid positive number for the balance.");
            }
        }
    </script>
</body>
</html>
