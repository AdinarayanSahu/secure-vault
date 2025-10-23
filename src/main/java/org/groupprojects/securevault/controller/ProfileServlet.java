package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("ProfileServlet: Session invalid, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String name = (String) session.getAttribute("name");
        Integer accountNo = (Integer) session.getAttribute("accountNo");
        Double balance = (Double) session.getAttribute("balance");

        System.out.println("ProfileServlet DEBUG - Session attributes:");
        System.out.println("userId: " + userId);
        System.out.println("name: " + name);
        System.out.println("accountNo: " + accountNo);
        System.out.println("balance: " + balance);

        if (name == null) {
            name = "User";
            System.out.println("ProfileServlet WARNING: name is null, using fallback");
        }
        if (accountNo == null) {
            accountNo = 0;
            System.out.println("ProfileServlet WARNING: accountNo is null, using fallback");
        }
        if (balance == null) {
            balance = 0.0;
            System.out.println("ProfileServlet WARNING: balance is null, using fallback");
        }

        User user = null;
        try {
            String sql = "SELECT * FROM users WHERE user_id = ?";
            try (Connection con = getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setName(rs.getString("name"));
                        user.setAge(rs.getInt("age"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone(rs.getString("mobile"));
                        user.setAddress(rs.getString("address"));
                        user.setPanNo(rs.getString("pan_no"));
                        user.setAadhaarNo(rs.getString("aadhaar_no"));
                        System.out.println("ProfileServlet: User loaded successfully: " + user.getName());
                    } else {
                        System.out.println("ProfileServlet: No user found for userId: " + userId);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("ProfileServlet ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
        }

        if (user != null) {
            request.setAttribute("user", user);
        }
        request.setAttribute("accountNo", accountNo);
        request.setAttribute("balance", balance);

        System.out.println("ProfileServlet: Forwarding to profile.jsp");
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        try {
            // Update user profile (excluding PAN and Aadhaar - only editable by admin)
            String sql = "UPDATE users SET name=?, age=?, email=?, mobile=?, address=? WHERE user_id=?";
            try (Connection con = getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, request.getParameter("name"));
                ps.setInt(2, Integer.parseInt(request.getParameter("age")));
                ps.setString(3, request.getParameter("email"));
                ps.setString(4, request.getParameter("mobile"));
                ps.setString(5, request.getParameter("address"));
                ps.setInt(6, userId);

                int result = ps.executeUpdate();
                if (result > 0) {
                    session.setAttribute("name", request.getParameter("name"));
                    request.setAttribute("success", "Profile updated successfully!");
                    System.out.println("ProfileServlet: Profile updated successfully for userId: " + userId);
                } else {
                    request.setAttribute("error", "Failed to update profile.");
                    System.out.println("ProfileServlet: Profile update failed for userId: " + userId);
                }
            }

            // Fetch updated user data including PAN and Aadhaar
            String sql2 = "SELECT * FROM users WHERE user_id = ?";
            try (Connection con = getConnection();
                 PreparedStatement ps = con.prepareStatement(sql2)) {

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
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        request.setAttribute("accountNo", session.getAttribute("accountNo"));
        request.setAttribute("balance", session.getAttribute("balance"));

        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }
}