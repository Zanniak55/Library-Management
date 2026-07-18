<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff, java.util.List"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Dashboard");
    request.setAttribute("activePage", "dashboard");
%>
<jsp:include page="/includes/header.jsp" />
<style>
/* PREMIUM DASHBOARD STYLES */
.welcome-banner {
    background: linear-gradient(135deg, rgba(255,255,255,0.8), rgba(255,255,255,0.4));
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.5);
    border-radius: 20px;
    padding: 32px 40px;
    margin-bottom: 32px;
    box-shadow: 0 10px 30px -10px rgba(0,0,0,0.05);
    position: relative;
    overflow: hidden;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.welcome-text h1 {
    font-size: 28px;
    font-weight: 800;
    color: #1e293b;
    margin-bottom: 8px;
    letter-spacing: -0.5px;
}
.welcome-text p {
    font-size: 15px;
    color: #64748b;
    font-weight: 500;
}
.welcome-illustration {
    font-size: 72px;
    opacity: 0.8;
    filter: drop-shadow(0 10px 10px rgba(0,0,0,0.1));
    animation: float 3s ease-in-out infinite;
}
@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.premium-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}
.stat-card {
    border-radius: 20px;
    padding: 24px;
    color: white;
    position: relative;
    overflow: hidden;
    box-shadow: 0 10px 20px -5px rgba(0,0,0,0.1);
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-height: 140px;
}
.stat-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 20px 30px -10px rgba(0,0,0,0.2);
}
.stat-card::before {
    content: '';
    position: absolute;
    top: -50%; right: -50%;
    width: 200%; height: 200%;
    background: radial-gradient(circle, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 70%);
    transform: scale(0.5);
    transition: transform 0.6s ease-out;
    pointer-events: none;
}
.stat-card:hover::before {
    transform: scale(1);
}
.stat-icon {
    position: absolute;
    right: 20px;
    bottom: 10px;
    font-size: 64px;
    opacity: 0.15;
    transform: rotate(-15deg);
    transition: all 0.4s ease;
}
.stat-card:hover .stat-icon {
    transform: rotate(0deg) scale(1.2);
    opacity: 0.25;
}
.stat-value {
    font-size: 42px;
    font-weight: 800;
    line-height: 1;
    margin-bottom: 8px;
    text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
.stat-label {
    font-size: 14px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 1px;
    opacity: 0.9;
}

.section-title {
    font-size: 18px;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.section-title::before {
    content: '';
    display: block;
    width: 4px;
    height: 20px;
    background: var(--primary);
    border-radius: 4px;
}

.action-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    margin-bottom: 32px;
}
.action-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    display: flex;
    align-items: center;
    gap: 20px;
    text-decoration: none;
    color: #1e293b;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
    transition: all 0.3s ease;
    border: 1px solid #f1f5f9;
}
.action-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 20px -8px rgba(0,0,0,0.1);
    border-color: var(--primary);
}
.action-icon {
    width: 56px;
    height: 56px;
    border-radius: 16px;
    background: #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    transition: all 0.3s ease;
}
.action-card:hover .action-icon {
    background: var(--primary);
    color: white;
}
.action-content h4 {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 4px;
}
.action-content p {
    font-size: 13px;
    color: #64748b;
}

