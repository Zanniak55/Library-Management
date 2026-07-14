<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Determine current page for active nav highlighting
    String currentURI = request.getRequestURI();
    String servlet    = request.getParameter("action");
%>
<style>
    /* ── Navbar ─────────────────────────────────────── */
    .lib-navbar {
        background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
        padding: .85rem 2rem;
        display: flex;
        align-items: center;
        gap: 1.2rem;
        box-shadow: 0 4px 20px rgba(79,70,229,.4);
        flex-wrap: wrap;
    }

    .lib-navbar .brand {
        font-size: 1.3rem;
        font-weight: 700;
        color: #fff;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: .5rem;
        white-space: nowrap;
    }
    .lib-navbar .brand i { font-size: 1.5rem; }

    .lib-navbar nav {
        display: flex;
        gap: .25rem;
        flex-wrap: wrap;
    }
    .lib-navbar nav a {
        color: rgba(255,255,255,.82);
        text-decoration: none;
        font-size: .9rem;
        padding: .38rem .9rem;
        border-radius: .45rem;
        display: flex;
        align-items: center;
        gap: .35rem;
        transition: background .2s, color .2s;
        white-space: nowrap;
    }
    .lib-navbar nav a:hover,
    .lib-navbar nav a.active {
        background: rgba(255,255,255,.22);
        color: #fff;
    }

    /* "Thư viện ABC" pill badge on the right */
    .lib-badge {
        margin-left: auto;
        background: rgba(255,255,255,.15);
        color: rgba(255,255,255,.9);
        border-radius: 999px;
        padding: .3rem .9rem;
        font-size: .8rem;
        font-weight: 600;
        white-space: nowrap;
        display: flex;
        align-items: center;
        gap: .4rem;
    }
</style>

<nav class="lib-navbar">
    <!-- Brand -->
    <a href="index.jsp" class="brand">
        <i class="bi bi-book-half"></i>
        Quản lý Thư viện
    </a>

    <!-- Nav links -->
    <nav>
        <a href="index.jsp"
           class="${currentURI.contains('index') ? 'active' : ''}">
            <i class="bi bi-house-fill"></i> Trang chủ
        </a>
        <a href="BookServlet"
           class="${currentURI.contains('Book') ? 'active' : ''}">
            <i class="bi bi-book-fill"></i> Sách
        </a>
        <a href="<%= request.getContextPath() %>/members"
           class="${currentURI.contains('Member') ? 'active' : ''}">
            <i class="bi bi-people-fill"></i> Thành viên
        </a>
        <a href="LoanServlet"
           class="${currentURI.contains('Loan') ? 'active' : ''}">
            <i class="bi bi-arrow-left-right"></i> Mượn/Trả
        </a>
    </nav>

    <!-- Badge -->
    <span class="lib-badge">
        <i class="bi bi-building-fill"></i> Thư viện ABC
    </span>
</nav>
