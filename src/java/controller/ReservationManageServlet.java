package controller;

import dao.ReservationDAO;
import dao.TransactionDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reservation;
import model.Staff;

@WebServlet(name = "ReservationManageServlet", urlPatterns = {"/reservations"})
public class ReservationManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ReservationDAO dao = new ReservationDAO();
        List<Reservation> list = dao.getAllPendingReservations();
        request.setAttribute("reservations", list);
        request.getRequestDispatcher("/quan_li_muon_tra/reservations.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int reservationID = Integer.parseInt(request.getParameter("reservationID"));
        ReservationDAO dao = new ReservationDAO();
        
        if ("approve".equals(action)) {
            boolean ok = dao.approveReservation(reservationID);
            if (!ok) {
                request.getSession().setAttribute("errorMsg", "Duyệt thất bại: Không đủ sách trên kệ hoặc lỗi hệ thống!");
                response.sendRedirect(request.getContextPath() + "/reservations");
                return;
            }
            request.getSession().setAttribute("successMsg", "Đã duyệt yêu cầu mượn thành công.");
        } else if ("reject".equals(action)) {
            dao.updateReservationStatus(reservationID, "Đã từ chối");
            request.getSession().setAttribute("successMsg", "Đã từ chối yêu cầu mượn.");
        }
        
        response.sendRedirect(request.getContextPath() + "/reservations");
    }
}
