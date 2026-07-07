<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${formTitle} – Library System</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <style>
            body {
                background: #f5f7fa;
            }
            .form-card {
                max-width: 700px;
                margin: 2rem auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,.09);
                overflow: hidden;
            }
            .form-header {
                background: linear-gradient(135deg, #1e3c72, #2a5298);
                color: white;
                padding: 1.4rem 2rem;
            }
            .form-body {
                padding: 2rem;
            }
            .form-label {
                font-weight: 600;
                font-size: .9rem;
                color: #374151;
            }
            .form-control:focus {
                border-color: #2a5298;
                box-shadow: 0 0 0 3px rgba(42,82,152,.15);
            }
            .section-label {
                font-size: .75rem;
                text-transform: uppercase;
                letter-spacing: .08em;
                color: #9ca3af;
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: .3rem;
                margin-bottom: 1rem;
            }
        </style>
    </head>
    <body>

        <%-- <jsp:include page="header.jsp" /> --%>

        <div class="form-card">

            <%-- ── Header form ── --%>
            <div class="form-header">
                <h4 class="mb-0">
                    <i class="bi bi-${empty book ? 'plus-circle' : 'pencil-square'} me-2"></i>
                    ${formTitle}
                </h4>
            </div>

            <div class="form-body">

                <form action="books" method="post" novalidate id="bookForm">

                    <%-- ID ẩn khi edit --%>
                    <c:if test="${not empty book}">
                        <input type="hidden" name="id" value="${book.id}">
                    </c:if>

                    <%-- ── Thông tin cơ bản ── --%>
                    <p class="section-label">Thông Tin Cơ Bản</p>

                    <div class="mb-3">
                        <label class="form-label">Tên Sách <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required maxlength="200"
                               placeholder="Nhập tên sách…"
                               value="${not empty book ? book.title : ''}">
                        <div class="invalid-feedback">Vui lòng nhập tên sách.</div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Tác Giả <span class="text-danger">*</span></label>
                            <input type="text" name="author" class="form-control" required maxlength="100"
                                   placeholder="Tên tác giả…"
                                   value="${not empty book ? book.author : ''}">
                            <div class="invalid-feedback">Vui lòng nhập tác giả.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Thể Loại</label>
                            <c:set var="cat" value="${not empty book ? book.category : ''}"/>
                            <select name="category" class="form-select">
                                <option value="" disabled ${empty cat ? 'selected' : ''}>-- Chọn thể loại --</option>
                                <option value="Khoa học"  ${cat == 'Khoa học'  ? 'selected' : ''}>Khoa học</option>
                                <option value="Văn học"   ${cat == 'Văn học'   ? 'selected' : ''}>Văn học</option>
                                <option value="Lịch sử"   ${cat == 'Lịch sử'   ? 'selected' : ''}>Lịch sử</option>
                                <option value="Kỹ thuật"  ${cat == 'Kỹ thuật'  ? 'selected' : ''}>Kỹ thuật</option>
                                <option value="Kinh tế"   ${cat == 'Kinh tế'   ? 'selected' : ''}>Kinh tế</option>
                                <option value="Ngoại ngữ" ${cat == 'Ngoại ngữ' ? 'selected' : ''}>Ngoại ngữ</option>
                                <option value="Khác"      ${cat == 'Khác'      ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>

                    <%-- ── Thông tin xuất bản ── --%>
                    <p class="section-label mt-4">Thông Tin Xuất Bản</p>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">ISBN</label>
                            <input type="text" name="isbn" class="form-control" maxlength="20"
                                   placeholder="978-xxx-xxx-xxx-x"
                                   value="${not empty book ? book.isbn : ''}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Năm Xuất Bản</label>
                            <input type="number" name="publishYear" class="form-control"
                                   min="1900" max="2099" placeholder="VD: 2023"
                                   value="${not empty book ? book.publishYear : ''}">
                        </div>
                    </div>

                    <%-- ── Số lượng ── --%>
                    <p class="section-label mt-4">Số Lượng</p>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Tổng Số Lượng <span class="text-danger">*</span></label>
                            <input type="number" name="quantity" id="quantity" class="form-control"
                                   min="0" required placeholder="0"
                                   value="${not empty book ? book.quantity : ''}">
                            <div class="invalid-feedback">Vui lòng nhập số lượng hợp lệ.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số Lượng Còn Lại</label>
                            <input type="number" name="available" id="available" class="form-control"
                                   min="0" placeholder="0"
                                   value="${not empty book ? book.available : ''}">
                            <small class="text-muted">Không được vượt quá Tổng số lượng.</small>
                        </div>
                    </div>

                    <%-- ── Nút hành động ── --%>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-floppy-fill me-2"></i>
                            ${empty book ? 'Thêm Sách' : 'Lưu Thay Đổi'}
                        </button>
                        <a href="books" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left me-1"></i>Quay Lại
                        </a>
                    </div>

                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Bootstrap validation
            document.getElementById('bookForm').addEventListener('submit', function (e) {
                if (!this.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                this.classList.add('was-validated');
            });

            // Auto-fill available = quantity khi thêm mới
            const qtyInput = document.getElementById('quantity');
            const availInput = document.getElementById('available');

            qtyInput.addEventListener('input', function () {
                const q = parseInt(this.value) || 0;
                const a = parseInt(availInput.value) || 0;
                if (a > q)
                    availInput.value = q;   // đảm bảo available ≤ quantity
            });
        </script>
    </body>
</html>
