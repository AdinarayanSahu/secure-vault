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

        System.out.println("DEBUG: Received registration request for user: " + username);

        if (phone == null || phone.trim().isEmpty()) {
            response.getWriter().println("Error: Phone number is required");
            return;
        }

        int age = 0;
        try {
            age = Integer.parseInt(ageParam);
        } catch (NumberFormatException e) {
            response.getWriter().println("Error: Invalid age format");
            return;
        }

        Connection con = null;
        PreparedStatement psUser = null;
        PreparedStatement psLogin = null;
        ResultSet rs = null;

        HttpSession session = request.getSession();

        try {
            con = getConnection();
            con.setAutoCommit(false);

            String userQuery = "INSERT INTO users (name, age, address, email, mobile) VALUES (?, ?, ?, ?, ?)";
            psUser = con.prepareStatement(userQuery, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, name);
            psUser.setInt(2, age);
            psUser.setString(3, address);
            psUser.setString(4, email);
            psUser.setString(5, phone);

            int userRows = psUser.executeUpdate();
            System.out.println("DEBUG: User insert affected rows: " + userRows);

            rs = psUser.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
                System.out.println("DEBUG: Generated user_id: " + userId);
            }

            if (userId == 0) {
                throw new SQLException("Failed to get generated user_id");
            }

            String loginQuery = "INSERT INTO login (user_id, username, password) VALUES (?, ?, ?)";
            psLogin = con.prepareStatement(loginQuery);
            psLogin.setInt(1, userId);
            psLogin.setString(2, username);
            psLogin.setString(3, password);
            int loginRows = psLogin.executeUpdate();
            System.out.println("DEBUG: Login insert affected rows: " + loginRows);

            String personalAccountQuery = "INSERT INTO personal_account (user_id, name, balance) VALUES (?, ?, ?)";
            PreparedStatement psPersonal = con.prepareStatement(personalAccountQuery, Statement.RETURN_GENERATED_KEYS);
            psPersonal.setInt(1, userId);
            psPersonal.setString(2, name);
            psPersonal.setDouble(3, 0.0);
            int accountRows = psPersonal.executeUpdate();
            System.out.println("DEBUG: Account insert affected rows: " + accountRows);

            ResultSet rsAccount = psPersonal.getGeneratedKeys();
            int accountNo = 0;
            if (rsAccount.next()) {
                accountNo = rsAccount.getInt(1);
                System.out.println("DEBUG: Generated account_no: " + accountNo);
            }

            con.commit();

            session.setAttribute("userId", userId);
            session.setAttribute("username", username);
            session.setAttribute("name", name);
            session.setAttribute("accountNo", accountNo);
            session.setAttribute("balance", 0.0);

            rsAccount.close();
            psPersonal.close();

            System.out.println("DEBUG: Registration successful, redirecting to LandingServlet");
            response.sendRedirect("LandingServlet");

        } catch (Exception e) {
            System.out.println("ERROR: Registration failed - " + e.getMessage());
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            response.getWriter().println("Registration failed: " + e.getMessage());
        } finally {
            try {
                if (con != null) con.setAutoCommit(true);
                if (rs != null) rs.close();
                if (psUser != null) psUser.close();
                if (psLogin != null) psLogin.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}