<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tạo phiếu mượn</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
            h2 { margin-bottom: 16px; }
            label { display: block; margin: 12px 0 4px; font-weight: bold; }
            select, input[type=date] { padding: 8px; width: 350px; border: 1px solid #ccc; border-radius: 4px; }
            table { border-collapse: collapse; width: 100%; background: white; margin-top: 6px; }
            th { background: #34495e; color: white; padding: 9px; text-align: left; }
            td { padding: 8px 10px; border-bottom: 1px solid #ddd; }
            button { margin-top: 16px; background: #27ae60; color: white; padding: 9px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
            button:hover { background: #219150; }
            a { margin-left: 12px; color: #555; }
            .err { background: #f8d7da; color: #721c24; padding: 8px 12px; border-radius: 4px; margin-bottom: 12px; }
        </style>
    </head>
    <body>

        <h2>Tạo phiếu mượn sách</h2>

        <% String msg = request.getParameter("msg");
           if ("no_copy".equals(msg)) { %><div class="err">Vui lòng chọn ít nhất một bản sao.</div><% }
           if ("error".equals(msg))   { %><div class="err">Lỗi tạo phiếu, thử lại.</div><% } %>

        <form action="${pageContext.request.contextPath}/loan" method="post">
            <input type="hidden" name="action" value="borrow">

            <label>Thành viên</label>
            <select name="memberID" required>
                <option value="">-- Chọn --</option>
                <% List<String[]> members = (List<String[]>) request.getAttribute("members");
                   for (String[] m : members) { %>
                    <option value="<%= m[0] %>"><%= m[0] %> - <%= m[1] %></option>
                <% } %>
            </select>

            <label>Hạn trả</label>
            <input type="date" name="dueDate" required>

            <label>Chọn bản sao sách</label>
            <table>
                <tr>
                    <th>Chọn</th>
                    <th>Tên sách</th>
                    <th>Barcode</th>
                </tr>
                <% List<String[]> copies = (List<String[]>) request.getAttribute("copies");
                   for (String[] c : copies) { %>
                <tr>
                    <td><input type="checkbox" name="copyID" value="<%= c[0] %>"></td>
                    <td><%= c[2] %></td>
                    <td><%= c[1] %></td>
                </tr>
                <% } %>
            </table>

            <button type="submit">Xác nhận mượn</button>
            <a href="${pageContext.request.contextPath}/loan?action=list">← Quay lại</a>
        </form>

    </body>
</html>
