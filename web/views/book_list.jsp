<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Sách</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <style>
            body {
                background: #f5f7fa;
            }
            .page-header {
                background: linear-gradient(135deg, #1e3c72, #2a5298);
                color: white;
                padding: 1.5rem 2rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }
            .table-card {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 12px rgba(0,0,0,.08);
            }
            .table thead {
                background: #1e3c72;
                color: #fff;
            }
            .badge-avail   {
                background: #d1fae5;
                color: #065f46;
            }
            .badge-noavail {
                background: #fee2e2;
                color: #991b1b;
            }
        </style>
    </head>
    <body>
        <div class="container py-4">

            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-0"><i class="bi bi-book-half me-2"></i>Quản Lý Sách</h2>
                    <small class="opacity-75">Library Management System</small>
                </div>
                <a href="books?action=new" class="btn btn-warning fw-semibold">
                    <i class="bi bi-plus-lg me-1"></i>Thêm Sách
                </a>
            </div>

            <%-- Thông báo --%>
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-circle-fill me-2"></i>${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <%-- Tìm kiếm --%>
            <form action="books" method="get" class="mb-3 d-flex gap-2">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="form-control"
                       placeholder="Tìm theo tên sách, tác giả, ISBN…"
                       value="${not empty keyword ? keyword : ''}">
                <button class="btn btn-primary px-4"><i class="bi bi-search"></i></button>
                    <c:if test="${not empty keyword}">
                    <a href="books" class="btn btn-outline-secondary">Xóa lọc</a>
                </c:if>
            </form>

            <%-- Bảng danh sách --%>
            <div class="table-card">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>ISBN</th>
                            <th>Tên Sách</th>
                            <th>Tác Giả</th>
                            <th>Thể Loại</th>
                            <th>NXB</th>
                            <th>Năm XB</th>
                            <th class="text-center">SL</th>
                            <th class="text-center">Còn Lại</th>
                            <th class="text-center">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty books}">
                                <tr>
                                    <td colspan="10" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                        Không có sách nào.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="b" items="${books}" varStatus="st">
                                    <tr>
                                        <td class="text-muted">${st.index + 1}</td>
                                        <td><code>${b.isbn}</code></td>
                                        <td class="fw-semibold">${b.title}</td>
                                        <td>${not empty b.authors ? b.authors : '—'}</td>
                                        <td><span class="badge bg-secondary bg-opacity-10 text-dark">${b.categoryName}</span></td>
                                        <td>${b.publisherName}</td>
                                        <td>${b.publicationYear}</td>
                                        <td class="text-center">${b.totalQuantity}</td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill px-3 py-1
                                                  ${b.availableQuantity > 0 ? 'badge-avail' : 'badge-noavail'}">
                                                ${b.availableQuantity}
                                            </span>
                                        </td>
                                        <td class="text-center" style="white-space:nowrap">
                                            <a href="books?action=edit&isbn=${b.isbn}"
                                               class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                                <i class="bi bi-pencil-fill"></i>
                                            </a>
                                            <a href="books?action=delete&isbn=${b.isbn}"
                                               class="btn btn-sm btn-outline-danger" title="Xóa"
                                               onclick="return confirm('Xóa sách «${b.title}»?')">
                                                <i class="bi bi-trash-fill"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <p class="text-muted mt-2 small">Tổng cộng: <strong>${books.size()}</strong> sách</p>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

