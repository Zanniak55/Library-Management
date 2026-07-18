package controller;

import dao.FineDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Fine;
import model.Member;

@WebServlet(name = "UserFineServlet", urlPatterns = {"/user/fines"})
public class UserFineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        FineDAO dao = new FineDAO();
        List<Fine> fines = dao.getFinesByMember(user.getMemberID());
        
        request.setAttribute("fines", fines);
        request.getRequestDispatcher("/user/fine_history.jsp").forward(request, response);
    }
}