/* Charts and Rankings */
.data-row {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
}
@media(max-width: 1024px) { .data-row { grid-template-columns: 1fr; } }
.data-card {
    background: white;
    border-radius: 20px;
    padding: 28px;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
}
.bar-chart-modern {
    display: flex;
    align-items: flex-end;
    gap: 12px;
    height: 200px;
    padding-top: 20px;
    border-bottom: 2px solid #f1f5f9;
}
.bar-wrap {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-end;
    height: 100%;
    group: hover;
}
.bar {
    width: 100%;
    max-width: 40px;
    background: var(--card-1);
    border-radius: 8px 8px 0 0;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    cursor: pointer;
}
.bar:hover {
    filter: brightness(1.1);
    transform: scaleY(1.02);
}
.bar-tooltip {
    position: absolute;
    top: -35px;
    left: 50%;
    transform: translateX(-50%);
    background: #1e293b;
    color: white;
    padding: 4px 8px;
    border-radius: 6px;
    font-size: 12px;
    font-weight: 600;
    opacity: 0;
    transition: all 0.2s ease;
    pointer-events: none;
    white-space: nowrap;
}
.bar:hover .bar-tooltip {
    opacity: 1;
    top: -40px;
}
.bar-label {
    font-size: 12px;
    color: #64748b;
    font-weight: 500;
    margin-top: 12px;
}
.rank-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}
.rank-item {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 12px;
    border-radius: 12px;
    transition: background 0.2s;
}
.rank-item:hover {
    background: #f8fafc;
}
.rank-medal {
    font-size: 24px;
    width: 32px;
    text-align: center;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
}
.rank-info {
    flex: 1;
}
.rank-title {
    font-weight: 600;
    color: #1e293b;
    font-size: 14px;
    margin-bottom: 6px;
}
.progress-bg {
    height: 6px;
    background: #f1f5f9;
    border-radius: 10px;
    overflow: hidden;
}
.progress-fill {
    height: 100%;
    background: var(--card-2);
    border-radius: 10px;
    transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
}
.rank-score {
    font-weight: 700;
    color: #475569;
    font-size: 14px;
}
</style>

<%
    List<String[]> monthlyBorrows = (List<String[]>) request.getAttribute("monthlyBorrows");
    List<String[]> topBooks       = (List<String[]>) request.getAttribute("topBooks");
    int maxBorrow = 1;
    if (monthlyBorrows != null) {
        for (String[] row : monthlyBorrows) {
            int v = Integer.parseInt(row[1]);
            if (v > maxBorrow) maxBorrow = v;
        }
    }
    int topMax = 1;
    if (topBooks != null && !topBooks.isEmpty()) {
        topMax = Integer.parseInt(topBooks.get(0)[1]);
    }
%>

