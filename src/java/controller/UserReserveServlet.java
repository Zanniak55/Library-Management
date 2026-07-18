package controller;

import dao.ReservationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Member;

@WebServlet(name = "UserReserveServlet", urlPatterns = {"/user/reserve", "/user/reservations"})
public class UserReserveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        String isbn = request.getParameter("isbn");
        if (isbn != null && !isbn.trim().isEmpty()) {
            ReservationDAO dao = new ReservationDAO();
            dao.createReservation(user.getMemberID(), isbn);
            // Optionally set a success message here
        }
        
        response.sendRedirect(request.getContextPath() + "/user/reservations");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        ReservationDAO dao = new ReservationDAO();
        request.setAttribute("reservations", dao.getReservationsByMember(user.getMemberID()));
        request.getRequestDispatcher("/user/reservation_history.jsp").forward(request, response);
    }
}
