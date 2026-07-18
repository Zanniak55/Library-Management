<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Staff" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Quản lý Thành viên - Thư viện");
    request.setAttribute("activePage", "members");
%>
<jsp:include page="/includes/header.jsp" />

            <!-- ALERTS -->
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success">✅ ${successMsg}</div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">⚠️ ${errorMsg}</div>
            </c:if>

            <!-- TOOLBAR -->
            <div class="toolbar">
                <div class="toolbar-left">
                    <form method="get" action="<%= ctx %>/members" class="search-group">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Tìm tên, email, username..."
                               value="${not empty keyword ? keyword : ''}">
                        <button type="submit" class="search-btn">🔍 Tìm</button>
                    </form>
                    <c:if test="${not empty keyword}">
                        <a href="<%= ctx %>/members" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa lọc</a>
                    </c:if>
                </div>
                <a href="<%= ctx %>/members?action=add" class="btn-add">➕ Thêm thành viên</a>
            </div>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>📋 Danh sách thành viên</h3>
                        <c:if test="${not empty memberList}">
                            <span class="count-badge">${memberList.size()} thành viên</span>
                        </c:if>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th>Điện thoại</th>
                            <th>Loại thành viên</th>
                            <th>Ngày đăng ký</th>
                            <th>Username</th>
                            <th>Trạng thái</th>
                            <th style="text-align:center;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty memberList}">
                                <c:forEach var="m" items="${memberList}" varStatus="idx">
                                    <tr>
                                        <td style="color:#94a3b8;">${(currentPage - 1) * 10 + idx.index + 1}</td>
                                        <td><strong>${m.fullName}</strong></td>
                                        <td>
                                            <c:if test="${not empty m.email}">
                                                <a href="mailto:${m.email}" style="color:var(--primary);text-decoration:none;">${m.email}</a>
                                            </c:if>
                                        </td>
                                        <td>${m.phone}</td>
                                        <td><span class="badge badge-type">${m.memberType}</span></td>
                                        <td>${m.membershipDate}</td>
                                        <td style="color:#94a3b8;">
                                            <c:choose>
                                                <c:when test="${not empty m.username}">@${m.username}</c:when>
                                                <c:otherwise><span style="color:#cbd5e1;">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.status == 'Hoạt động'}">
                                                    <span class="badge badge-active">● Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-locked">● ${m.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="<%= ctx %>/members?action=edit&id=${m.memberID}" class="btn-edit">✏️ Sửa</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete"
                                               onclick="confirmDelete(${m.memberID}, '${m.fullName}'); return false;">🗑️ Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <div class="icon">👤</div>
                                            <p>Không tìm thấy thành viên nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:20px; margin-bottom:10px;">
                        <c:choose>
                            <c:when test="${action == 'search'}">
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/members?action=search&keyword=${keyword}&page=" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/members?action=list&page=" />
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${currentPage > 1}">
                            <a href="${pageUrl}${currentPage - 1}" class="page-btn" style="padding:6px 12px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#475569;">Trước</a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageUrl}${i}" class="page-btn" style="padding:6px 12px; border:1px solid ${currentPage == i ? 'var(--primary)' : '#cbd5e1'}; border-radius:6px; text-decoration:none; color:${currentPage == i ? '#fff' : '#475569'}; background:${currentPage == i ? 'var(--primary)' : '#fff'}; font-weight:${currentPage == i ? 'bold' : 'normal'};">${i}</a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageUrl}${currentPage + 1}" class="page-btn" style="padding:6px 12px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#475569;">Sau</a>
                        </c:if>
                    </div>
                </c:if>
                <c:if test="${not empty memberList}">
                    <div class="table-footer" style="padding:16px 24px; border-top:1px solid #f1f5f9; color:#64748b; font-size:13px;">
                        Hiển thị trang <strong>${currentPage}</strong> / ${totalPages}
                        <c:if test="${not empty keyword}"> — kết quả tìm kiếm cho "<em>${keyword}</em>"</c:if>
                    </div>
                </c:if>
            </div>

    <!-- DELETE MODAL -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <h4>⚠️ Xác nhận xóa</h4>
            <p id="deleteModalText">Bạn có chắc muốn xóa thành viên này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            document.getElementById('deleteModalText').textContent =
                'Xóa thành viên "' + name + '"? Hành động này không thể hoàn tác!';
            document.getElementById('deleteConfirmLink').href = '<%= ctx %>/members?action=delete&id=' + id;
            document.getElementById('deleteModal').classList.add('show');
        }
        function closeModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
    </script>
<jsp:include page="/includes/footer.jsp" />
