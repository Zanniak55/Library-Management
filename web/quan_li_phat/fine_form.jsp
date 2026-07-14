<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Staff"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tạo phiếu phạt</title>
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
            .form-card {
                background: white;
                border-radius: 8px;
                padding: 28px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
                max-width: 600px;
            }
            label {
                display: block;
                margin: 14px 0 5px;
                font-size: 13px;
                font-weight: bold;
                color: #444;
            }
            select, input[type=text], input[type=number], textarea {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 13px;
                font-family: Arial, sans-serif;
            }
            select:focus, input:focus, textarea:focus {
                outline: none;
                border-color: #4a90d9;
            }
            textarea {
                resize: vertical;
                height: 80px;
            }
            .hint {
                font-size: 12px;
                color: #888;
                margin-top: 4px;
            }
            .actions {
                margin-top: 20px;
                display: flex;
                gap: 10px;
                align-items: center;
            }
            button[type=submit] {
                background: #e74c3c;
                color: white;
                padding: 9px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
            }
            button[type=submit]:hover {
                background: #c0392b;
            }
            a.cancel {
                color: #888;
                font-size: 14px;
                text-decoration: none;
            }
            a.cancel:hover {
                color: #333;
            }
            .err {
                background: #f8d7da;
                color: #721c24;
                padding: 10px 14px;
                border-radius: 6px;
                margin-bottom: 16px;
                font-size: 14px;
            }
        </style>
    </head>
    <body>

        <%
            Staff staff = (Staff) session.getAttribute("staff");
            String ctx = request.getContextPath();
        %>

        <!-- SIDEBAR -->
        <div class="sidebar">
            <div class="sidebar-logo"><span>📚</span> Thư viện</div>
            <div class="sidebar-menu">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a>
                <div class="section-title">Quản lý</div>
                <a href="<%= ctx %>/loan?action=list">📋 Mượn / Trả sách</a>
                <a href="<%= ctx %>/fines?action=list" class="active">💰 Quản lý phạt</a>
                <a href="<%= ctx %>/members">👥 Thành viên</a>
                <a href="#">📖 Sách</a>
                <a href="#">📦 Bản sao sách</a>
                <a href="#">🏷️ Thể loại</a>
                <a href="#">✍️ Tác giả</a>
                <a href="#">🏢 Nhà xuất bản</a>
                <div class="section-title">Hệ thống</div>
                <a href="<%= ctx %>/staffs">👤 Quản lý nhân sự</a>
                <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
        <div class="main">
            <div class="topbar">
                <h2>Tạo phiếu phạt</h2>
                <div class="topbar-right">
                    👤 <%= staff != null ? staff.getFullName() : "" %>
                    <% if (staff != null) { %><span class="badge-role"><%= staff.getRole() %></span><% } %>
                    <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <div class="content">
                <div class="form-card">

                    <% String msg = request.getParameter("msg");
               if ("error".equals(msg)) { %><div class="err">✕ Có lỗi, thử lại.</div><% } %>

                    <form action="<%= ctx %>/fines" method="post">
                        <input type="hidden" name="action" value="add">

                        <label>Phiếu mượn</label>
                        <%
                            List<String[]> transactions = (List<String[]>) request.getAttribute("transactions");
                            StringBuilder txJson = new StringBuilder("[");
                            for (int i = 0; i < transactions.size(); i++) {
                                String[] tr = transactions.get(i);
                                if (i > 0) txJson.append(",");
                                txJson.append("{\"id\":\"").append(tr[0])
                                      .append("\",\"label\":\"#").append(tr[0])
                                      .append(" - ").append(tr[1].replace("\"","\\\""))
                                      .append(" (").append(tr[4]).append(")\"}");
                            }
                            txJson.append("]");
                        %>
                        <div style="position:relative">
                            <input type="text" id="txSearch" placeholder="Tìm theo mã hoặc tên thành viên..." autocomplete="off">
                            <input type="hidden" name="transactionID" id="transactionID" required>
                            <div id="txSuggestions" style="position:absolute;top:100%;left:0;width:100%;background:white;border:1px solid #ddd;border-top:none;border-radius:0 0 6px 6px;max-height:200px;overflow-y:auto;z-index:10;display:none"></div>
                        </div>
                        <script>
                            const TX = <%= txJson %>;
                            const txInput = document.getElementById("txSearch");
                            const txHidden = document.getElementById("transactionID");
                            const txBox = document.getElementById("txSuggestions");
                            txInput.addEventListener("input", function () {
                                const q = this.value.toLowerCase();
                                txHidden.value = "";
                                if (!q) {
                                    txBox.style.display = "none";
                                    return;
                                }
                                const m = TX.filter(t => t.label.toLowerCase().includes(q)).slice(0, 10);
                                if (!m.length) {
                                    txBox.style.display = "none";
                                    return;
                                }
                                txBox.innerHTML = m.map(t =>
                                        `<div style="padding:8px 12px;cursor:pointer;font-size:13px" data-id="${t.id}" data-label="${t.label}"
                                  onmouseover="this.style.background='#f0f4ff'" onmouseout="this.style.background=''"
                                  onclick="txInput.value=this.dataset.label;txHidden.value=this.dataset.id;txBox.style.display='none'">${t.label}</div>`
                                ).join("");
                                txBox.style.display = "block";
                            });
                            document.addEventListener("click", e => {
                                if (!e.target.closest("#txSearch"))
                                    txBox.style.display = "none";
                            });
                        </script>

                        <label>Lý do phạt</label>
                        <textarea name="reason" placeholder="Ví dụ: Trả sách muộn 3 ngày, Sách bị rách bìa..." required></textarea>

                        <label>Số tiền phạt (đồng)</label>
                        <input type="number" name="amount" min="0" step="1000" placeholder="Ví dụ: 15000" required>
                        <div class="hint">Mức phạt trả trễ: 5.000đ/ngày</div>

                        <div class="actions">
                            <button type="submit">Tạo phiếu phạt</button>
                            <a href="<%= ctx %>/fines?action=list" class="cancel">← Quay lại</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>
