package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.KYCDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/KYCServlet")
public class KYCServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get all parameters and log them for debugging
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String panNo = request.getParameter("panNo");
        String aadhaarNo = request.getParameter("aadhaarNo");
        String address = request.getParameter("address");

        // Debug logging
        System.out.println("=== KYC UPDATE DEBUG ===");
        System.out.println("Username: " + username);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        System.out.println("PAN: " + panNo);
        System.out.println("Aadhaar: " + aadhaarNo);
        System.out.println("Address: " + address);

        // Basic validation
        if (email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                panNo == null || panNo.trim().isEmpty() ||
                aadhaarNo == null || aadhaarNo.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required. Missing: " +
                    (email == null || email.trim().isEmpty() ? "Email " : "") +
                    (phone == null || phone.trim().isEmpty() ? "Phone " : "") +
                    (panNo == null || panNo.trim().isEmpty() ? "PAN " : "") +
                    (aadhaarNo == null || aadhaarNo.trim().isEmpty() ? "Aadhaar " : "") +
                    (address == null || address.trim().isEmpty() ? "Address " : ""));
            request.getRequestDispatcher("kyc.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("kyc.jsp").forward(request, response);
            return;
        }

        // Validate phone number (10 digits)
        if (!phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits");
            request.getRequestDispatcher("kyc.jsp").forward(request, response);
            return;
        }

        // Validate PAN number format (5 letters + 4 digits + 1 letter)
        panNo = panNo.toUpperCase(); // Convert to uppercase
        if (!panNo.matches("[A-Z]{5}[0-9]{4}[A-Z]{1}")) {
            request.setAttribute("error", "PAN number must be in format: ABCDE1234F (5 letters + 4 digits + 1 letter)");
            request.getRequestDispatcher("kyc.jsp").forward(request, response);
            return;
        }

        // Validate Aadhaar number (12 digits)
        if (!aadhaarNo.matches("\\d{12}")) {
            request.setAttribute("error", "Aadhaar number must be exactly 12 digits");
            request.getRequestDispatcher("kyc.jsp").forward(request, response);
            return;
        }

        try {
            System.out.println("Attempting to update KYC...");
            KYCDao kycDao = new KYCDao();
            boolean success = kycDao.updateKYC(username, email, phone, panNo, aadhaarNo, address);
            System.out.println("Update result: " + success);

            if (success) {
                // Update session with new values
                session.setAttribute("email", email);
                session.setAttribute("phone", phone);
                session.setAttribute("panNo", panNo);
                session.setAttribute("aadhaarNo", aadhaarNo);
                session.setAttribute("address", address);

                request.setAttribute("success", "KYC information updated successfully!");
                System.out.println("KYC update successful!");
            } else {
                request.setAttribute("error", "Failed to update KYC information. Please check if the database columns 'pan_no' and 'aadhaar_no' exist in the users table.");
                System.out.println("KYC update failed - no rows affected");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "Database error: " + e.getMessage();
            if (e.getMessage().contains("Unknown column")) {
                errorMsg = "Database column missing. Please run: ALTER TABLE users ADD COLUMN pan_no VARCHAR(10), ADD COLUMN aadhaar_no VARCHAR(12);";
            }
            request.setAttribute("error", errorMsg);
            System.out.println("KYC update exception: " + e.getMessage());
        }

        request.getRequestDispatcher("kyc.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Redirect to KYC page
        response.sendRedirect("kyc.jsp");
    }
}