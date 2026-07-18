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
    request.setAttribute("pageTitle", "Báo cáo Phạt - Thư viện");
    request.setAttribute("activePage", "finestats");
    
    double totalPaid   = request.getAttribute("totalPaid")   != null ? (Double) request.getAttribute("totalPaid")   : 0;
    double totalUnpaid = request.getAttribute("totalUnpaid") != null ? (Double) request.getAttribute("totalUnpaid") : 0;
    List<String[]> monthlyStats = (List<String[]>) request.getAttribute("monthlyStats");
    List<String[]> topMembers   = (List<String[]>) request.getAttribute("topMembers");
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
    .bar.paid   { background: #27ae60; }
    .bar.unpaid { background: #e74c3c; }
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
    .amount-red { color: #e74c3c; font-weight: bold; }
    .no-data { text-align: center; padding: 30px; color: #aaa; font-size: 13px; }
</style>

<div class="cards">
    <div class="card">
        <div>
            <div class="lbl">TỔNG ĐÃ THU</div>
            <div class="val green"><%= String.format("%,.0f", totalPaid) %> ₫</div>
        </div>
        <div class="card-icon green">💰</div>
    </div>
    <div class="card">
        <div>
            <div class="lbl">TỔNG CHƯA THU</div>
            <div class="val red"><%= String.format("%,.0f", totalUnpaid) %> ₫</div>
        </div>
        <div class="card-icon red">⚠️</div>
    </div>
    <div class="card">
        <div>
            <div class="lbl">TỔNG PHẠT</div>
            <div class="val blue"><%= String.format("%,.0f", totalPaid + totalUnpaid) %> ₫</div>
        </div>
        <div class="card-icon blue">📊</div>
    </div>
</div>

<div class="chart-card">
    <h3>BIỂU ĐỒ THU PHẠT THEO THÁNG</h3>
    <div class="bar-chart">
        <% 
            double maxAmount = 10000;
            for (String[] st : monthlyStats) {
                double p = Double.parseDouble(st[1]);
                double u = Double.parseDouble(st[2]);
                if (p > maxAmount) maxAmount = p;
                if (u > maxAmount) maxAmount = u;
            }
            if (monthlyStats.isEmpty()) {
        %>
            <div class="no-data" style="width:100%">Không có dữ liệu tháng</div>
        <% } else {
            for (String[] st : monthlyStats) {
                double p = Double.parseDouble(st[1]);
                double u = Double.parseDouble(st[2]);
                int hp = (int)((p / maxAmount) * 100);
                int hu = (int)((u / maxAmount) * 100);
        %>
            <div class="bar-group">
                <div class="bar-wrap" style="height:100%">
                    <div class="bar paid" style="height:<%= hp %>%" title="Đã thu: <%= String.format("%,.0f", p) %>₫"></div>
                    <div class="bar unpaid" style="height:<%= hu %>%" title="Chưa thu: <%= String.format("%,.0f", u) %>₫"></div>
                </div>
                <div class="bar-label"><%= st[0] %></div>
            </div>
        <%  }
        } %>
    </div>
    <div class="chart-legend">
        <div><span class="legend-dot paid"></span> Đã thu (VND)</div>
        <div><span class="legend-dot unpaid"></span> Chưa thu (VND)</div>
    </div>
</div>

<div class="table-card">
    <div style="padding: 20px 24px; border-bottom: 1px solid #f1f5f9;">
        <h3 style="font-size: 16px; color: #1e293b; margin:0;">TOP 5 THÀNH VIÊN NỢ/PHẠT NHIỀU NHẤT</h3>
    </div>
    <table>
        <thead>
            <tr>
                <th>Hạng</th>
                <th>Thành viên</th>
                <th>Số lần phạt</th>
                <th>Tổng tiền</th>
            </tr>
        </thead>
        <tbody>
            <% if (topMembers.isEmpty()) { %>
            <tr><td colspan="4"><div class="no-data">Chưa có dữ liệu phạt</div></td></tr>
            <% } else {
                int rank = 1;
                for (String[] m : topMembers) {
                    String rClass = rank <= 3 ? "rank-" + rank : "";
            %>
            <tr>
                <td><span class="rank <%= rClass %>">#<%= rank %></span></td>
                <td style="font-weight: 600;"><%= m[0] %></td>
                <td><%= m[1] %> lần</td>
                <td class="amount-red"><%= String.format("%,.0f", Double.parseDouble(m[2])) %> ₫</td>
            </tr>
            <%  rank++;
                }
            } %>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/footer.jsp" />
