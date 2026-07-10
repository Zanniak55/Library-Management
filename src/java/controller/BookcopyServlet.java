/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookcopyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Bookcopy;

/**
 *
 * @author AAA
 */
@WebServlet(name = "BookcopyServlet", urlPatterns = {"/bookcopies"})
public class BookcopyServlet extends HttpServlet {

    private final BookcopyDAO copyDAO = new BookcopyDAO();

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
            out.println("<title>Servlet BookcopyServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookcopyServlet at " + request.getContextPath() + "</h1>");
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
                request.setAttribute("copy", null);
                request.setAttribute("formTitle", "Thêm Bản Sao");
                request.setAttribute("books", copyDAO.getAllBooks());
                request.getRequestDispatcher("/views/bookcopy_form.jsp").forward(request, response);
                break;

            case "edit":
                int editId = parseIntSafe(request.getParameter("id"), 0);
                Bookcopy editCopy = copyDAO.getCopyByID(editId);
                if (editCopy == null) {
                    request.getSession().setAttribute("error", "Không tìm thấy bản sao.");
                    response.sendRedirect("bookcopies");
                    return;
                }
                request.setAttribute("copy", editCopy);
                request.setAttribute("formTitle", "Chỉnh Sửa Bản Sao");
                request.setAttribute("books", copyDAO.getAllBooks());
                request.getRequestDispatcher("/views/bookcopy_form.jsp").forward(request, response);
                break;

            case "delete":
                int delId = parseIntSafe(request.getParameter("id"), 0);
                boolean deleted = copyDAO.deleteCopy(delId);
                request.getSession().setAttribute(
                        deleted ? "success" : "error",
                        deleted ? "Xóa bản sao thành công." : "Xóa bản sao thất bại."
                );
                response.sendRedirect("bookcopies");
                break;

            case "filter":
                // Lọc theo ISBN
                String filterISBN = request.getParameter("isbn");
                List<Bookcopy> filtered = copyDAO.getCopiesByISBN(filterISBN);
                request.setAttribute("copies", filtered);
                request.setAttribute("filterISBN", filterISBN);
                request.setAttribute("books", copyDAO.getAllBooks());
                request.getRequestDispatcher("/views/bookcopy_list.jsp").forward(request, response);
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                List<Bookcopy> results = copyDAO.searchCopies(keyword == null ? "" : keyword);
                request.setAttribute("copies", results);
                request.setAttribute("keyword", keyword);
                request.setAttribute("books", copyDAO.getAllBooks());
                request.getRequestDispatcher("/views/bookcopy_list.jsp").forward(request, response);
                break;

            default: // list
                request.setAttribute("copies", copyDAO.getAllCopies());
                request.setAttribute("books", copyDAO.getAllBooks());
                request.getRequestDispatcher("/views/bookcopy_list.jsp").forward(request, response);
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

        String idParam = request.getParameter("copyID");
        String actionParam = request.getParameter("actionType");
        boolean isEdit = "edit".equals(actionParam);

        Bookcopy copy = new Bookcopy();
        if (isEdit) {
            copy.setCopyID(parseIntSafe(idParam, 0));
        }
        copy.setIsbn(request.getParameter("isbn"));
        copy.setBarcode(request.getParameter("barcode").trim());
        copy.setCondition(request.getParameter("condition"));
        copy.setStatus(request.getParameter("status"));
        copy.setShelfLocation(request.getParameter("shelfLocation").trim());

        boolean ok;
        String msg;

        if (isEdit) {
            ok = copyDAO.updateCopy(copy);
            msg = ok ? "Cập nhật bản sao thành công." : "Cập nhật thất bại.";
        } else {
            // Kiểm tra barcode trùng
            if (copyDAO.isBarcodeExist(copy.getBarcode())) {
                request.getSession().setAttribute("error",
                        "Barcode «" + copy.getBarcode() + "» đã tồn tại!");
                request.setAttribute("copy", null);
                request.setAttribute("formTitle", "Thêm Bản Sao");
                request.setAttribute("books", copyDAO.getAllBooks());
                request.getRequestDispatcher("/views/bookcopy_form.jsp").forward(request, response);
                return;
            }
            ok = copyDAO.addCopy(copy);
            msg = ok ? "Thêm bản sao thành công." : "Thêm bản sao thất bại.";
        }

        request.getSession().setAttribute(ok ? "success" : "error", msg);
        response.sendRedirect("bookcopies");
    }

    private int parseIntSafe(String s, int def) {
        try {
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
