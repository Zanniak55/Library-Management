<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%
    request.setAttribute("pageTitle", "Tạo phiếu mượn");
    request.setAttribute("activePage", "loans");
%>
<jsp:include page="/includes/header.jsp" />

<div class="content-header">
    <h2>Tạo Phiếu Mượn Sách</h2>
    <p>Điền thông tin thành viên và chọn sách để mượn</p>
</div>

<% String msg = request.getParameter("msg");
   if ("no_copy".equals(msg)) { %><div class="alert alert-danger">Vui lòng chọn ít nhất một cuốn sách.</div><% }
   if ("error".equals(msg))   { %><div class="alert alert-danger">Có lỗi xảy ra, vui lòng thử lại.</div><% } %>

<form action="${pageContext.request.contextPath}/loan" method="post" class="stats-row" style="align-items: flex-start;">
    <input type="hidden" name="action" value="borrow">

    <!-- Left side: Form info -->
    <div style="flex: 1; background: white; padding: 24px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">
        <h3 style="margin-bottom: 20px; font-size: 16px; color: #1e293b;">Thông tin người mượn</h3>
        
        <label style="display: block; font-size: 13px; color: #475569; font-weight: 600; margin-bottom: 8px;">Chọn Thành viên</label>
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
        <div class="member-search-wrap" style="position: relative; margin-bottom: 20px;">
            <input type="text" id="memberNameInput" class="search-input" placeholder="Gõ tên thành viên để tìm kiếm..." autocomplete="off" style="width: 100%; box-sizing: border-box;">
            <input type="hidden" name="memberID" id="memberID" required>
            <div id="memberSuggestions" style="position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #e2e8f0; border-radius: 0 0 8px 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); max-height: 200px; overflow-y: auto; z-index: 10; display: none;"></div>
        </div>

        <label style="display: block; font-size: 13px; color: #475569; font-weight: 600; margin-bottom: 8px;">Hạn trả sách</label>
        <input type="date" name="dueDate" class="search-input" style="width: 100%; box-sizing: border-box; margin-bottom: 24px;" required>

        <button type="submit" class="btn-add" style="width: 100%; justify-content: center; font-size: 15px; padding: 12px;">✅ Xác nhận tạo phiếu</button>
        <a href="${pageContext.request.contextPath}/loan?action=list" style="display: block; text-align: center; margin-top: 16px; color: #64748b; font-size: 14px; text-decoration: none;">← Hủy và quay lại</a>
    </div>

    <!-- Right side: Book selection -->
    <div class="table-card" style="flex: 2;">
        <div class="table-card-header">
            <div class="table-card-header-left">
                <h3>Chọn sách mượn</h3>
            </div>
            <input type="text" id="bookSearch" class="search-input" placeholder="Tìm theo tên sách hoặc barcode..." style="width: 250px;">
        </div>
        <div style="max-height: 400px; overflow-y: auto;">
            <table id="bookTable">
                <thead>
                    <tr>
                        <th style="width: 50px;">Chọn</th>
                        <th>Tên sách</th>
                        <th>Mã vạch (Barcode)</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<String[]> copies = (List<String[]>) request.getAttribute("copies");
                       for (String[] c : copies) { %>
                    <tr class="book-row">
                        <td><input type="checkbox" name="copyID" value="<%= c[0] %>" style="width: 16px; height: 16px; cursor: pointer;"></td>
                        <td class="book-name" style="font-weight: 500;"><%= c[2] %></td>
                        <td class="book-code"><span style="background: #f1f5f9; padding: 4px 8px; border-radius: 4px; font-family: monospace; font-size: 13px;"><%= c[1] %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</form>

<script>
    // Member Autocomplete
    const MEMBERS = <%= memberJson %>;
    const nameInput = document.getElementById("memberNameInput");
    const idInput   = document.getElementById("memberID");
    const box       = document.getElementById("memberSuggestions");

    function removeAccents(str) {
        return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
    }

    function renderList(list) {
        if (!list.length) {
            box.innerHTML = '<div style="padding: 10px 16px; color: #94a3b8; font-size: 14px;">Không tìm thấy kết quả</div>';
        } else {
            box.innerHTML = list.map(function(m) {
                return '<div class="suggestion-item" data-id="' + m.id + '" data-name="' + m.name + '" style="padding: 10px 16px; cursor: pointer; border-bottom: 1px solid #f1f5f9; font-size: 14px; color: #1e293b;">' + m.name + '</div>';
            }).join("");
            
            box.querySelectorAll(".suggestion-item").forEach(function(d) {
                d.addEventListener("mouseover", function() {
                    box.querySelectorAll(".suggestion-item").forEach(el => el.style.background = "white");
                    this.style.background = "#eff6ff";
                });
                d.addEventListener("click", function() {
                    nameInput.value = this.dataset.name;
                    idInput.value   = this.dataset.id;
                    box.style.display = "none";
                });
            });
        }
        box.style.display = "block";
    }

    nameInput.addEventListener("focus", function() {
        const q = removeAccents(this.value.trim());
        const matches = q ? MEMBERS.filter(m => removeAccents(m.name).includes(q)) : MEMBERS;
        renderList(matches.slice(0, 20)); // Show up to 20
    });

    nameInput.addEventListener("input", function() {
        idInput.value = ""; // Clear ID when typing
        const q = removeAccents(this.value.trim());
        const matches = q ? MEMBERS.filter(m => removeAccents(m.name).includes(q)) : MEMBERS;
        renderList(matches.slice(0, 20));
    });

    document.addEventListener("click", function(e) {
        if (!e.target.closest(".member-search-wrap")) box.style.display = "none";
    });

    document.querySelector("form").addEventListener("submit", function(e) {
        if (!idInput.value) {
            e.preventDefault();
            nameInput.style.borderColor = "#ef4444";
            nameInput.focus();
            alert("Vui lòng chọn thành viên từ danh sách gợi ý.");
        }
    });

    // Book Filter
    const bookSearch = document.getElementById("bookSearch");
    const bookRows = document.querySelectorAll(".book-row");
    bookSearch.addEventListener("input", function() {
        const q = this.value.trim().toLowerCase();
        bookRows.forEach(row => {
            const name = row.querySelector(".book-name").textContent.toLowerCase();
            const code = row.querySelector(".book-code").textContent.toLowerCase();
            if (name.includes(q) || code.includes(q)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    });
</script>

<jsp:include page="/includes/footer.jsp" />
