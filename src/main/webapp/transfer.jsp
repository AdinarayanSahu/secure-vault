<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Money - SecureVault</title>
    <link rel="stylesheet" href="styles/securevault.css">
</head>
<body>

<!-- ENHANCED Loading Overlay -->
<div id="loadingOverlay">
    <div class="loading-spinner"></div>
    <div class="loading-text">Processing Your Transfer...</div>
    <div class="transaction-message">Please wait while we securely transfer your money. This process is encrypted and secure.</div>
    <div class="loading-progress">
        <div id="loadingBar" class="loading-bar"></div>
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
    <h1>🏦 SecureVault - Transfer</h1>
</header>

<main class="container">
    <div class="user-info">
        <h3>Transfer Money</h3>
        <p>Welcome, <%= name %> !</p>
        <p>From Account: <%= accountNo %></p>
    </div>

    <div class="balance-card">
        <h3>Available Balance</h3>
        <div class="balance-amount">₹ <%= String.format("%.2f", balance) %></div>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
            <br>Remaining Balance: ₹ <%= request.getAttribute("newBalance") %>
        </div>
    <% } %>

    <div class="content-section">
        <h2>Send Money</h2>

        <form id="transferForm" action="TransferServlet" method="post">
            <div class="form-group">
                <label for="toAccountNo">To Account Number:</label>
                <input type="number" id="toAccountNo" name="toAccountNo" placeholder="Enter recipient account number" required>
            </div>

            <div class="form-group">
                <label for="amount">Amount to Transfer:</label>
                <input type="number" id="amount" name="amount" placeholder="Enter amount (₹)" required min="1" step="0.01" max="<%= balance %>">
                <small style="color: #666; font-size: 12px;">Maximum available: ₹<%= String.format("%.2f", balance) %></small>
            </div>

            <div class="form-group">
                <label for="transactionPassword">Enter Your Password:</label>
                <input type="password" id="transactionPassword" name="transactionPassword" placeholder="Enter your login password" required>
                <small style="color: #666; font-size: 12px;">Please enter your account password to confirm this transfer</small>
            </div>

            <button type="submit" class="btn btn-primary" id="transferBtn">
                Transfer Money
            </button>
        </form>
    </div>

    <div class="navigation">
        <div class="nav-links">
            <a href="dashboard.jsp"> Back to Dashboard</a>
            <a href="deposit.jsp"> Deposit Money</a>
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
// ENHANCED Loading Screen Implementation with Full Screen Coverage
document.addEventListener('DOMContentLoaded', function() {
    console.log(' Transfer page loaded - initializing enhanced loading screen...');

    const transferForm = document.getElementById('transferForm');
    const loadingOverlay = document.getElementById('loadingOverlay');
    const loadingBar = document.getElementById('loadingBar');
    const transferBtn = document.getElementById('transferBtn');

    // Debug: Check if all elements exist
    console.log('Element check:', {
        form: !!transferForm,
        overlay: !!loadingOverlay,
        bar: !!loadingBar,
        button: !!transferBtn
    });

    if (!transferForm || !loadingOverlay || !loadingBar || !transferBtn) {
        console.error('❌ Critical elements missing!');
        return;
    }

    transferForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent immediate submission
        console.log(' Transfer form submitted - starting enhanced loading sequence');

        // Validate form before showing loading
        const toAccount = document.getElementById('toAccountNo').value;
        const amount = document.getElementById('amount').value;
        const password = document.getElementById('transactionPassword').value;

        if (!toAccount || !amount || !password) {
            console.log(' Form validation failed');
            return false;
        }

        // Start loading sequence
        showFullScreenLoading();

        // Simulate processing time (6-8 seconds for transfers)
        const processingTime = Math.floor(Math.random() * 2000) + 6000;

        setTimeout(() => {
            hideLoadingAndSubmit();
        }, processingTime);
    });

    function showFullScreenLoading() {
        console.log('🎬 Starting full screen loading sequence...');

        // Disable the submit button immediately
        transferBtn.disabled = true;
        transferBtn.innerHTML = ' Processing Transfer...';
        transferBtn.style.opacity = '0.6';

        // Force body to prevent any scrolling and ensure full coverage
        document.body.style.overflow = 'hidden';
        document.documentElement.style.overflow = 'hidden';
        document.body.style.position = 'fixed';
        document.body.style.width = '100%';
        document.body.style.height = '100%';
        document.body.style.top = '0';
        document.body.style.left = '0';

        // Show loading overlay with maximum priority
        loadingOverlay.style.setProperty('display', 'flex', 'important');
        loadingOverlay.style.setProperty('visibility', 'visible', 'important');
        loadingOverlay.style.setProperty('opacity', '1', 'important');
        loadingOverlay.style.setProperty('z-index', '2147483647', 'important');
        loadingOverlay.style.setProperty('position', 'fixed', 'important');
        loadingOverlay.style.setProperty('top', '0', 'important');
        loadingOverlay.style.setProperty('left', '0', 'important');
        loadingOverlay.style.setProperty('right', '0', 'important');
        loadingOverlay.style.setProperty('bottom', '0', 'important');
        loadingOverlay.style.setProperty('width', '100vw', 'important');
        loadingOverlay.style.setProperty('height', '100vh', 'important');
        loadingOverlay.classList.add('show');

        // Force browser to apply styles immediately
        loadingOverlay.offsetHeight;

        console.log('✅ Loading overlay should now be visible');
        console.log(' Overlay styles applied:', {
            display: loadingOverlay.style.display,
            visibility: loadingOverlay.style.visibility,
            opacity: loadingOverlay.style.opacity,
            zIndex: loadingOverlay.style.zIndex,
            position: loadingOverlay.style.position
        });

        // Reset and animate progress bar
        loadingBar.style.width = '0%';
        animateProgressBar();
    }

    function animateProgressBar() {
        let progress = 0;
        const progressInterval = setInterval(() => {
            progress += Math.random() * 3 + 1; // Random increment between 1-4
            if (progress > 100) progress = 100;

            loadingBar.style.setProperty('width', progress + '%', 'important');
            console.log(' Transfer Progress:', progress + '%');

            if (progress >= 100) {
                clearInterval(progressInterval);
                console.log(' Transfer progress animation complete');
            }
        }, 150);
    }

    function hideLoadingAndSubmit() {
        console.log(' Hiding loading and submitting transfer form...');

        // Hide loading overlay
        loadingOverlay.style.display = 'none';
        loadingOverlay.style.visibility = 'hidden';
        loadingOverlay.style.opacity = '0';
        loadingOverlay.classList.remove('show');

        // Restore body scroll and positioning
        document.body.style.overflow = '';
        document.documentElement.style.overflow = '';
        document.body.style.position = '';
        document.body.style.width = '';
        document.body.style.height = '';
        document.body.style.top = '';
        document.body.style.left = '';

        // Re-enable button
        transferBtn.disabled = false;
        transferBtn.innerHTML = '💸 Transfer Money';
        transferBtn.style.opacity = '1';

        // Submit the form
        console.log(' Submitting transfer form to server...');
        transferForm.submit();
    }

    // Prevent page refresh during transfer processing
    window.addEventListener('beforeunload', function(e) {
        if (loadingOverlay && (
            loadingOverlay.style.display === 'flex' ||
            loadingOverlay.classList.contains('show')
        )) {
            console.log('🚫 Preventing page unload during transfer processing');
            e.preventDefault();
            e.returnValue = '⚠️ Transfer in progress. Are you sure you want to leave?';
            return e.returnValue;
        }
    });

    // Additional safety: Force overlay to maintain full coverage
    setInterval(() => {
        if (loadingOverlay && loadingOverlay.style.display === 'flex') {
            loadingOverlay.style.setProperty('z-index', '2147483647', 'important');
            loadingOverlay.style.setProperty('position', 'fixed', 'important');
            loadingOverlay.style.setProperty('width', '100vw', 'important');
            loadingOverlay.style.setProperty('height', '100vh', 'important');
        }
    }, 100);
});
</script>

</body>
</html>
