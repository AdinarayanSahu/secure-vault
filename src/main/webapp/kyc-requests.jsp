<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.groupprojects.securevault.model.KYCRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KYC Requests - Admin - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    String adminName = (String) session.getAttribute("name");
    List<KYCRequest> pendingRequests = (List<KYCRequest>) request.getAttribute("pendingRequests");

    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm");
%>

<header>
    <h1>🏦 SecureVault - Admin KYC Requests</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>📋 KYC Requests Management</h3>
        <p>Admin: <%= adminName %> | Pending Requests: <%= pendingRequests != null ? pendingRequests.size() : 0 %></p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if (pendingRequests == null || pendingRequests.isEmpty()) { %>
        <div class="simple-card">
            <h4>📋 No Pending KYC Requests</h4>
            <p>All KYC requests have been processed.</p>
        </div>
    <% } else { %>

    <div class="simple-card">
        <h4>📋 Pending KYC Requests</h4>
        <p style="color: #666;">Review and approve/reject user KYC requests below.</p>
    </div>

    <% for (KYCRequest kycRequest : pendingRequests) { %>
    <div class="simple-card" style="margin-bottom: 20px; border-left: 4px solid #007bff;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
            <div>
                <h4>Request #<%= kycRequest.getRequestId() %> - <%= kycRequest.getName() %></h4>
                <small style="color: #666;">Username: <%= kycRequest.getUsername() %> | User ID: <%= kycRequest.getUserId() %></small>
            </div>
            <div>
                <span style="padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; background-color: #fff3cd; color: #856404;">
                    PENDING
                </span>
            </div>
        </div>

        <div style="margin-bottom: 15px; font-size: 14px; color: #666;">
            <strong>Request Date:</strong> <%= dateFormat.format(kycRequest.getRequestDate()) %>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-bottom: 20px;">
            <div>
                <strong>📧 Email:</strong><br>
                <%= kycRequest.getEmail() %>
            </div>
            <div>
                <strong>📱 Phone:</strong><br>
                <%= kycRequest.getPhone() %>
            </div>
            <div>
                <strong>🆔 PAN Number:</strong><br>
                <%= kycRequest.getPanNo() %>
            </div>
            <div>
                <strong>🆔 Aadhaar Number:</strong><br>
                <%= kycRequest.getAadhaarNo() %>
            </div>
            <div style="grid-column: 1 / -1;">
                <strong>🏠 Address:</strong><br>
                <%= kycRequest.getAddress() %>
            </div>
        </div>

        <!-- Action Buttons -->
        <div style="display: flex; gap: 10px; justify-content: center; padding-top: 15px; border-top: 1px solid #eee;">
            <form action="KYCRequestServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="requestId" value="<%= kycRequest.getRequestId() %>">
                <button type="submit" class="simple-btn btn-primary"
                        onclick="return confirm('Are you sure you want to APPROVE this KYC request? This will update the user\'s information.')">
                    ✅ Approve
                </button>
            </form>

            <form action="KYCRequestServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="requestId" value="<%= kycRequest.getRequestId() %>">
                <button type="submit" class="simple-btn btn-secondary"
                        onclick="return confirm('Are you sure you want to REJECT this KYC request?')"
                        style="background-color: #dc3545;">
                    ❌ Reject
                </button>
            </form>
        </div>
    </div>
    <% } %>

    <% } %>

    <div class="navigation">
        <div class="nav-links">
            <a href="AdminServlet">Admin Dashboard</a>
            <a href="admin-dashboard.jsp">Back to Admin Panel</a>
        </div>
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
