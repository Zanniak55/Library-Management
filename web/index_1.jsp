<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description"
          content="Hệ thống quản lý thư viện – tra cứu sách, quản lý thành viên và theo dõi mượn/trả sách trực tuyến.">
    <title>Trang chủ – Hệ thống Quản lý Thư viện</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        /* ── Color tokens ──────────────────────────── */
        :root {
            --primary:   #4f46e5;
            --primary-h: #4338ca;
            --accent:    #06b6d4;
            --bg-body:   #0f172a;
            --bg-card:   #1e293b;
            --text-main: #f1f5f9;
            --text-muted:#94a3b8;
            --border:    #334155;
            --radius:    .85rem;
        }

        *, *::before, *::after { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: var(--bg-body);
            color: var(--text-main);
            min-height: 100vh;
            margin: 0;
        }

        /* ── Hero section ──────────────────────────── */
        .hero {
            background:
                radial-gradient(ellipse at 70% 30%, rgba(79,70,229,.35) 0%, transparent 60%),
                radial-gradient(ellipse at 20% 80%, rgba(6,182,212,.25) 0%, transparent 55%),
                linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            padding: 5rem 1.5rem 4rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        /* animated floating circles */
        .hero::before, .hero::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            opacity: .12;
            animation: float 8s ease-in-out infinite;
        }
        .hero::before {
            width: 420px; height: 420px;
            background: var(--primary);
            top: -100px; left: -80px;
        }
        .hero::after {
            width: 300px; height: 300px;
            background: var(--accent);
            bottom: -80px; right: -60px;
            animation-delay: -4s;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50%       { transform: translateY(-20px); }
        }

        .hero-label {
            display: inline-block;
            background: rgba(79,70,229,.2);
            border: 1px solid rgba(79,70,229,.4);
            color: #a5b4fc;
            border-radius: 999px;
            padding: .3rem 1rem;
            font-size: .82rem;
            font-weight: 600;
            letter-spacing: .08em;
            text-transform: uppercase;
            margin-bottom: 1.2rem;
        }
        .hero h1 {
            font-size: clamp(2rem, 5vw, 3.2rem);
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #fff 30%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .hero p {
            color: var(--text-muted);
            font-size: 1.05rem;
            max-width: 580px;
            margin: 0 auto 2.5rem;
            line-height: 1.7;
        }

        /* Hero CTA buttons */
        .hero-btns {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-hero-primary {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff;
            border: none;
            border-radius: .6rem;
            padding: .8rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            transition: opacity .2s, transform .15s;
            box-shadow: 0 4px 20px rgba(79,70,229,.4);
        }
        .btn-hero-primary:hover { opacity: .88; transform: translateY(-2px); color: #fff; }
        .btn-hero-secondary {
            background: rgba(255,255,255,.07);
            color: var(--text-main);
            border: 1px solid var(--border);
            border-radius: .6rem;
            padding: .8rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            transition: background .2s;
        }
        .btn-hero-secondary:hover { background: rgba(255,255,255,.12); color: var(--text-main); }

        /* ── Stats row ─────────────────────────────── */
        .stats-wrapper {
            max-width: 1100px;
            margin: -2.5rem auto 0;
            padding: 0 1.5rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            position: relative;
            z-index: 1;
        }
        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1.4rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 4px 16px rgba(0,0,0,.3);
            transition: transform .2s, box-shadow .2s;
        }
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 8px 28px rgba(0,0,0,.4); }
        .stat-icon {
            width: 52px; height: 52px;
            border-radius: .65rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .stat-icon.books   { background: rgba(79,70,229,.2); color: #a5b4fc; }
        .stat-icon.members { background: rgba(6,182,212,.2); color: #67e8f9; }
        .stat-icon.loans   { background: rgba(34,197,94,.2); color: #86efac; }
        .stat-icon.overdue { background: rgba(239,68,68,.2); color: #fca5a5; }
        .stat-label {
            font-size: .8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: .06em;
            font-weight: 600;
        }
        .stat-value {
            font-size: 1.7rem;
            font-weight: 700;
            line-height: 1;
            margin-top: .2rem;
        }

        /* ── Feature cards ─────────────────────────── */
        .section-title {
            text-align: center;
            font-size: 1.5rem;
            font-weight: 700;
            margin: 4rem 0 1.8rem;
        }
        .section-title span {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .features-grid {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 1.5rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.2rem;
        }
        .feature-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1.8rem;
            text-decoration: none;
            color: var(--text-main);
            transition: transform .2s, box-shadow .2s, border-color .2s;
            display: block;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 36px rgba(0,0,0,.4);
            border-color: var(--primary);
            color: var(--text-main);
        }
        .feature-icon {
            width: 56px; height: 56px;
            border-radius: .75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.7rem;
            margin-bottom: 1rem;
        }
        .fi-book   { background: linear-gradient(135deg, #4f46e5, #7c3aed); }
        .fi-member { background: linear-gradient(135deg, #06b6d4, #0284c7); }
        .fi-loan   { background: linear-gradient(135deg, #22c55e, #16a34a); }
        .feature-card h3 { font-size: 1.05rem; font-weight: 700; margin: 0 0 .5rem; }
        .feature-card p  { font-size: .88rem; color: var(--text-muted); margin: 0; line-height: 1.6; }

        .feature-arrow {
            display: inline-flex;
            align-items: center;
            gap: .3rem;
            margin-top: 1rem;
            font-size: .85rem;
            font-weight: 600;
            color: var(--accent);
        }

        /* ── Footer ────────────────────────────────── */
        footer {
            text-align: center;
            padding: 2rem 1rem;
            color: var(--text-muted);
            font-size: .82rem;
            margin-top: 4rem;
            border-top: 1px solid var(--border);
        }
    </style>
</head>
<body>

<!-- ══════════════ NAVBAR ══════════════ -->
<jsp:include page="header.jsp"/>

<!-- ══════════════ HERO ════════════════ -->
<section class="hero">
    <div class="hero-label"><i class="bi bi-stars"></i> Hệ thống quản lý hiện đại</div>
    <h1>Quản lý Thư viện<br>Thông minh &amp; Hiệu quả</h1>
    <p>Theo dõi sách, quản lý thành viên và xử lý giao dịch mượn/trả một cách dễ dàng, chính xác và trực quan.</p>
    <div class="hero-btns">
        <a href="<%= request.getContextPath() %>/members" class="btn-hero-primary" id="heroMemberBtn">
            <i class="bi bi-people-fill"></i> Quản lý Thành viên
        </a>
        <a href="BookServlet" class="btn-hero-secondary" id="heroBookBtn">
            <i class="bi bi-book-fill"></i> Danh mục Sách
        </a>
    </div>
</section>

<!-- ══════════════ STATS ═══════════════ -->
<div class="stats-wrapper">
    <div class="stat-card">
        <div class="stat-icon books"><i class="bi bi-book-fill"></i></div>
        <div>
            <div class="stat-label">Tổng số sách</div>
            <div class="stat-value" style="color:#a5b4fc;">1,240</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon members"><i class="bi bi-people-fill"></i></div>
        <div>
            <div class="stat-label">Thành viên</div>
            <div class="stat-value" style="color:#67e8f9;">348</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon loans"><i class="bi bi-arrow-left-right"></i></div>
        <div>
            <div class="stat-label">Đang mượn</div>
            <div class="stat-value" style="color:#86efac;">87</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon overdue"><i class="bi bi-exclamation-triangle-fill"></i></div>
        <div>
            <div class="stat-label">Quá hạn</div>
            <div class="stat-value" style="color:#fca5a5;">12</div>
        </div>
    </div>
</div>

<!-- ══════════════ FEATURES ═══════════ -->
<p class="section-title">Các chức năng <span>chính</span></p>

<div class="features-grid">

    <a href="BookServlet" class="feature-card" id="featBook">
        <div class="feature-icon fi-book">
            <i class="bi bi-book-fill" style="color:#fff;"></i>
        </div>
        <h3>Quản lý Sách</h3>
        <p>Thêm, sửa, xóa và tìm kiếm sách trong kho. Theo dõi số lượng tồn kho và thể loại sách.</p>
        <div class="feature-arrow">Xem danh sách <i class="bi bi-arrow-right"></i></div>
    </a>

    <a href="<%= request.getContextPath() %>/members" class="feature-card" id="featMember">
        <div class="feature-icon fi-member">
            <i class="bi bi-person-badge-fill" style="color:#fff;"></i>
        </div>
        <h3>Quản lý Thành viên</h3>
        <p>Đăng ký, cập nhật và tra cứu thông tin thành viên. Quản lý trạng thái và hạn thẻ thư viện.</p>
        <div class="feature-arrow">Xem thành viên <i class="bi bi-arrow-right"></i></div>
    </a>

    <a href="LoanServlet" class="feature-card" id="featLoan">
        <div class="feature-icon fi-loan">
            <i class="bi bi-arrow-left-right" style="color:#fff;"></i>
        </div>
        <h3>Mượn / Trả Sách</h3>
        <p>Ghi nhận giao dịch mượn và trả sách. Tự động cập nhật số lượng tồn và theo dõi hạn trả.</p>
        <div class="feature-arrow">Xem giao dịch <i class="bi bi-arrow-right"></i></div>
    </a>

</div>

<!-- ══════════════ FOOTER ══════════════ -->
<footer>
    © 2024 Hệ thống Quản lý Thư viện &nbsp;|&nbsp;
    Xây dựng bởi Nhóm sinh viên &nbsp;|&nbsp;
    <i class="bi bi-heart-fill" style="color:#ef4444;"></i> Made with love
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
