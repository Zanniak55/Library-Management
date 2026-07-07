/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Book;

/**
 *
 * @author AAA
 */
@WebServlet(name = "BookServlet", urlPatterns = {"/books"})
public class BookServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

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
            out.println("<title>Servlet BookServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookServlet at " + request.getContextPath() + "</h1>");
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
                // Mở form thêm sách (book = null → form trống)
                request.setAttribute("book", null);
                request.setAttribute("formTitle", "Thêm Sách Mới");
                request.getRequestDispatcher("/views/book_form.jsp").forward(request, response);
                break;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Book editBook = bookDAO.getBookById(editId);
                if (editBook == null) {
                    request.getSession().setAttribute("error", "Không tìm thấy sách.");
                    response.sendRedirect("books");
                    return;
                }
                request.setAttribute("book", editBook);
                request.setAttribute("formTitle", "Chỉnh Sửa Sách");
                request.getRequestDispatcher("/views/book_form.jsp").forward(request, response);
                break;

            case "delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = bookDAO.deleteBook(delId);
                request.getSession().setAttribute(
                        deleted ? "success" : "error",
                        deleted ? "Xóa sách thành công." : "Xóa sách thất bại."
                );
                response.sendRedirect("books");
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                List<Book> searchResult = bookDAO.searchBooks(keyword == null ? "" : keyword);
                request.setAttribute("books", searchResult);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/views/book_list.jsp").forward(request, response);
                break;

            default: // list
                List<Book> allBooks = bookDAO.getAllBooks();
                request.setAttribute("books", allBooks);
                request.getRequestDispatcher("/views/book_list.jsp").forward(request, response);
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

        String idParam = request.getParameter("id");
        boolean isEdit = (idParam != null && !idParam.isEmpty());

        Book book = new Book();
        if (isEdit) {
            book.setId(Integer.parseInt(idParam));
        }
        book.setTitle(request.getParameter("title").trim());
        book.setAuthor(request.getParameter("author").trim());
        book.setCategory(request.getParameter("category").trim());
        book.setIsbn(request.getParameter("isbn").trim());

        // Validate số nguyên an toàn
        int qty = parseIntSafe(request.getParameter("quantity"), 0);
        int avail = parseIntSafe(request.getParameter("available"), 0);
        int year = parseIntSafe(request.getParameter("publishYear"), 0);
        book.setQuantity(qty);
        book.setAvailable(Math.min(avail, qty));   // available không vượt quá quantity
        book.setPublishYear(year);

        boolean ok;
        String msg;

        if (isEdit) {
            ok = bookDAO.updateBook(book);
            msg = ok ? "Cập nhật sách thành công." : "Cập nhật thất bại.";
        } else {
            ok = bookDAO.addBook(book);
            msg = ok ? "Thêm sách thành công." : "Thêm sách thất bại.";
        }

        request.getSession().setAttribute(ok ? "success" : "error", msg);
        response.sendRedirect("books");
    }

    // ─── Helper ──────────────────────────────────────────────────────────────
    private int parseIntSafe(String s, int defaultVal) {
        try {
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return defaultVal;
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
