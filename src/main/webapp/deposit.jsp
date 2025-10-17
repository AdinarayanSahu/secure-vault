<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Deposit Money</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5;">

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    Double balance = (Double) session.getAttribute("balance");

    if (name == null || accountNo == null || balance == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div style="max-width: 500px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
    <h2 style="text-align: center; color: #333;">Deposit Money</h2>
    <p style="text-align: center; color: #666;">Account: <%= accountNo %> | Balance: ₹ <%= balance %></p>

    <% if (request.getAttribute("error") != null) { %>
        <div style="color: red; margin: 10px 0; padding: 10px; background: #ffebee; border-radius: 3px;">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div style="color: green; margin: 10px 0; padding: 10px; background: #e8f5e8; border-radius: 3px;">
            <%= request.getAttribute("success") %>
            <br>New Balance: ₹ <%= request.getAttribute("newBalance") %>
        </div>
    <% } %>

    <form action="DepositServlet" method="post">
        <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px; font-weight: bold;">Amount:</label>
            <input type="number" name="amount" placeholder="Enter amount" required min="1" max="100000" step="0.01"
                   style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 3px; box-sizing: border-box;">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px; font-weight: bold;">Payment Method:</label>
            <select name="paymentMethod" required
                    style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 3px; box-sizing: border-box;">
                <option value="">Select Payment Method</option>
                <option value="UPI">UPI</option>
                <option value="NET_BANKING">Net Banking</option>
                <option value="DEBIT_CARD">Debit Card</option>
                <option value="CREDIT_CARD">Credit Card</option>
                <option value="CASH">Cash</option>
            </select>
        </div>

        <button type="submit" style="width: 100%; padding: 12px; background: #007bff; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 16px;">
            Deposit Money
        </button>
    </form>

    <hr style="margin: 20px 0; border: none; border-top: 1px solid #eee;">

    <h4 style="text-align: center; color: #333;">Quick Deposit</h4>
    <div style="text-align: center;">
        <form action="DepositServlet" method="post" style="display: inline-block; margin: 5px;">
            <input type="hidden" name="amount" value="500">
            <input type="hidden" name="paymentMethod" value="DIRECT_ADD">
            <input type="hidden" name="isQuickAdd" value="true">
            <button type="submit" style="padding: 8px 15px; background: #28a745; color: white; border: none; border-radius: 3px; cursor: pointer;">
                Add ₹500
            </button>
        </form>

        <form action="DepositServlet" method="post" style="display: inline-block; margin: 5px;">
            <input type="hidden" name="amount" value="1000">
            <input type="hidden" name="paymentMethod" value="DIRECT_ADD">
            <input type="hidden" name="isQuickAdd" value="true">
            <button type="submit" style="padding: 8px 15px; background: #28a745; color: white; border: none; border-radius: 3px; cursor: pointer;">
                Add ₹1000
            </button>
        </form>

        <form action="DepositServlet" method="post" style="display: inline-block; margin: 5px;">
            <input type="hidden" name="amount" value="5000">
            <input type="hidden" name="paymentMethod" value="DIRECT_ADD">
            <input type="hidden" name="isQuickAdd" value="true">
            <button type="submit" style="padding: 8px 15px; background: #28a745; color: white; border: none; border-radius: 3px; cursor: pointer;">
                Add ₹5000
            </button>
        </form>
    </div>

    <div style="text-align: center; margin-top: 20px;">
        <a href="DashboardServlet" style="color: #007bff; text-decoration: none;">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
