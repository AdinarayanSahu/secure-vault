<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.groupprojects.securevault.model.LoanType" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Application - Secure Vault</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .loan-container {
            max-width: 900px;
            margin: 50px auto;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .loan-form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group select, .form-group input, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        .loan-types {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .loan-type-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            border: 3px solid #ddd;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .loan-type-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .loan-type-card:hover::before {
            transform: scaleX(1);
        }
        .loan-type-card:hover {
            border-color: #667eea;
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
        }
        .loan-type-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #f0f4ff 0%, #e8f2ff 100%);
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }
        .loan-type-card.selected::before {
            transform: scaleX(1);
        }
        .interest-rate {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin: 15px 0;
        }
        .loan-features {
            list-style: none;
            padding: 0;
            margin: 15px 0;
        }
        .loan-features li {
            padding: 5px 0;
            font-size: 0.9em;
            color: #666;
        }
        .loan-features li::before {
            content: '✓';
            color: #28a745;
            font-weight: bold;
            margin-right: 8px;
        }
        .emi-calculator {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 20px;
            border: 2px solid #f1f3f4;
        }
        .emi-result {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            border-left: 5px solid #667eea;
        }
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
            margin-right: 15px;
        }
        .tenure-info {
            background: #fff3cd;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            border-left: 4px solid #ffc107;
        }
        .approval-notice {
            background: #d1ecf1;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 5px solid #17a2b8;
        }
    </style>
