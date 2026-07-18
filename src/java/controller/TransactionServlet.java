package controller;

import dao.TransactionDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Staff;

@WebServlet(name = "TransactionServlet", urlPatterns = {"/loans"})
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
                dao.updateOverdue();
                String keyword = request.getParameter("keyword");
                String status  = request.getParameter("status");
                
                int page = 1;
                int limit = 10;
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) { }
                }
                int offset = (page - 1) * limit;

                List<model.Transaction> list;
                int totalRecords;
                
                if ((keyword == null || keyword.trim().isEmpty()) && (status == null || status.trim().isEmpty())) {
                    list = dao.getTransactions(offset, limit);
                    totalRecords = dao.getTotalTransactions();
                } else {
                    list = dao.searchTransactions(keyword, status, offset, limit);
                    totalRecords = dao.getTotalSearchTransactions(keyword, status);
                }

                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("transactions", list);
                request.setAttribute("keyword", keyword != null ? keyword : "");
                request.setAttribute("status",  status  != null ? status  : "");
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                
                request.getRequestDispatcher("/quan_li_tra_va_muon/loan_list.jsp")
                        .forward(request, response);
            }
            case "detail" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("transaction", dao.getTransactionByID(id));
                request.setAttribute("details", dao.getTransactionDetails(id));
                request.getRequestDispatcher("/quan_li_tra_va_muon/loan_detail.jsp")
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
