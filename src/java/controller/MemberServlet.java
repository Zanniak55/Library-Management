package controller;

import dao.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Member;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MemberServlet", urlPatterns = {"/MemberServlet"})
public class MemberServlet extends HttpServlet {

    private final MemberDAO dao = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listMembers(request, response);
                break;
            case "add":
                request.getRequestDispatcher("member_form.jsp")
                        .forward(request, response);
                break;
            case "edit":
                editMember(request, response);
                break;
            case "delete":
                deleteMember(request, response);
                break;
            case "search":
                searchMembers(request, response);
                break;
            default:
                listMembers(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "insert":
                insertMember(request, response);
                break;
            case "update":
                updateMember(request, response);
                break;
            default:
                listMembers(request, response);
        }
    }

    private void listMembers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Member> memberList = dao.getAllMembers();
        req.setAttribute("memberList", memberList);
        req.setAttribute("action", "list");
        req.getRequestDispatcher("member_list.jsp").forward(req, resp);
    }

    private void searchMembers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        List<Member> memberList = dao.searchMembers(keyword.trim());
        req.setAttribute("memberList", memberList);
        req.setAttribute("keyword", keyword);
        req.setAttribute("action", "search");
        req.getRequestDispatcher("member_list.jsp").forward(req, resp);
    }

    private void editMember(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Member member = dao.getMemberByID(id);
            if (member == null) {
                req.setAttribute("errorMsg", "Không tìm thấy thành viên có ID = " + id);
                listMembers(req, resp);
                return;
            }
            req.setAttribute("member", member);
            req.getRequestDispatcher("member_form.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect("MemberServlet?action=list");
        }
    }

    private void deleteMember(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = dao.deleteMember(id);
            req.setAttribute(ok ? "successMsg" : "errorMsg",
                    ok ? "Xóa thành viên thành công!" : "Xóa thất bại! Có thể thành viên đang có giao dịch mượn sách.");
        } catch (NumberFormatException e) {
            req.setAttribute("errorMsg", "ID không hợp lệ!");
        }
        listMembers(req, resp);
    }

    private void insertMember(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void updateMember(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


}
