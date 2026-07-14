/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;

/**
 *
 * @author AAA
 */
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CategoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CategoryServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                request.setAttribute("category", null);
                request.setAttribute("formTitle", "Thêm Thể Loại");
                request.getRequestDispatcher("/views/category_form.jsp").forward(request, response);
                break;

            case "edit":
                int editId = parseIntSafe(request.getParameter("id"), 0);
                Category editCat = categoryDAO.getCategoryByID(editId);
                if (editCat == null) {
                    request.getSession().setAttribute("error", "Không tìm thấy thể loại.");
                    response.sendRedirect("categories");
                    return;
                }
                request.setAttribute("category", editCat);
                request.setAttribute("formTitle", "Chỉnh Sửa Thể Loại");
                request.getRequestDispatcher("/views/category_form.jsp").forward(request, response);
                break;

            case "delete":
                int delId = parseIntSafe(request.getParameter("id"), 0);
                boolean deleted = categoryDAO.deleteCategory(delId);
                request.getSession().setAttribute(
                        deleted ? "success" : "error",
                        deleted ? "Xóa thể loại thành công." : "Xóa thất bại (có thể đang được dùng)."
                );
                response.sendRedirect("categories");
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                request.setAttribute("categories", categoryDAO.searchCategories(keyword == null ? "" : keyword));
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/views/category_list.jsp").forward(request, response);
                break;

            default:
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/views/category_list.jsp").forward(request, response);
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("categoryID");
        boolean isEdit = "edit".equals(request.getParameter("actionType"));

        Category cat = new Category();
        if (isEdit) {
            cat.setCategoryID(parseIntSafe(idParam, 0));
        }
        cat.setCategoryName(request.getParameter("categoryName").trim());
        cat.setDescription(request.getParameter("description") == null ? "" : request.getParameter("description").trim());

        boolean ok;
        String msg;

        if (isEdit) {
            ok = categoryDAO.updateCategory(cat);
            msg = ok ? "Cập nhật thể loại thành công." : "Cập nhật thất bại.";
        } else {
            if (categoryDAO.isCategoryExist(cat.getCategoryName())) {
                request.getSession().setAttribute("error", "Thể loại «" + cat.getCategoryName() + "» đã tồn tại!");
                request.setAttribute("category", null);
                request.setAttribute("formTitle", "Thêm Thể Loại");
                request.getRequestDispatcher("/views/category_form.jsp").forward(request, response);
                return;
            }
            ok = categoryDAO.addCategory(cat);
            msg = ok ? "Thêm thể loại thành công." : "Thêm thất bại.";
        }

        request.getSession().setAttribute(ok ? "success" : "error", msg);
        response.sendRedirect("categories");
    }

    private int parseIntSafe(String s, int def) {
        try {
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
