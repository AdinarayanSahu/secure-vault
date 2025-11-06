<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.LoanType" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Loan - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
    <script>
        function calculateEMI() {
            const amount = parseFloat(document.getElementById('loanAmount').value);
            const rate = parseFloat(document.getElementById('interestRate').value);
            const tenure = parseInt(document.getElementById('tenureMonths').value);

            if (amount && rate && tenure) {
                const monthlyRate = rate / (12 * 100);
                let emi;

                if (monthlyRate > 0) {
                    emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, tenure)) / (Math.pow(1 + monthlyRate, tenure) - 1);
                } else {
                    emi = amount / tenure;
                }

                const totalAmount = emi * tenure;

                document.getElementById('monthlyEMI').textContent = '₹' + emi.toFixed(2);
                document.getElementById('totalAmount').textContent = '₹' + totalAmount.toFixed(2);
            }
        }

        function updateLoanTypeDetails() {
            const select = document.getElementById('loanTypeId');
            const selectedOption = select.options[select.selectedIndex];

            if (selectedOption.value) {
                const interestRate = selectedOption.getAttribute('data-rate');
                const minAmount = selectedOption.getAttribute('data-min');
                const maxAmount = selectedOption.getAttribute('data-max');
                const maxTenure = selectedOption.getAttribute('data-tenure');

                document.getElementById('interestRate').value = interestRate;
                document.getElementById('loanAmount').setAttribute('min', minAmount);
                document.getElementById('loanAmount').setAttribute('max', maxAmount);
                document.getElementById('tenureMonths').setAttribute('max', maxTenure);

                document.getElementById('loanDetails').innerHTML =
                    '<p><strong>Interest Rate:</strong> ' + interestRate + '% p.a.</p>' +
                    '<p><strong>Loan Amount:</strong> ₹' + minAmount + ' - ₹' + maxAmount + '</p>' +
                    '<p><strong>Maximum Tenure:</strong> ' + maxTenure + ' months</p>';

                calculateEMI();
            }
        }

        function validateForm() {
            const loanTypeId = document.getElementById('loanTypeId').value;
            const loanAmount = parseFloat(document.getElementById('loanAmount').value);
            const tenureMonths = parseInt(document.getElementById('tenureMonths').value);
            const purpose = document.getElementById('purpose').value.trim();

            if (!loanTypeId) {
                alert('Please select a loan type');
                return false;
            }

            if (!loanAmount || loanAmount <= 0) {
                alert('Please enter a valid loan amount');
                return false;
            }

            if (!tenureMonths || tenureMonths <= 0) {
                alert('Please enter a valid tenure');
                return false;
            }

            if (!purpose) {
                alert('Please enter the purpose of the loan');
                return false;
            }

            return true;
        }
    </script>
</head>
<body>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    Double balance = (Double) session.getAttribute("balance");

    if (name == null || accountNo == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - Apply for Loan</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Loan Application</h3>
        <p>Account: <%= accountNo %> | Name: <%= name %> | Balance: ₹<%= String.format("%.2f", balance) %></p>
    </div>

    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
    <div class="alert alert-error"><%= error %></div>
    <% } else if (success != null) { %>
    <div class="alert alert-success"><%= success %></div>
    <% } %>

    <div class="content-section">
        <form action="LoanServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="apply">

            <div class="form-group">
                <label for="loanTypeId">Loan Type:</label>
                <select id="loanTypeId" name="loanTypeId" required onchange="updateLoanTypeDetails()">
                    <option value="">Select Loan Type</option>
                    <%
                        List<LoanType> loanTypes = (List<LoanType>) request.getAttribute("loanTypes");
                        if (loanTypes != null) {
                            for (LoanType loanType : loanTypes) {
                    %>
                    <option value="<%= loanType.getLoanTypeId() %>"
                            data-rate="<%= loanType.getInterestRate() %>"
                            data-min="<%= loanType.getMinAmount() %>"
                            data-max="<%= loanType.getMaxAmount() %>"
                            data-tenure="<%= loanType.getMaxTenureMonths() %>">
                        <%= loanType.getLoanName() %>
                    </option>
                    <% }} %>
                </select>
            </div>

            <div id="loanDetails" class="loan-details" style="margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 5px;">
                <p>Please select a loan type to see details</p>
            </div>

            <div class="form-group">
                <label for="loanAmount">Loan Amount (₹):</label>
                <input type="number" id="loanAmount" name="loanAmount" required
                       onchange="calculateEMI()" onkeyup="calculateEMI()">
            </div>

            <div class="form-group">
                <label for="tenureMonths">Tenure (Months):</label>
                <input type="number" id="tenureMonths" name="tenureMonths" required
                       onchange="calculateEMI()" onkeyup="calculateEMI()">
            </div>

            <div class="form-group">
                <label for="purpose">Purpose:</label>
                <textarea id="purpose" name="purpose" rows="3" required
                          placeholder="Describe the purpose of this loan"></textarea>
            </div>

            <input type="hidden" id="interestRate" name="interestRate">

            <div class="emi-calculator" style="margin: 20px 0; padding: 15px; background: #e3f2fd; border-radius: 5px;">
                <h4>EMI Calculation</h4>
                <p><strong>Monthly EMI:</strong> <span id="monthlyEMI">₹0.00</span></p>
                <p><strong>Total Amount Payable:</strong> <span id="totalAmount">₹0.00</span></p>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-success">Submit Application</button>
                <a href="LoanServlet?action=myloans" class="btn btn-secondary">View My Loans</a>
                <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </form>
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
