package org.groupprojects.securevault.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LandingServlet", value = "/LandingServlet")
public class LandingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("LandingServlet: Received action parameter: " + action);

        if ("login".equalsIgnoreCase(action)) {
            System.out.println("LandingServlet: Redirecting to login.jsp");
            response.sendRedirect("login.jsp");
        } else if ("register".equalsIgnoreCase(action)) {
            System.out.println("LandingServlet: Redirecting to register.jsp");
            response.sendRedirect("register.jsp");
        } else {
            System.out.println("LandingServlet: Unknown action, redirecting to index.jsp");
            response.sendRedirect("index.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("LandingServlet: GET request received, redirecting to index.jsp");
        response.sendRedirect("index.jsp");
    }
}
