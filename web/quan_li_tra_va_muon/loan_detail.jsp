<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết phiếu mượn</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        h2 { margin: 0; }
        a.back-btn { background: #7f8c8d; color: white; padding: 7px 14px; border-radius: 4px; text-decoration: none; font-size: 13px; }
        a.back-btn:hover { background: #636e72; }
        a.return-btn { background: #e74c3c; color: white; padding: 7px 14px; border-radius: 4px; text-decoration: none; font-size: 13px; }

        .info-card { background: white; border-radius: 8px; padding: 20px 24px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .info-card h3 { margin: 0 0 14px; font-size: 15px; color: #555; border-bottom: 1px solid #eee; padding-bottom: 8px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 30px; }
        .info-row { display: flex; flex-direction: column; }
        .info-row .lbl { font-size: 12px; color: #888; margin-bottom: 2px; }
        .info-row .val { font-size: 14px; color: #222; font-weight: 500; }
        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .badge-borrowing { background: #d4edda; color: #155724; }
        .badge-returned  { background: #cce5ff; color: #004085; }
        .badge-overdue   { background: #f8d7da; color: #721c24; }

        table { border-collapse: collapse; width: 100%; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        th { background: #34495e; color: white; padding: 10px 12px; text-align: left; font-size: 13px; }
        td { padding: 9px 12px; border-bottom: 1px solid #eee; font-size: 13px; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f9f9f9; }
        .actions { margin-top: 20px; display: flex; gap: 10px; }
    </style>
</head>
<body>

<%
    Transaction t = (Transaction) request.getAttribute("transaction");
    List<String[]> details = (List<String[]>) request.getAttribute("details");
    if (t == null) {
        response.sendRedirect(request.getContextPath() + "/loan?action=list");
        return;
    }
    String statusClass = "Đang mượn".equals(t.getStatus()) ? "badge-borrowing"
                       : "Đã trả".equals(t.getStatus())    ? "badge-returned"
                       : "badge-overdue";
%>

<div class="topbar">
    <h2>Chi tiết phiếu mượn #<%= t.getTransactionID() %></h2>
    <a href="${pageContext.request.contextPath}/loan?action=list" class="back-btn">← Quay lại</a>
</div>

<div class="info-card">
    <h3>Thông tin phiếu</h3>
    <div class="info-grid">
        <div class="info-row">
            <span class="lbl">Mã phiếu</span>
            <span class="val">#<%= t.getTransactionID() %></span>
        </div>
        <div class="info-row">
            <span class="lbl">Trạng thái</span>
            <span class="val">
                <span class="status-badge <%= statusClass %>"><%= t.getStatus() %></span>
            </span>
        </div>
        <div class="info-row">
            <span class="lbl">Thành viên</span>
            <span class="val"><%= t.getMemberName() %></span>
        </div>
        <div class="info-row">
            <span class="lbl">Mã thành viên</span>
            <span class="val">#<%= t.getMemberID() %></span>
        </div>
        <div class="info-row">
            <span class="lbl">Ngày mượn</span>
            <span class="val"><%= t.getBorrowDate() %></span>
        </div>
        <div class="info-row">
            <span class="lbl">Hạn trả</span>
            <span class="val" style="<%= "Quá hạn".equals(t.getStatus()) ? "color:#c0392b;font-weight:bold" : "" %>">
                <%= t.getDueDate() %><%= "Quá hạn".equals(t.getStatus()) ? " ⚠️" : "" %>
            </span>
        </div>
        <div class="info-row">
            <span class="lbl">Ngày trả thực tế</span>
            <span class="val"><%= t.getReturnDate() != null ? t.getReturnDate() : "—" %></span>
        </div>
        <div class="info-row">
            <span class="lbl">Mã nhân viên xử lý</span>
            <span class="val">#<%= t.getStaffID() %></span>
        </div>
    </div>
</div>

<table>
    <tr>
        <th>#</th>
        <th>Tên sách</th>
        <th>ISBN</th>
        <th>Barcode</th>
        <th>Trạng thái bản sao</th>
    </tr>
    <% if (details != null) {
           int idx = 1;
           for (String[] d : details) { %>
    <tr>
        <td><%= idx++ %></td>
        <td><%= d[2] %></td>
        <td><%= d[3] %></td>
        <td><%= d[1] %></td>
        <td><%= d[4] %></td>
    </tr>
    <% }} %>
</table>

<div class="actions">
    <% if ("Đang mượn".equals(t.getStatus()) || "Quá hạn".equals(t.getStatus())) { %>
    <a href="${pageContext.request.contextPath}/loan?action=return&id=<%= t.getTransactionID() %>"
       class="return-btn"
       onclick="return confirm('Xác nhận trả sách?')">Trả sách</a>
    <% } %>
</div>

</body>
</html>
