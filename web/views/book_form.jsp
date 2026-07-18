<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${formTitle}</title>
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
            .section-label {
                font-size: .75rem;
                text-transform: uppercase;
                letter-spacing: .08em;
                color: #9ca3af;
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: .3rem;
                margin-bottom: 1rem;
            }
            /* Custom invalid style cho select */
            .form-select.is-invalid {
                border-color: #dc3545;
            }
            .form-select.is-invalid + .invalid-feedback {
                display: block;
            }
        </style>
    </head>
    <body>
        <div class="form-card">
            <div class="form-header">
                <h4 class="mb-0">
                    <i class="bi bi-${empty book ? 'plus-circle' : 'pencil-square'} me-2"></i>
                    ${formTitle}
                </h4>
            </div>
            <div class="form-body">

                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <form action="books" method="post" id="bookForm" novalidate>
                    <input type="hidden" name="actionType" value="${empty book ? 'add' : 'edit'}">

                    <%-- ── Thông Tin Cơ Bản ── --%>
                    <p class="section-label">Thông Tin Cơ Bản</p>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">ISBN</label>
                            <c:choose>
                                <c:when test="${not empty book}">
                                    <input type="text" name="isbn" class="form-control" value="${book.isbn}" readonly>
                                </c:when>
                                <c:otherwise>
                                    <div class="input-group">
                                        <input type="text" name="isbn" id="isbnField"
                                               class="form-control" required maxlength="20"
                                               placeholder="978-xxx-xxx-xxx-x">
                                        <button type="button" class="btn btn-outline-secondary"
                                                onclick="generateISBN()" title="Tạo ISBN mới">
                                            <i class="bi bi-arrow-clockwise"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Vui lòng nhập ISBN.</div>
                                    <small class="text-muted">Tự động tạo, hoặc nhấn 🔄 để tạo lại.</small>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Năm Xuất Bản <span class="text-danger">*</span></label>
                            <input type="number" name="publicationYear" id="publicationYear"
                                   class="form-control" required min="1000" max="2099"
                                   placeholder="VD: 2023"
                                   value="${not empty book ? book.publicationYear : ''}">
                            <div class="invalid-feedback">Vui lòng nhập năm xuất bản hợp lệ (1000–2099).</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tên Sách <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="titleField"
                               class="form-control" required maxlength="300"
                               placeholder="Nhập tên sách…"
                               value="${not empty book ? book.title : ''}">
                        <div id="titleFeedback" class="small mt-1"></div>
                        <div class="invalid-feedback">Vui lòng nhập tên sách.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tác Giả <span class="text-danger">*</span></label>
                        <input type="text" name="authorName" id="authorName"
                               class="form-control" required
                               placeholder="Nhập tên tác giả…"
                               value="${not empty book ? book.authors : ''}">
                        <div class="invalid-feedback">Vui lòng nhập tên tác giả.</div>
                        <small class="text-muted">Nhiều tác giả cách nhau bằng dấu phẩy.</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ngôn Ngữ <span class="text-danger">*</span></label>
                        <select name="language" id="language" class="form-select" required>
                            <option value="">-- Chọn ngôn ngữ --</option>
                            <c:set var="lang" value="${not empty book ? book.language : ''}"/>
                            <option value="Tiếng Việt" ${lang == 'Tiếng Việt' ? 'selected' : ''}>Tiếng Việt</option>
                            <option value="Tiếng Anh"  ${lang == 'Tiếng Anh'  ? 'selected' : ''}>Tiếng Anh</option>
                            <option value="Tiếng Nhật" ${lang == 'Tiếng Nhật' ? 'selected' : ''}>Tiếng Nhật</option>
                            <option value="Tiếng Pháp" ${lang == 'Tiếng Pháp' ? 'selected' : ''}>Tiếng Pháp</option>
                            <option value="Khác"       ${lang == 'Khác'       ? 'selected' : ''}>Khác</option>
                        </select>
                        <div class="invalid-feedback">Vui lòng chọn ngôn ngữ.</div>
                    </div>

                    <%-- ── Phân Loại & NXB ── --%>
                    <p class="section-label mt-4">Phân Loại & Nhà Xuất Bản</p>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Thể Loại <span class="text-danger">*</span></label>
                            <select name="categoryID" id="categoryID" class="form-select" required>
                                <option value="">-- Chọn thể loại --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat[0]}"
                                            <c:if test="${not empty book and book.categoryID == cat[0]}">selected</c:if>>
                                        ${cat[1]}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn thể loại.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nhà Xuất Bản <span class="text-danger">*</span></label>
                            <select name="publisherID" id="publisherID" class="form-select" required>
                                <option value="">-- Chọn NXB --</option>
                                <c:forEach var="pub" items="${publishers}">
                                    <option value="${pub[0]}"
                                            <c:if test="${not empty book and book.publisherID == pub[0]}">selected</c:if>>
                                        ${pub[1]}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhà xuất bản.</div>
                        </div>
                    </div>

                    <%-- ── Số Lượng ── --%>
                    <p class="section-label mt-4">Số Lượng</p>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Tổng Số Lượng <span class="text-danger">*</span></label>
                            <input type="number" name="totalQuantity" id="totalQty"
                                   class="form-control" min="1" required placeholder="0"
                                   value="${not empty book ? book.totalQuantity : ''}">
                            <div class="invalid-feedback">Vui lòng nhập số lượng (tối thiểu 1).</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số Lượng Còn Lại</label>
                            <input type="number" name="availableQuantity" id="availQty"
                                   class="form-control" min="0" placeholder="0"
                                   value="${not empty book ? book.availableQuantity : ''}">
                            <small class="text-muted">Không được vượt quá Tổng số lượng.</small>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" id="submitBtn" class="btn btn-primary px-4">
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
                                                    // ── Auto-generate ISBN ───────────────────────────────────────────
                                                    function generateISBN() {
                                                        let digits = '978';
                                                        for (let i = 0; i < 9; i++)
                                                            digits += Math.floor(Math.random() * 10);
                                                        let sum = 0;
                                                        for (let i = 0; i < 12; i++)
                                                            sum += parseInt(digits[i]) * (i % 2 === 0 ? 1 : 3);
                                                        const check = (10 - (sum % 10)) % 10;
                                                        const full = digits + check;
                                                        document.getElementById('isbnField').value =
                                                                full.slice(0, 3) + '-' + full.slice(3, 6) + '-' + full.slice(6, 12) + '-' + full.slice(12);
                                                    }
                                                    window.onload = function () {
                                                        const f = document.getElementById('isbnField');
                                                        if (f)
                                                            generateISBN();
                                                    };

                                                    // ── Check trùng tên sách realtime ────────────────────────────────
                                                    const titleField = document.getElementById('titleField');
                                                    const submitBtn = document.getElementById('submitBtn');
                                                    const titleFeedback = document.getElementById('titleFeedback');

                                                    if (titleField) {
                                                        titleField.addEventListener('blur', function () {
                                                            const title = this.value.trim();
                                                            if (!title)
                                                                return;
                                                            fetch('books?action=checkTitle&title=' + encodeURIComponent(title))
                                                                    .then(r => r.text())
                                                                    .then(result => {
                                                                        if (result === 'existed') {
                                                                            titleFeedback.innerHTML = '<span class="text-danger"><i class="bi bi-exclamation-circle-fill me-1"></i>Sách «' + title + '» đã có trong danh sách!</span>';
                                                                            submitBtn.disabled = true;
                                                                        } else {
                                                                            titleFeedback.innerHTML = '<span class="text-success"><i class="bi bi-check-circle-fill me-1"></i>Tên sách hợp lệ</span>';
                                                                            submitBtn.disabled = false;
                                                                        }
                                                                    });
                                                        });
                                                        titleField.addEventListener('input', function () {
                                                            titleFeedback.innerHTML = '';
                                                            submitBtn.disabled = false;
                                                        });
                                                    }

                                                    // ── Validation khi submit ────────────────────────────────────────
                                                    document.getElementById('bookForm').addEventListener('submit', function (e) {
                                                        let valid = true;

                                                        // Reset tất cả custom invalid trước
                                                        this.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

                                                        // Check từng field bắt buộc
                                                        const fields = ['titleField', 'authorName', 'language',
                                                            'categoryID', 'publisherID', 'publicationYear', 'totalQty'];
                                                        fields.forEach(id => {
                                                            const el = document.getElementById(id);
                                                            if (!el)
                                                                return;
                                                            const val = el.value.trim();
                                                            if (!val || val === '' || val === '0') {
                                                                el.classList.add('is-invalid');
                                                                valid = false;
                                                            }
                                                        });

                                                        // totalQty phải >= 1
                                                        const qty = document.getElementById('totalQty');
                                                        if (qty && parseInt(qty.value) < 1) {
                                                            qty.classList.add('is-invalid');
                                                            valid = false;
                                                        }

                                                        // publicationYear phải hợp lệ
                                                        const year = document.getElementById('publicationYear');
                                                        if (year) {
                                                            const y = parseInt(year.value);
                                                            if (!y || y < 1000 || y > 2099) {
                                                                year.classList.add('is-invalid');
                                                                valid = false;
                                                            }
                                                        }

                                                        if (!valid) {
                                                            e.preventDefault();
                                                            e.stopPropagation();
                                                            // Scroll đến field lỗi đầu tiên
                                                            const firstInvalid = this.querySelector('.is-invalid');
                                                            if (firstInvalid)
                                                                firstInvalid.scrollIntoView({behavior: 'smooth', block: 'center'});
                                                        }
                                                    });

                                                    // ── availableQty không vượt totalQty ─────────────────────────────
                                                    document.getElementById('totalQty').addEventListener('input', function () {
                                                        const avail = document.getElementById('availQty');
                                                        if (parseInt(avail.value) > parseInt(this.value))
                                                            avail.value = this.value;
                                                        // Xóa invalid khi đã nhập
                                                        if (parseInt(this.value) >= 1)
                                                            this.classList.remove('is-invalid');
                                                    });

                                                    // ── Xóa invalid khi người dùng bắt đầu nhập ─────────────────────
                                                    document.querySelectorAll('.form-control, .form-select').forEach(el => {
                                                        el.addEventListener('input', function () {
                                                            this.classList.remove('is-invalid');
                                                        });
                                                        el.addEventListener('change', function () {
                                                            this.classList.remove('is-invalid');
                                                        });
                                                    });
        </script>
    </body>
</html>
