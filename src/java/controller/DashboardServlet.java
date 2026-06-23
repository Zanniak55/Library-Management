package controller;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Staff;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Staff staff = (Staff) request.getSession().getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DashboardDAO dao = new DashboardDAO();
        request.setAttribute("totalMembers",  dao.getTotalMembers());
        request.setAttribute("activeMembers", dao.getActiveMembers());
        request.setAttribute("totalStaff",    dao.getTotalStaff());
        request.setAttribute("totalBooks",    dao.getTotalBooks());
        request.setAttribute("borrowingNow",   dao.getBorrowingNow());
        request.setAttribute("monthlyBorrows", dao.getMonthlyBorrows());
        request.setAttribute("topBooks",       dao.getTopBooks());

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
