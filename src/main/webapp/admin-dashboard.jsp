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
    <link rel="stylesheet" href="styles/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h1>SecureVault</h1>
                <p>Admin Panel</p>
            </div>

            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="AdminServlet" class="nav-link <%= (request.getParameter("action") == null || "dashboard".equals(request.getParameter("action"))) ? "active" : "" %>">
                        Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="AdminServlet?action=getAllUsers" class="nav-link <%= "getAllUsers".equals(request.getParameter("action")) ? "active" : "" %>">
                        Manage Users
                    </a>
                </li>
                <li class="nav-item">
                    <a href="register.jsp" class="nav-link">
                        Register User
                    </a>
                </li>
                <li class="nav-item">
                    <a href="AdminServlet?action=viewPendingLoans" class="nav-link <%= "viewPendingLoans".equals(request.getParameter("action")) ? "active" : "" %>">
                        Loan Approvals
                    </a>
                </li>
                <li class="nav-item">
                    <a href="KYCRequestServlet" class="nav-link">
                        KYC Requests
                    </a>
                </li>
                <li class="nav-item">
                    <a href="AdminServlet?action=getAllStatements" class="nav-link <%= "getAllStatements".equals(request.getParameter("action")) ? "active" : "" %>">
                        View Statements
                    </a>
                </li>
            </ul>

            <div class="logout-section">
                <a href="index.jsp" class="logout-btn">
                    Logout
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Content Header -->
            <div class="content-header">
                <h1>Admin Dashboard</h1>
                <div class="breadcrumb">
                    Home /
                    <%
                    String action = request.getParameter("action");
                    if ("getAllUsers".equals(action)) { %>
                        User Management
                    <% } else if ("getAllStatements".equals(action)) { %>
                        View Statements
                    <% } else if ("viewUserStatements".equals(action)) { %>
                        User Statements
                    <% } else if ("viewPendingLoans".equals(action)) { %>
                        Loan Approvals
                    <% } else { %>
                        Dashboard
                    <% } %>
                </div>
            </div>

            <!-- Messages -->
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <!-- Users Management Section -->
            <% if (request.getAttribute("showUsers") != null && (Boolean)request.getAttribute("showUsers")) {
                List<User> users = (List<User>) request.getAttribute("users");
            %>
            <div class="data-section">
                <div class="section-header">
                    <h2>User Management</h2>
                    <p>Manage all registered users in the system</p>
                    <div class="user-stats">
                        <span class="stat-badge">
                            Total Users: <%= users != null ? users.size() : 0 %>
                        </span>
                    </div>
                </div>

                <% if (users != null && !users.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Email Address</th>
                                <th>Age</th>
                                <th>Phone Number</th>
                                <th>Address</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User user : users) { %>
                            <tr>
                                <td><strong>#<%= user.getUserId() %></strong></td>
                                <td><%= user.getName() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getAge() %> years</td>
                                <td><%= user.getPhone() %></td>
                                <td><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></td>
                                <td>
                                    <a href="AdminServlet?action=viewUser&userId=<%= user.getUserId() %>" class="btn btn-success">
                                        View
                                    </a>
                                    <a href="AdminServlet?action=viewUserStatements&userId=<%= user.getUserId() %>" class="btn btn-primary">
                                        Statements
                                    </a>
                                    <a href="AdminServlet?action=deleteUser&userId=<%= user.getUserId() %>"
                                       class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to delete user: <%= user.getName() %>?')">
                                        Delete
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-data">
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
                    <h2>All Transaction Statements</h2>
                    <p>Complete transaction history across all users</p>
                    <div class="user-stats">
                        <span class="stat-badge">
                            Total Statements: <%= statements != null ? statements.size() : 0 %>
                        </span>
                    </div>
                </div>

                <% if (statements != null && !statements.isEmpty()) { %>
                <div class="statements-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Statement Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (String statement : statements) { %>
                            <tr>
                                <td>
                                    <div class="statement-entry">
                                        <%= statement %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-data">
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
                    <h2><%= user.getName() %>'s Transaction Statements</h2>
                    <p>Transaction history for User ID: #<%= user.getUserId() %></p>
                    <div class="user-stats">
                        <span class="stat-badge">
                            Total Statements: <%= userStatements != null ? userStatements.size() : 0 %>
                        </span>
                    </div>
                    <div class="action-buttons">
                        <a href="AdminServlet?action=getAllUsers" class="btn btn-primary">
                            Back to Users
                        </a>
                        <a href="AdminServlet?action=viewUser&userId=<%= user.getUserId() %>" class="btn btn-success">
                            View User Details
                        </a>
                    </div>
                </div>

                <% if (userStatements != null && !userStatements.isEmpty()) { %>
                <div class="statements-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Transaction Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (String statement : userStatements) { %>
                            <tr>
                                <td>
                                    <div class="statement-entry">
                                        <%= statement %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-data">
                    <h3>No Statements Found</h3>
                    <p>This user has no transaction statements yet.</p>
                </div>
                <% } %>
            </div>

            <!-- Loan Approval Section -->
            <% } else if (request.getAttribute("showPendingLoans") != null) { %>
                <div class="data-section">
                    <div class="section-header">
                        <h2>Pending Loan Applications</h2>
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
                                            <div>
                                                <strong><%= loan.getUserName() %></strong><br>
                                                <%= loan.getUserEmail() %><br>
                                                Account: <%= loan.getAccountNo() %>
                                            </div>
                                        </td>
                                        <td><%= loan.getLoanTypeName() %></td>
                                        <td><strong>₹<%= String.format("%.2f", loan.getLoanAmount()) %></strong></td>
                                        <td><%= loan.getInterestRate() %>%</td>
                                        <td><%= loan.getTenureMonths() %> months</td>
                                        <td>₹<%= String.format("%.2f", loan.getMonthlyEmi()) %></td>
                                        <td><%= loan.getPurpose() %></td>
                                        <td><%= loan.getApplicationDate().toString().substring(0, 16) %></td>
                                        <td>
                                            <div class="loan-actions">
                                                <form method="post" action="AdminServlet" style="display: inline;">
                                                    <input type="hidden" name="action" value="approveLoan">
                                                    <input type="hidden" name="loanId" value="<%= loan.getLoanId() %>">
                                                    <input type="hidden" name="status" value="APPROVED">
                                                    <button type="submit" class="btn btn-approve"
                                                            onclick="return confirm('Are you sure you want to approve this loan?')">
                                                        Approve
                                                    </button>
                                                </form>
                                                <form method="post" action="AdminServlet" style="display: inline;">
                                                    <input type="hidden" name="action" value="approveLoan">
                                                    <input type="hidden" name="loanId" value="<%= loan.getLoanId() %>">
                                                    <input type="hidden" name="status" value="REJECTED">
                                                    <button type="submit" class="btn btn-reject"
                                                            onclick="return confirm('Are you sure you want to reject this loan?')">
                                                        Reject
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div class="no-data">
                            <h3>No Pending Loan Applications</h3>
                            <p>All loan applications have been processed. Check back later for new applications.</p>
                        </div>
                    <% } %>
                </div>

            <% } else { %>
            <!-- Default Dashboard View -->
            <div class="quick-actions">
                <div class="action-card">
                    <h3>User Management</h3>
                    <p>View, manage, and oversee all registered users in the SecureVault system</p>
                    <a href="AdminServlet?action=getAllUsers" class="btn btn-success">
                        View All Users
                    </a>
                </div>

                <div class="action-card">
                    <h3>Transaction Reports</h3>
                    <p>Access comprehensive transaction statements and financial records</p>
                    <a href="AdminServlet?action=getAllStatements" class="btn btn-warning">
                        View Statements
                    </a>
                </div>

                <div class="action-card">
                    <h3>Loan Management</h3>
                    <p>Review and manage pending loan applications from users</p>
                    <a href="AdminServlet?action=viewPendingLoans" class="btn btn-primary">
                        View Loan Requests
                    </a>
                </div>

                <div class="action-card">
                    <h3>KYC Verification</h3>
                    <p>Review and verify user KYC documentation and requests</p>
                    <a href="KYCRequestServlet" class="btn btn-primary">
                        View KYC Requests
                    </a>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
