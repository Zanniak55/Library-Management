<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Fine, model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    double totalUnpaid = request.getAttribute("totalUnpaid") != null
                       ? (Double) request.getAttribute("totalUnpaid") : 0;
    request.setAttribute("pageTitle", "Quản lý Phạt - Thư viện");
    request.setAttribute("activePage", "fines");
%>
<jsp:include page="/includes/header.jsp" />

                <%
                    double totalPaid = request.getAttribute("totalPaid") != null
                                     ? (Double) request.getAttribute("totalPaid") : 0;
                %>
                <div class="summary-row">
                    <div class="summary-card red">
                        <div>
                            <div class="label">Chưa thu</div>
                            <div class="amount amount-red">
                                <%= String.format("%,.0f", totalUnpaid).replace(",", ".") %> đ
                            </div>
                        </div>
                        <span style="font-size:36px;opacity:0.2">⏳</span>
                    </div>
                    <div class="summary-card green">
                        <div>
                            <div class="label">Đã thu</div>
                            <div class="amount amount-green">
                                <%= String.format("%,.0f", totalPaid).replace(",", ".") %> đ
                            </div>
                        </div>
                        <span style="font-size:36px;opacity:0.2">✅</span>
                    </div>
                    <div class="summary-card blue">
                        <div>
                            <div class="label">Tổng phạt</div>
                            <div class="amount amount-blue">
                                <%= String.format("%,.0f", totalUnpaid + totalPaid).replace(",", ".") %> đ
                            </div>
                        </div>
                        <span style="font-size:36px;opacity:0.2">💰</span>
                    </div>
                </div>

                <% String msg = request.getParameter("msg");
                   if ("paid".equals(msg))  { %><div class="alert alert-success">✅ Đã xác nhận thanh toán!</div><% }
                   if ("added".equals(msg)) { %><div class="alert alert-success">✅ Đã tạo phiếu phạt!</div><% }
                   if ("error".equals(msg)) { %><div class="alert alert-danger">⚠️ Có lỗi xảy ra, thử lại.</div><% } %>

            <!-- TOOLBAR -->
            <div class="toolbar">
                <div class="toolbar-left">
                    <%
                        String kw = (String) request.getAttribute("keyword");
                        String ps2 = (String) request.getAttribute("paidStatus");
                        if (kw == null) kw = "";
                        if (ps2 == null) ps2 = "";
                    %>
                    <form method="get" action="<%= ctx %>/fines" class="search-group">
                        <input type="hidden" name="action" value="list">
                        <input type="text" name="keyword" class="search-input" placeholder="Tìm tên thành viên..." value="<%= kw %>">
                        <button class="search-btn" type="submit">🔍 Tìm</button>
                    </form>
                    <% if (!kw.isEmpty()) { %>
                        <a href="<%= ctx %>/fines?action=list" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa</a>
                    <% } %>
                    <span style="color:#ddd;">|</span>
                    <form method="get" action="<%= ctx %>/fines" class="search-group">
                        <input type="hidden" name="action" value="list">
                        <select name="paidStatus" class="select-input">
                            <option value=""         <%= ps2.isEmpty()           ? "selected" : "" %>>-- Trạng thái --</option>
                            <option value="Chưa đóng" <%= "Chưa đóng".equals(ps2) ? "selected" : "" %>>Chưa đóng</option>
                            <option value="Đã đóng"   <%= "Đã đóng".equals(ps2)   ? "selected" : "" %>>Đã đóng</option>
                        </select>
                        <button class="search-btn" type="submit">🏷️ Lọc</button>
                    </form>
                    <% if (!ps2.isEmpty()) { %>
                        <a href="<%= ctx %>/fines?action=list" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa lọc</a>
                    <% } %>
                </div>
            </div>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>💰 Danh sách Phạt</h3>
                    </div>
                    <div style="display:flex;gap:10px">
                        <a href="<%= ctx %>/fines?action=add" class="btn-add">➕ Tạo phiếu phạt</a>
                        <a href="<%= ctx %>/fines?action=stats" class="btn-stats">📊 Thống kê</a>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Mã phạt</th>
                            <th>Thành viên</th>
                            <th>Mã phiếu mượn</th>
                            <th>Lý do</th>
                            <th style="text-align:right;">Số tiền</th>
                            <th>Ngày lập</th>
                            <th>Ngày đóng</th>
                            <th style="text-align:center;">Trạng thái</th>
                            <th style="text-align:center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Fine> fines = (List<Fine>) request.getAttribute("fines");
                            if (fines == null || fines.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="9">
                                <div class="empty-state">
                                    <div class="icon">💰</div>
                                    <p>Không có phiếu phạt nào.</p>
                                </div>
                            </td>
                        </tr>
                        <%
                            } else {
                                for (Fine f : fines) {
                                    boolean unpaid = "Chưa đóng".equals(f.getPaidStatus());
                        %>
                        <tr class="<%= unpaid ? "unpaid" : "" %>">
                            <td style="color:#888;">#<%= f.getFineID() %></td>
                            <td><strong><%= f.getMemberName() %></strong></td>
                            <td style="color:#888;">#<%= f.getTransactionID() %></td>
                            <td><%= f.getReason() %></td>
                            <td class="amount-cell" style="text-align:right;">
                                <%= String.format("%,.0f", f.getAmount()).replace(",", ".") %> đ
                            </td>
                            <td><%= f.getIssueDate() %></td>
                            <td><%= f.getPaidDate() != null ? f.getPaidDate() : "—" %></td>
                            <td style="text-align:center;">
                                <span class="badge <%= unpaid ? "badge-unpaid" : "badge-paid" %>">
                                    <%= f.getPaidStatus() %>
                                </span>
                            </td>
                            <td style="text-align:center;">
                                <% if (unpaid) { %>
                                <a href="<%= ctx %>/fines?action=paid&id=<%= f.getFineID() %>"
                                   class="paid-btn"
                                   onclick="return confirm('Xác nhận đã thu tiền phạt?')">Thu tiền</a>
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
                    String paidStatus = (String) request.getAttribute("paidStatus");
                    String pageUrl = ctx + "/fines?action=list";
                    if (keyword != null && !keyword.isEmpty()) pageUrl += "&keyword=" + keyword;
                    if (paidStatus != null && !paidStatus.isEmpty()) pageUrl += "&paidStatus=" + paidStatus;
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
