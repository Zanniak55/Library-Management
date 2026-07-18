package controller;

import dao.MemberDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Member;

@WebServlet(name = "UserProfileServlet", urlPatterns = {"/user/profile"})
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        MemberDAO dao = new MemberDAO();
        Member freshUser = dao.getMemberByID(user.getMemberID());
        
        // Pass to JSP
        request.setAttribute("member", freshUser);
        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        String action = request.getParameter("action");
        if ("change-password".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            MemberDAO dao = new MemberDAO();
            Member currentMember = dao.getMemberByUsername(user.getUsername());

            if (currentMember == null || !currentMember.getPassword().equals(oldPassword)) {
                request.setAttribute("error", "Mật khẩu cũ không chính xác!");
            } else if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Xác nhận mật khẩu không khớp!");
            } else {
                boolean success = dao.changePassword(user.getMemberID(), newPassword);
                if (success) {
                    request.setAttribute("msg", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại sau!");
                }
            }

            // Refresh user details
            Member freshUser = dao.getMemberByID(user.getMemberID());
            request.setAttribute("member", freshUser);
            request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }
}
