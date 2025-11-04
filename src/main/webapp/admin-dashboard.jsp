<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.User" %>
<%@ page import="org.groupprojects.securevault.model.Loan" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureVault - Admin Dashboard</title>
    <link rel="stylesheet" href="styles/securevault.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 30px 20px;
            text-align: center;
            border-bottom: 2px solid #34495e;
            background: rgba(0,0,0,0.1);
        }

        .sidebar-header h1 {
            color: #74b9ff;
            margin: 0 0 10px 0;
            font-size: 28px;
            font-weight: bold;
        }

        .sidebar-header p {
            color: #bdc3c7;
            margin: 0;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .nav-menu {
            list-style: none;
            padding: 30px 0;
            margin: 0;
        }

        .nav-item {
            margin: 5px 15px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #bdc3c7;
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            font-size: 16px;
        }

        .nav-link:hover {
            background: rgba(116, 185, 255, 0.2);
            color: #74b9ff;
            transform: translateX(5px);
        }

        .nav-link.active {
            background: #74b9ff;
            color: white;
            box-shadow: 0 4px 15px rgba(116, 185, 255, 0.3);
        }

        .nav-link i {
            margin-right: 12px;
            font-size: 18px;
            width: 20px;
        }

        .main-content {
            margin-left: 280px;
            padding: 30px;
            width: calc(100% - 280px);
        }

        .content-header {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(116, 185, 255, 0.3);
        }

        .content-header h1 {
            margin: 0 0 10px 0;
            font-size: 32px;
        }

        .breadcrumb {
            opacity: 0.9;
            font-size: 14px;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .action-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease;
            border-left: 5px solid #74b9ff;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .action-card h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 20px;
        }

        .action-card p {
            color: #7f8c8d;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .data-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-top: 30px;
        }

        .section-header {
            border-bottom: 2px solid #f1f2f6;
            padding-bottom: 20px;
            margin-bottom: 25px;
        }

        .section-header h2 {
            color: #2c3e50;
            margin: 0 0 10px 0;
            font-size: 24px;
        }

        .user-stats {
            display: flex;
            gap: 20px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .stat-badge {
            background: #74b9ff;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .data-table th {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
        }

        .data-table td {
            padding: 15px;
            border-bottom: 1px solid #f1f2f6;
        }

        .data-table tr:hover {
            background-color: #f8f9fa;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .logout-section {
            position: fixed;
            bottom: 30px;
            left: 30px;
            right: 30px;
            width: 220px;
        }

        .logout-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .logout-btn:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }

        .logout-btn i {
            margin-right: 10px;
        }

        .no-users {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .no-users i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
            font-size: 14px;
        }

        .btn i {
            margin-right: 6px;
        }

        .btn-primary {
            background: #74b9ff;
            color: white;
        }

        .btn-primary:hover {
            background: #0984e3;
            transform: translateY(-1px);
        }

        .btn-success {
            background: #00b894;
            color: white;
        }

        .btn-success:hover {
            background: #00a085;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn-danger:hover {
            background: #c0392b;
        }

        .btn-warning {
            background: #fdcb6e;
            color: white;
        }

        .btn-warning:hover {
            background: #f39c12;
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
            .sidebar {
                width: 250px;
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
                width: 100%;
            }

            .user-stats {
                flex-direction: column;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <!-- Enhanced Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h1><i class="fas fa-shield-alt"></i> SecureVault</h1>
                <p>Admin Control Panel</p>
            </div>

            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="AdminServlet" class="nav-link <%= (request.getParameter("action") == null || "dashboard".equals(request.getParameter("action"))) ? "active" : "" %>">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="AdminServlet?action=getAllUsers" class="nav-link <%= "getAllUsers".equals(request.getParameter("action")) ? "active" : "" %>">
                        <i class="fas fa-users"></i>
                        Manage Users
                    </a>
                </li>
                <li class="nav-item">
                    <a href="register.jsp" class="nav-link">
                        <i class="fas fa-user-plus"></i>
                        Register User
                    </a>
                </li>
                <li class="nav-item">
                    <a href="AdminServlet?action=viewPendingLoans" class="nav-link <%= "viewPendingLoans".equals(request.getParameter("action")) ? "active" : "" %>">
                        <i class="fas fa-hand-holding-usd"></i>
                        Loan Approvals
                    </a>
                </li>
                <li class="nav-item">
                    <a href="KYCRequestServlet" class="nav-link">
                        <i class="fas fa-id-card"></i>
                        KYC Requests
                    </a>
                </li>
                <li class="nav-item">
                    <a href="AdminServlet?action=getAllStatements" class="nav-link <%= "getAllStatements".equals(request.getParameter("action")) ? "active" : "" %>">
                        <i class="fas fa-file-alt"></i>
                        View Statements
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        Analytics
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        Settings
                    </a>
                </li>
            </ul>

            <div class="logout-section">
                <a href="index.jsp" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    Logout
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Enhanced Content Header -->
            <div class="content-header">
                <h1><i class="fas fa-crown"></i> Admin Dashboard</h1>
                <div class="breadcrumb">
                    <i class="fas fa-home"></i> Home /
                    <%
                    String action = request.getParameter("action");
                    if ("getAllUsers".equals(action)) { %>
                        User Management
                    <% } else if ("getAllStatements".equals(action)) { %>
                        View Statements
                    <% } else if ("viewUserStatements".equals(action)) { %>
                        User Statements
                    <% } else { %>
                        Dashboard
                    <% } %>
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

            <!-- Users Management Section -->
            <% if (request.getAttribute("showUsers") != null && (Boolean)request.getAttribute("showUsers")) {
                List<User> users = (List<User>) request.getAttribute("users");
            %>
            <div class="data-section">
                <div class="section-header">
                    <h2><i class="fas fa-users"></i> User Management</h2>
                    <p style="color: #7f8c8d; margin: 10px 0 0 0;">Manage all registered users in the system</p>
                    <div class="user-stats">
                        <span class="stat-badge">
                            <i class="fas fa-user"></i> Total Users: <%= users != null ? users.size() : 0 %>
                        </span>
                        <span class="stat-badge" style="background: #55efc4;">
                            <i class="fas fa-user-check"></i> Active
                        </span>
                    </div>
                </div>

                <% if (users != null && !users.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> User ID</th>
                                <th><i class="fas fa-user"></i> Full Name</th>
                                <th><i class="fas fa-envelope"></i> Email Address</th>
                                <th><i class="fas fa-birthday-cake"></i> Age</th>
                                <th><i class="fas fa-phone"></i> Phone Number</th>
                                <th><i class="fas fa-map-marker-alt"></i> Address</th>
                                <th><i class="fas fa-tools"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User user : users) { %>
                            <tr>
                                <td><strong>#<%= user.getUserId() %></strong></td>
                                <td>
                                    <div style="display: flex; align-items: center;">
                                        <div style="width: 35px; height: 35px; background: #74b9ff; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 10px;">
                                            <%= user.getName().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <%= user.getName() %>
                                    </div>
                                </td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getAge() %> years</td>
                                <td><%= user.getPhone() %></td>
                                <td><%= user.getAddress() != null ? user.getAddress() : "<em>Not provided</em>" %></td>
                                <td>
                                    <a href="AdminServlet?action=viewUser&userId=<%= user.getUserId() %>"
                                       class="btn btn-success"
                                       style="padding: 6px 12px; font-size: 12px; border-radius: 15px; margin-right: 8px;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a href="AdminServlet?action=viewUserStatements&userId=<%= user.getUserId() %>"
                                       class="btn btn-primary"
                                       style="padding: 6px 12px; font-size: 12px; border-radius: 15px; margin-right: 8px;">
                                        <i class="fas fa-file-alt"></i> Statements
                                    </a>
                                    <a href="AdminServlet?action=deleteUser&userId=<%= user.getUserId() %>"
                                       class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to delete user: <%= user.getName() %>?')"
                                       style="padding: 6px 12px; font-size: 12px; border-radius: 15px;">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-users">
                    <i class="fas fa-users"></i>
                    <h3>No Users Found</h3>
                    <p>There are currently no registered users in the system.</p>
                </div>
                <% } %>
            </div>

            <!-- All Statements Section -->
            <% } else if (request.getAttribute("showStatements") != null && (Boolean)request.getAttribute("showStatements")) {
                List<String> statements = (List<String>) request.getAttribute("statements");
            %>
            <div class="data-section">
                <div class="section-header">
                    <h2><i class="fas fa-file-alt"></i> All Transaction Statements</h2>
                    <p style="color: #7f8c8d; margin: 10px 0 0 0;">Complete transaction history across all users</p>
                    <div class="user-stats">
                        <span class="stat-badge">
                            <i class="fas fa-receipt"></i> Total Statements: <%= statements != null ? statements.size() : 0 %>
                        </span>
                        <span class="stat-badge" style="background: #55efc4;">
                            <i class="fas fa-clock"></i> Recent 100
                        </span>
                    </div>
                </div>

                <% if (statements != null && !statements.isEmpty()) { %>
                <div class="statements-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> Statement Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (String statement : statements) { %>
                            <tr>
                                <td>
                                    <div style="font-family: 'Courier New', monospace; font-size: 14px; padding: 10px; background: #f8f9fa; border-radius: 5px; border-left: 4px solid #74b9ff;">
                                        <%= statement %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-users">
                    <i class="fas fa-file-alt"></i>
                    <h3>No Statements Found</h3>
                    <p>There are currently no transaction statements in the system.</p>
                </div>
                <% } %>
            </div>

            <!-- Individual User Statements Section -->
            <% } else if (request.getAttribute("showUserStatements") != null && (Boolean)request.getAttribute("showUserStatements")) {
                User user = (User) request.getAttribute("user");
                List<String> userStatements = (List<String>) request.getAttribute("userStatements");
            %>
            <div class="data-section">
                <div class="section-header">
                    <h2><i class="fas fa-user"></i> <%= user.getName() %>'s Transaction Statements</h2>
                    <p style="color: #7f8c8d; margin: 10px 0 0 0;">Transaction history for User ID: #<%= user.getUserId() %></p>
                    <div class="user-stats">
                        <span class="stat-badge">
                            <i class="fas fa-receipt"></i> Total Statements: <%= userStatements != null ? userStatements.size() : 0 %>
                        </span>
                        <span class="stat-badge" style="background: #fdcb6e;">
                            <i class="fas fa-user"></i> <%= user.getName() %>
                        </span>
                    </div>
                    <div style="margin-top: 15px;">
                        <a href="AdminServlet?action=getAllUsers" class="btn btn-primary" style="margin-right: 10px;">
                            <i class="fas fa-arrow-left"></i> Back to Users
                        </a>
                        <a href="AdminServlet?action=viewUser&userId=<%= user.getUserId() %>" class="btn btn-success">
                            <i class="fas fa-eye"></i> View User Details
                        </a>
                    </div>
                </div>

                <% if (userStatements != null && !userStatements.isEmpty()) { %>
                <div class="statements-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> Transaction Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (String statement : userStatements) { %>
                            <tr>
                                <td>
                                    <div style="font-family: 'Courier New', monospace; font-size: 14px; padding: 10px; background: #f8f9fa; border-radius: 5px; border-left: 4px solid #74b9ff;">
                                        <%= statement %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-users">
                    <i class="fas fa-file-alt"></i>
                    <h3>No Statements Found</h3>
                    <p>This user has no transaction statements yet.</p>
                </div>
                <% } %>
            </div>

            <% } else { %>
            <!-- Default Dashboard View -->
            <div class="quick-actions">
                <div class="action-card">
                    <h3><i class="fas fa-users"></i> User Management</h3>
                    <p>View, manage, and oversee all registered users in the SecureVault system</p>
                    <a href="AdminServlet?action=getAllUsers" class="btn btn-success">
                        <i class="fas fa-eye"></i> View All Users
                    </a>
                </div>

                <div class="action-card">
                    <h3><i class="fas fa-file-alt"></i> Transaction Reports</h3>
                    <p>Access comprehensive transaction statements and financial records</p>
                    <a href="AdminServlet?action=getAllStatements" class="btn btn-warning">
                        <i class="fas fa-file-download"></i> View Statements
                    </a>
                </div>

                <div class="action-card">
                    <h3><i class="fas fa-chart-line"></i> System Analytics</h3>
                    <p>Monitor system performance, user growth, and transaction trends</p>
                    <a href="#" class="btn" style="background: #fd79a8;">
                        <i class="fas fa-chart-bar"></i> Coming Soon
                    </a>
                </div>

                <div class="action-card">
                    <h3><i class="fas fa-shield-alt"></i> Security Center</h3>
                    <p>Manage security settings, user permissions, and system access</p>
                    <a href="#" class="btn" style="background: #a29bfe;">
                        <i class="fas fa-lock"></i> Coming Soon
                    </a>
                </div>
            </div>
            <% } %>

            <!-- Loan Approval Section -->
            <% if (request.getAttribute("showPendingLoans") != null) { %>
                <div class="data-section">
                    <div class="section-header">
                        <h2><i class="fas fa-hand-holding-usd"></i> Pending Loan Applications</h2>
                        <p>Review and approve/reject user loan applications</p>
                    </div>

                    <%
                        @SuppressWarnings("unchecked")
                        List<Loan> pendingLoans = (List<Loan>) request.getAttribute("pendingLoans");
                        if (pendingLoans != null && !pendingLoans.isEmpty()) {
                    %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Loan ID</th>
                                    <th>User Details</th>
                                    <th>Loan Type</th>
                                    <th>Amount</th>
                                    <th>Interest Rate</th>
                                    <th>Tenure</th>
                                    <th>Monthly EMI</th>
                                    <th>Purpose</th>
                                    <th>Applied Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Loan loan : pendingLoans) { %>
                                    <tr>
                                        <td><strong>#<%= loan.getLoanId() %></strong></td>
                                        <td>
                                            <div style="font-weight: bold;"><%= loan.getUserName() %></div>
                                            <div style="font-size: 12px; color: #666;"><%= loan.getUserEmail() %></div>
                                            <div style="font-size: 12px; color: #888;">Account: <%= loan.getAccountNo() %></div>
                                        </td>
                                        <td><%= loan.getLoanTypeName() %></td>
                                        <td><strong>₹<%= String.format("%.2f", loan.getLoanAmount()) %></strong></td>
                                        <td><%= loan.getInterestRate() %>%</td>
                                        <td><%= loan.getTenureMonths() %> months</td>
                                        <td>₹<%= String.format("%.2f", loan.getMonthlyEmi()) %></td>
                                        <td><%= loan.getPurpose() %></td>
                                        <td><%= loan.getApplicationDate().toString().substring(0, 16) %></td>
                                        <td>
                                            <div style="display: flex; gap: 10px;">
                                                <form method="post" action="AdminServlet" style="display: inline;">
                                                    <input type="hidden" name="action" value="approveLoan">
                                                    <input type="hidden" name="loanId" value="<%= loan.getLoanId() %>">
                                                    <input type="hidden" name="status" value="APPROVED">
                                                    <button type="submit" class="btn btn-approve"
                                                            onclick="return confirm('Are you sure you want to approve this loan?')">
                                                        <i class="fas fa-check"></i> Approve
                                                    </button>
                                                </form>
                                                <form method="post" action="AdminServlet" style="display: inline;">
                                                    <input type="hidden" name="action" value="approveLoan">
                                                    <input type="hidden" name="loanId" value="<%= loan.getLoanId() %>">
                                                    <input type="hidden" name="status" value="REJECTED">
                                                    <button type="submit" class="btn btn-reject"
                                                            onclick="return confirm('Are you sure you want to reject this loan?')">
                                                        <i class="fas fa-times"></i> Reject
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div class="no-data-message">
                            <i class="fas fa-inbox" style="font-size: 48px; color: #bdc3c7; margin-bottom: 20px;"></i>
                            <h3>No Pending Loan Applications</h3>
                            <p>All loan applications have been processed. Check back later for new applications.</p>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <style>


        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-approve {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
        }

        .btn-approve:hover {
            background: linear-gradient(135deg, #00a085, #00b894);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 184, 148, 0.3);
        }

        .btn-reject {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-reject:hover {
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        .no-data-message {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .no-data-message h3 {
            margin: 0 0 10px 0;
            color: #2c3e50;
        }
    </style>

    <!-- ...existing scripts... -->
</body>
</html>
