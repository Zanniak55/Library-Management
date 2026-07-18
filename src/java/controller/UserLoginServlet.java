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

@WebServlet(name = "UserLoginServlet", urlPatterns = {"/user-login"})
public class UserLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
            return;
        }
        request.getRequestDispatcher("/user_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tên đăng nhập và mật khẩu");
            request.getRequestDispatcher("/user_login.jsp").forward(request, response);
            return;
        }

        MemberDAO dao = new MemberDAO();
        Member member = dao.getMemberByUsername(username);

        if (member == null || !password.equals(member.getPassword())) {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/user_login.jsp").forward(request, response);
            return;
        }

        if (!"Hoạt động".equals(member.getStatus())) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa hoặc ngừng hoạt động");
            request.getRequestDispatcher("/user_login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", member);
        response.sendRedirect(request.getContextPath() + "/user/dashboard");
    }
}
