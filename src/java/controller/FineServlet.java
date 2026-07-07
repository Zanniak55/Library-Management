package controller;

import dao.FineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Staff;

@WebServlet(name = "FineServlet", urlPatterns = {"/fines"})
public class FineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Staff staff = (Staff) request.getSession().getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        FineDAO dao = new FineDAO();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list" -> {
                dao.autoCreateOverdueFines();
                String keyword    = request.getParameter("keyword");
                String paidStatus = request.getParameter("paidStatus");
                request.setAttribute("fines",      dao.getAllFines(keyword, paidStatus));
                request.setAttribute("totalUnpaid", dao.getTotalUnpaid());
                request.setAttribute("totalPaid",   dao.getTotalPaid());
                request.setAttribute("keyword",    keyword    != null ? keyword    : "");
                request.setAttribute("paidStatus", paidStatus != null ? paidStatus : "");
                request.getRequestDispatcher("/quan_li_phat/fine_list.jsp").forward(request, response);
            }
            case "add" -> {
                request.setAttribute("transactions", dao.getTransactionsForFine());
                request.getRequestDispatcher("/quan_li_phat/fine_form.jsp").forward(request, response);
            }
            case "stats" -> {
                request.setAttribute("totalPaid",   dao.getTotalPaid());
                request.setAttribute("totalUnpaid", dao.getTotalUnpaid());
                request.setAttribute("monthlyStats", dao.getMonthlyStats());
                request.setAttribute("topMembers",   dao.getTopFineMembers());
                request.getRequestDispatcher("/quan_li_phat/fine_stats.jsp").forward(request, response);
            }
            case "paid" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.markPaid(id);
                response.sendRedirect(request.getContextPath()
                        + "/fine?action=list&msg=" + (ok ? "paid" : "error"));
            }
            default -> response.sendRedirect(request.getContextPath() + "/fine");
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
        if ("add".equals(action)) {
            int transactionID = Integer.parseInt(request.getParameter("transactionID"));
            String reason = request.getParameter("reason");
            double amount = Double.parseDouble(request.getParameter("amount"));
            FineDAO dao = new FineDAO();
            boolean ok = dao.createFine(transactionID, reason, amount);
            response.sendRedirect(request.getContextPath()
                    + "/fine?action=list&msg=" + (ok ? "added" : "error"));
        } else {
            response.sendRedirect(request.getContextPath() + "/fine");
        }
    }
}
