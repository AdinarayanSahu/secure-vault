package org.groupprojects.securevault.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

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
                response.getWriter().println("<h3>Invalid username or password. <a href='login.jsp'>Try again</a></h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
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
