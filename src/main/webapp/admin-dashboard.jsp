<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial; background-color: #f0f0f0; margin: 0; }
        .container { width: 90%; margin: 20px auto; background: white; padding: 15px; border-radius: 5px; }
        h1, h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #007BFF; color: white; }
        .btn {
            display: inline-block; padding: 5px 10px; margin: 3px;
            text-decoration: none; color: white; border-radius: 3px;
        }
        .blue { background-color: #007BFF; }
        .green { background-color: #28a745; }
        .orange { background-color: #f39c12; }
        .red { background-color: #dc3545; }
        .gray { background-color: #6c757d; }
        .msg { text-align: center; padding: 8px; border-radius: 3px; margin-bottom: 10px; }
        .success-msg { background: #d4edda; color: #155724; }
        .error-msg { background: #f8d7da; color: #721c24; }
        .actions { text-align: center; margin-bottom: 15px; }
    </style>
</head>
<body>

<div class="container">
    <h1>SecureVault Admin Dashboard</h1>

    <% if (request.getAttribute("success") != null) { %>
    <div class="msg success-msg"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="msg error-msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="actions">
        <a href="AdminServlet?action=getAllUsers" class="btn blue">View Users</a>
        <a href="AdminServlet?action=addUser" class="btn green">Add User</a>
        <a href="AdminServlet?action=getAllStatements" class="btn orange">View Statements</a>
        <a href="AdminServlet?action=deleteAllUsers" class="btn red">Delete Users</a>
        <a href="index.jsp" class="btn gray">Logout</a>
    </div>

    <%-- Show Users --%>
    <% if (request.getAttribute("showUsers") != null && (Boolean)request.getAttribute("showUsers")) {
        List<User> users = (List<User>) request.getAttribute("users");
    %>
    <h2>All Registered Users</h2>
    <% if (users != null && !users.isEmpty()) { %>
    <table>
        <tr>
            <th>ID</th><th>Name</th><th>Email</th><th>Age</th><th>Phone</th><th>Actions</th>
        </tr>
        <% for (User user : users) { %>
        <tr>
            <td><%= user.getUserId() %></td>
            <td><%= user.getName() %></td>
            <td><%= user.getEmail() %></td>
            <td><%= user.getAge() %></td>
            <td><%= user.getPhone() %></td>
            <td>
                <a href="AdminServlet?action=viewUser&userId=<%= user.getUserId() %>" class="btn blue">View</a>
                <a href="AdminServlet?action=editUser&userId=<%= user.getUserId() %>" class="btn orange">Edit</a>
                <a href="AdminServlet?action=deleteUser&userId=<%= user.getUserId() %>"
                   class="btn red" onclick="return confirm('Delete user <%= user.getName() %>?')">Delete</a>
            </td>
        </tr>
        <% } %>
    </table>
    <% } else { %>
    <p style="text-align:center;">No users found.</p>
    <% } } %>

    <%-- Show Statements --%>
    <% if (request.getAttribute("showStatements") != null && (Boolean)request.getAttribute("showStatements")) {
        List<String> statements = (List<String>) request.getAttribute("statements");
    %>
    <h2>All Transaction Statements</h2>
    <% if (statements != null && !statements.isEmpty()) { %>
    <table>
        <tr><th>Statement</th></tr>
        <% for (String s : statements) { %>
        <tr><td><%= s %></td></tr>
        <% } %>
    </table>
    <% } else { %>
    <p style="text-align:center;">No statements found.</p>
    <% } } %>
</div>

</body>
</html>