</head>
<body>
    <div class="loan-container">
        <h2 style="color: white; text-align: center; margin-bottom: 30px;">💰 Apply for Loan</h2>

        <div class="approval-notice">
            <h4 style="color: #0c5460; margin-bottom: 10px;">📋 Loan Approval Process</h4>
            <p style="color: #0c5460; margin: 0;">All loan applications require admin approval. Once approved, the loan amount will be automatically credited to your account. Processing time: 1-2 business days.</p>
        </div>

        <!-- Fixed Interest Rate Loan Types -->
        <div class="loan-types">
            <%
                List<LoanType> loanTypes = (List<LoanType>) request.getAttribute("loanTypes");
                if (loanTypes != null) {
                    for (LoanType loanType : loanTypes) {
                        String cardClass = "";
                        String features = "";

                        if (loanType.getInterestRate() == 7.0) {
                            cardClass = "basic-loan";
                            features = "Quick approval|Short term|Lower amounts|6-12 months";
                        } else if (loanType.getInterestRate() == 9.0) {
                            cardClass = "standard-loan";
                            features = "Flexible terms|Medium amounts|12-36 months|Best for personal needs";
                        } else if (loanType.getInterestRate() == 12.0) {
                            cardClass = "premium-loan";
                            features = "High amounts|Long term|24-60 months|Business & major purchases";
                        }

                        String[] featureArray = features.split("\\|");
            %>
            <div class="loan-type-card <%= cardClass %>" onclick="selectLoanType(<%= loanType.getLoanTypeId() %>, <%= loanType.getInterestRate() %>, <%= loanType.getMaxAmount() %>, <%= loanType.getMinAmount() %>, <%= loanType.getMaxTenureMonths() %>)">
                <h4><%= loanType.getLoanName() %></h4>
                <div class="interest-rate"><%= String.format("%.0f", loanType.getInterestRate()) %>%</div>
                <p><strong>Amount:</strong> ₹<%= String.format("%.0f", loanType.getMinAmount()) %> - ₹<%= String.format("%.0f", loanType.getMaxAmount()) %></p>

                <ul class="loan-features">
                    <% for (String feature : featureArray) { %>
                    <li><%= feature %></li>
                    <% } %>
                </ul>
            </div>
            <%
                    }
                }
            %>
        </div>

        <!-- EMI Calculator -->
        <div class="emi-calculator">
            <h3>💰 EMI Calculator</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                <div class="form-group">
                    <label>Loan Amount (₹)</label>
                    <input type="number" id="calcAmount" placeholder="Enter amount" onchange="calculateEMI()">
                </div>
                <div class="form-group">
                    <label>Interest Rate (%)</label>
                    <input type="number" id="calcRate" placeholder="Rate" step="0.01" readonly style="background: #f8f9fa;">
                </div>
                <div class="form-group">
                    <label>Tenure (Months)</label>
                    <input type="number" id="calcTenure" placeholder="Months" onchange="calculateEMI()">
                </div>
            </div>
            <div class="emi-result" id="emiResult" style="display: none;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; text-align: center;">
                    <div>
                        <strong>Monthly EMI</strong><br>
                        <span id="monthlyEmi" style="color: #667eea; font-size: 1.3em; font-weight: bold;">₹0</span>
                    </div>
                    <div>
                        <strong>Total Amount</strong><br>
                        <span id="totalAmount" style="color: #28a745; font-size: 1.3em; font-weight: bold;">₹0</span>
                    </div>
                    <div>
                        <strong>Total Interest</strong><br>
                        <span id="totalInterest" style="color: #dc3545; font-size: 1.3em; font-weight: bold;">₹0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loan Application Form -->
        <div class="loan-form">
            <h3>📋 Loan Application Form</h3>
            <form action="LoanServlet" method="post">
                <input type="hidden" name="action" value="apply">
                <input type="hidden" id="selectedLoanType" name="loanTypeId" required>

                <div class="form-group">
                    <label>Selected Loan Type</label>
                    <input type="text" id="selectedLoanTypeName" readonly placeholder="Please select a loan type above" style="background: #f8f9fa;">
                </div>

                <div class="form-group">
                    <label>Loan Amount (₹)</label>
                    <input type="number" name="loanAmount" id="loanAmount" required placeholder="Enter loan amount" min="1000">
                </div>

                <div class="form-group">
                    <label>Tenure (Months)</label>
                    <input type="number" name="tenureMonths" id="tenureMonths" required placeholder="Enter tenure in months" min="1">
                    <div class="tenure-info" id="tenureInfo" style="display: none;">
                        <strong>Tenure Guidelines:</strong>
                        <ul style="margin: 5px 0 0 20px;">
                            <li>7% Rate: 6-12 months maximum</li>
                            <li>9% Rate: 12-36 months maximum</li>
                            <li>12% Rate: 24-60 months maximum</li>
                        </ul>
                    </div>
                </div>

                <div class="form-group">
                    <label>Purpose of Loan</label>
                    <textarea name="purpose" rows="3" required placeholder="Describe the purpose of your loan (e.g., business expansion, personal needs, education, etc.)"></textarea>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='dashboard.jsp'">Cancel</button>
                    <button type="submit" class="btn btn-primary">Submit for Admin Approval</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        let selectedLoanTypeData = null;

        function selectLoanType(id, rate, maxAmount, minAmount, maxTenure) {
            // Remove previous selection
            document.querySelectorAll('.loan-type-card').forEach(card => {
                card.classList.remove('selected');
            });

            // Add selection to clicked card
            event.target.closest('.loan-type-card').classList.add('selected');

            // Store selected loan type data
            selectedLoanTypeData = {
                id: id,
                rate: rate,
                maxAmount: maxAmount,
                minAmount: minAmount,
                maxTenure: maxTenure
            };

            // Update form fields
            document.getElementById('selectedLoanType').value = id;
            document.getElementById('selectedLoanTypeName').value = event.target.closest('.loan-type-card').querySelector('h4').textContent;
            document.getElementById('calcRate').value = rate;

            // Set minimum tenure based on interest rate
            let minTenure = 1;
            if (rate === 7) minTenure = 6;
            else if (rate === 9) minTenure = 12;
            else if (rate === 12) minTenure = 24;

            // Update input constraints
            document.getElementById('loanAmount').setAttribute('max', maxAmount);
            document.getElementById('loanAmount').setAttribute('min', minAmount);
            document.getElementById('tenureMonths').setAttribute('max', maxTenure);
            document.getElementById('tenureMonths').setAttribute('min', minTenure);

            // Show tenure info
            document.getElementById('tenureInfo').style.display = 'block';

            // Clear previous calculations
            document.getElementById('emiResult').style.display = 'none';
        }

        function calculateEMI() {
            const amount = parseFloat(document.getElementById('calcAmount').value);
            const rate = parseFloat(document.getElementById('calcRate').value);
            const tenure = parseInt(document.getElementById('calcTenure').value);

            if (!amount || !rate || !tenure || !selectedLoanTypeData) {
                return;
            }

            // Validate amounts
            if (amount < selectedLoanTypeData.minAmount || amount > selectedLoanTypeData.maxAmount) {
                alert(`Loan amount must be between ₹${selectedLoanTypeData.minAmount} and ₹${selectedLoanTypeData.maxAmount}`);
                return;
            }

            // Validate tenure based on interest rate
            let minTenure = 1;
            if (selectedLoanTypeData.rate === 7) minTenure = 6;
            else if (selectedLoanTypeData.rate === 9) minTenure = 12;
            else if (selectedLoanTypeData.rate === 12) minTenure = 24;

            if (tenure < minTenure || tenure > selectedLoanTypeData.maxTenure) {
                alert(`Tenure must be between ${minTenure} and ${selectedLoanTypeData.maxTenure} months for ${selectedLoanTypeData.rate}% interest rate`);
                return;
            }

            // Calculate EMI
            const r = rate / (12 * 100);
            let emi;

            if (r > 0) {
                emi = (amount * r * Math.pow(1 + r, tenure)) / (Math.pow(1 + r, tenure) - 1);
            } else {
                emi = amount / tenure;
            }

            const totalAmount = emi * tenure;
            const totalInterest = totalAmount - amount;

            // Display results
            document.getElementById('monthlyEmi').textContent = '₹' + emi.toFixed(2);
            document.getElementById('totalAmount').textContent = '₹' + totalAmount.toFixed(2);
            document.getElementById('totalInterest').textContent = '₹' + totalInterest.toFixed(2);
            document.getElementById('emiResult').style.display = 'block';

            // Update form fields
            document.getElementById('loanAmount').value = amount;
            document.getElementById('tenureMonths').value = tenure;
        }
    </script>
</body>
</html>

