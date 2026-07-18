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
import model.Member;
import model.Transaction;

@WebServlet(name = "UserLoanServlet", urlPatterns = {"/user/loans"})
public class UserLoanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        TransactionDAO dao = new TransactionDAO();

        if ("list".equals(action)) {
            List<Transaction> list = dao.getTransactionsByMember(user.getMemberID());
            for (Transaction t : list) {
                List<String[]> details = dao.getTransactionDetails(t.getTransactionID());
                StringBuilder titles = new StringBuilder();
                for (String[] detail : details) {
                    if (titles.length() > 0) titles.append(", ");
                    titles.append(detail[2]); // Title is at index 2
                }
                t.setBookTitles(titles.toString());
            }
            request.setAttribute("transactions", list);
            request.getRequestDispatcher("/user/loan_history.jsp").forward(request, response);
        } else if ("detail".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Transaction t = dao.getTransactionByID(id);
                
                if (t == null || t.getMemberID() != user.getMemberID()) {
                    response.sendRedirect(request.getContextPath() + "/user/loans");
                    return;
                }
                
                request.setAttribute("transaction", t);
                request.setAttribute("details", dao.getTransactionDetails(id));
                request.getRequestDispatcher("/user/loan_detail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/user/loans");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user/loans");
        }
    }
}
