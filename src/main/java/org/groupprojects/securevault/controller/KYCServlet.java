package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.KYCDao;
import org.groupprojects.securevault.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/KYCServlet")
public class KYCServlet extends HttpServlet {

    private static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        try {

            String sql = "SELECT * FROM users WHERE user_id = ?";
            try (Connection con = getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setName(rs.getString("name"));
                        user.setAge(rs.getInt("age"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone(rs.getString("mobile"));
                        user.setAddress(rs.getString("address"));
                        user.setPanNo(rs.getString("pan_no"));
                        user.setAadhaarNo(rs.getString("aadhaar_no"));

                        request.setAttribute("user", user);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading user data: " + e.getMessage());
        }

        request.getRequestDispatcher("kyc.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");


        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String panNo = request.getParameter("panNo");
        String aadhaarNo = request.getParameter("aadhaarNo");
        String address = request.getParameter("address");


        if (email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                panNo == null || panNo.trim().isEmpty() ||
                aadhaarNo == null || aadhaarNo.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required.");
            doGet(request, response);
            return;
        }


        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("error", "Please enter a valid email address");
            doGet(request, response);
            return;
        }


        if (!phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits");
            doGet(request, response);
            return;
        }


        panNo = panNo.toUpperCase();
        if (!panNo.matches("[A-Z]{5}[0-9]{4}[A-Z]{1}")) {
            request.setAttribute("error", "PAN number must be in format: ABCDE1234F (5 letters + 4 digits + 1 letter)");
            doGet(request, response);
            return;
        }


        if (!aadhaarNo.matches("\\d{12}")) {
            request.setAttribute("error", "Aadhaar number must be exactly 12 digits");
            doGet(request, response);
            return;
        }

        try {

            String sql = "UPDATE users SET email = ?, mobile = ?, pan_no = ?, aadhaar_no = ?, address = ? WHERE user_id = ?";
            try (Connection con = getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, email);
                ps.setString(2, phone);
                ps.setString(3, panNo);
                ps.setString(4, aadhaarNo);
                ps.setString(5, address);
                ps.setInt(6, userId);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    request.setAttribute("success", "KYC information updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update KYC information. Please try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg = "Database error occurred while updating KYC information.";
            if (e.getMessage().contains("Unknown column")) {
                errorMsg = "Database schema error. Please contact administrator.";
            }
            request.setAttribute("error", errorMsg);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
        }


        doGet(request, response);
    }
}
