<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Fine, model.Staff"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý phạt</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: Arial, sans-serif;
                background: #f0f2f5;
                display: flex;
            }

            .sidebar {
                width: 220px;
                min-height: 100vh;
                background: #1a2238;
                color: white;
                position: fixed;
                top: 0;
                left: 0;
            }
            .sidebar-logo {
                padding: 20px 16px;
                font-size: 18px;
                font-weight: bold;
                border-bottom: 1px solid #2d3a55;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .sidebar-logo span {
                color: #4a90d9;
                font-size: 22px;
            }
            .sidebar-menu {
                padding: 12px 0;
            }
            .sidebar-menu a {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 11px 20px;
                color: #aab4c8;
                text-decoration: none;
                font-size: 14px;
                transition: background 0.2s;
            }
            .sidebar-menu a:hover, .sidebar-menu a.active {
                background: #2d3a55;
                color: white;
            }
            .sidebar-menu .section-title {
                padding: 14px 20px 6px;
                font-size: 11px;
                color: #556;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .main {
                margin-left: 220px;
                flex: 1;
                min-height: 100vh;
            }
            .topbar {
                background: white;
                padding: 14px 28px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
            .topbar h2 {
                font-size: 20px;
                color: #333;
            }
            .topbar-right {
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                color: #555;
            }
            .badge-role {
                background: #4a90d9;
                color: white;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 12px;
            }
            .btn-logout {
                border: 1px solid #ccc;
                padding: 6px 14px;
                border-radius: 4px;
                color: #555;
                font-size: 13px;
                text-decoration: none;
            }

            .content {
                padding: 28px;
            }

            .summary-row {
                display: flex;
                gap: 16px;
                margin-bottom: 20px;
            }
            .summary-card {
                flex: 1;
                background: white;
                border-radius: 8px;
                padding: 16px 24px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
            .summary-card .label {
                font-size: 13px;
                color: #888;
                margin-bottom: 4px;
            }
            .summary-card .amount {
                font-size: 26px;
                font-weight: bold;
            }
            .amount-red   {
                color: #e74c3c;
            }
            .amount-green {
                color: #27ae60;
            }

            .msg {
                padding: 10px 14px;
                border-radius: 6px;
                margin-bottom: 16px;
                font-size: 14px;
            }
            .ok  {
                background: #d4edda;
                color: #155724;
            }
            .err {
                background: #f8d7da;
                color: #721c24;
            }

            .toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }
            a.btn-create {
                background: #e74c3c;
                color: white;
                padding: 8px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 14px;
                font-weight: bold;
            }
            a.btn-create:hover {
                background: #c0392b;
            }

            .search-bar {
                display: flex;
                gap: 8px;
                align-items: center;
                margin-bottom: 16px;
                background: white;
                padding: 12px 16px;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            }
            .search-bar input[type=text] {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 13px;
            }
            .search-bar input[type=text]:focus {
                outline: none;
                border-color: #4a90d9;
            }
            .search-bar select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 13px;
            }
            .search-bar button {
                padding: 8px 18px;
                background: #4a90d9;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 13px;
                font-weight: bold;
            }
            .search-bar a.clear-btn {
                padding: 8px 12px;
                color: #888;
                font-size: 13px;
                text-decoration: none;
            }

            .table-wrap {
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
                overflow: hidden;
            }
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th {
                background: #34495e;
                color: white;
                padding: 11px 14px;
                text-align: left;
                font-size: 13px;
            }
            td {
                padding: 10px 14px;
                border-bottom: 1px solid #f0f0f0;
                font-size: 13px;
                color: #333;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover td {
                background: #f8f9fb;
            }
            tr.unpaid td {
                background: #fff9f9;
            }

            .badge {
                display: inline-block;
                padding: 3px 10px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: bold;
            }
            .badge-unpaid {
                background: #f8d7da;
                color: #721c24;
            }
            .badge-paid   {
                background: #d4edda;
                color: #155724;
            }

            a.paid-btn {
                background: #27ae60;
                color: white;
                padding: 4px 10px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 12px;
            }
            a.paid-btn:hover {
                background: #219150;
            }
            .empty {
                text-align: center;
                padding: 40px;
                color: #aaa;
                font-size: 14px;
            }

            .amount-cell {
                font-weight: bold;
                color: #e74c3c;
            }
        </style>
    </head>
    <body>

        <%
            Staff staff = (Staff) session.getAttribute("staff");
            String ctx = request.getContextPath();
            double totalUnpaid = request.getAttribute("totalUnpaid") != null
                               ? (Double) request.getAttribute("totalUnpaid") : 0;
        %>

        <!-- SIDEBAR -->
        <div class="sidebar">
            <div class="sidebar-logo"><span>📚</span> Thư viện</div>
            <div class="sidebar-menu">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a>
                <div class="section-title">Quản lý</div>
                <a href="<%= ctx %>/loan?action=list">📋 Mượn / Trả sách</a>
                <a href="<%= ctx %>/fine?action=list" class="active">💰 Quản lý phạt</a>
                <a href="<%= ctx %>/MemberServlet">👥 Thành viên</a>
                <a href="#">📖 Sách</a>
                <a href="#">📦 Bản sao sách</a>
                <a href="#">🏷️ Thể loại</a>
                <a href="#">✍️ Tác giả</a>
                <a href="#">🏢 Nhà xuất bản</a>
                <div class="section-title">Hệ thống</div>
                <a href="<%= ctx %>/StaffServlet">👤 Quản lý nhân sự</a>
                <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
        <div class="main">
            <div class="topbar">
                <h2>Quản lý phạt / thu phí</h2>
                <div class="topbar-right">
                    👤 <%= staff != null ? staff.getFullName() : "" %>
                    <% if (staff != null) { %><span class="badge-role"><%= staff.getRole() %></span><% } %>
                    <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <div class="content">

                <%
                    double totalPaid = request.getAttribute("totalPaid") != null
                                     ? (Double) request.getAttribute("totalPaid") : 0;
                %>
                <div class="summary-row">
                    <div class="summary-card">
                        <div>
                            <div class="label">Chưa thu</div>
                            <div class="amount amount-red">
                                <%= String.format("%,.0f", totalUnpaid).replace(",", ".") %> đ
                            </div>
                        </div>
                        <span style="font-size:36px;opacity:0.2">⏳</span>
                    </div>
                    <div class="summary-card">
                        <div>
                            <div class="label">Đã thu</div>
                            <div class="amount amount-green">
                                <%= String.format("%,.0f", totalPaid).replace(",", ".") %> đ
                            </div>
                        </div>
                        <span style="font-size:36px;opacity:0.2">✅</span>
                    </div>
                    <div class="summary-card">
                        <div>
                            <div class="label">Tổng phạt</div>
                            <div class="amount" style="color:#2980b9">
                                <%= String.format("%,.0f", totalUnpaid + totalPaid).replace(",", ".") %> đ
                            </div>
                        </div>
                        <span style="font-size:36px;opacity:0.2">💰</span>
                    </div>
                </div>

                <% String msg = request.getParameter("msg");
           if ("paid".equals(msg))  { %><div class="msg ok">✓ Đã xác nhận thanh toán!</div><% }
           if ("added".equals(msg)) { %><div class="msg ok">✓ Đã tạo phiếu phạt!</div><% }
           if ("error".equals(msg)) { %><div class="msg err">✕ Có lỗi xảy ra, thử lại.</div><% } %>

                <div class="toolbar">
                    <div style="display:flex;gap:10px">
                        <a href="<%= ctx %>/fine?action=add" class="btn-create">+ Tạo phiếu phạt</a>
                        <a href="<%= ctx %>/fine?action=stats" style="background:#4a90d9;color:white;padding:8px 16px;border-radius:6px;text-decoration:none;font-size:14px;font-weight:bold">📊 Thống kê</a>
                    </div>
                </div>

                <%
                    String kw = (String) request.getAttribute("keyword");
                    String ps2 = (String) request.getAttribute("paidStatus");
                    if (kw == null) kw = "";
                    if (ps2 == null) ps2 = "";
                %>
                <form method="get" action="<%= ctx %>/fine" class="search-bar">
                    <input type="hidden" name="action" value="list">
                    <input type="text" name="keyword" placeholder="Tìm theo tên thành viên..." value="<%= kw %>">
                    <select name="paidStatus">
                        <option value=""         <%= ps2.isEmpty()           ? "selected" : "" %>>-- Tất cả --</option>
                        <option value="Chưa đóng" <%= "Chưa đóng".equals(ps2) ? "selected" : "" %>>Chưa đóng</option>
                        <option value="Đã đóng"   <%= "Đã đóng".equals(ps2)   ? "selected" : "" %>>Đã đóng</option>
                    </select>
                    <button type="submit">🔍 Tìm kiếm</button>
                    <% if (!kw.isEmpty() || !ps2.isEmpty()) { %>
                    <a href="<%= ctx %>/fine?action=list" class="clear-btn">✕ Xóa bộ lọc</a>
                    <% } %>
                </form>

                <div class="table-wrap">
                    <table>
                        <tr>
                            <th>Mã phạt</th>
                            <th>Thành viên</th>
                            <th>Mã phiếu mượn</th>
                            <th>Lý do</th>
                            <th>Số tiền</th>
                            <th>Ngày lập</th>
                            <th>Ngày đóng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        <%
                            List<Fine> fines = (List<Fine>) request.getAttribute("fines");
                            if (fines == null || fines.isEmpty()) {
                        %>
                        <tr><td colspan="9" class="empty">Không có phiếu phạt nào.</td></tr>
                        <%
                            } else {
                                for (Fine f : fines) {
                                    boolean unpaid = "Chưa đóng".equals(f.getPaidStatus());
                        %>
                        <tr class="<%= unpaid ? "unpaid" : "" %>">
                            <td>#<%= f.getFineID() %></td>
                            <td><%= f.getMemberName() %></td>
                            <td>#<%= f.getTransactionID() %></td>
                            <td><%= f.getReason() %></td>
                            <td class="amount-cell">
                                <%= String.format("%,.0f", f.getAmount()).replace(",", ".") %> đ
                            </td>
                            <td><%= f.getIssueDate() %></td>
                            <td><%= f.getPaidDate() != null ? f.getPaidDate() : "—" %></td>
                            <td>
                                <span class="badge <%= unpaid ? "badge-unpaid" : "badge-paid" %>">
                                    <%= f.getPaidStatus() %>
                                </span>
                            </td>
                            <td>
                                <% if (unpaid) { %>
                                <a href="<%= ctx %>/fine?action=paid&id=<%= f.getFineID() %>"
                                   class="paid-btn"
                                   onclick="return confirm('Xác nhận đã thu tiền phạt?')">Thu tiền</a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </table>
                </div>

            </div>
        </div>

    </body>
</html>
