package controller;

import dao.FineDAO;
import dao.TransactionDAO;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Fine;
import model.Member;
import java.math.BigDecimal;

@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/user/dashboard"})
public class UserDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        TransactionDAO tDao = new TransactionDAO();
        int[] stats = tDao.getMemberLoanStats(user.getMemberID());
        
        FineDAO fDao = new FineDAO();
        List<Fine> allFines = fDao.getFinesByMember(user.getMemberID());
        List<Fine> unpaidFines = allFines.stream()
                .filter(f -> "Chưa đóng".equals(f.getPaidStatus()))
                .collect(Collectors.toList());
                
        double totalUnpaidAmount = 0;
        for (Fine f : unpaidFines) {
            totalUnpaidAmount += f.getAmount();
        }

        request.setAttribute("activeLoanCount", stats[0]);
        request.setAttribute("totalLoanCount", stats[1]);
        request.setAttribute("unpaidFines", unpaidFines);
        request.setAttribute("unpaidFineCount", unpaidFines.size());
        request.setAttribute("totalUnpaidAmount", totalUnpaidAmount);
        
        List<String[]> topBooks = tDao.getTopBorrowedBooks();
        request.setAttribute("topBooks", topBooks);

        request.getRequestDispatcher("/user/dashboard.jsp").forward(request, response);
    }
}
