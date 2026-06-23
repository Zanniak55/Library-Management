<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - Thư viện</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
            h2 { margin-bottom: 6px; }
            p { color: #555; margin-bottom: 20px; }
            .menu a { display: inline-block; background: white; border: 1px solid #ddd; border-radius: 6px; padding: 16px 24px; margin-right: 14px; text-decoration: none; color: #333; font-size: 15px; }
            .menu a:hover { background: #2c3e50; color: white; }
            .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        </style>
    </head>
    <body>

        <div class="topbar">
            <h2>Dashboard - Thư viện</h2>
            <span>Xin chào <b><%= staff.getFullName() %></b> |
                <a href="${pageContext.request.contextPath}/loan?action=logout">Đăng xuất</a>
            </span>
        </div>

        <div class="menu">
            <a href="${pageContext.request.contextPath}/loan?action=list">📋 Danh sách phiếu mượn</a>
            <a href="${pageContext.request.contextPath}/loan?action=borrow">➕ Tạo phiếu mượn</a>
        </div>

    </body>
</html>
