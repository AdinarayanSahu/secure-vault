<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deposit Money - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<!-- ENHANCED Loading Overlay -->
<div id="loadingOverlay">
    <div class="loading-spinner deposit"></div>
    <div class="loading-text">Processing Your Deposit...</div>
    <div class="transaction-message">Please wait while we securely process your deposit. This may take a few moments.</div>
    <div class="loading-progress">
        <div id="loadingBar" class="loading-bar deposit"></div>
    </div>
</div>

<%
    String name = (String) session.getAttribute("name");
    Integer accountNo = (Integer) session.getAttribute("accountNo");
    Double balance = (Double) session.getAttribute("balance");

    if (name == null || accountNo == null || balance == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<header>
    <h1>🏦 SecureVault - Deposit</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Deposit Money</h3>
        <p>Welcome , <%= name %> !</p>
        <p>Account: <%= accountNo %> | Current Balance: ₹ <%= String.format("%.2f", balance) %></p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
            <br>New Balance: ₹ <%= request.getAttribute("newBalance") %>
        </div>
    <% } %>

    <div class="content-section">
        <h2> Add Money to Your Account</h2>

        <form id="depositForm" action="DepositServlet" method="post">
            <div class="form-group">
                <label for="amount"> Amount to Deposit:</label>
                <input type="number" id="amount" name="amount" placeholder="Enter amount (₹)" required min="1" max="100000" step="0.01">
                <small style="color: #666; font-size: 12px;">Minimum: ₹1 | Maximum: ₹100,000</small>
            </div>

            <div class="form-group">
                <label for="paymentMethod"> Payment Method:</label>
                <select id="paymentMethod" name="paymentMethod" required>
                    <option value="">Select Payment Method</option>
                    <option value="UPI">UPI Payment</option>
                    <option value="NET_BANKING">Net Banking</option>
                    <option value="DEBIT_CARD">Debit Card</option>
                    <option value="CREDIT_CARD">Credit Card</option>
                    <option value="CASH">Cash Deposit</option>
                </select>
            </div>

            <div class="form-group">
                <label for="transactionPassword"> Enter Your Password:</label>
                <input type="password" id="transactionPassword" name="transactionPassword" placeholder="Enter your login password" required>
                <small style="color: #666; font-size: 12px;">Please enter your account password to confirm this deposit</small>
            </div>

            <button type="submit" class="btn btn-success" id="depositBtn">
                 Deposit Money
            </button>
        </form>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp"> Back to Dashboard</a>
            <a href="transfer.jsp"> Transfer Money</a>
            <a href="UserStatementsServlet"> View Statements</a>
            <a href="profile.jsp"> My Profile</a>
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

<script>
// ENHANCED Loading Screen Implementation with Better Debugging and Full Screen Coverage
document.addEventListener('DOMContentLoaded', function() {
    console.log(' Deposit page loaded - initializing enhanced loading screen...');

    const depositForm = document.getElementById('depositForm');
    const loadingOverlay = document.getElementById('loadingOverlay');
    const loadingBar = document.getElementById('loadingBar');
    const depositBtn = document.getElementById('depositBtn');

    // Debug: Check if all elements exist
    console.log('Element check:', {
        form: !!depositForm,
        overlay: !!loadingOverlay,
        bar: !!loadingBar,
        button: !!depositBtn
    });

    if (!depositForm || !loadingOverlay || !loadingBar || !depositBtn) {
        console.error('❌ Critical elements missing!');
        return;
    }

    // Add event listener for form submission
    depositForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent immediate submission
        console.log(' Deposit form submitted - starting enhanced loading sequence');

        // Validate form before showing loading
        const amount = document.getElementById('amount').value;
        const paymentMethod = document.getElementById('paymentMethod').value;
        const password = document.getElementById('transactionPassword').value;

        if (!amount || !paymentMethod || !password) {
            console.log(' Form validation failed');
            return false;
        }

        // Start loading sequence
        showFullScreenLoading();

        // Simulate processing time (4-6 seconds for deposits)
        const processingTime = Math.floor(Math.random() * 2000) + 4000;

        setTimeout(() => {
            hideLoadingAndSubmit();
        }, processingTime);
    });

    function showFullScreenLoading() {
        console.log(' Starting full screen loading sequence...');

        // Disable the submit button immediately
        depositBtn.disabled = true;
        depositBtn.innerHTML = 'Processing Deposit...';
        depositBtn.style.opacity = '0.6';

        // Force body to prevent any scrolling
        document.body.style.overflow = 'hidden';
        document.documentElement.style.overflow = 'hidden';
        document.body.style.position = 'fixed';
        document.body.style.width = '100%';
        document.body.style.height = '100%';

        // Show loading overlay with multiple fallback methods
        loadingOverlay.style.setProperty('display', 'flex', 'important');
        loadingOverlay.style.setProperty('visibility', 'visible', 'important');
        loadingOverlay.style.setProperty('opacity', '1', 'important');
        loadingOverlay.style.setProperty('z-index', '2147483647', 'important');
        loadingOverlay.classList.add('show');

        // Force browser to apply styles immediately
        loadingOverlay.offsetHeight;

        console.log('✅ Loading overlay should now be visible');
        console.log(' Overlay styles:', {
            display: loadingOverlay.style.display,
            visibility: loadingOverlay.style.visibility,
            opacity: loadingOverlay.style.opacity,
            zIndex: loadingOverlay.style.zIndex
        });

        // Reset and animate progress bar
        loadingBar.style.width = '0%';
        animateProgressBar();
    }

    function animateProgressBar() {
        let progress = 0;
        const progressInterval = setInterval(() => {
            progress += Math.random() * 4 + 2; // Random increment between 2-6
            if (progress > 100) progress = 100;

            loadingBar.style.setProperty('width', progress + '%', 'important');
            console.log(' Progress:', progress + '%');

            if (progress >= 100) {
                clearInterval(progressInterval);
                console.log('✅ Progress bar animation complete');
            }
        }, 120);
    }

    function hideLoadingAndSubmit() {
        console.log('🔚 Hiding loading and submitting form...');

        // Hide loading overlay
        loadingOverlay.style.display = 'none';
        loadingOverlay.style.visibility = 'hidden';
        loadingOverlay.style.opacity = '0';
        loadingOverlay.classList.remove('show');

        // Restore body scroll
        document.body.style.overflow = '';
        document.documentElement.style.overflow = '';
        document.body.style.position = '';
        document.body.style.width = '';
        document.body.style.height = '';

        // Re-enable button
        depositBtn.disabled = false;
        depositBtn.innerHTML = ' Deposit Money';
        depositBtn.style.opacity = '1';

        // Submit the form
        console.log(' Submitting form to server...');
        depositForm.submit();
    }

    // Prevent page refresh during deposit processing
    window.addEventListener('beforeunload', function(e) {
        if (loadingOverlay && (
            loadingOverlay.style.display === 'flex' ||
            loadingOverlay.classList.contains('show')
        )) {
            console.log(' Preventing page unload during deposit processing');
            e.preventDefault();
            e.returnValue = ' Deposit in progress. Are you sure you want to leave?';
            return e.returnValue;
        }
    });

    // Additional safety: Force overlay to stay on top
    setInterval(() => {
        if (loadingOverlay && loadingOverlay.style.display === 'flex') {
            loadingOverlay.style.setProperty('z-index', '2147483647', 'important');
        }
    }, 100);
});
</script>

</body>
</html>
