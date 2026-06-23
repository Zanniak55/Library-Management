package filter;

import model.Staff;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class RoleFilter implements Filter {

    // URL chỉ dành cho Admin
    private static final List<String> ADMIN_URLS = Arrays.asList(
            "/staffs");

    // URL chỉ dành cho Librarian
    private static final List<String> LIBRARIAN_URLS = Arrays.asList(
            "/bookcopies", "/categories", "/authors",
            "/publishers", "/transactions", "/fines", "/members");

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Bỏ qua: login, logout, user/*, dashboard, static resources
        if (path.equals("/login") || path.equals("/logout") ||
                path.equals("/dashboard") || path.equals("/") ||
                path.equals("/user-login") || path.equals("/user-logout") ||
                path.startsWith("/user/") ||
                path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".ico")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            chain.doFilter(req, res);
            return;
        }

        Staff staff = (Staff) session.getAttribute("staff");
        String role = staff.getRole();

        // Admin được vào tất cả URL
        if ("Admin".equals(role)) {
            chain.doFilter(req, res);
            return;
        }

        // Librarian không được vào ADMIN_URLS
        if (ADMIN_URLS.contains(path)) {
            response.sendRedirect(contextPath + "/dashboard");
            return;
        }

        // Không phải Librarian thì không được vào LIBRARIAN_URLS
        if (LIBRARIAN_URLS.contains(path) && !"Librarian".equals(role)) {
            response.sendRedirect(contextPath + "/dashboard");
            return;
        }

        chain.doFilter(req, res);
    }
}
