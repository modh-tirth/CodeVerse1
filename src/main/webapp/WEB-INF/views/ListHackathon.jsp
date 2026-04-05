<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Manage Hackathons | CodeVerse</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        /* ========== RESET & GLOBAL ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            overflow: hidden;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f5f7fb;
            color: #1e293b;
        }

        /* ========== APP WRAPPER ========== */
        .app-wrapper {
            display: flex;
            height: 100vh;
            width: 100%;
        }

        /* ========== SIDEBAR (matches AdminSidebar) ========== */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            color: #e2e8f0;
            transition: width 0.3s ease, left 0.3s ease;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 20px rgba(0,0,0,0.08);
            flex-shrink: 0;
            overflow-y: auto;
            height: 100vh;
        }

        .sidebar.collapsed {
            width: 80px;
        }

        .sidebar-header {
            padding: 24px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .logo-area {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-icon-img {
            height: 70px;
            width: auto;
            max-width: 100%;
            object-fit: contain;
        }

        .logo-text {
            font-size: 1.25rem;
            font-weight: 600;
            color: white;
            white-space: nowrap;
        }

        .sidebar.collapsed .logo-text {
            display: none;
        }

        .sidebar-menu {
            flex: 1;
            padding: 20px 0;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 12px 24px;
            margin: 4px 8px;
            border-radius: 12px;
            color: #cbd5e1;
            transition: 0.2s;
            white-space: nowrap;
            cursor: pointer;
            position: relative;
        }

        .menu-item i:first-child {
            font-size: 1.25rem;
            min-width: 36px;
        }

        .menu-item span {
            margin-left: 8px;
            font-weight: 500;
            flex: 1;
        }

        .menu-item .arrow-icon {
            font-size: 0.9rem;
            transition: transform 0.3s;
            margin-left: auto;
        }

        .menu-item.open .arrow-icon {
            transform: rotate(-90deg);
        }

        .menu-item:hover {
            background: rgba(59, 130, 246, 0.2);
            color: white;
        }

        .menu-item.active {
            background: rgba(59, 130, 246, 0.2);
            color: white;
        }

        .submenu {
            list-style: none;
            padding-left: 56px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
        }

        .submenu.open {
            max-height: 200px;
        }

        .submenu-item {
            padding: 10px 0 10px 12px;
            margin: 2px 8px 2px 0;
            border-radius: 10px;
            color: #a0afc0;
            font-size: 0.95rem;
            cursor: pointer;
            white-space: nowrap;
            display: flex;
            align-items: center;
        }

        .submenu-item:hover {
            color: white;
            background: rgba(255, 255, 255, 0.05);
        }

        .submenu-item i {
            margin-right: 10px;
            font-size: 1rem;
            width: 20px;
            color: #a0afc0;
        }

        .submenu-item a {
            color: inherit;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
        }

        .sidebar.collapsed .menu-item span,
        .sidebar.collapsed .menu-item .arrow-icon {
            display: none;
        }

        .sidebar.collapsed .submenu {
            display: none;
        }

        /* ========== MAIN CONTENT ========== */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            background: #f8fafc;
        }

        /* ========== HEADER ========== */
        .top-header {
            flex-shrink: 0;
            background: white;
            padding: 16px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            border-bottom: 1px solid #e9eef2;
            z-index: 1000;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #475569;
            cursor: pointer;
        }

        .page-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #0f172a;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .user-dropdown {
            position: relative;
            cursor: pointer;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: #3b82f6;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }

        .user-info {
            display: none;
        }

        @media (min-width: 768px) {
            .user-info {
                display: block;
            }
            .user-info .name {
                font-weight: 600;
                font-size: 0.95rem;
                color: #1e293b;
            }
            .user-info .role {
                font-size: 0.75rem;
                color: #64748b;
            }
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 50px;
            background: white;
            min-width: 180px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 1px solid #edf2f7;
            overflow: hidden;
            z-index: 1001;
        }

        .dropdown-menu.show {
            display: block;
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            color: #1e293b;
            text-decoration: none;
            font-size: 0.95rem;
            transition: 0.2s;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
        }

        .dropdown-item:hover {
            background: #f1f5f9;
        }

        /* ========== CONTENT AREA (SCROLLABLE) ========== */
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }

        /* ========== TABLE CARD ========== */
        .table-card {
            background: white;
            border-radius: 28px;
            padding: 24px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.04);
            border: 1px solid #eef2f6;
            margin-bottom: 24px;
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .card-header h3 {
            font-size: 1.35rem;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header h3 i {
            color: #3b82f6;
            font-size: 1.5rem;
        }

        .add-btn {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            border-radius: 40px;
            padding: 10px 24px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: 0.2s;
            font-size: 0.9rem;
        }

        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59,130,246,0.3);
        }

        /* ========== TABLE STYLES ========== */
        .responsive-table {
            overflow-x: auto;
        }

        .hackathon-table {
            width: 100%;
            border-collapse: collapse;
        }

        .hackathon-table th {
            text-align: left;
            padding: 16px 12px;
            font-weight: 600;
            font-size: 0.85rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border-bottom: 2px solid #e2e8f0;
        }

        .hackathon-table td {
            padding: 16px 12px;
            border-bottom: 1px solid #edf2f7;
            color: #1e293b;
            vertical-align: middle;
        }

        .hackathon-table tr:hover td {
            background: #f8fafc;
        }

        .event-title {
            font-weight: 700;
            color: #0f172a;
            display: block;
            margin-bottom: 6px;
        }

        .type-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 4px 12px;
            border-radius: 30px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-block;
            margin-right: 6px;
        }

        .date-start {
            font-size: 0.85rem;
            color: #10b981;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 4px;
        }

        .date-end {
            font-size: 0.85rem;
            color: #ef4444;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .team-size {
            font-size: 0.75rem;
            color: #64748b;
            margin-top: 6px;
        }

        /* Status badges */
        .status-badge {
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-live {
            background: #d1fae5;
            color: #065f46;
        }

        .status-expired {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-upcoming {
            background: #fef9c3;
            color: #854d0e;
        }

        /* Action buttons */
        .action-btns {
            display: flex;
            gap: 8px;
        }

        .btn-icon {
            width: 36px;
            height: 36px;
            border-radius: 12px;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
            color: white;
        }

        .btn-edit {
            background: #3b82f6;
        }

        .btn-edit:hover {
            background: #2563eb;
        }

        .btn-delete {
            background: #ef4444;
        }

        .btn-delete:hover {
            background: #dc2626;
        }

        .btn-judge {
            background: #10b981;
        }

        .btn-judge:hover {
            background: #059669;
        }

        /* ========== PAGINATION ========== */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .page-link {
            padding: 8px 18px;
            border-radius: 40px;
            background: white;
            border: 1px solid #e2e8f0;
            color: #1e293b;
            text-decoration: none;
            transition: 0.2s;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .page-link:hover:not(.disabled) {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }

        .page-link.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .current-page {
            background: skyblue;
            color: #1e293b;
            font-weight: 700;
            border: none;
            padding: 8px 18px;
            border-radius: 40px;
        }

        /* ========== FOOTER ========== */
        .footer {
            background: white;
            padding: 20px 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
            flex-shrink: 0;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                left: -280px;
                width: 280px;
                z-index: 2000;
                transition: left 0.3s ease-in-out;
            }
            .sidebar.mobile-open {
                left: 0;
                box-shadow: 10px 0 25px rgba(0,0,0,0.2);
            }
            .main-content {
                width: 100%;
            }
            .mobile-menu-btn {
                display: block;
            }
            .top-header {
                padding: 16px 20px;
            }
            .content-area {
                padding: 20px;
            }
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .hackathon-table th, .hackathon-table td {
                padding: 12px 8px;
            }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="AdminSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="AdminHeader.jsp" />
        <div class="content-area">
            <div style="margin-bottom: 24px;">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: #0f172a;">Manage Hackathons</h1>
            </div>

            <div class="table-card">
                <div class="card-header">
                    <h3><i class="fas fa-calendar-alt"></i> Hackathon Events List</h3>
                   <!--  <a href="create-hackathon" class="add-btn" style="margin-left:50rem"><i class="fas fa-plus"></i> Launch New</a>
                     -->
                     <a href="exportHackathons" class="add-btn" style="background: linear-gradient(135deg,#10b981,#059669);">
            <i class="fas fa-download"></i> Export Report
        </a>
                </div>
                <div class="responsive-table">
                    <table class="hackathon-table">
                        <thead>
                            <tr>
                                <th>Sr.No</th>
                                <th>Event Details</th>
                                <th>Participation</th>
                                <th>Registration Period</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="h" items="${allHackathons}" varStatus="s">
                                <tr>
                                    <td>${(currentPage - 1) * 10 + s.count}</td>
                                    <td>
                                        <span class="event-title">${h.title}</span>
                                        <div>
                                            <span class="type-badge">${h.eventType}</span>
                                            <span class="type-badge">${h.payment}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div>${h.userType}</div>
                                        <div class="team-size">Team: ${h.minTeamSize} - ${h.maxTeamSize}</div>
                                    </td>
                                    <td>
                                        <div class="date-start"><i class="fas fa-calendar-check"></i> ${h.registrationStartDate}</div>
                                        <div class="date-end"><i class="fas fa-calendar-times"></i> ${h.registrationEndDate}</div>
                                    </td>
                                    <td>${h.location}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${h.status == 'LIVE'}">
                                                <span class="status-badge status-live">Live</span>
                                            </c:when>
                                            <c:when test="${h.status == 'EXPIRED'}">
                                                <span class="status-badge status-expired">Expired</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-upcoming">${h.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="btn-icon btn-edit" onclick="location.href='editHackathon?hackathonId=${h.hackathonId}'" title="Edit">
                                                <i class="fas fa-pencil-alt"></i>
                                            </button>
                                            <button class="btn-icon btn-delete" onclick="if(confirm('Delete this event?')) location.href='deleteHackathon?hackathonId=${h.hackathonId}'" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                            <button class="btn-icon btn-judge" onclick="location.href='manageHackathonJudge?hackathonId=${h.hackathonId}'" title="Manage Judges">
                                                <i class="fas fa-users"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allHackathons}">
                                <tr><td colspan="7" style="text-align:center; padding: 60px;">No hackathons found. <a href="create-hackathon" style="color:#3b82f6;">Create one</a>?</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination: Prev, current page (skyblue), Next -->
                <div class="pagination">
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a class="page-link" href="listHackathon?page=${currentPage - 1}">
                                <i class="fas fa-chevron-left"></i> Previous
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-link disabled"><i class="fas fa-chevron-left"></i> Previous</span>
                        </c:otherwise>
                    </c:choose>

                    <span class="current-page">${currentPage}</span>

                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a class="page-link" href="listHackathon?page=${currentPage + 1}">
                                Next <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-link disabled">Next <i class="fas fa-chevron-right"></i></span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <footer class="footer">
            &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<script>
    // Sidebar toggle and mobile menu
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('toggleSidebar');
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');

    if (toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.toggle('collapsed');
            const icon = toggleBtn.querySelector('i');
            if (sidebar.classList.contains('collapsed')) {
                icon.classList.remove('fa-chevron-left');
                icon.classList.add('fa-chevron-right');
            } else {
                icon.classList.remove('fa-chevron-right');
                icon.classList.add('fa-chevron-left');
            }
        });
    }

    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', () => {
            sidebar.classList.add('mobile-open');
        });
    }

    document.addEventListener('click', (e) => {
        if (window.innerWidth <= 768) {
            if (sidebar && !sidebar.contains(e.target) && mobileMenuBtn && !mobileMenuBtn.contains(e.target)) {
                sidebar.classList.remove('mobile-open');
            }
        }
    });

    window.addEventListener('resize', () => {
        if (window.innerWidth > 768 && sidebar) {
            sidebar.classList.remove('mobile-open');
        }
    });
	
    // User dropdown from AdminHeader
    const userDropdown = document.getElementById('userDropdown');
    const dropdownMenu = document.getElementById('dropdownMenu');
    if (userDropdown) {
        userDropdown.addEventListener('click', (e) => {
            e.stopPropagation();
            dropdownMenu.classList.toggle('show');
        });
    }
    document.addEventListener('click', () => {
        if (dropdownMenu) dropdownMenu.classList.remove('show');
    });
</script>
</body>
</html>