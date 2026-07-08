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
                // Truyền danh sách Category và Publisher để hiển thị dropdown
                request.setAttribute("book", null);
                request.setAttribute("formTitle", "Thêm Sách Mới");
                request.setAttribute("categories", bookDAO.getAllCategories());
                request.setAttribute("publishers", bookDAO.getAllPublishers());
                request.getRequestDispatcher("/views/book_form.jsp").forward(request, response);
                break;

            case "edit":
                String editIsbn = request.getParameter("isbn");
                Book editBook = bookDAO.getBookByISBN(editIsbn);
                if (editBook == null) {
                    request.getSession().setAttribute("error", "Không tìm thấy sách.");
                    response.sendRedirect("books");
                    return;
                }
                request.setAttribute("book", editBook);
                request.setAttribute("formTitle", "Chỉnh Sửa Sách");
                request.setAttribute("categories", bookDAO.getAllCategories());
                request.setAttribute("publishers", bookDAO.getAllPublishers());
                request.getRequestDispatcher("/views/book_form.jsp").forward(request, response);
                break;

            case "delete":
                String delIsbn = request.getParameter("isbn");
                boolean deleted = bookDAO.deleteBook(delIsbn);
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
                request.setAttribute("books", bookDAO.getAllBooks());
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

        String isbnParam = request.getParameter("isbn");
        String actionParam = request.getParameter("actionType"); // "add" hoặc "edit"
        boolean isEdit = "edit".equals(actionParam);

        Book book = new Book();
        book.setIsbn(isbnParam == null ? "" : isbnParam.trim());
        book.setTitle(request.getParameter("title").trim());
        book.setLanguage(request.getParameter("language") == null ? "Tiếng Việt"
                : request.getParameter("language").trim());
        book.setPublicationYear(parseIntSafe(request.getParameter("publicationYear"), 0));
        book.setTotalQuantity(parseIntSafe(request.getParameter("totalQuantity"), 0));
        // availableQuantity không được vượt quá totalQuantity
        int avail = parseIntSafe(request.getParameter("availableQuantity"), 0);
        book.setAvailableQuantity(Math.min(avail, book.getTotalQuantity()));
        book.setPublisherID(parseIntSafe(request.getParameter("publisherID"), 0));
        book.setCategoryID(parseIntSafe(request.getParameter("categoryID"), 0));

        // ── Xử lý tác giả: gõ tên → tìm hoặc tạo mới ───────────────────────
        String authorName = request.getParameter("authorName");
        if (authorName != null && !authorName.trim().isEmpty()) {
            int authorID = bookDAO.getOrCreateAuthor(authorName.trim());
            book.setAuthorID(authorID);
        }

        boolean ok;
        String msg;

        if (isEdit) {
            ok = bookDAO.updateBook(book);
            msg = ok ? "Cập nhật sách thành công." : "Cập nhật sách thất bại.";
        } else {
            // ── Kiểm tra tên sách đã tồn tại chưa ───────────────────────────
            if (bookDAO.isBookExist(book.getTitle())) {
                request.getSession().setAttribute("error",
                        "Sách «" + book.getTitle() + "» đã có trong danh sách!");
                response.sendRedirect("books?action=new");
                return;
            }
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
