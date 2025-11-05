package org.groupprojects.securevault.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Extract the path after context path
        String path = requestURI.substring(contextPath.length());

        // Define public paths that don't require authentication
        boolean isPublicPath = isPublicPath(path);

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        // Check if user is admin
        boolean isAdmin = (session != null && Boolean.TRUE.equals(session.getAttribute("isAdmin")));

        // Allow public paths
        if (isPublicPath) {
            chain.doFilter(request, response);
            return;
        }

        // Redirect direct JSP access to appropriate servlets (only for logged-in users)
        if (isProtectedJSP(path) && isLoggedIn) {
            String servletPath = getServletForJSP(path);
            if (servletPath != null) {
                httpResponse.sendRedirect(contextPath + servletPath);
                return;
            }
        }

        // Check for admin-only resources
        if (isAdminPath(path)) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(contextPath + "/login.jsp");
                return;
            }
            if (!isAdmin) {
                httpResponse.sendRedirect(contextPath + "/DashboardServlet");
                return;
            }
        }

        // Check for user authentication on protected resources
        if (!isLoggedIn) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // User is authenticated, proceed with request
        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/") ||
               path.equals("/index.jsp") ||
               path.equals("/login.jsp") ||
               path.equals("/register.jsp") ||
               path.equals("/LoginServlet") ||
               path.equals("/RegisterServlet") ||
               path.equals("/LandingServlet") ||
               path.startsWith("/assets/") ||
               path.startsWith("/styles/") ||
               path.startsWith("/icons/") ||
               path.endsWith(".css") ||
               path.endsWith(".js") ||
               path.endsWith(".png") ||
               path.endsWith(".jpg") ||
               path.endsWith(".jpeg") ||
               path.endsWith(".gif") ||
               path.endsWith(".ico");
    }

    private boolean isAdminPath(String path) {
        return path.startsWith("/admin") ||
               path.equals("/AdminServlet") ||
               path.equals("/admin-dashboard.jsp") ||
               path.equals("/admin-user-details.jsp") ||
               path.equals("/kyc-requests.jsp");
    }

    private boolean isProtectedJSP(String path) {
        return path.equals("/dashboard.jsp") ||
               path.equals("/profile.jsp") ||
               path.equals("/deposit.jsp") ||
               path.equals("/transfer.jsp") ||
               path.equals("/user-statements.jsp") ||
               path.equals("/my-loans.jsp") ||
               path.equals("/loan-application.jsp") ||
               path.equals("/kyc.jsp");
    }

    private String getServletForJSP(String jspPath) {
        switch (jspPath) {
            case "/dashboard.jsp":
                return "/DashboardServlet";
            case "/profile.jsp":
                return "/ProfileServlet";
            case "/deposit.jsp":
                return "/DepositServlet";
            case "/transfer.jsp":
                return "/TransferServlet";
            case "/user-statements.jsp":
                return "/UserStatementsServlet";
            case "/my-loans.jsp":
                return "/LoanServlet";
            case "/loan-application.jsp":
                return "/LoanServlet";
            case "/kyc.jsp":
                return "/KYCServlet";
            default:
                return null;
        }
    }

    @Override
    public void destroy() {
        // Filter cleanup
    }
}
