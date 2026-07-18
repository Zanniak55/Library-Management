package controller;

import dao.TransactionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Staff;

@WebServlet(name = "LoanReportServlet", urlPatterns = {"/loan-reports"})
public class LoanReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Staff staff = (Staff) request.getSession().getAttribute("staff");
        // Chỉ cho phép Admin truy cập
        if (staff == null || !"Admin".equals(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        TransactionDAO dao = new TransactionDAO();
        int[] overviewStats = dao.getLoanOverviewStats();
        
        request.setAttribute("totalBorrowing", overviewStats[0]);
        request.setAttribute("totalReturned", overviewStats[1]);
        request.setAttribute("totalOverdue", overviewStats[2]);
        request.setAttribute("monthlyStats", dao.getMonthlyLoanStats());
        request.setAttribute("topBooks", dao.getTopBorrowedBooks());
        
        request.getRequestDispatcher("/quan_li_muon_tra/loan_stats.jsp").forward(request, response);
    }
}
