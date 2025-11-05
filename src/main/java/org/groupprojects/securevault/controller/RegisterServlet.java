package org.groupprojects.securevault.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String ageParam = request.getParameter("age");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String panNo = request.getParameter("panNo");
        String aadhaarNo = request.getParameter("aadhaarNo");

        // Trim whitespace from input fields
        if (name != null) name = name.trim();
        if (address != null) address = address.trim();
        if (email != null) email = email.trim();
        if (username != null) username = username.trim();
        if (phone != null) phone = phone.trim();
        if (panNo != null) panNo = panNo.trim().toUpperCase();
        if (aadhaarNo != null) aadhaarNo = aadhaarNo.trim();

        // Validation
        if (name == null || name.isEmpty()) {
            request.setAttribute("error", "Name is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (ageParam == null || ageParam.trim().isEmpty()) {
            request.setAttribute("error", "Age is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (address == null || address.isEmpty()) {
            request.setAttribute("error", "Address is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (username == null || username.isEmpty()) {
            request.setAttribute("error", "Username is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.isEmpty()) {
            request.setAttribute("error", "Password is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (phone == null || phone.isEmpty()) {
            request.setAttribute("error", "Phone number is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (panNo == null || panNo.isEmpty()) {
            request.setAttribute("error", "PAN number is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (aadhaarNo == null || aadhaarNo.isEmpty()) {
            request.setAttribute("error", "Aadhaar number is required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate phone number (10 digits)
        if (!phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate PAN number format (5 letters + 4 digits + 1 letter)
        if (!panNo.matches("[A-Z]{5}[0-9]{4}[A-Z]{1}")) {
            request.setAttribute("error", "PAN number must be in format: ABCDE1234F (5 letters + 4 digits + 1 letter)");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate Aadhaar number (12 digits)
        if (!aadhaarNo.matches("\\d{12}")) {
            request.setAttribute("error", "Aadhaar number must be exactly 12 digits");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        int age = 0;
        try {
            age = Integer.parseInt(ageParam.trim());
            if (age < 18 || age > 100) {
                request.setAttribute("error", "Age must be between 18 and 100");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid age");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement psUser = null;
        PreparedStatement psLogin = null;
        PreparedStatement psPersonal = null;
        ResultSet rs = null;
        ResultSet rsAccount = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            // Check if username already exists
            String checkUserQuery = "SELECT username FROM login WHERE username = ?";
            try (PreparedStatement psCheck = con.prepareStatement(checkUserQuery)) {
                psCheck.setString(1, username);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        request.setAttribute("error", "Username already exists. Please choose a different username.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Insert user data
            String userQuery = "INSERT INTO users (name, age, address, email, mobile, pan_no, aadhaar_no) VALUES (?, ?, ?, ?, ?, ?, ?)";
            psUser = con.prepareStatement(userQuery, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, name);
            psUser.setInt(2, age);
            psUser.setString(3, address);
            psUser.setString(4, email);
            psUser.setString(5, phone);
            psUser.setString(6, panNo);
            psUser.setString(7, aadhaarNo);

            int userRows = psUser.executeUpdate();

            rs = psUser.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
            }

            if (userId == 0) {
                throw new SQLException("Failed to get generated user_id");
            }

            // Insert login credentials
            String loginQuery = "INSERT INTO login (user_id, username, password) VALUES (?, ?, ?)";
            psLogin = con.prepareStatement(loginQuery);
            psLogin.setInt(1, userId);
            psLogin.setString(2, username);
            psLogin.setString(3, password);
            int loginRows = psLogin.executeUpdate();

            // Create personal account
            String personalAccountQuery = "INSERT INTO personal_account (user_id, name, balance) VALUES (?, ?, ?)";
            psPersonal = con.prepareStatement(personalAccountQuery, Statement.RETURN_GENERATED_KEYS);
            psPersonal.setInt(1, userId);
            psPersonal.setString(2, name);
            psPersonal.setDouble(3, 0.0);
            int accountRows = psPersonal.executeUpdate();

            rsAccount = psPersonal.getGeneratedKeys();
            int accountNo = 0;
            if (rsAccount.next()) {
                accountNo = rsAccount.getInt(1);
            }

            con.commit();

            // Set success message and redirect to login page
            request.setAttribute("success", "Registration successful! Your account has been created. Please login with your credentials.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("ERROR: Registration failed - " + e.getMessage());
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            String errorMessage = "Registration failed. Please try again.";
            if (e.getMessage().contains("Duplicate entry")) {
                if (e.getMessage().contains("email")) {
                    errorMessage = "Email address already registered. Please use a different email.";
                } else if (e.getMessage().contains("pan_no")) {
                    errorMessage = "PAN number already registered. Please check your PAN number.";
                } else if (e.getMessage().contains("aadhaar_no")) {
                    errorMessage = "Aadhaar number already registered. Please check your Aadhaar number.";
                }
            }

            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            try {
                if (con != null) con.setAutoCommit(true);
                if (rsAccount != null) rsAccount.close();
                if (rs != null) rs.close();
                if (psPersonal != null) psPersonal.close();
                if (psUser != null) psUser.close();
                if (psLogin != null) psLogin.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
