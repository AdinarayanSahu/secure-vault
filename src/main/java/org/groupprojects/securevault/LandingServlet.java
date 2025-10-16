package org.groupprojects.securevault;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LandingServlet", value = "/LandingServlet")
public class LandingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("login".equalsIgnoreCase(action)) {
            response.sendRedirect("login.jsp");  // redirect to login page
        } else if ("register".equalsIgnoreCase(action)) {
            response.sendRedirect("register.jsp");  // redirect to registration page
        } else {
            response.sendRedirect("index.jsp");  // fallback to landing page
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
