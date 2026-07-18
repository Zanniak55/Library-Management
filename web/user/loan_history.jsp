<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Transaction, java.util.List"%>
<%
    request.setAttribute("pageTitle", "Lịch sử mượn sách");
    request.setAttribute("activePage", "loans");
%>
<jsp:include page="/includes/user_header.jsp" />

<div class="table-card" style="background:white; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); overflow:hidden;">
    <div style="padding:20px; border-bottom:1px solid #e2e8f0;">
        <h3 style="margin:0; color:#1e293b; font-size:18px;">📋 Biên bản mượn sách của tôi</h3>
    </div>
    <table style="width:100%; border-collapse:collapse; text-align:left;">
        <thead>
            <tr style="background:#f8fafc; border-bottom:1px solid #e2e8f0; color:#475569; font-size:13px; text-transform:uppercase;">
                <th style="padding:16px;">Mã phiếu</th>
                <th style="padding:16px;">Tên sách</th>
                <th style="padding:16px;">Ngày mượn</th>
                <th style="padding:16px;">Hạn trả</th>
                <th style="padding:16px;">Ngày trả</th>
                <th style="padding:16px;">Trạng thái</th>
                <th style="padding:16px; text-align:center;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
                if (transactions != null && !transactions.isEmpty()) {
                    for (Transaction tr : transactions) {
                        String status = tr.getStatus();
                        String badgeClass = "";
                        String badgeBg = "";
                        String badgeColor = "";
                        if ("Đang mượn".equals(status)) {
                            badgeBg = "#eff6ff"; badgeColor = "#1d4ed8";
                        } else if ("Đã trả".equals(status)) {
                            badgeBg = "#dcfce7"; badgeColor = "#166534";
                        } else if ("Quá hạn".equals(status)) {
                            badgeBg = "#fee2e2"; badgeColor = "#991b1b";
                        }
            %>
                        <tr style="border-bottom:1px solid #f1f5f9;">
                            <td style="padding:16px; font-weight:600; color:#1e293b;">#<%= String.format("%05d", tr.getTransactionID()) %></td>
                            <td style="padding:16px; color:#1e293b;"><%= tr.getBookTitles() != null ? tr.getBookTitles() : "" %></td>
                            <td style="padding:16px; color:#475569;"><%= tr.getBorrowDate() %></td>
                            <td style="padding:16px; color:#475569;"><%= tr.getDueDate() %></td>
                            <td style="padding:16px; color:#475569;">
                                <%= tr.getReturnDate() != null ? tr.getReturnDate() : "<span style='color:#cbd5e1'>—</span>" %>
                            </td>
                            <td style="padding:16px;">
                                <span style="background:<%= badgeBg %>; color:<%= badgeColor %>; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;"><%= status %></span>
                            </td>
                            <td style="padding:16px; text-align:center;">
                                <a href="${pageContext.request.contextPath}/user/loans?action=detail&id=<%= tr.getTransactionID() %>" 
                                   style="display:inline-block; padding:6px 12px; background:#f8fafc; color:#475569; text-decoration:none; border-radius:6px; font-size:13px; font-weight:500; border:1px solid #e2e8f0; transition:all 0.2s;">
                                    👀 Chi tiết
                                </a>
                            </td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="6" style="padding:40px; text-align:center; color:#64748b;">
                            <div style="font-size:48px; margin-bottom:16px;">📋</div>
                            <div>Bạn chưa mượn cuốn sách nào.</div>
                        </td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/user_footer.jsp" />
