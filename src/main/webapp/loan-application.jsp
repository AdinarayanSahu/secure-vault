<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.LoanType" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Application - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");

    if (name == null || accountNo == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - Loan Application</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Apply for Loan</h3>
        <p>Account: <%= accountNo %> | Name: <%= name %></p>
    </div>

    <div class="balance-card">
        <h3>📋 Loan Approval Process</h3>
        <p>All loan applications require admin approval. Processing time: 1-2 business days.</p>
    </div>

    <!-- Loan Type Selection -->
    <div class="content-section">
        <h3>Select Loan Type</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 20px;">
            <%
                List<LoanType> loanTypes = (List<LoanType>) request.getAttribute("loanTypes");
                if (loanTypes != null) {
                    for (LoanType loanType : loanTypes) {
            %>
            <div class="content-section" style="cursor: pointer; border: 2px solid transparent; transition: all 0.3s;"
                 onclick="selectLoanType(<%= loanType.getLoanTypeId() %>, <%= loanType.getInterestRate() %>, <%= loanType.getMaxAmount() %>, <%= loanType.getMinAmount() %>, <%= loanType.getMaxTenureMonths() %>, '<%= loanType.getLoanName() %>')">
                <h4 style="color: #2c3e50; margin-bottom: 15px;"><%= loanType.getLoanName() %></h4>
                <div style="font-size: 24px; font-weight: bold; color: #74b9ff; margin-bottom: 10px;"><%= String.format("%.0f", loanType.getInterestRate()) %>%</div>
                <p><strong>Amount:</strong> ₹<%= String.format("%.0f", loanType.getMinAmount()) %> - ₹<%= String.format("%.0f", loanType.getMaxAmount()) %></p>
                <p><strong>Max Tenure:</strong> <%= loanType.getMaxTenureMonths() %> months</p>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <!-- EMI Calculator -->
    <div class="content-section" style="display: none;" id="calculatorSection">
        <h3>💰 EMI Calculator</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 20px;">
            <div class="form-group">
                <label>Loan Amount (₹)</label>
                <input type="number" id="calcAmount" placeholder="Enter amount">
            </div>
            <div class="form-group">
                <label>Interest Rate (%)</label>
                <input type="number" id="calcRate" readonly style="background: #f8f9fa;">
            </div>
            <div class="form-group">
                <label>Tenure (Months)</label>
                <input type="number" id="calcTenure" placeholder="Enter months">
            </div>
        </div>
        <button type="button" class="btn btn-primary" onclick="calculateEMI()">Calculate EMI</button>

        <div class="content-section" style="display: none; margin-top: 20px;" id="emiResult">
            <h4>EMI Calculation Results</h4>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                <div style="text-align: center;">
                    <p><strong>Monthly EMI</strong></p>
                    <div style="font-size: 20px; font-weight: bold; color: #74b9ff;" id="monthlyEmi">₹0</div>
                </div>
                <div style="text-align: center;">
                    <p><strong>Total Amount</strong></p>
                    <div style="font-size: 20px; font-weight: bold; color: #2c3e50;" id="totalAmount">₹0</div>
                </div>
                <div style="text-align: center;">
                    <p><strong>Total Interest</strong></p>
                    <div style="font-size: 20px; font-weight: bold; color: #fdcb6e;" id="totalInterest">₹0</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Loan Application Form -->
    <div class="content-section" style="display: none;" id="applicationForm">
        <h3>📋 Loan Application Form</h3>
        <form action="LoanServlet" method="post">
            <input type="hidden" name="action" value="apply">
            <input type="hidden" id="selectedLoanType" name="loanTypeId" required>

            <div class="form-group">
                <label>Selected Loan Type</label>
                <input type="text" id="selectedLoanTypeName" readonly style="background: #f8f9fa;">
            </div>

            <div class="form-group">
                <label>Loan Amount (₹)</label>
                <input type="number" name="loanAmount" id="loanAmount" required placeholder="Enter loan amount" min="1000">
            </div>

            <div class="form-group">
                <label>Tenure (Months)</label>
                <input type="number" name="tenureMonths" id="tenureMonths" required placeholder="Enter tenure in months" min="1">
                <small id="tenureHelp" style="color: #666; margin-top: 5px; display: block;"></small>
            </div>

            <div class="form-group">
                <label>Purpose of Loan</label>
                <textarea name="purpose" rows="3" required placeholder="Describe the purpose of your loan"></textarea>
            </div>

            <div class="navigation">
                <div class="nav-links">
                    <a href="dashboard.jsp" class="btn btn-warning">Cancel</a>
                    <button type="submit" class="btn btn-success">Submit Application</button>
                </div>
            </div>
        </form>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp" class="btn">🏠 Back to Dashboard</a>
            <a href="my-loans.jsp" class="btn btn-loan">💰 My Loans</a>
            <a href="profile.jsp" class="btn btn-primary">👤 Profile</a>
        </div>
    </div>
</main>

<footer>
    <div class="footer-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="profile.jsp">Profile</a>
        <a href="my-loans.jsp">My Loans</a>
        <a href="user-statements.jsp">Statements</a>
    </div>
    <p>&copy; 2024 SecureVault. All rights reserved.</p>
</footer>

<script>
    let selectedLoanData = null;

    function selectLoanType(id, rate, maxAmount, minAmount, maxTenure, name) {
        // Remove previous selection
        document.querySelectorAll('.content-section[onclick]').forEach(card => {
            card.style.borderColor = 'transparent';
            card.style.backgroundColor = 'white';
        });

        // Add selection to clicked card
        event.target.closest('.content-section').style.borderColor = '#74b9ff';
        event.target.closest('.content-section').style.backgroundColor = '#f8f9fa';

        // Store loan data
        selectedLoanData = { id, rate, maxAmount, minAmount, maxTenure, name };

        // Update form fields
        document.getElementById('selectedLoanType').value = id;
        document.getElementById('selectedLoanTypeName').value = name;
        document.getElementById('calcRate').value = rate;

        // Set input constraints
        document.getElementById('loanAmount').setAttribute('max', maxAmount);
        document.getElementById('loanAmount').setAttribute('min', minAmount);
        document.getElementById('tenureMonths').setAttribute('max', maxTenure);

        // Show help text
        document.getElementById('tenureHelp').textContent = `Maximum tenure: ${maxTenure} months`;

        // Show calculator and form sections
        document.getElementById('calculatorSection').style.display = 'block';
        document.getElementById('applicationForm').style.display = 'block';
    }

    function calculateEMI() {
        const amount = parseFloat(document.getElementById('calcAmount').value);
        const rate = parseFloat(document.getElementById('calcRate').value);
        const tenure = parseInt(document.getElementById('calcTenure').value);

        if (!amount || !rate || !tenure) {
            alert('Please enter all values');
            return;
        }

        if (!selectedLoanData) {
            alert('Please select a loan type first');
            return;
        }

        // Validate amount
        if (amount < selectedLoanData.minAmount || amount > selectedLoanData.maxAmount) {
            alert(`Amount must be between ₹${selectedLoanData.minAmount} and ₹${selectedLoanData.maxAmount}`);
            return;
        }

        // Validate tenure
        if (tenure > selectedLoanData.maxTenure) {
            alert(`Tenure cannot exceed ${selectedLoanData.maxTenure} months`);
            return;
        }

        // Calculate EMI
        const r = rate / (12 * 100);
        let emi = (amount * r * Math.pow(1 + r, tenure)) / (Math.pow(1 + r, tenure) - 1);
        const totalAmount = emi * tenure;
        const totalInterest = totalAmount - amount;

        // Display results
        document.getElementById('monthlyEmi').textContent = '₹' + emi.toFixed(2);
        document.getElementById('totalAmount').textContent = '₹' + totalAmount.toFixed(2);
        document.getElementById('totalInterest').textContent = '₹' + totalInterest.toFixed(2);
        document.getElementById('emiResult').style.display = 'block';

        // Auto-fill form
        document.getElementById('loanAmount').value = amount;
        document.getElementById('tenureMonths').value = tenure;
    }
</script>

</body>
</html>
