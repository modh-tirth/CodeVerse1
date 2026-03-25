<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="https://jakarta.ee/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Admin Dashboard | CodeVerse</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        /* (keep all your existing CSS exactly as before) */
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
        }
        /* Sidebar styles (unchanged) */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            color: #e2e8f0;
            transition: width 0.3s ease;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 20px rgba(0,0,0,0.08);
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
        .logo-icon {
            background: #3b82f6;
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            color: white;
        }
        .logo-text {
            font-size: 1.25rem;
            font-weight: 600;
            color: white;
            letter-spacing: 0.5px;
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
        }
        .menu-item i {
            font-size: 1.25rem;
            min-width: 36px;
        }
        .menu-item span {
            margin-left: 8px;
            font-weight: 500;
        }
        .menu-item:hover, .menu-item.active {
            background: rgba(59, 130, 246, 0.2);
            color: white;
        }
        .sidebar.collapsed .menu-item span {
            display: none;
        }
        .sidebar.collapsed .menu-item {
            justify-content: center;
            padding: 12px 0;
        }
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8fafc;
        }
        /* Header styles now come from included file, but we keep the top-header class definition if needed */
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
        /* Page title now appears in content area */
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
        .notification-icon {
            position: relative;
            font-size: 1.25rem;
            color: #475569;
            cursor: pointer;
        }
        .notification-badge {
            position: absolute;
            top: -6px;
            right: -6px;
            background: #ef4444;
            color: white;
            font-size: 0.6rem;
            padding: 2px 5px;
            border-radius: 20px;
        }
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
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
        .content-area {
            padding: 30px;
            flex: 1;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 30px;
              height: 25%;
        }
        .stat-card {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
            transition: 0.2s;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .stat-card:hover {
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
            font-size: 0.9rem;
            font-weight: 500;
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
        /* Chart cards */
      /*  .chart-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 30px;*/
            .chart-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr)); /* FIX */
    gap: 20px;
}
.chart-container {
    position: relative;
    height: 300px;
    width: 100%;
    overflow: hidden; /* prevent stretch */
    
}
.chart-container{
    background-color: white;
    border-radius: 12px; /* optional for clean UI */
}
        }
        .chart-card {
            background: white;
            border-radius: 24px;
            padding: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
        }
        .chart-card h4 {
            font-size: 1rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .chart-card h4 i {
            color: #3b82f6;
        }
        .chart-container {
            position: relative;
            height: 250px;
            width: 100%;
        }
        .table-card {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
        }
        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .card-header h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card-header h3 i {
            color: #3b82f6;
        }
        .view-all {
            color: #3b82f6;
            font-weight: 500;
            font-size: 0.9rem;
            text-decoration: none;
        }
        .responsive-table {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            text-align: left;
            padding: 16px 12px;
            font-weight: 600;
            font-size: 0.85rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border-bottom: 2px solid #e2e8f0;
        }
        td {
            padding: 16px 12px;
            border-bottom: 1px solid #edf2f7;
            color: #1e293b;
            font-weight: 500;
        }
        .badge {
            background: #fef9c3;
            color: #854d0e;
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }
        .action-btns {
            display: flex;
            gap: 8px;
        }
        .btn-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
            color: white;
        }
        .btn-approve {
            background: #10b981;
        }
        .btn-approve:hover {
            background: #059669;
        }
        .btn-reject {
            background: #ef4444;
        }
        .btn-reject:hover {
            background: #dc2626;
        }
        .footer {
            background: white;
            padding: 20px 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
        }
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                left: -260px;
                height: 100vh;
                z-index: 1000;
                transition: left 0.3s ease;
            }
            .sidebar.mobile-open {
                left: 0;
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
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .chart-grid {
                grid-template-columns: 1fr;
            }
        }
        /* Make the entire wrapper fill the viewport and prevent outer scrolling */
.app-wrapper {
    height: 100vh;
    overflow: hidden;
}

/* Main content area: full height, flex column, no outer scroll */
.main-content {
    height: 100vh;
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

/* Content area (the part with stats, charts, table) becomes scrollable */
.content-area {
    flex: 1;
    overflow-y: auto;
    padding: 30px; /* keep your existing padding */
}
.content-area {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 16px;
    overflow: auto; /* REMOVE SCROLL */
    padding: 20px;
}
.chart-card {
	
    display: flex;
    flex-direction: column;
}
.chart-card {
    background: #ffffff;
    border-radius: 20px;
    padding: 20px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
    transition: all 0.25s ease;
    display: flex;
    flex-direction: column;
}
.chart-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
    border-color: #cbd5e1;
}
.stat-card {
    padding: 16px;
}

.chart-card {
    padding: 26px;
}
.chart-card canvas {
    flex: 1 !important;
}

/* Sidebar: full height, flex column so its header stays fixed */
.sidebar {
    height: 100vh;
    display: flex;
    flex-direction: column;
}

/* Sidebar menu becomes scrollable if items overflow */
.sidebar-menu {
    flex: 1;
    overflow-y: auto;
}