<% if (isAdmin) { %>
    <!-- ADMIN DASHBOARD -->
    <div class="welcome-banner">
        <div class="welcome-text">
            <h1>Chào mừng trở lại, <%= staff.getFullName() %>! 👋</h1>
            <p>Bảng điều khiển Tổng Quan Hệ Thống dành cho Quản Trị Viên.</p>
        </div>
        <div class="welcome-illustration">👑</div>
    </div>

    <div class="premium-grid">
        <div class="stat-card" style="background: var(--card-1);">
            <div>
                <div class="stat-value">${totalMembers}</div>
                <div class="stat-label">Tổng thành viên</div>
            </div>
            <div class="stat-icon">👥</div>
        </div>
        <div class="stat-card" style="background: var(--card-2);">
            <div>
                <div class="stat-value">${activeMembers}</div>
                <div class="stat-label">Thành viên hoạt động</div>
            </div>
            <div class="stat-icon">✅</div>
        </div>
        <div class="stat-card" style="background: var(--card-3);">
            <div>
                <div class="stat-value">${totalStaff}</div>
                <div class="stat-label">Tổng nhân viên</div>
            </div>
            <div class="stat-icon">👤</div>
        </div>
    </div>

    <div class="section-title">Quản lý Hệ Thống</div>
    <div class="action-grid">
        <a href="<%= ctx %>/staffs" class="action-card">
            <div class="action-icon">👔</div>
            <div class="action-content">
                <h4>Quản lý Nhân sự</h4>
                <p>Thêm, sửa, xóa, phân quyền nhân viên.</p>
            </div>
        </a>
        <a href="<%= ctx %>/members" class="action-card">
            <div class="action-icon">👥</div>
            <div class="action-content">
                <h4>Quản lý Thành viên</h4>
                <p>Kiểm soát danh sách độc giả toàn hệ thống.</p>
            </div>
        </a>
        <a href="<%= ctx %>/publishers" class="action-card">
            <div class="action-icon">🏢</div>
            <div class="action-content">
                <h4>Nhà xuất bản</h4>
                <p>Quản lý dữ liệu đối tác xuất bản.</p>
            </div>
        </a>
    </div>

<% } else { %>
    <!-- LIBRARIAN DASHBOARD -->
    <div class="welcome-banner">
        <div class="welcome-text">
            <h1>Xin chào, Thủ thư <%= staff.getFullName() %>! ✨</h1>
            <p>Bảng điều khiển Hoạt Động Thư Viện hằng ngày.</p>
        </div>
        <div class="welcome-illustration">📚</div>
    </div>

    <div class="premium-grid">
        <div class="stat-card" style="background: var(--card-4);">
            <div>
                <div class="stat-value">${totalBooks}</div>
                <div class="stat-label">Đầu sách trong kho</div>
            </div>
            <div class="stat-icon">📖</div>
        </div>
        <div class="stat-card" style="background: var(--card-5);">
            <div>
                <div class="stat-value">${borrowingNow}</div>
                <div class="stat-label">Sách đang cho mượn</div>
            </div>
            <div class="stat-icon">📤</div>
        </div>
        <div class="stat-card" style="background: var(--card-1);">
            <div>
                <div class="stat-value">${activeMembers}</div>
                <div class="stat-label">Độc giả hoạt động</div>
            </div>
            <div class="stat-icon">🎯</div>
        </div>
    </div>

    <div class="section-title">Nghiệp vụ hằng ngày</div>
    <div class="action-grid">
        <a href="<%= ctx %>/loan?action=borrow" class="action-card">
            <div class="action-icon">📝</div>
            <div class="action-content">
                <h4>Tạo phiếu mượn mới</h4>
                <p>Ghi nhận độc giả mượn sách.</p>
            </div>
        </a>
        <a href="<%= ctx %>/loan?action=list" class="action-card">
            <div class="action-icon">📋</div>
            <div class="action-content">
                <h4>Quản lý Mượn/Trả</h4>
                <p>Theo dõi hạn trả và thu hồi sách.</p>
            </div>
        </a>
        <a href="<%= ctx %>/fines?action=list" class="action-card">
            <div class="action-icon">💰</div>
            <div class="action-content">
                <h4>Xử lý Phạt</h4>
                <p>Quản lý các khoản phạt quá hạn.</p>
            </div>
        </a>
    </div>
<% } %>

    <div class="section-title">Thống kê Vận Hành</div>
    <div class="data-row">
        <div class="data-card">
            <h3 style="font-size:16px; font-weight:700; color:#1e293b; margin-bottom:16px;">📈 Số phiếu mượn (6 tháng qua)</h3>
            <div class="bar-chart-modern">
                <% if (monthlyBorrows == null || monthlyBorrows.isEmpty()) { %>
                <div style="width:100%;text-align:center;color:#94a3b8;padding:40px 0;">Chưa có dữ liệu</div>
                <% } else { for (String[] row : monthlyBorrows) {
                    int h = (int)((double) Integer.parseInt(row[1]) / maxBorrow * 160); %>
                <div class="bar-wrap">
                    <div class="bar" style="height:<%= Math.max(h, 4) %>px">
                        <div class="bar-tooltip"><%= row[1] %> phiếu</div>
                    </div>
                    <div class="bar-label"><%= row[0] %></div>
                </div>
                <% }} %>
            </div>
        </div>

        <div class="data-card">
            <h3 style="font-size:16px; font-weight:700; color:#1e293b; margin-bottom:24px;">🏆 Top sách yêu thích</h3>
            <% if (topBooks == null || topBooks.isEmpty()) { %>
            <div style="text-align:center;color:#94a3b8;padding:20px 0;">Chưa có dữ liệu</div>
            <% } else {
                String[] medals = {"🥇","🥈","🥉","4️⃣","5️⃣"};
                out.print("<div class=\"rank-list\">");
                for (int i = 0; i < topBooks.size(); i++) {
                    String[] b = topBooks.get(i);
                    int pct = (int)((double) Integer.parseInt(b[1]) / topMax * 100); %>
            <div class="rank-item">
                <div class="rank-medal"><%= medals[i] %></div>
                <div class="rank-info">
                    <div class="rank-title"><%= b[0] %></div>
                    <div class="progress-bg">
                        <div class="progress-fill" style="width:<%= pct %>%"></div>
                    </div>
                </div>
                <div class="rank-score"><%= b[1] %> lần</div>
            </div>
            <% } out.print("</div>"); } %>
        </div>
    </div>

<jsp:include page="/includes/footer.jsp" />
