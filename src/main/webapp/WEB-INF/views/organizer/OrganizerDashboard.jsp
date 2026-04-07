<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Organizer Dashboard | CodeVerse</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f5f7fb;
            overflow-x: hidden;
        }

        /* Main app wrapper with sidebar + main content */
        .app-wrapper {
            display: flex;
            height: 100vh;
            width: 100%;
            overflow: hidden;
        }

        /* Main content area (right side) */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            background: #f8fafc;
        }

        /* Content area inside main (scrollable) */
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }

        /* Stats grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: 0.2s;
            border-left: 4px solid #3b82f6;
        }
        .stat-card h3 {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 0.5rem;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #0f172a;
        }

        /* Two columns layout */
        .row-2cols {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .card h2 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #1e293b;
        }

        /* Status badges */
        .status-badge {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            border-radius: 1rem;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .status-upcoming { background: #fef9c3; color: #854d0e; }
        .status-live { background: #d1fae5; color: #065f46; }
        .status-completed { background: #e0e7ff; color: #3730a3; }
        .status-expired { background: #fee2e2; color: #991b1b; }

        /* Hackathon list */
        .hackathon-list {
            max-height: 400px;
            overflow-y: auto;
        }
        .hackathon-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e2e8f0;
        }
        .hackathon-title {
            font-weight: 500;
        }
        .hackathon-actions a {
            margin-left: 0.75rem;
            font-size: 0.8rem;
            color: #3b82f6;
            text-decoration: none;
        }

        canvas {
            max-height: 300px;
            width: 100%;
        }

        /* Fallback for chart */
        .chart-fallback {
            text-align: center;
            padding: 2rem;
            color: #64748b;
            background: #f1f5f9;
            border-radius: 0.5rem;
        }

        /* Footer */
        .footer {
            background: white;
            padding: 1rem 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.8rem;
            flex-shrink: 0;
        }

        @media (max-width: 768px) {
            .row-2cols {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .content-area {
                padding: 20px;
            }
            .stats-grid {
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <!-- Sidebar -->
    <jsp:include page="OrganizerSidebar.jsp" />
    
    <div class="main-content">
        <!-- Header -->
        <jsp:include page="OrganizerHeader.jsp" />
        
        <!-- Main content area -->
        <div class="content-area">
            <h1 style="font-size: 1.5rem; font-weight: 700; color: #0f172a; margin-bottom: 24px;">
                <i class="fas fa-chart-line"></i> Dashboard
            </h1>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Hackathons</h3>
                    <div class="stat-number">${totalHackathons}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Participants</h3>
                    <div class="stat-number">${totalParticipants}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Revenue</h3>
                    <div class="stat-number">$${totalRevenue}</div>
                </div>
                <div class="stat-card">
                    <h3>Avg Participants / Hackathon</h3>
                    <div class="stat-number">
                        <c:choose>
                            <c:when test="${totalHackathons > 0}">${Math.round(totalParticipants / totalHackathons)}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Status & Chart row -->
            <div class="row-2cols">
                <!-- Status Breakdown -->
                <div class="card">
                    <h2><i class="fas fa-chart-pie"></i> Hackathon Status</h2>
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <div><span class="status-badge status-upcoming">UPCOMING</span> <strong>${upcomingCount}</strong> hackathons</div>
                        <div><span class="status-badge status-live">LIVE / ONGOING</span> <strong>${liveCount}</strong> hackathons</div>
                        <div><span class="status-badge status-completed">COMPLETED</span> <strong>${completedCount}</strong> hackathons</div>
                        <div><span class="status-badge status-expired">EXPIRED</span> <strong>${expiredCount}</strong> hackathons</div>
                    </div>
                </div>

                <!-- Participants per Hackathon Chart -->
                <div class="card">
                    <h2><i class="fas fa-users"></i> Participants per Hackathon</h2>
                    <canvas id="participantsChart" width="400" height="250"></canvas>
                    <div id="chartFallback" class="chart-fallback" style="display:none;">No participant data available</div>
                </div>
            </div>
            
            <!-- My Hackathons List -->
            <div class="card">
                <h2><i class="fas fa-calendar-alt"></i> My Hackathons</h2>
                <div class="hackathon-list">
                    <c:forEach items="${hackathons}" var="h">
                        <div class="hackathon-item">
                            <div>
                                <div class="hackathon-title"><strong>${h.title}</strong></div>
                                <div style="font-size: 0.8rem; color: #475569;">
                                    ${h.location} | 
                                    <span class="status-badge status-${fn:toLowerCase(h.status)}">${h.status}</span>
                                </div>
                            </div>
                            <div class="hackathon-actions">
                                <a href="/organizer/edit-hackathon?hackathonId=${h.hackathonId}">Edit</a>
                                <a href="/organizer/manage-judges?hackathonId=${h.hackathonId}">Manage Judges</a>
                                <a href="/organizer/delete-hackathon?hackathonId=${h.hackathonId}" onclick="return confirm('Delete?')">Delete</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty hackathons}">
                        <div style="text-align: center; padding: 2rem; color: #64748b;">
                            You haven't created any hackathons yet. 
                            <a href="/organizer/create-hackathon">Create one</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <footer class="footer">
            © 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Build JavaScript arrays from JSTL
    const hackathonNames = [
        <c:forEach items="${hackathonNames}" var="name" varStatus="loop">
            '${name}'${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    const participantCounts = [
        <c:forEach items="${participantCounts}" var="count" varStatus="loop">
            ${count}${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    
    const totalParticipants = participantCounts.reduce((a,b) => a + b, 0);
    if (hackathonNames.length === 0 || totalParticipants === 0) {
        document.getElementById('participantsChart').style.display = 'none';
        document.getElementById('chartFallback').style.display = 'block';
    } else {
        new Chart(document.getElementById('participantsChart'), {
            type: 'bar',
            data: {
                labels: hackathonNames,
                datasets: [{
                    label: 'Number of Participants',
                    data: participantCounts,
                    backgroundColor: '#3b82f6',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { position: 'top' },
                    tooltip: { callbacks: { label: (ctx) => `${ctx.raw} participants` } }
                },
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Participants' } }
                }
            }
        });
    }
});
</script>
</body>
</html>