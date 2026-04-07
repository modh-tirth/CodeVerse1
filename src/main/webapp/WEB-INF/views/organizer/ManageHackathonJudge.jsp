<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Manage Judges | CodeVerse Admin</title>
   
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
            overflow: hidden;
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
            height: 100vh;
            overflow-y: auto;
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

        /* ========== CARD & FORM STYLES ========== */
        .form-card, .table-card {
            background: white;
            border-radius: 28px;
            padding: 28px;
            margin-bottom: 28px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.04);
            border: 1px solid #eef2f6;
        }

        .card-header-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f1f5f9;
            flex-wrap: wrap;
            gap: 12px;
        }

        .card-header-custom h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header-custom i {
            color: #3b82f6;
            font-size: 1.3rem;
        }

        .badge-count {
            background: #e2e8f0;
            color: #1e293b;
            padding: 5px 12px;
            border-radius: 30px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        /* Form layout */
        .form-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .form-group-flex {
            flex: 2;
            min-width: 200px;
        }

        .form-group-flex label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
            letter-spacing: 0.3px;
        }

        .input-group {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            transition: all 0.2s ease;
        }

        .input-group:focus-within {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .input-group-icon {
            padding: 0 16px;
            color: #3b82f6;
            font-size: 1rem;
        }

        .input-group select {
            width: 100%;
            padding: 14px 16px 14px 0;
            border: none;
            outline: none;
            font-size: 0.95rem;
            color: #1e293b;
            background: transparent;
            font-family: inherit;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3E%3Cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 20px;
        }

        .btn {
            padding: 12px 28px;
            border-radius: 40px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 8px rgba(59, 130, 246, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* Alert styles */
        .alert {
            padding: 16px 20px;
            border-radius: 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }

        .alert-success {
            background: #d1fae5;
            border-left: 4px solid #10b981;
            color: #065f46;
        }

        .alert-danger {
            background: #fee2e2;
            border-left: 4px solid #ef4444;
            color: #991b1b;
        }

        .alert-warning {
            background: #fef9c3;
            border-left: 4px solid #fbbf24;
            color: #854d0e;
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            opacity: 0.7;
        }

        /* Table styles */
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

        /* Footer */
        .footer {
            background: white;
            padding: 20px 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
            flex-shrink: 0;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .content-area {
                padding: 20px;
            }
            .form-card, .table-card {
                padding: 20px;
            }
            .form-row {
                flex-direction: column;
                align-items: stretch;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="OrganizerSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="OrganizerHeader.jsp" />
        <div class="content-area">
            <!-- Page Header -->
            <div style="margin-bottom: 24px;">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: #0f172a;">Manage Judges</h1>
                <p style="color: #64748b; margin-top: 4px;">Assign or remove judges for this hackathon</p>
            </div>

            <!-- Alert Messages -->
            <c:if test="${success == 'added'}">
                <div class="alert alert-success">
                    <span><i class="fas fa-check-circle"></i> Judge assigned successfully.</span>
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:if>
            <c:if test="${success == 'removed'}">
                <div class="alert alert-success">
                    <span><i class="fas fa-check-circle"></i> Judge removed from hackathon.</span>
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:if>
            <c:if test="${error == 'alreadyAssigned'}">
                <div class="alert alert-warning">
                    <span><i class="fas fa-exclamation-triangle"></i> Judge already assigned.</span>
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:if>
            <c:if test="${error == 'invalidJudge'}">
                <div class="alert alert-danger">
                    <span><i class="fas fa-exclamation-triangle"></i> Invalid judge selection.</span>
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:if>

            <!-- Assign Judge Card -->
            <div class="form-card">
                <div class="card-header-custom">
                    <h3><i class="fas fa-user-plus"></i> Assign New Judge</h3>
                    <a href="listHackathon" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.85rem;">
                        <i class="fas fa-arrow-left"></i> Back to Hackathons
                    </a>
                </div>
                <form action="assign-judge" method="post">
                    <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">
                    <div class="form-row">
                        <div class="form-group-flex">
                            <label>Select Judge</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-gavel"></i></span>
                                <select name="userId" required>
                                    <option value="">-- Choose a judge --</option>
                                    <c:forEach items="${availableJudges}" var="j">
                                        <option value="${j.userId}">${j.firstName} ${j.lastName} - ${j.email}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-plus-circle"></i> Assign Judge
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Assigned Judges Table -->
            <div class="table-card">
                <div class="card-header-custom">
                    <h3><i class="fas fa-users"></i> Assigned Judges</h3>
                    <span class="badge-count">${assignedJudges.size()} Judges</span>
                </div>
                <div class="table-responsive">
                    <table class="judge-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Contact</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty assignedJudges}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">
                                        <i class="fas fa-user-slash"></i> No judges assigned for this hackathon.
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach items="${assignedJudges}" var="a" varStatus="i">
                                <tr>
                                    <td>${i.count}</td>
                                    <td><strong>${judgeMap[a.userId].firstName} ${judgeMap[a.userId].lastName}</strong></td>
                                    <td>${judgeMap[a.userId].email}</td>
                                    <td>${judgeMap[a.userId].contactNum}</td>
                                    <td>
                                        <a class="btn btn-danger" style="padding: 8px 16px; font-size: 0.8rem;"
                                           href="remove-judge?hackathonJudgeId=${a.hackathonJudgeId}&hackathonId=${hackathon.hackathonId}"
                                           onclick="return confirm('Remove this judge from hackathon?')">
                                            <i class="fas fa-trash-alt"></i> Remove
                                        </a>
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

    // User dropdown toggle
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