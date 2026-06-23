package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Cho phép truy cập: login (staff + user), static resources
        if (path.equals("/login") || path.equals("/logout") ||
                path.equals("/user-login") || path.equals("/user-logout") ||
                path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".ico")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);

        // URL /user/* cần session "user" (Member)
        if (path.startsWith("/user/")) {
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(contextPath + "/user-login");
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        // Các URL admin/librarian cần session "staff"
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        chain.doFilter(req, res);
    }
}
