package controller;

import dao.BookDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.Member;

@WebServlet(name = "UserBookServlet", urlPatterns = {"/user/books"})
public class UserBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user-login");
            return;
        }

        String keyword = request.getParameter("keyword");
        
        int page = 1;
        int limit = 12;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
            }
        }
        int offset = (page - 1) * limit;

        BookDAO dao = new BookDAO();
        List<Book> books;
        int totalRecords;

        if (keyword == null || keyword.trim().isEmpty()) {
            books = dao.getBooks(offset, limit);
            totalRecords = dao.getTotalBooks();
        } else {
            books = dao.searchBooks(keyword, offset, limit);
            totalRecords = dao.getTotalSearchBooks(keyword);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/user/book_search.jsp").forward(request, response);
    }
}
