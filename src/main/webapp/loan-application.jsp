<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.LoanType" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Application - Secure Vault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/securevault.css">
</head>
<body>
    <div class="simple-container">
        <div class="simple-card">
            <h2>💰 Apply for Loan</h2>
            <div class="info-box">
                <strong>📋 Loan Approval Process</strong><br>
                All loan applications require admin approval. Processing time: 1-2 business days.
            </div>
        </div>

        <!-- Loan Type Selection -->
        <div class="simple-card">
            <h3>Select Loan Type</h3>
            <div class="loan-options">
                <%
                    List<LoanType> loanTypes = (List<LoanType>) request.getAttribute("loanTypes");
                    if (loanTypes != null) {
                        for (LoanType loanType : loanTypes) {
                %>
                <div class="loan-card" onclick="selectLoanType(<%= loanType.getLoanTypeId() %>, <%= loanType.getInterestRate() %>, <%= loanType.getMaxAmount() %>, <%= loanType.getMinAmount() %>, <%= loanType.getMaxTenureMonths() %>, '<%= loanType.getLoanName() %>')">
                    <h4><%= loanType.getLoanName() %></h4>
                    <div class="rate-display"><%= String.format("%.0f", loanType.getInterestRate()) %>%</div>
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
        <div class="simple-card hidden" id="calculatorSection">
            <h3>💰 EMI Calculator</h3>
            <div class="calculator-grid">
                <div class="form-row">
                    <label>Loan Amount (₹)</label>
                    <input type="number" id="calcAmount" placeholder="Enter amount">
                </div>
                <div class="form-row">
                    <label>Interest Rate (%)</label>
                    <input type="number" id="calcRate" readonly style="background: #f8f9fa;">
                </div>
                <div class="form-row">
                    <label>Tenure (Months)</label>
                    <input type="number" id="calcTenure" placeholder="Enter months">
                </div>
            </div>
            <button type="button" class="simple-btn btn-primary" onclick="calculateEMI()">Calculate EMI</button>

            <div class="result-box hidden" id="emiResult">
                <div class="calculator-grid">
                    <div class="result-item">
                        <div>Monthly EMI</div>
                        <div class="result-value" id="monthlyEmi">₹0</div>
                    </div>
                    <div class="result-item">
                        <div>Total Amount</div>
                        <div class="result-value" id="totalAmount">₹0</div>
                    </div>
                    <div class="result-item">
                        <div>Total Interest</div>
                        <div class="result-value" id="totalInterest">₹0</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loan Application Form -->
        <div class="simple-card hidden" id="applicationForm">
            <h3>📋 Loan Application Form</h3>
            <form action="LoanServlet" method="post" class="simple-form">
                <input type="hidden" name="action" value="apply">
                <input type="hidden" id="selectedLoanType" name="loanTypeId" required>

                <div class="form-row">
                    <label>Selected Loan Type</label>
                    <input type="text" id="selectedLoanTypeName" readonly style="background: #f8f9fa;">
                </div>

                <div class="form-row">
                    <label>Loan Amount (₹)</label>
                    <input type="number" name="loanAmount" id="loanAmount" required placeholder="Enter loan amount" min="1000">
                </div>

                <div class="form-row">
                    <label>Tenure (Months)</label>
                    <input type="number" name="tenureMonths" id="tenureMonths" required placeholder="Enter tenure in months" min="1">
                    <small id="tenureHelp" style="color: #666; margin-top: 5px;"></small>
                </div>

                <div class="form-row">
                    <label>Purpose of Loan</label>
                    <textarea name="purpose" rows="3" required placeholder="Describe the purpose of your loan"></textarea>
                </div>

                <div class="btn-group">
                    <button type="button" class="simple-btn btn-secondary" onclick="window.location.href='dashboard.jsp'">Cancel</button>
                    <button type="submit" class="simple-btn btn-primary">Submit Application</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        let selectedLoanData = null;

        function selectLoanType(id, rate, maxAmount, minAmount, maxTenure, name) {
            // Remove previous selection
            document.querySelectorAll('.loan-card').forEach(card => {
                card.classList.remove('selected');
            });

            // Add selection to clicked card
            event.target.closest('.loan-card').classList.add('selected');

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
            document.getElementById('calculatorSection').classList.remove('hidden');
            document.getElementById('applicationForm').classList.remove('hidden');
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
            document.getElementById('emiResult').classList.remove('hidden');

            // Auto-fill form
            document.getElementById('loanAmount').value = amount;
            document.getElementById('tenureMonths').value = tenure;
        }
    </script>
</body>
</html>
