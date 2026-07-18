<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Báo cáo Mượn/Trả - Thư viện");
    request.setAttribute("activePage", "loanstats");
    
    int totalBorrowing = request.getAttribute("totalBorrowing") != null ? (Integer) request.getAttribute("totalBorrowing") : 0;
    int totalReturned  = request.getAttribute("totalReturned")  != null ? (Integer) request.getAttribute("totalReturned") : 0;
    int totalOverdue   = request.getAttribute("totalOverdue")   != null ? (Integer) request.getAttribute("totalOverdue") : 0;
    
    List<String[]> monthlyStats = (List<String[]>) request.getAttribute("monthlyStats");
    List<String[]> topBooks     = (List<String[]>) request.getAttribute("topBooks");
%>
<jsp:include page="/includes/header.jsp" />

<style>
    /* STAT CARDS */
    .cards { display: flex; gap: 16px; margin-bottom: 24px; }
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
    .bar-chart { display: flex; align-items: flex-end; gap: 8px; height: 180px; border-bottom: 2px solid #eee; padding-bottom: 0; overflow-x: auto; }
    .bar-group { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 2px; height: 100%; justify-content: flex-end; min-width: 40px; }
    .bar-wrap { width: 100%; display: flex; gap: 3px; align-items: flex-end; justify-content: center; }
    .bar { width: 14px; border-radius: 3px 3px 0 0; min-height: 2px; transition: opacity 0.2s; cursor: default; }
    .bar:hover { opacity: 0.8; }
    .bar.borrow { background: #2980b9; }
    .bar.return { background: #27ae60; }
    .bar-label { font-size: 10px; color: #999; margin-top: 6px; white-space: nowrap; }
    .chart-legend { display: flex; gap: 16px; margin-top: 12px; font-size: 12px; color: #666; }
    .legend-dot { width: 10px; height: 10px; border-radius: 2px; display: inline-block; margin-right: 4px; }

    /* TOP TABLE */
    .table-card { background: white; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; margin-bottom: 24px;}
    table { border-collapse: collapse; width: 100%; }
    th { background: #f8fafc; color: #64748b; padding: 14px 20px; text-align: left; font-size: 13px; font-weight: 600; text-transform: uppercase; border-bottom: 2px solid #e2e8f0;}
    td { padding: 14px 20px; border-bottom: 1px solid #f1f5f9; font-size: 14px; color: #334155;}
    tr:last-child td { border-bottom: none; }
    tr:hover td { background: #eff6ff; }
    .rank { font-weight: bold; color: #4a90d9; }
    .rank-1 { color: #f39c12; }
    .rank-2 { color: #95a5a6; }
    .rank-3 { color: #cd7f32; }
    .no-data { text-align: center; padding: 30px; color: #aaa; font-size: 13px; }
</style>

<div class="cards">
    <div class="card">
        <div>
            <div class="lbl">SÁCH ĐANG MƯỢN</div>
            <div class="val blue"><%= totalBorrowing %> cuốn</div>
        </div>
        <div class="card-icon blue">📖</div>
    </div>
    <div class="card">
        <div>
            <div class="lbl">SÁCH QUÁ HẠN</div>
            <div class="val red"><%= totalOverdue %> cuốn</div>
        </div>
        <div class="card-icon red">⚠️</div>
    </div>
    <div class="card">
        <div>
            <div class="lbl">SÁCH ĐÃ TRẢ TỔNG</div>
            <div class="val green"><%= totalReturned %> cuốn</div>
        </div>
        <div class="card-icon green">✅</div>
    </div>
</div>

<div class="chart-card">
    <h3>BIỂU ĐỒ MƯỢN / TRẢ THEO THÁNG</h3>
    <div class="bar-chart">
        <% 
            double maxCount = 10; // Default max to show chart scale properly
            for (String[] st : monthlyStats) {
                double b = Double.parseDouble(st[1]);
                double r = Double.parseDouble(st[2]);
                if (b > maxCount) maxCount = b;
                if (r > maxCount) maxCount = r;
            }
            if (monthlyStats.isEmpty()) {
        %>
            <div class="no-data" style="width:100%">Không có dữ liệu tháng</div>
        <% } else {
            for (String[] st : monthlyStats) {
                double b = Double.parseDouble(st[1]);
                double r = Double.parseDouble(st[2]);
                int hb = (int)((b / maxCount) * 100);
                int hr = (int)((r / maxCount) * 100);
        %>
            <div class="bar-group">
                <div class="bar-wrap" style="height:100%">
                    <div class="bar borrow" style="height:<%= hb %>%" title="Đã mượn: <%= String.format("%,.0f", b) %> cuốn"></div>
                    <div class="bar return" style="height:<%= hr %>%" title="Đã trả: <%= String.format("%,.0f", r) %> cuốn"></div>
                </div>
                <div class="bar-label"><%= st[0] %></div>
            </div>
        <%  }
        } %>
    </div>
    <div class="chart-legend">
        <div><span class="legend-dot borrow"></span> Mượn (Cuốn)</div>
        <div><span class="legend-dot return"></span> Trả (Cuốn)</div>
    </div>
</div>

<div class="table-card">
    <div style="padding: 20px 24px; border-bottom: 1px solid #f1f5f9;">
        <h3 style="font-size: 16px; color: #1e293b; margin:0;">🔥 TOP 5 SÁCH ĐƯỢC MƯỢN NHIỀU NHẤT</h3>
    </div>
    <table>
        <thead>
            <tr>
                <th>Hạng</th>
                <th>Tên Sách</th>
                <th>Số lượt mượn</th>
            </tr>
        </thead>
        <tbody>
            <% if (topBooks.isEmpty()) { %>
            <tr><td colspan="3"><div class="no-data">Chưa có dữ liệu mượn sách</div></td></tr>
            <% } else {
                int rank = 1;
                for (String[] b : topBooks) {
                    String rClass = rank <= 3 ? "rank-" + rank : "";
            %>
            <tr>
                <td><span class="rank <%= rClass %>">#<%= rank %></span></td>
                <td style="font-weight: 600;"><%= b[0] %></td>
                <td><span style="background: #eef2f6; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold;"><%= b[1] %> lượt</span></td>
            </tr>
            <%  rank++;
                }
            } %>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/footer.jsp" />