/* Optional: hide scrollbar for a cleaner look (works in WebKit) */
.sidebar-menu::-webkit-scrollbar {
    width: 4px;
}
.sidebar-menu::-webkit-scrollbar-thumb {
    background: rgba(255,255,255,0.2);
    border-radius: 10px;
}
  width: 100%;
}
.chart-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
    height: 30%; /* Adjust this */
}
.chart-card h4 {
    font-size: 1rem;
    font-weight: 600;
    color: #0f172a;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.chart-card h4 i {
    color: #3b82f6;
    font-size: 1.1rem;
}
.chart-container {
    background: #f8fafc; /* light inner background */
    border-radius: 12px;
    padding: 10px;
    height: 300px;
}
</style>
</head>
<body>
    <div class="app-wrapper">
        <!-- Sidebar (unchanged) -->
        <jsp:include page="AdminSidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header is now a separate include -->
            <jsp:include page="AdminHeader.jsp" />

            <!-- Content Area -->
            <div class="content-area">
                <!-- Page title moved here -->
                <h1 class="page-title" style="margin-bottom: 24px;">Dashboard</h1>

                <!-- Stats Cards Row (exactly as before) -->
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
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fas fa-user-friends"></i></div>
                        <div class="stat-content">
                            <h4>Total Participants</h4>
                            <h2>${totalParticipants}</h2>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fas fa-user-tie"></i></div>
                        <div class="stat-content">
                            <h4>Total Judges</h4>
                            <h2>${totalJudges}</h2>
                        </div>
                    </div>
                </div>

                <!-- Charts Row 1 (existing) -->
                <div class="chart-grid">
                    <!-- Doughnut Chart: Hackathon Status Distribution -->
                    <div class="chart-card">
                        <h4><i class="fas fa-chart-pie"></i> Hackathon Status</h4>
                        <div class="chart-container">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>
                    <!-- Bar Chart: User Roles Distribution -->
                    <div class="chart-card">
                        <h4><i class="fas fa-chart-bar"></i> User Roles</h4>
                        <div class="chart-container">
                            <canvas id="roleChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- New Charts Row 2 -->
                <div class="chart-grid">
                    <!-- Line Chart: Registrations Over Time -->
                    <div class="chart-card">
                        <h4><i class="fas fa-chart-line"></i> Registrations Over Time</h4>
                        <div class="chart-container">
                            <canvas id="registrationsChart"></canvas>
                        </div>
                    </div>
                    <!-- Horizontal Bar Chart: Top Hackathons by Participants -->
                    <div class="chart-card">
                        <h4><i class="fas fa-ranking-star"></i> Top Hackathons by Participants</h4>
                        <div class="chart-container">
                            <canvas id="topHackathonsChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Pending Approvals Table (unchanged) -->
                <!-- div class="table-card">
                    <div class="card-header">
                        <h3><i class="fas fa-hourglass-half"></i> Pending Approvals</h3>
                        <a href="#" class="view-all">View all <i class="fas fa-arrow-right"></i></a>
                    </div>
                    <div class="responsive-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role Request</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Tech Innovators</td>
                                    <td>contact@techinn.com</td>
                                    <td>Organizer</td>
                                    <td><span class="badge"><i class="far fa-clock"></i> Pending</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="btn-icon btn-approve" title="Approve"><i class="fas fa-check"></i></button>
                                            <button class="btn-icon btn-reject" title="Reject"><i class="fas fa-times"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div-->

            <!-- Footer (unchanged) -->
            <footer class="footer">
                &copy; 2025 CodeVerse. All rights reserved. Empowering hackathons.
            </footer>
        </div>
    </div>

    <!-- JavaScript for Charts -->
    <script>
        // Hackathon Status Chart (doughnut)
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Upcoming', 'Live', 'Expired'],
                datasets: [{
                    data: [
                        ${upcomingHackathon != null ? upcomingHackathon : 0},
                        ${liveHackathon != null ? liveHackathon : 0},
                        ${totalHackathon - (upcomingHackathon + liveHackathon) + 0}
                    ],
                    backgroundColor: ['#fbbf24', '#10b981', '#94a3b8'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: { legend: { position: 'bottom' } }
            }
        });

        // User Roles Chart (bar)
        const roleCtx = document.getElementById('roleChart').getContext('2d');
        new Chart(roleCtx, {
            type: 'bar',
            data: {
                labels: ['Participants', 'Judges','Admins'],
                datasets: [{
                    label: 'Number of Users',
                    data: [
                        ${totalParticipants != null ? totalParticipants : 0},
                        ${totalJudges != null ? totalJudges : 0},
                        ${totalAdmins != null ? totalAdmins : 0}
                    ],
                    backgroundColor: '#3b82f6',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, grid: { color: '#e2e8f0' } } }
            }
        });

        // Registrations Over Time (line chart)
        const registrationsCtx = document.getElementById('registrationsChart').getContext('2d');
        new Chart(registrationsCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach items="${monthLabels}" var="label" varStatus="loop">
                        '${label}'${!loop.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Registrations',
                    data: [
                        <c:forEach items="${registrationCounts}" var="count" varStatus="loop">
                            ${count}${!loop.last ? ',' : ''}
                        </c:forEach>
                    ],
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, grid: { color: '#e2e8f0' } } }
            }
        });

        // Top Hackathons by Participants (horizontal bar chart)
        const topHackathonsCtx = document.getElementById('topHackathonsChart').getContext('2d');
        new Chart(topHackathonsCtx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach items="${topHackathonNames}" var="name" varStatus="loop">
                        '${name}'${!loop.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Participants',
                    data: [
                        <c:forEach items="${topHackathonParticipants}" var="count" varStatus="loop">
                            ${count}${!loop.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: '#10b981',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                indexAxis: 'y',  // horizontal bars
                plugins: { legend: { display: false } },
                scales: { x: { beginAtZero: true, grid: { color: '#e2e8f0' } } }
            }
        });
    </script>

    <!-- Sidebar toggle JavaScript (unchanged) -->
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
    </script>
</body>
</html>

