package controller;

import dao.TransactionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Staff;

@WebServlet(name = "TransactionServlet", urlPatterns = {"/loan"})
public class TransactionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        TransactionDAO dao = new TransactionDAO();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list" -> {
                request.setAttribute("transactions", dao.getAllTransactions());
                request.getRequestDispatcher("/quan_li_tra_va_muon/loan_list.jsp")
                        .forward(request, response);
            }
            case "borrow" -> {
                request.setAttribute("copies", dao.getAvailableCopies());
                request.setAttribute("members", dao.getActiveMembers());
                request.getRequestDispatcher("/quan_li_tra_va_muon/loan_form.jsp")
                        .forward(request, response);
            }
            case "return" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.returnTransaction(id);
                response.sendRedirect(request.getContextPath()
                        + "/loan?action=list&msg=" + (ok ? "returned" : "error"));
            }
            case "logout" -> {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
            }
            default -> response.sendRedirect(request.getContextPath() + "/loan");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Staff staff = (Staff) request.getSession().getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("borrow".equals(action)) {
            int memberID = Integer.parseInt(request.getParameter("memberID"));
            int staffID  = staff.getStaffID();
            String dueDate = request.getParameter("dueDate");
            String[] copyIDs = request.getParameterValues("copyID");

            if (copyIDs == null || copyIDs.length == 0) {
                response.sendRedirect(request.getContextPath() + "/loan?action=borrow&msg=no_copy");
                return;
            }

            TransactionDAO dao = new TransactionDAO();
            int transactionID = dao.createTransaction(memberID, staffID, dueDate);
            System.out.println("DEBUG transactionID = " + transactionID);

            if (transactionID == -1) {
                response.sendRedirect(request.getContextPath() + "/loan?action=borrow&msg=error");
                return;
            }

            for (String copyIDStr : copyIDs) {
                dao.addCopyToTransaction(transactionID, Integer.parseInt(copyIDStr));
            }

            response.sendRedirect(request.getContextPath() + "/loan?action=list&msg=borrowed");
        } else {
            response.sendRedirect(request.getContextPath() + "/loan");
        }
    }
}
