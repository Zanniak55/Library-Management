package controller;
import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Staff;
import java.io.IOException;
import java.util.List;
@WebServlet(name = "StaffServlet", urlPatterns = {"/StaffServlet"})
public class StaffServlet extends HttpServlet {
    private final StaffDAO dao = new StaffDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "list":
                listStaff(request, response);
                break;
            case "add":
                request.getRequestDispatcher("staff_form.jsp").forward(request, response);
                break;
            case "edit":
                editStaff(request, response);
                break;
            case "delete":
                deleteStaff(request, response);
                break;
            default:
                listStaff(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "insert":
                insertStaff(request, response);
                break;
            case "update":
                updateStaff(request, response);
                break;
            default:
                listStaff(request, response);
        }
    }
    private void listStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Staff> staffList = dao.getAllStaff();
        req.setAttribute("staffList", staffList);
        req.getRequestDispatcher("staff_list.jsp").forward(req, resp);
    }
    private void editStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Staff staff = dao.getStaffByID(id);
            if (staff == null) {
                req.setAttribute("errorMsg", "Không tìm thấy nhân viên có ID = " + id);
                listStaff(req, resp);
                return;
            }
            req.setAttribute("staff", staff);
            req.getRequestDispatcher("staff_form.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect("StaffServlet?action=list");
        }
    }
    private void deleteStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = dao.deleteStaff(id);
            req.setAttribute(ok ? "successMsg" : "errorMsg",
                    ok ? "Xóa nhân viên thành công!" : "Xóa thất bại!");
        } catch (NumberFormatException e) {
            req.setAttribute("errorMsg", "ID không hợp lệ!");
        }
        listStaff(req, resp);
    }
    private void insertStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Staff s = buildFromRequest(req);
        boolean ok = dao.addStaff(s);
        req.setAttribute(ok ? "successMsg" : "errorMsg",
                ok ? "Thêm nhân viên \"" + s.getFullName() + "\" thành công!" : "Thêm thất bại! Email có thể đã tồn tại.");
        listStaff(req, resp);
    }
    private void updateStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("staffID"));
            Staff s = buildFromRequest(req);
            s.setStaffID(id);
            boolean ok = dao.updateStaff(s);
            req.setAttribute(ok ? "successMsg" : "errorMsg",
                    ok ? "Cập nhật nhân viên thành công!" : "Cập nhật thất bại!");
        } catch (NumberFormatException e) {
            req.setAttribute("errorMsg", "ID nhân viên không hợp lệ!");
        }
        listStaff(req, resp);
    }
    /**
     * Đọc dữ liệu từ form và tạo đối tượng Staff.
     */
    private Staff buildFromRequest(HttpServletRequest req) {
        Staff s = new Staff();
        s.setFullName(req.getParameter("fullName"));
        s.setEmail(req.getParameter("email"));
        s.setPassword(req.getParameter("password"));
        s.setRole(req.getParameter("role"));
        return s;
    }
}
