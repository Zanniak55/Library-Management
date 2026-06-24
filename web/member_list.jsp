<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thành viên – Thư viện</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #4f46e5; --primary-h: #4338ca;
            --accent: #06b6d4;
            --bg-body: #0f172a; --bg-card: #1e293b;
            --text-main: #f1f5f9; --text-muted: #94a3b8;
            --border: #334155;
            --success: #22c55e; --danger: #ef4444; --warning: #f59e0b;
            --radius: .75rem;
        }
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Segoe UI', system-ui, sans-serif; background: var(--bg-body); color: var(--text-main); min-height: 100vh; margin: 0; }

        .page-wrapper { max-width: 1250px; margin: 2rem auto; padding: 0 1.25rem; }
        .page-title { font-size: 1.6rem; font-weight: 700; margin-bottom: 1.5rem; display: flex; align-items: center; gap: .6rem; }
        .page-title i { color: var(--accent); }

        .alert-custom { border-radius: var(--radius); padding: .85rem 1.2rem; margin-bottom: 1.2rem; font-size: .92rem; display: flex; align-items: center; gap: .6rem; }
        .alert-success-custom { background: rgba(34,197,94,.12); border: 1px solid var(--success); color: var(--success); }
        .alert-danger-custom  { background: rgba(239,68,68,.12);  border: 1px solid var(--danger);  color: var(--danger);  }

        .toolbar { display: flex; gap: .75rem; margin-bottom: 1.4rem; flex-wrap: wrap; align-items: center; }
        .search-group { display: flex; flex: 1; min-width: 240px; max-width: 440px; }
        .search-input { background: var(--bg-card); border: 1px solid var(--border); color: var(--text-main); border-radius: .55rem 0 0 .55rem; padding: .55rem 1rem; flex: 1; outline: none; transition: border-color .2s; }
        .search-input:focus { border-color: var(--primary); }
        .search-input::placeholder { color: var(--text-muted); }
        .search-btn { background: var(--primary); border: none; color: #fff; padding: .55rem 1rem; border-radius: 0 .55rem .55rem 0; cursor: pointer; transition: background .2s; }
        .search-btn:hover { background: var(--primary-h); }
        .btn-add { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; border: none; border-radius: .55rem; padding: .55rem 1.2rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: .4rem; text-decoration: none; font-size: .92rem; transition: opacity .2s, transform .15s; }
        .btn-add:hover { opacity: .88; transform: translateY(-1px); color: #fff; }

        .card-table { background: var(--bg-card); border-radius: var(--radius); overflow: hidden; box-shadow: 0 4px 24px rgba(0,0,0,.35); }
        .lib-table { width: 100%; border-collapse: collapse; font-size: .88rem; }
        .lib-table thead { background: linear-gradient(90deg, var(--primary) 0%, var(--accent) 100%); }
        .lib-table thead th { color: #fff; padding: .85rem 1rem; text-align: left; font-weight: 600; white-space: nowrap; }
        .lib-table tbody tr { border-bottom: 1px solid var(--border); transition: background .18s; }
        .lib-table tbody tr:last-child { border-bottom: none; }
        .lib-table tbody tr:hover { background: rgba(255,255,255,.04); }
        .lib-table td { padding: .75rem 1rem; color: var(--text-main); vertical-align: middle; }

        .badge-pill { display: inline-block; padding: .22rem .65rem; border-radius: 999px; font-size: .75rem; font-weight: 600; }
        .badge-active   { background: rgba(34,197,94,.18); color: var(--success); }
        .badge-locked   { background: rgba(239,68,68,.18);  color: var(--danger);  }
        .badge-type     { background: rgba(79,70,229,.18); color: #a5b4fc; }

        .btn-action { display: inline-flex; align-items: center; gap: .3rem; padding: .28rem .65rem; border-radius: .4rem; font-size: .78rem; font-weight: 500; text-decoration: none; cursor: pointer; border: none; transition: opacity .18s, transform .12s; }
        .btn-action:hover { opacity: .82; transform: translateY(-1px); }
        .btn-edit   { background: rgba(79,70,229,.2); color: #a5b4fc; }
        .btn-delete { background: rgba(239,68,68,.15); color: #fca5a5; }

        .empty-state { text-align: center; padding: 3rem 1rem; color: var(--text-muted); }
        .empty-state i { font-size: 2.8rem; margin-bottom: .8rem; display: block; }

        footer { text-align: center; padding: 1.5rem; color: var(--text-muted); font-size: .82rem; margin-top: 3rem; }

        @media (max-width: 900px) {
            .lib-table thead th:nth-child(5),
            .lib-table td:nth-child(5) { display: none; }
        }
        @media (max-width: 640px) {
            .lib-table thead th:nth-child(6),
            .lib-table td:nth-child(6) { display: none; }
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="page-wrapper">

    <div class="page-title">
        <i class="bi bi-people-fill"></i> Quản lý Thành viên
    </div>

    <%-- Alert messages --%>
    <c:if test="${not empty successMsg}">
        <div class="alert-custom alert-success-custom">
            <i class="bi bi-check-circle-fill"></i> ${successMsg}
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert-custom alert-danger-custom">
            <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
        </div>
    </c:if>

    <%-- Toolbar --%>
    <div class="toolbar">
        <form method="get" action="MemberServlet" class="search-group" id="searchForm">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input"
                   id="searchInput"
                   placeholder="Tìm tên, email hoặc username…"
                   value="${not empty keyword ? keyword : ''}">
            <button type="submit" class="search-btn" id="btnSearch">
                <i class="bi bi-search"></i>
            </button>
        </form>
        <a href="MemberServlet?action=add" class="btn-add" id="btnAddMember">
            <i class="bi bi-person-plus-fill"></i> Thêm thành viên
        </a>
    </div>

    <%-- Table --%>
    <div class="card-table">
        <table class="lib-table">
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
                                <td style="color:var(--text-muted);">${idx.count}</td>
                                <td><strong>${m.fullName}</strong></td>
                                <td>
                                    <c:if test="${not empty m.email}">
                                        <a href="mailto:${m.email}" style="color:var(--accent);text-decoration:none;">${m.email}</a>
                                    </c:if>
                                </td>
                                <td>${m.phone}</td>
                                <td>
                                    <span class="badge-pill badge-type">${m.memberType}</span>
                                </td>
                                <td>${m.membershipDate}</td>
                                <td style="color:var(--text-muted);">
                                    <c:choose>
                                        <c:when test="${not empty m.username}">
                                            <i class="bi bi-person-circle"></i> ${m.username}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:var(--border);">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${m.status == 'Hoạt động'}">
                                            <span class="badge-pill badge-active">● Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-pill badge-locked">● ${m.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align:center; white-space:nowrap;">
                                    <a href="MemberServlet?action=edit&id=${m.memberID}"
                                       class="btn-action btn-edit"
                                       id="btnEdit-${m.memberID}">
                                        <i class="bi bi-pencil-fill"></i> Sửa
                                    </a>
                                    <a href="#"
                                       class="btn-action btn-delete"
                                       id="btnDelete-${m.memberID}"
                                       onclick="confirmDelete(${m.memberID},'${m.fullName}'); return false;">
                                        <i class="bi bi-trash-fill"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="9">
                            <div class="empty-state">
                                <i class="bi bi-person-x"></i>
                                Không tìm thấy thành viên nào.
                            </div>
                        </td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <c:if test="${not empty memberList}">
        <p style="color:var(--text-muted);font-size:.84rem;margin-top:.75rem;">
            Tổng <strong style="color:var(--text-main);">${memberList.size()}</strong> thành viên
            <c:if test="${action == 'search'}"> &nbsp;–&nbsp; từ khóa "<em>${keyword}</em>"</c:if>.
        </p>
    </c:if>
</div>

<footer>© 2024 Hệ thống Quản lý Thư viện – Member B</footer>

<%-- Delete Modal --%>
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background:var(--bg-card);color:var(--text-main);border:1px solid var(--border);">
            <div class="modal-header" style="border-color:var(--border);">
                <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill text-warning"></i> Xác nhận xóa</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="deleteModalBody">Bạn có chắc muốn xóa thành viên này?</div>
            <div class="modal-footer" style="border-color:var(--border);">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn btn-danger">
                    <i class="bi bi-trash-fill"></i> Xóa
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function confirmDelete(id, name) {
    document.getElementById('deleteModalBody').textContent =
        'Xóa thành viên "' + name + '"? Hành động này không thể hoàn tác!';
    document.getElementById('deleteConfirmLink').href = 'MemberServlet?action=delete&id=' + id;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
</body>
</html>
