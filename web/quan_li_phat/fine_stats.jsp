<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Staff"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thống kê phạt</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; display: flex; }

        .sidebar { width: 220px; min-height: 100vh; background: #1a2238; color: white; position: fixed; top: 0; left: 0; }
        .sidebar-logo { padding: 20px 16px; font-size: 18px; font-weight: bold; border-bottom: 1px solid #2d3a55; display: flex; align-items: center; gap: 8px; }
        .sidebar-logo span { color: #4a90d9; font-size: 22px; }
        .sidebar-menu { padding: 12px 0; }
        .sidebar-menu a { display: flex; align-items: center; gap: 10px; padding: 11px 20px; color: #aab4c8; text-decoration: none; font-size: 14px; transition: background 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background: #2d3a55; color: white; }
        .sidebar-menu .section-title { padding: 14px 20px 6px; font-size: 11px; color: #556; text-transform: uppercase; letter-spacing: 1px; }

        .main { margin-left: 220px; flex: 1; min-height: 100vh; }
        .topbar { background: white; padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .topbar h2 { font-size: 20px; color: #333; }
        .topbar-right { display: flex; align-items: center; gap: 12px; font-size: 14px; color: #555; }
        .badge-role { background: #4a90d9; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; }
        .btn-logout { border: 1px solid #ccc; padding: 6px 14px; border-radius: 4px; color: #555; font-size: 13px; text-decoration: none; }

        .content { padding: 28px; }
        .section-title { font-size: 16px; font-weight: bold; color: #333; margin: 24px 0 12px; }

        /* STAT CARDS */
        .cards { display: flex; gap: 16px; margin-bottom: 8px; }
        .card { flex: 1; background: white; border-radius: 8px; padding: 20px 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; }
        .card .lbl { font-size: 13px; color: #888; margin-bottom: 6px; }
        .card .val { font-size: 26px; font-weight: bold; }
        .red   { color: #e74c3c; }
        .green { color: #27ae60; }
        .blue  { color: #2980b9; }
        .card-icon { font-size: 36px; opacity: 0.2; }

        /* BAR CHART */
        .chart-card { background: white; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 24px; }
        .chart-card h3 { font-size: 14px; color: #555; margin-bottom: 20px; }
        .bar-chart { display: flex; align-items: flex-end; gap: 8px; height: 180px; border-bottom: 2px solid #eee; padding-bottom: 0; }
        .bar-group { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 2px; height: 100%; justify-content: flex-end; }
        .bar-wrap { width: 100%; display: flex; gap: 3px; align-items: flex-end; justify-content: center; }
        .bar { width: 14px; border-radius: 3px 3px 0 0; min-height: 2px; transition: opacity 0.2s; cursor: default; }
        .bar:hover { opacity: 0.8; }
        .bar.paid   { background: #27ae60; }
        .bar.unpaid { background: #e74c3c; }
        .bar-label { font-size: 10px; color: #999; margin-top: 6px; white-space: nowrap; }
        .chart-legend { display: flex; gap: 16px; margin-top: 12px; font-size: 12px; color: #666; }
        .legend-dot { width: 10px; height: 10px; border-radius: 2px; display: inline-block; margin-right: 4px; }

        /* TOP TABLE */
        .table-card { background: white; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; }
        table { border-collapse: collapse; width: 100%; }
        th { background: #34495e; color: white; padding: 11px 14px; text-align: left; font-size: 13px; }
        td { padding: 10px 14px; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f8f9fb; }
        .rank { font-weight: bold; color: #4a90d9; }
        .rank-1 { color: #f39c12; }
        .rank-2 { color: #95a5a6; }
        .rank-3 { color: #cd7f32; }
        .amount-red { color: #e74c3c; font-weight: bold; }

        .no-data { text-align: center; padding: 30px; color: #aaa; font-size: 13px; }
    </style>
</head>
<body>

<%
    Staff staff = (Staff) session.getAttribute("staff");
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff != null ? staff.getRole() : "");
    double totalPaid   = request.getAttribute("totalPaid")   != null ? (Double) request.getAttribute("totalPaid")   : 0;
    double totalUnpaid = request.getAttribute("totalUnpaid") != null ? (Double) request.getAttribute("totalUnpaid") : 0;
    List<String[]> monthlyStats = (List<String[]>) request.getAttribute("monthlyStats");
    List<String[]> topMembers   = (List<String[]>) request.getAttribute("topMembers");
%>

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-logo"><span>📚</span> Thư viện</div>
    <div class="sidebar-menu">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a>
                <% if (isAdmin) { %>
                <a href="<%= ctx %>/staffs">👤 Quản lý nhân sự</a>
                <% } %>
                <a href="<%= ctx %>/members">👥 Thành viên</a>
                <a href="<%= ctx %>/books">📖 Sách</a>
                <a href="<%= ctx %>/bookcopies">📦 Bản sao sách</a>
                <a href="#">🏷️ Thể loại</a>
                <a href="#">✍️ Tác giả</a>
                <a href="<%= ctx %>/publishers">🏢 Nhà xuất bản</a>
                <% if (!isAdmin) { %>
                <a href="<%= ctx %>/loan?action=list">📋 Mượn/Trả</a>
                <a href="<%= ctx %>/fines?action=list" class="active">💰 Phạt</a>
                <% } %>
                <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
<div class="main">
    <div class="topbar">
        <h2>Thống kê phạt / thu phí</h2>
        <div class="topbar-right">
            👤 <%= staff != null ? staff.getFullName() : "" %>
            <% if (staff != null) { %><span class="badge-role"><%= staff.getRole() %></span><% } %>
            <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <div class="content">

        <!-- TỔNG QUAN -->
        <div class="section-title">Tổng quan</div>
        <div class="cards">
            <div class="card">
                <div>
                    <div class="lbl">Đã thu</div>
                    <div class="val green"><%= String.format("%,.0f", totalPaid).replace(",", ".") %> đ</div>
                </div>
                <div class="card-icon">✅</div>
            </div>
            <div class="card">
                <div>
                    <div class="lbl">Chưa thu</div>
                    <div class="val red"><%= String.format("%,.0f", totalUnpaid).replace(",", ".") %> đ</div>
                </div>
                <div class="card-icon">⏳</div>
            </div>
            <div class="card">
                <div>
                    <div class="lbl">Tổng phạt</div>
                    <div class="val blue"><%= String.format("%,.0f", totalPaid + totalUnpaid).replace(",", ".") %> đ</div>
                </div>
                <div class="card-icon">💰</div>
            </div>
            <div class="card">
                <div>
                    <div class="lbl">Tỉ lệ đã thu</div>
                    <div class="val green">
                        <%= (totalPaid + totalUnpaid) > 0
                            ? String.format("%.0f%%", totalPaid / (totalPaid + totalUnpaid) * 100)
                            : "0%" %>
                    </div>
                </div>
                <div class="card-icon">📈</div>
            </div>
        </div>

        <!-- BIỂU ĐỒ THEO THÁNG -->
        <div class="section-title">Thu phạt theo tháng (12 tháng gần nhất)</div>
        <div class="chart-card">
            <h3>Xanh = Đã thu &nbsp;|&nbsp; Đỏ = Chưa thu</h3>
            <%
                double maxVal = 1;
                if (monthlyStats != null) {
                    for (String[] row : monthlyStats) {
                        double paid   = Double.parseDouble(row[1]);
                        double unpaid = Double.parseDouble(row[2]);
                        if (paid + unpaid > maxVal) maxVal = paid + unpaid;
                    }
                }
            %>
            <div class="bar-chart">
                <%
                    if (monthlyStats == null || monthlyStats.isEmpty()) {
                %><div class="no-data" style="width:100%">Không có dữ liệu</div><%
                    } else {
                        for (String[] row : monthlyStats) {
                            double paid   = Double.parseDouble(row[1]);
                            double unpaid = Double.parseDouble(row[2]);
                            int hPaid   = (int) (paid   / maxVal * 160);
                            int hUnpaid = (int) (unpaid / maxVal * 160);
                            String tooltip1 = String.format("%,.0f đ", paid).replace(",",".");
                            String tooltip2 = String.format("%,.0f đ", unpaid).replace(",",".");
                %>
                <div class="bar-group">
                    <div class="bar-wrap">
                        <div class="bar paid"   style="height:<%= hPaid %>px"   title="Đã thu: <%= tooltip1 %>"></div>
                        <div class="bar unpaid" style="height:<%= hUnpaid %>px" title="Chưa thu: <%= tooltip2 %>"></div>
                    </div>
                    <div class="bar-label"><%= row[0] %></div>
                </div>
                <%      }
                    }
                %>
            </div>
            <div class="chart-legend">
                <span><span class="legend-dot" style="background:#27ae60"></span>Đã thu</span>
                <span><span class="legend-dot" style="background:#e74c3c"></span>Chưa thu</span>
            </div>
        </div>

        <!-- TOP THÀNH VIÊN -->
        <div class="section-title">Top thành viên bị phạt nhiều nhất</div>
        <div class="table-card">
            <table>
                <tr>
                    <th>Hạng</th>
                    <th>Thành viên</th>
                    <th>Số phiếu phạt</th>
                    <th>Tổng tiền phạt</th>
                </tr>
                <%
                    if (topMembers == null || topMembers.isEmpty()) {
                %>
                <tr><td colspan="4" class="no-data">Không có dữ liệu</td></tr>
                <%
                    } else {
                        int rank = 1;
                        for (String[] m : topMembers) {
                            String rankClass = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "rank";
                            String medal = rank == 1 ? "🥇" : rank == 2 ? "🥈" : rank == 3 ? "🥉" : "#" + rank;
                            double amt = Double.parseDouble(m[2]);
                %>
                <tr>
                    <td class="<%= rankClass %>"><%= medal %></td>
                    <td><%= m[0] %></td>
                    <td><%= m[1] %> phiếu</td>
                    <td class="amount-red"><%= String.format("%,.0f", amt).replace(",", ".") %> đ</td>
                </tr>
                <%
                            rank++;
                        }
                    }
                %>
            </table>
        </div>

    </div>
</div>

</body>
</html>
