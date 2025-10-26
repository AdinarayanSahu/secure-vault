<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.Loan" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Loans - Secure Vault</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .loans-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .loans-header {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        .loan-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .loan-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f1f3f4;
        }
        .loan-title {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            color: white;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-pending { background: #ffc107; }
        .status-approved { background: #28a745; }
        .status-rejected { background: #dc3545; }
        .status-active { background: #17a2b8; }
        .status-completed { background: #6c757d; }
        .loan-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .detail-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .detail-label {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }
        .detail-value {
            font-size: 1.1em;
            font-weight: bold;
            color: #333;
        }
        .amount {
            color: #667eea;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 10px 5px;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .no-loans {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 10px;
        }
        .loan-purpose {
            margin-top: 15px;
            padding: 15px;
            background: #e9ecef;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
    </style>
</head>
<body>
    <div class="loans-container">
        <div class="loans-header">
            <h2>📊 My Loans</h2>
            <p>Track your loan applications and current loans</p>
        </div>

        <%
            List<Loan> userLoans = (List<Loan>) request.getAttribute("userLoans");
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");

            if (userLoans != null && !userLoans.isEmpty()) {
                for (Loan loan : userLoans) {
        %>
        <div class="loan-card">
            <div class="loan-header">
                <div class="loan-title">
                    🏦 <%= loan.getLoanTypeName() %>
                </div>
                <div class="status-badge status-<%= loan.getStatus().toLowerCase() %>">
                    <%= loan.getStatus() %>
                </div>
            </div>

            <div class="loan-details">
                <div class="detail-item">
                    <div class="detail-label">Loan Amount</div>
                    <div class="detail-value amount">₹<%= String.format("%.2f", loan.getLoanAmount()) %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Interest Rate</div>
                    <div class="detail-value"><%= loan.getInterestRate() %>% p.a.</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Tenure</div>
                    <div class="detail-value"><%= loan.getTenureMonths() %> months</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Monthly EMI</div>
                    <div class="detail-value amount">₹<%= String.format("%.2f", loan.getMonthlyEmi()) %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Total Amount</div>
                    <div class="detail-value amount">₹<%= String.format("%.2f", loan.getTotalAmount()) %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Application Date</div>
                    <div class="detail-value"><%= sdf.format(loan.getApplicationDate()) %></div>
                </div>
            </div>

            <% if (loan.getPurpose() != null && !loan.getPurpose().isEmpty()) { %>
            <div class="loan-purpose">
                <strong>Purpose:</strong> <%= loan.getPurpose() %>
            </div>
            <% } %>

            <% if (loan.getApprovalDate() != null) { %>
            <div style="margin-top: 15px; padding: 10px; background: #d4edda; border-radius: 5px; color: #155724;">
                <strong>Approved on:</strong> <%= sdf.format(loan.getApprovalDate()) %>
            </div>
            <% } %>
        </div>
        <%
                }
            } else {
        %>
        <div class="no-loans">
            <h3>📋 No Loans Found</h3>
            <p>You haven't applied for any loans yet.</p>
            <a href="LoanServlet?action=apply" class="btn btn-primary">Apply for Loan</a>
        </div>
        <%
            }
        %>

        <div style="text-align: center; margin-top: 30px;">
            <a href="LoanServlet?action=apply" class="btn btn-primary">Apply for New Loan</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
