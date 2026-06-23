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
            select, input[type=date], input[type=text] { padding: 8px; width: 350px; border: 1px solid #ccc; border-radius: 4px; }
            .member-search-wrap { position: relative; display: inline-block; }
            #memberNameInput { width: 350px; }
            #memberSuggestions { position: absolute; top: 100%; left: 0; width: 350px; background: white; border: 1px solid #ccc; border-top: none; border-radius: 0 0 4px 4px; max-height: 200px; overflow-y: auto; z-index: 10; display: none; }
            #memberSuggestions div { padding: 8px 10px; cursor: pointer; font-size: 13px; }
            #memberSuggestions div:hover, #memberSuggestions div.active { background: #e8f0fe; }
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
            <%
                List<String[]> members = (List<String[]>) request.getAttribute("members");
                StringBuilder memberJson = new StringBuilder("[");
                for (int i = 0; i < members.size(); i++) {
                    String[] m = members.get(i);
                    if (i > 0) memberJson.append(",");
                    memberJson.append("{\"id\":\"").append(m[0])
                              .append("\",\"name\":\"").append(m[1].replace("\"","\\\"")).append("\"}");
                }
                memberJson.append("]");
            %>
            <div class="member-search-wrap">
                <input type="text" id="memberNameInput" placeholder="Gõ tên thành viên..." autocomplete="off">
                <input type="hidden" name="memberID" id="memberID" required>
                <div id="memberSuggestions"></div>
            </div>
            <script>
                const MEMBERS = <%= memberJson %>;
                const nameInput = document.getElementById("memberNameInput");
                const idInput   = document.getElementById("memberID");
                const box       = document.getElementById("memberSuggestions");
                let activeIdx   = -1;

                nameInput.addEventListener("input", function() {
                    const q = this.value.trim().toLowerCase();
                    idInput.value = "";
                    if (!q) { box.style.display = "none"; return; }
                    const matches = MEMBERS.filter(m => m.name.toLowerCase().includes(q)).slice(0, 10);
                    if (!matches.length) { box.style.display = "none"; return; }
                    box.innerHTML = matches.map((m, i) =>
                        `<div data-id="${m.id}" data-name="${m.name}">${m.name}</div>`
                    ).join("");
                    box.style.display = "block";
                    activeIdx = -1;
                    box.querySelectorAll("div").forEach(d => d.addEventListener("click", function() {
                        nameInput.value = this.dataset.name;
                        idInput.value   = this.dataset.id;
                        box.style.display = "none";
                    }));
                });

                nameInput.addEventListener("keydown", function(e) {
                    const items = box.querySelectorAll("div");
                    if (!items.length) return;
                    if (e.key === "ArrowDown") { activeIdx = Math.min(activeIdx + 1, items.length - 1); }
                    else if (e.key === "ArrowUp") { activeIdx = Math.max(activeIdx - 1, 0); }
                    else if (e.key === "Enter" && activeIdx >= 0) {
                        e.preventDefault();
                        items[activeIdx].click();
                        return;
                    } else return;
                    items.forEach((d, i) => d.classList.toggle("active", i === activeIdx));
                });

                document.addEventListener("click", function(e) {
                    if (!e.target.closest(".member-search-wrap")) box.style.display = "none";
                });

                document.querySelector("form").addEventListener("submit", function(e) {
                    if (!idInput.value) {
                        e.preventDefault();
                        nameInput.style.borderColor = "red";
                        nameInput.focus();
                        alert("Vui lòng chọn thành viên từ danh sách gợi ý.");
                    }
                });
            </script>

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
