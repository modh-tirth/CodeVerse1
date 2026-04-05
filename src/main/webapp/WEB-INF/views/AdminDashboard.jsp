<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Admin Dashboard | CodeVerse</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        /* (keep all your existing CSS – no changes needed) */
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

        .app-wrapper {
            display: flex;
            height: 100vh;
            width: 100%;
            overflow: hidden;
        }

        /* Sidebar styles (same as before) – kept as is */
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
        .sidebar.collapsed { width: 80px; }
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
            object-fit: contain;
        }
        .logo-text {
            font-size: 1.25rem;
            font-weight: 600;
            color: white;
            white-space: nowrap;
        }
        .sidebar.collapsed .logo-text { display: none; }
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
        .menu-item.open .arrow-icon { transform: rotate(-90deg); }
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
        .submenu.open { max-height: 200px; }
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
        .sidebar.collapsed .menu-item .arrow-icon { display: none; }
        .sidebar.collapsed .submenu { display: none; }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            background: #f8fafc;
        }

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
        .user-info { display: none; }
        @media (min-width: 768px) {
            .user-info { display: block; }
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
        .dropdown-menu.show { display: block; }
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
        .dropdown-item:hover { background: #f1f5f9; }

        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.06);
            border-color: #cbd5e1;
        }
        .stat-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.8rem;
        }
        .stat-content h4 {
            font-size: 0.85rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .stat-content h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #0f172a;
        }

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 30px;
        }
        .chart-card {
            background: white;
            border-radius: 24px;
            padding: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
            transition: all 0.2s;
            display: flex;
            flex-direction: column;
        }
        .chart-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.06);
            border-color: #cbd5e1;
        }
        .chart-card h4 {
            font-size: 1rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .chart-card h4 i {
            color: #3b82f6;
            font-size: 1.1rem;
        }
        .chart-container {
            position: relative;
            height: 260px;
            width: 100%;
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

        @media (max-width: 1024px) {
            .chart-grid { grid-template-columns: 1fr; gap: 20px; }
        }
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                left: -280px;
                width: 280px;
                z-index: 2000;
                transition: left 0.3s ease-in-out;
            }
            .sidebar.mobile-open { left: 0; box-shadow: 10px 0 25px rgba(0,0,0,0.2); }
            .main-content { width: 100%; }
            .mobile-menu-btn { display: block; }
            .top-header { padding: 16px 20px; }
            .content-area { padding: 20px; }
            .stats-grid { grid-template-columns: 1fr; gap: 16px; }
            .chart-container { height: 220px; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="AdminSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="AdminHeader.jsp" />
        <div class="content-area">
            <h1 style="font-size: 1.5rem; font-weight: 700; color: #0f172a; margin-bottom: 24px;">Dashboard</h1>

            <!-- Stats Cards (4 cards) -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-trophy"></i></div>
                    <div class="stat-content">
                        <h4>Total Hackathons</h4>
                        <h2>${totalHackathon}</h2>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-calendar-plus"></i></div>
                    <div class="stat-content">
                        <h4>Upcoming</h4>
                        <h2>${upcomingHackathon}</h2>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-play-circle"></i></div>
                    <div class="stat-content">
                        <h4>Live Now</h4>
                        <h2>${liveHackathon}</h2>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-content">
                        <h4>Total Users</h4>
                        <h2>${totalUsers}</h2>
                    </div>
                </div>
            </div>

            <!-- Full‑width line chart: Registrations Trend (Cumulative) -->
            <div class="full-width-card chart-card">
                <h4><i class="fas fa-chart-line"></i> Registrations Trend (Cumulative)</h4>
                <div class="chart-container" style="height: 280px;">
                    <canvas id="registrationsChart"></canvas>
                </div>
            </div>

            <!-- Remaining 6 charts in 2‑column grid -->
            <div class="chart-grid">
                <!-- 1. Hackathon Status (Pie) -->
                <div class="chart-card">
                    <h4><i class="fas fa-chart-pie"></i> Hackathon Status</h4>
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>

                <!-- 2. User Roles (Bar) -->
                <div class="chart-card">
                    <h4><i class="fas fa-chart-bar"></i> User Roles</h4>
                    <div class="chart-container">
                        <canvas id="roleChart"></canvas>
                    </div>
                </div>

                <!-- 3. Monthly Revenue (Line) – now inside grid -->
                <div class="chart-card">
                    <h4><i class="fas fa-chart-line"></i> Monthly Revenue (₹)</h4>
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- 4. Submission vs Evaluation (Bar) -->
                <div class="chart-card">
                    <h4><i class="fas fa-file-alt"></i> Submission vs Evaluation</h4>
                    <div class="chart-container">
                        <canvas id="submissionEvalChart"></canvas>
                    </div>
                </div>

                <!-- 5. Judge Workload (Horizontal bar) -->
                <div class="chart-card">
                    <h4><i class="fas fa-gavel"></i> Judge Workload</h4>
                    <div class="chart-container">
                        <canvas id="judgeWorkloadChart"></canvas>
                    </div>
                </div>

                <!-- 6. Top Hackathons by Participants (Horizontal bar) -->
                <div class="chart-card">
                    <h4><i class="fas fa-chart-simple"></i> Top Hackathons by Participants</h4>
                    <div class="chart-container">
                        <canvas id="topHackathonsChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <footer class="footer">
            &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<script>
    // 1. Hackathon Status (Pie)
    new Chart(document.getElementById('statusChart'), {
        type: 'pie',
        data: {
            labels: ['Upcoming', 'Live', 'Expired'],
            datasets: [{
                data: [${upcomingHackathon}, ${liveHackathon}, ${totalHackathon - (upcomingHackathon + liveHackathon)}],
                backgroundColor: ['#fbbf24', '#10b981', '#94a3b8'],
                borderWidth: 0
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
    });

    // 2. User Roles
    new Chart(document.getElementById('roleChart'), {
        type: 'bar',
        data: {
            labels: ['Participants', 'Judges', 'Admins'],
            datasets: [{
                label: 'Count',
                data: [${totalParticipants}, ${totalJudges}, ${totalAdmins}],
                backgroundColor: '#3b82f6',
                borderRadius: 8
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, stepSize: 1 } } }
    });

    // 3. Monthly Revenue (inside grid)
    new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
            labels: [<c:forEach items="${revenueMonths}" var="m" varStatus="loop">'${m}'${!loop.last ? ',' : ''}</c:forEach>],
            datasets: [{
                label: 'Revenue (₹)',
                data: [<c:forEach items="${revenueAmounts}" var="amt" varStatus="loop">${amt}${!loop.last ? ',' : ''}</c:forEach>],
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59,130,246,0.05)',
                tension: 0.3,
                fill: true
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, ticks: { callback: v => '₹' + v } } } }
    });

    // 4. Submission vs Evaluation
    new Chart(document.getElementById('submissionEvalChart'), {
        type: 'bar',
        data: {
            labels: ['Total Submissions', 'Evaluated'],
            datasets: [{
                label: 'Count',
                data: [${totalSubmissions}, ${evaluatedSubmissions}],
                backgroundColor: ['#3b82f6', '#10b981'],
                borderRadius: 8
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, stepSize: 1 } } }
    });

    // 5. Judge Workload
    new Chart(document.getElementById('judgeWorkloadChart'), {
        type: 'bar',
        data: {
            labels: [<c:forEach items="${judgeNames}" var="name" varStatus="loop">'${name}'${!loop.last ? ',' : ''}</c:forEach>],
            datasets: [{
                label: 'Assigned Hackathons',
                data: [<c:forEach items="${judgeWorkloads}" var="w" varStatus="loop">${w}${!loop.last ? ',' : ''}</c:forEach>],
                backgroundColor: '#f59e0b',
                borderRadius: 8
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, stepSize: 1 } } }
    });

    // 6. Registrations Trend (full‑width)
    new Chart(document.getElementById('registrationsChart'), {
        type: 'line',
        data: {
            labels: [<c:forEach items="${monthLabels}" var="label" varStatus="loop">'${label}'${!loop.last ? ',' : ''}</c:forEach>],
            datasets: [{
                label: 'Cumulative Registrations',
                data: [<c:forEach items="${registrationCounts}" var="count" varStatus="loop">${count}${!loop.last ? ',' : ''}</c:forEach>],
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59,130,246,0.05)',
                tension: 0.3,
                fill: true
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, ticks: { stepSize: 1, callback: v => Number.isInteger(v) ? v : '' } } } }
    });

    // 7. Top Hackathons by Participants
    new Chart(document.getElementById('topHackathonsChart'), {
        type: 'bar',
        data: {
            labels: [<c:forEach items="${topHackathonNames}" var="name" varStatus="loop">'${name}'${!loop.last ? ',' : ''}</c:forEach>],
            datasets: [{
                label: 'Participants',
                data: [<c:forEach items="${topHackathonParticipants}" var="count" varStatus="loop">${count}${!loop.last ? ',' : ''}</c:forEach>],
                backgroundColor: '#10b981',
                borderRadius: 8
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, stepSize: 1 } } }
    });
</script>

<script>
    // Sidebar toggle and mobile menu logic (keep exactly as before)
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