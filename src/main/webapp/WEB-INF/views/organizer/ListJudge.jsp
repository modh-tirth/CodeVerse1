<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Judge List | CodeVerse Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* ========== DASHBOARD LAYOUT STYLES ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: #f5f7fb;
            color: #1e293b;
            overflow-x: hidden;
        }
        .app-wrapper {
            display: flex;
            min-height: 100vh;
            height: 100vh;
            overflow: hidden;
        }
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            color: #e2e8f0;
            transition: width 0.3s ease;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 20px rgba(0,0,0,0.08);
            height: 100vh;
        }
        .sidebar.collapsed {
            width: 80px;
        }
        .sidebar-header {
            padding: 24px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
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
            display: block;
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
        .toggle-btn {
            background: rgba(255,255,255,0.1);
            border: none;
            color: #cbd5e1;
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
        }
        .toggle-btn:hover {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        .sidebar.collapsed .toggle-btn i {
            transform: rotate(180deg);
        }
        .sidebar-menu {
            flex: 1;
            padding: 20px 0;
            overflow-y: auto;
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
        @media (max-width: 768px) {
            #sidebar {
                position: fixed;
                top: 0;
                left: -280px;
                width: 280px;
                height: 100vh;
                z-index: 2000;
                background: #1e293b;
                transition: left 0.3s ease-in-out;
                box-shadow: none;
            }
            #sidebar.mobile-open {
                left: 0;
                box-shadow: 10px 0 25px rgba(0,0,0,0.2);
            }
            .main-content {
                margin-left: 0 !important;
                width: 100% !important;
            }
            .mobile-menu-btn {
                display: block;
            }
        }

        /* Main content area */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8fafc;
            height: 100vh;
            overflow: hidden;
        }
        .top-header {
            background: white;
            padding: 16px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            border-bottom: 1px solid #e9eef2;
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
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }
        .footer {
            background: white;
            padding: 20px 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        @media (max-width: 768px) {
            .content-area {
                padding: 20px;
            }
        }

        /* ========== IMPROVED TABLE & CARD STYLES ========== */
        .table-card {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
        }
        .card-header-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
            flex-wrap: wrap;
            gap: 12px;
        }
        .card-header-custom h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-header-custom i {
            color: #3b82f6;
        }
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            border-radius: 30px;
            padding: 8px 20px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: 0.2s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59,130,246,0.3);
        }
        .table-responsive {
            overflow-x: auto;
        }
        .judge-table {
            width: 100%;
            border-collapse: collapse;
        }
        .judge-table th {
            text-align: left;
            padding: 16px 12px;
            font-weight: 600;
            font-size: 0.85rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border-bottom: 2px solid #e2e8f0;
        }
        .judge-table td {
            padding: 16px 12px;
            border-bottom: 1px solid #edf2f7;
            color: #1e293b;
            vertical-align: middle;
        }
        .judge-table tr:hover td {
            background: #f8fafc;
        }
        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }
        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }
        .badge-warning {
            background: #fed7aa;
            color: #9b4d00;
        }
        .badge-primary {
            background: #dbeafe;
            color: #1e40af;
        }
        /* Alert */
        .alert-success {
            background: #d1fae5;
            border-left: 4px solid #10b981;
            padding: 16px 20px;
            border-radius: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: #065f46;
        }
        .alert-success i {
            font-size: 1.2rem;
            margin-right: 10px;
        }
        .btn-close {
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            color: #065f46;
        }
        .text-muted {
            color: #94a3b8;
        }
        .text-center {
            text-align: center;
        }
        .py-4 {
            padding-top: 2rem;
            padding-bottom: 2rem;
        }
        .mt-3 {
            margin-top: 1rem;
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="OrganizerSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="OrganizerHeader.jsp" />
        <div class="content-area">
            <div style="margin-bottom: 24px;">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: #0f172a;">All Judges</h1>
            </div>

            <c:if test="${param.invited == 'true'}">
                <div class="alert-success">
                    <span><i class="fas fa-check-circle"></i> Judge invited successfully. Email with temporary password sent.</span>
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:if>

            <div class="table-card">
                <div class="card-header-custom">
                    <h3><i class="fas fa-gavel"></i> Judge List</h3>
                    <a href="newJudge" class="btn-primary">
                        <i class="fas fa-user-plus"></i> Invite New Judge
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="judge-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Contact</th>
                                <th>Qualification</th>
                                <th>Designation</th>
                                <th>Organization</th>
                                <th>Status</th>
                                <th>Password Reset</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty judgeList}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">
                                        <i class="fas fa-user-slash"></i> No judges found.
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach items="${judgeList}" var="j" varStatus="i">
                                <tr>
                                    <td>${i.count}</td>
                                    <td><strong>${j.firstName} ${j.lastName}</strong></td>
                                    <td>${j.email}</td>
                                    <td>${j.contactNum}</td>
                                    <td>${j.qualification}</td>
                                    <td>${j.designation}</td>
                                    <td>${j.organization}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${j.active}">
                                                <span class="badge badge-success"><i class="fas fa-check-circle"></i> Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger"><i class="fas fa-ban"></i> Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${j.passwordResetRequired}">
                                                <span class="badge badge-warning"><i class="fas fa-clock"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-primary"><i class="fas fa-check-circle"></i> Completed</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <footer class="footer">
            &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<script>
    // Sidebar toggle and mobile menu logic (compatible with AdminSidebar.js)
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
            if (!sidebar.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
                sidebar.classList.remove('mobile-open');
            }
        }
    });

    window.addEventListener('resize', () => {
        if (window.innerWidth > 768) {
            sidebar.classList.remove('mobile-open');
        }
    });

    // User dropdown toggle (from AdminHeader)
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