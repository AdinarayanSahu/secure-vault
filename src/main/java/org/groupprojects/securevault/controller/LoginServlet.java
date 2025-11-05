package org.groupprojects.securevault.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input parameters
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Validate password length (minimum 6 characters)
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Check for admin login first
        if ("admin".equals(username) && "admin123".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("isAdmin", true);
            session.setAttribute("username", "admin");
            session.setAttribute("name", "Administrator");
            session.setAttribute("userId", 1); // Add userId for proper session handling

            // Redirect to AdminServlet instead of directly to JSP
            response.sendRedirect("AdminServlet");
            return;
        }
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();

            String query = "SELECT u.user_id, u.name FROM login l JOIN users u ON l.user_id = u.user_id WHERE l.username = ? AND l.password = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String name = rs.getString("name");

                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setAttribute("name", name);
                session.setAttribute("isAdmin", false);

                String accQuery = "SELECT account_no, name, balance FROM personal_account WHERE user_id = ?";
                PreparedStatement ps2 = con.prepareStatement(accQuery);
                ps2.setInt(1, userId);
                ResultSet rs2 = ps2.executeQuery();

                if (rs2.next()) {
                    int accountNo = rs2.getInt("account_no");
                    String accountName = rs2.getString("name");
                    double balance = rs2.getDouble("balance");

                    session.setAttribute("accountNo", accountNo);
                    session.setAttribute("name", accountName);
                    session.setAttribute("balance", balance);
                }

                rs2.close();
                ps2.close();

                response.sendRedirect("dashboard.jsp");

            } else {
                // Invalid credentials - redirect back to login with error message
                request.setAttribute("error", "Invalid username or password. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Database or other error - redirect back to login with error message
            request.setAttribute("error", "Login failed. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
