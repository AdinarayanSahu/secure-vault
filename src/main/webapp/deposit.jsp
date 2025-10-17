<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Deposit Money</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; }
        .header { text-align: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 3px; box-sizing: border-box; }
        .btn { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 3px; cursor: pointer; margin: 5px; }
        .btn:hover { background: #0056b3; }
        .quick-btn { background: #28a745; }
        .quick-btn:hover { background: #218838; }
        .error { color: red; margin: 10px 0; }
        .success { color: green; margin: 10px 0; }
    </style>
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    Double balance = (Double) session.getAttribute("balance");

    if (name == null || accountNo == null || balance == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="container">
    <div class="header">
        <h2>Deposit Money</h2>
        <p>Account: <%= accountNo %> | Balance: ₹ <%= balance %></p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="success">
            <%= request.getAttribute("success") %>
            <br>New Balance: ₹ <%= request.getAttribute("newBalance") %>
        </div>
    <% } %>

    <form action="DepositServlet" method="post">
        <div class="form-group">
            <label>Amount to Deposit:</label>
            <input type="number" name="amount" placeholder="Enter amount" required min="1" max="100000" step="0.01">
        </div>

        <div class="form-group">
            <label>Payment Method:</label>
            <select name="paymentMethod" required>
                <option value="">Select Payment Method</option>
                <option value="UPI">UPI</option>
                <option value="NET_BANKING">Net Banking</option>
                <option value="DEBIT_CARD">Debit Card</option>
                <option value="CREDIT_CARD">Credit Card</option>
                <option value="CASH">Cash</option>
            </select>
        </div>

        <div style="text-align: center;">
            <button type="submit" class="btn">Deposit Money</button>
        </div>
    </form>

    <hr>

    <div style="text-align: center;">
        <h4>Quick Add Money</h4>
        <p>Add money directly to your account</p>

        <form action="DepositServlet" method="post" style="display: inline;">
            <input type="hidden" name="amount" value="500">
            <input type="hidden" name="paymentMethod" value="DIRECT_ADD">
            <input type="hidden" name="isQuickAdd" value="true">
            <button type="submit" class="btn quick-btn">Add ₹500</button>
        </form>

        <form action="DepositServlet" method="post" style="display: inline;">
            <input type="hidden" name="amount" value="1000">
            <input type="hidden" name="paymentMethod" value="DIRECT_ADD">
            <input type="hidden" name="isQuickAdd" value="true">
            <button type="submit" class="btn quick-btn">Add ₹1000</button>
        </form>

        <form action="DepositServlet" method="post" style="display: inline;">
            <input type="hidden" name="amount" value="5000">
            <input type="hidden" name="paymentMethod" value="DIRECT_ADD">
            <input type="hidden" name="isQuickAdd" value="true">
            <button type="submit" class="btn quick-btn">Add ₹5000</button>
        </form>
    </div>

    <div style="text-align: center; margin-top: 20px;">
        <a href="DashboardServlet">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
