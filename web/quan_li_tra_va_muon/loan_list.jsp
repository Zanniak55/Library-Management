<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction, model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Danh sách mượn sách");
    request.setAttribute("activePage", "loans");
%>
<jsp:include page="/includes/header.jsp" />
<style>
/* Loan-specific styles */
.msg { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; font-family: 'Inter', sans-serif; font-weight: 500; }
.ok  { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
.err { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

a.btn-create {
    background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px;
    text-decoration: none; font-size: 14px; font-weight: 600; font-family: 'Inter', sans-serif;
    display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
a.btn-create:hover { background: var(--primary-hover); transform: translateY(-1px); }

.search-bar {
    display: flex; gap: 10px; align-items: center; margin-bottom: 24px;
    background: white; padding: 16px 20px; border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); font-family: 'Inter', sans-serif;
}
.search-bar input[type=text] {
    flex: 1; padding: 10px 14px; border: 1px solid #e2e8f0; border-radius: 8px;
    font-size: 14px; font-family: 'Inter', sans-serif; color: #334155;
}
.search-bar input[type=text]:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79,70,229,0.1); }
.search-bar select {
    padding: 10px 14px; border: 1px solid #e2e8f0; border-radius: 8px;
    font-size: 14px; font-family: 'Inter', sans-serif; color: #334155;
}
.search-bar button {
    padding: 10px 20px; background: var(--primary); color: white; border: none;
    border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600;
    font-family: 'Inter', sans-serif; transition: background 0.2s;
}
.search-bar button:hover { background: var(--primary-hover); }
.search-bar a.clear-btn { padding: 10px 14px; color: #64748b; font-size: 13px; text-decoration: none; white-space: nowrap; font-weight: 500; }
.search-bar a.clear-btn:hover { color: #1e293b; }

.table-wrap {
    background: white; border-radius: 16px;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); overflow: hidden;
}

tr.overdue td { background: #fef2f2; }
tr.overdue:hover td { background: #fde8e8; }
tr.overdue .status-cell { color: #dc2626; font-weight: 700; }

a.detail-btn {
    background: var(--primary); color: white; padding: 6px 14px; border-radius: 6px;
    text-decoration: none; font-size: 13px; font-weight: 500; margin-right: 6px;
    font-family: 'Inter', sans-serif; transition: all 0.2s;
}
a.detail-btn:hover { opacity: 0.85; }
a.return-btn {
    background: #ef4444; color: white; padding: 6px 14px; border-radius: 6px;
    text-decoration: none; font-size: 13px; font-weight: 500;
    font-family: 'Inter', sans-serif; transition: all 0.2s;
}
a.return-btn:hover { background: #dc2626; }
</style>

        <% String msg = request.getParameter("msg");
           if ("borrowed".equals(msg)) { %><div class="msg ok">✅ Tạo phiếu mượn thành công!</div><% }
           if ("returned".equals(msg)) { %><div class="msg ok">✅ Trả sách thành công!</div><% }
           if ("error".equals(msg))    { %><div class="msg err">⚠️ Có lỗi xảy ra, thử lại.</div><% } %>

        <div class="toolbar">
            <a href="<%= ctx %>/loan?action=borrow" class="btn-create">➕ Tạo phiếu mượn</a>
        </div>

        <%
            String kw = (String) request.getAttribute("keyword");
            String st = (String) request.getAttribute("status");
            if (kw == null) kw = "";
            if (st == null) st = "";
        %>
        <form method="get" action="<%= ctx %>/loan" class="search-bar">
            <input type="hidden" name="action" value="list">
            <input type="text" name="keyword" placeholder="Tìm theo tên thành viên..." value="<%= kw %>">
            <select name="status">
                <option value="" <%= st.isEmpty() ? "selected" : "" %>>-- Tất cả trạng thái --</option>
                <option value="Đang mượn" <%= "Đang mượn".equals(st) ? "selected" : "" %>>Đang mượn</option>
                <option value="Đã trả"    <%= "Đã trả".equals(st)    ? "selected" : "" %>>Đã trả</option>
                <option value="Quá hạn"   <%= "Quá hạn".equals(st)   ? "selected" : "" %>>Quá hạn</option>
            </select>
            <button type="submit">🔍 Tìm kiếm</button>
            <% if (!kw.isEmpty() || !st.isEmpty()) { %>
            <a href="<%= ctx %>/loan?action=list" class="clear-btn">✕ Xóa bộ lọc</a>
            <% } %>
        </form>

        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Mã phiếu</th>
                    <th>Thành viên</th>
                    <th>Ngày mượn</th>
                    <th>Hạn trả</th>
                    <th>Ngày trả</th>
                    <th>Trạng thái</th>
                    <th style="text-align:center;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Transaction> list = (List<Transaction>) request.getAttribute("transactions");
                    if (list == null || list.isEmpty()) {
                %>
                <tr>
                    <td colspan="7">
                        <div class="empty-state">
                            <div class="icon">📋</div>
                            <p>Không có phiếu mượn nào.</p>
                        </div>
                    </td>
                </tr>
                <%
                    } else {
                        for (Transaction t : list) {
                            boolean overdue = "Quá hạn".equals(t.getStatus());
                %>
                <tr class="<%= overdue ? "overdue" : "" %>">
                    <td style="color:#94a3b8;">#<%= t.getTransactionID() %></td>
                    <td><strong><%= t.getMemberName() %></strong></td>
                    <td><%= t.getBorrowDate() %></td>
                    <td><%= t.getDueDate() %></td>
                    <td><%= t.getReturnDate() != null ? t.getReturnDate() : "—" %></td>
                    <td class="<%= overdue ? "status-cell" : "" %>">
                        <%= t.getStatus() %><%= overdue ? " ⚠️" : "" %>
                    </td>
                    <td style="text-align:center;white-space:nowrap;">
                        <a href="<%= ctx %>/loan?action=detail&id=<%= t.getTransactionID() %>" class="detail-btn">Chi tiết</a>
                        <% if ("Đang mượn".equals(t.getStatus()) || overdue) { %>
                        <a href="<%= ctx %>/loan?action=return&id=<%= t.getTransactionID() %>"
                           class="return-btn"
                           onclick="return confirm('Xác nhận trả sách?')">Trả sách</a>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>

        <% 
            Integer totalPages = (Integer) request.getAttribute("totalPages");
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            if (totalPages != null && totalPages > 1) {
                String keyword = (String) request.getAttribute("keyword");
                String status = (String) request.getAttribute("status");
                String pageUrl = ctx + "/loan?action=list";
                if (keyword != null && !keyword.isEmpty()) pageUrl += "&keyword=" + keyword;
                if (status != null && !status.isEmpty()) pageUrl += "&status=" + status;
                pageUrl += "&page=";
        %>
            <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:20px; margin-bottom:10px;">
                <% if (currentPage > 1) { %>
                    <a href="<%= pageUrl %><%= currentPage - 1 %>" class="page-btn" style="padding:6px 12px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#475569;">Trước</a>
                <% } %>
                
                <% for (int i = 1; i <= totalPages; i++) { 
                    boolean isCurrent = (currentPage == i);
                %>
                    <a href="<%= pageUrl %><%= i %>" class="page-btn" style="padding:6px 12px; border:1px solid <%= isCurrent ? "var(--primary)" : "#cbd5e1" %>; border-radius:6px; text-decoration:none; color:<%= isCurrent ? "#fff" : "#475569" %>; background:<%= isCurrent ? "var(--primary)" : "#fff" %>; font-weight:<%= isCurrent ? "bold" : "normal" %>;"><%= i %></a>
                <% } %>

                <% if (currentPage < totalPages) { %>
                    <a href="<%= pageUrl %><%= currentPage + 1 %>" class="page-btn" style="padding:6px 12px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#475569;">Sau</a>
                <% } %>
            </div>
        <% } %>
<jsp:include page="/includes/footer.jsp" />
