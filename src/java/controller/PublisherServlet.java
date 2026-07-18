package controller;

import dao.PublisherDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Publisher;
import model.Staff;

public class PublisherServlet extends HttpServlet {

    private PublisherDAO publisherDAO = new PublisherDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listPublishers(request, response);
                    break;
                case "add":
                    showForm(request, response, null);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "insert":
                    insertPublisher(request, response);
                    break;
                case "update":
                    updatePublisher(request, response);
                    break;
                case "delete":
                    deletePublisher(request, response);
                    break;
                default:
                    listPublishers(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
            listPublishers(request, response);
        }
    }

    private void listPublishers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            keyword = (String) request.getAttribute("forcedKeyword");
        }
        if (keyword == null) keyword = "";

        int page = 1;
        int limit = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) { }
        }
        int offset = (page - 1) * limit;

        List<Publisher> list;
        int totalRecords;

        if (keyword.trim().isEmpty()) {
            list = publisherDAO.getPublishers(offset, limit);
            totalRecords = publisherDAO.getTotalPublishers();
        } else {
            list = publisherDAO.searchPublishers(keyword, offset, limit);
            totalRecords = publisherDAO.getTotalSearchPublishers(keyword);
            request.setAttribute("keyword", keyword);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        request.setAttribute("publishers", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/publisher_list.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Publisher p)
            throws ServletException, IOException {
        if (p != null) {
            request.setAttribute("publisher", p);
        }
        request.getRequestDispatcher("/publisher_form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Publisher p = publisherDAO.getPublisherByID(id);
        showForm(request, response, p);
    }

    private void insertPublisher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("publisherName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        Publisher p = new Publisher(0, name, address, phone, email);
        if (publisherDAO.insertPublisher(p)) {
            request.setAttribute("successMsg", "Thêm nhà xuất bản thành công!");
            request.setAttribute("forcedKeyword", name);
        } else {
            request.setAttribute("errorMsg", "Thêm nhà xuất bản thất bại!");
        }
        listPublishers(request, response);
    }

    private void updatePublisher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("publisherID"));
        String name = request.getParameter("publisherName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        Publisher p = new Publisher(id, name, address, phone, email);
        if (publisherDAO.updatePublisher(p)) {
            request.setAttribute("successMsg", "Cập nhật nhà xuất bản thành công!");
        } else {
            request.setAttribute("errorMsg", "Cập nhật nhà xuất bản thất bại!");
        }
        listPublishers(request, response);
    }

    private void deletePublisher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (publisherDAO.deletePublisher(id)) {
            request.setAttribute("successMsg", "Xóa nhà xuất bản thành công!");
        } else {
            request.setAttribute("errorMsg", "Xóa thất bại. Nhà xuất bản này đang có sách lưu trong hệ thống!");
        }
        listPublishers(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
