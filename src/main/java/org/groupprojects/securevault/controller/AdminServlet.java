package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.AdminDao;
import org.groupprojects.securevault.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isValidAdmin(request, response)) return;

        String action = request.getParameter("action");
        AdminDao adminDao = new AdminDao();

        try {
            switch (action == null ? "dashboard" : action) {
                case "dashboard":
                    request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
                    break;

                case "viewUsers":
                case "getAllUsers":
                    List<User> users = adminDao.getAllUsers();
                    request.setAttribute("users", users);
                    request.setAttribute("showUsers", true);
                    request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
                    break;

                case "getAllStatements":
                    List<String> statements = adminDao.getAllStatements();
                    request.setAttribute("statements", statements);
                    request.setAttribute("showStatements", true);
                    request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
                    break;

                case "deleteUser":
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    boolean success = adminDao.deleteUser(userId);
                    request.setAttribute(success ? "success" : "error",
                            success ? "User deleted successfully!" : "Failed to delete user!");
                    List<User> updatedUsers = adminDao.getAllUsers();
                    request.setAttribute("users", updatedUsers);
                    request.setAttribute("showUsers", true);
                    request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
                    break;

                default:
                    // If action doesn't match, redirect to dashboard
                    response.sendRedirect("AdminServlet?action=dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
        }
    }

    private boolean isValidAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return false;
        }

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("DashboardServlet");
            return false;
        }
        return true;
    }
}