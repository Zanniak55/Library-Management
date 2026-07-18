<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Fine, java.util.List"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("pageTitle", "Lịch sử nộp phạt");
    request.setAttribute("activePage", "fines");
%>
<jsp:include page="/includes/user_header.jsp" />

<div class="table-card" style="background:white; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); overflow:hidden;">
    <div style="padding:20px; border-bottom:1px solid #e2e8f0;">
        <h3 style="margin:0; color:#1e293b; font-size:18px;">💰 Biên bản phạt của tôi</h3>
    </div>
    <table style="width:100%; border-collapse:collapse; text-align:left;">
        <thead>
            <tr style="background:#f8fafc; border-bottom:1px solid #e2e8f0; color:#475569; font-size:13px; text-transform:uppercase;">
                <th style="padding:16px;">Mã phạt</th>
                <th style="padding:16px;">Mã phiếu mượn</th>
                <th style="padding:16px;">Lý do phạt</th>
                <th style="padding:16px;">Số tiền</th>
                <th style="padding:16px;">Trạng thái</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Fine> fines = (List<Fine>) request.getAttribute("fines");
                if (fines != null && !fines.isEmpty()) {
                    for (Fine f : fines) {
                        String status = f.getPaidStatus();
            %>
                        <tr style="border-bottom:1px solid #f1f5f9;">
                            <td style="padding:16px; font-weight:600; color:#1e293b;">#<%= String.format("%04d", f.getFineID()) %></td>
                            <td style="padding:16px; color:#475569;">
                                <a href="${pageContext.request.contextPath}/user/loans?action=detail&id=<%= f.getTransactionID() %>" style="color:var(--primary); text-decoration:none;">
                                    #<%= String.format("%05d", f.getTransactionID()) %>
                                </a>
                            </td>
                            <td style="padding:16px; color:#475569;"><%= f.getReason() %></td>
                            <td style="padding:16px; font-weight:600; color:#ef4444;">
                                <fmt:formatNumber value="<%= f.getAmount() %>" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                            <td style="padding:16px;">
                                <% if ("Đã đóng".equals(status)) { %>
                                    <span style="background:#dcfce7; color:#166534; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Đã đóng</span>
                                <% } else { %>
                                    <span style="background:#fee2e2; color:#991b1b; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Chưa đóng</span>
                                <% } %>
                            </td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="5" style="padding:40px; text-align:center; color:#64748b;">
                            <div style="font-size:48px; margin-bottom:16px;">✨</div>
                            <div>Tuyệt vời! Bạn không có biên bản phạt nào.</div>
                        </td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/user_footer.jsp" />
