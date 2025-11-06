package org.groupprojects.securevault.controller;

import org.groupprojects.securevault.dao.KYCDao;
import org.groupprojects.securevault.model.KYCRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/KYCRequestServlet")
public class KYCRequestServlet extends HttpServlet {

    private KYCDao kycDao = new KYCDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (isAdmin != null && isAdmin) {
            List<KYCRequest> pendingRequests = kycDao.getPendingKYCRequests();
            request.setAttribute("pendingRequests", pendingRequests);
            request.getRequestDispatcher("kyc-requests.jsp").forward(request, response);
        } else {
            boolean hasPending = kycDao.hasPendingRequest(userId);
            request.setAttribute("hasPendingRequest", hasPending);
            request.getRequestDispatcher("kyc.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        String action = request.getParameter("action");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (isAdmin != null && isAdmin) {
            if ("approve".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                boolean success = kycDao.approveKYCRequest(requestId);

                if (success) {
                    request.setAttribute("success", "KYC request approved successfully!");
                } else {
                    request.setAttribute("error", "Failed to approve KYC request.");
                }
            } else if ("reject".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                boolean success = kycDao.rejectKYCRequest(requestId);

                if (success) {
                    request.setAttribute("success", "KYC request rejected.");
                } else {
                    request.setAttribute("error", "Failed to reject KYC request.");
                }
            }
            doGet(request, response);
        } else {

            if (kycDao.hasPendingRequest(userId)) {
                request.setAttribute("error", "You already have a pending KYC request.");
                doGet(request, response);
                return;
            }

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

            boolean success = kycDao.submitKYCRequest(userId, email, phone, panNo, aadhaarNo, address);

            if (success) {
                request.setAttribute("success", "KYC request submitted successfully! Please wait for admin approval.");
            } else {
                request.setAttribute("error", "Failed to submit KYC request.");
            }

            doGet(request, response);
        }
    }
}
