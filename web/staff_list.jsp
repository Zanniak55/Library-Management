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
    request.setAttribute("pageTitle", "Quản lý Nhân sự - Thư viện");
    request.setAttribute("activePage", "staffs");
%>
<jsp:include page="/includes/header.jsp" />

            <!-- ALERTS -->
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success">✅ ${successMsg}</div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">⚠️ ${errorMsg}</div>
            </c:if>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>👤 Danh sách Nhân sự</h3>
                        <c:if test="${not empty staffList}">
                            <span class="count-badge">${staffList.size()} nhân viên</span>
                        </c:if>
                    </div>
                    <div>
                        <a href="<%= ctx %>/staffs?action=add" class="btn-add">➕ Thêm Nhân sự</a>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th style="text-align:center;">Vai trò</th>
                            <th style="text-align:center;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty staffList}">
                                <c:forEach var="s" items="${staffList}" varStatus="idx">
                                    <tr>
                                        <td style="color:#94a3b8;">${(currentPage - 1) * 10 + idx.index + 1}</td>
                                        <td><strong>${s.fullName}</strong></td>
                                        <td>
                                            <c:if test="${not empty s.email}">
                                                <a href="mailto:${s.email}" style="color:var(--primary);text-decoration:none;">${s.email}</a>
                                            </c:if>
                                        </td>
                                        <td style="text-align:center;">
                                            <span class="badge ${s.role == 'Admin' ? 'badge-admin' : 'badge-staff'}">
                                                ${s.role}
                                            </span>
                                        </td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="<%= ctx %>/staffs?action=edit&id=${s.staffID}" class="btn-edit">✏️ Sửa</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete"
                                               onclick="confirmDelete(${s.staffID}, '${s.fullName}'); return false;">🗑️ Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5">
                                        <div class="empty-state">
                                            <div class="icon">👤</div>
                                            <p>Chưa có nhân viên nào trong hệ thống.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:20px; margin-bottom:10px;">
                        <c:set var="pageUrl" value="${pageContext.request.contextPath}/staffs?action=list&page=" />

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

            </div>

    <!-- DELETE MODAL -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <h4>⚠️ Xác nhận xóa</h4>
            <p id="deleteModalText">Bạn có chắc muốn xóa nhân sự này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            document.getElementById('deleteModalText').textContent =
                'Xóa nhân sự "' + name + '"? Hành động này không thể hoàn tác!';
            document.getElementById('deleteConfirmLink').href = '<%= ctx %>/staffs?action=delete&id=' + id;
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
