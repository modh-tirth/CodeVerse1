<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Judge Dashboard | CodeVerse</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* ========== ROOT VARIABLES & GLOBAL ========== */
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --primary-light: #818cf8;
            --secondary: #0f172a;
            --accent: #22c55e;
            --gray-50: #f8fafc;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-300: #cbd5e1;
            --gray-600: #475569;
            --gray-700: #334155;
            --gray-800: #1e293b;
            --gray-900: #0f172a;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f1f5f9 0%, #eef2ff 100%);
            color: var(--gray-800);
            line-height: 1.5;
            overflow-x: hidden;
        }

        /* ===== MAIN LAYOUT (compatible with sidebar/header) ===== */
        .app-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
        }

        .content-area {
            flex: 1;
            padding: 2rem 2rem 1rem 2rem;
        }

        /* ===== MODERN CARD DESIGN ===== */
        .glass-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(0px);
            border-radius: 28px;
            border: 1px solid rgba(255, 255, 255, 0.5);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .stat-card {
            background: white;
            border-radius: 24px;
            padding: 1.25rem 1.5rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            transition: all 0.25s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light);
        }

        /* ===== BACK LINK ===== */
        .back-link-modern {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
            border-radius: 40px;
            transition: all 0.2s;
            background: rgba(255,255,255,0.6);
        }
        .back-link-modern:hover {
            background: white;
            color: var(--primary);
            transform: translateX(-3px);
        }

        /* ===== PAGE TITLE (GRADIENT TEXT) ===== */
        .page-title {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--gray-900), var(--primary-dark));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            letter-spacing: -0.02em;
            margin: 0.5rem 0 0;
        }

        /* ===== BUTTONS ===== */
        .btn-primary-custom {
            background: linear-gradient(105deg, var(--primary) 0%, var(--primary-dark) 100%);
            border: none;
            border-radius: 40px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary-custom:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            color: white;
        }

        .btn-outline-custom {
            background: white;
            border: 1px solid #e2e8f0;
            color: #334155;
            border-radius: 40px;
            padding: 0.35rem 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-outline-custom:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }

        .hackathon-item {
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 1rem;
            transition: all 0.2s;
            background: white;
            height: 100%;
        }
        .hackathon-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
        }

        .pill {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 30px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .pill-pending {
            background: #fef3c7;
            color: #d97706;
        }
        .pill-done {
            background: #d1fae5;
            color: #059669;
        }

        .table-custom th {
            background: #f8fafc;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 1px solid #e2e8f0;
            padding: 1rem;
        }
        .table-custom td {
            vertical-align: middle;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .footer {
            padding: 1rem 2rem;
            text-align: center;
            font-size: 0.8rem;
            color: var(--gray-600);
            border-top: 1px solid var(--gray-200);
            background: rgba(255,255,255,0.6);
            margin-top: auto;
        }

        @media (max-width: 768px) {
            .content-area { padding: 1rem; }
            .page-title { font-size: 1.5rem; }
            .stat-card { padding: 0.8rem 1rem; }
        }
        /* 1. Ensure the app-wrapper takes full height and prevents body scroll */
html, body {
    height: 100%;
    overflow: hidden; /* Prevent double scrollbars */
}

.app-wrapper {
    display: flex;
    height: 100vh; /* Lock height to viewport */
    width: 100vw;
}

/* 2. Make Sidebar height 100% and non-scrollable (unless menu is too long) */
.sidebar {
    width: 260px;
    height: 100vh;
    background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
    color: #e2e8f0;
    display: flex;
    flex-direction: column;
    flex-shrink: 0; /* Prevent sidebar from shrinking */
    z-index: 1001;
    overflow-y: auto; /* Scrollable menu if items exceed screen height */
}

/* 3. Main Content should be a flex column that handles its own scroll */
.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    height: 100vh;
    overflow: hidden; /* Header stays top, only content-area scrolls */
}

/* 4. Fix the Header to the top */
.top-header {
    flex-shrink: 0; /* Don't let header squish */
    background: white;
    padding: 16px 30px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 2px 10px rgba(0,0,0,0.02);
    border-bottom: 1px solid #e9eef2;
    z-index: 1000;
}

/* 5. This is the only part that should scroll */
.content-area {
    padding: 30px;
    flex: 1;
    overflow-y: auto; /* Enable scrolling for the table and content only */
    background: #f8fafc;
}
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="JudgeSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="JudgeHeader.jsp" />
        <div class="content-area">
            <!-- Header & Back -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
                <div>
                    <a href="${pageContext.request.contextPath}/judge/judge-dashboard" class="back-link-modern mb-2 d-inline-block">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <h1 class="page-title mt-2">Judge Dashboard</h1>
                    <p class="text-muted mt-1">Review hackathons and manage your judging tasks.</p>
                </div>
                <div class="mt-2 mt-sm-0">
                    <span class="badge bg-light text-dark p-2 px-3 rounded-pill shadow-sm">
                        <i class="far fa-calendar-alt me-1"></i> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMM dd, yyyy" />
                    </span>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row g-4 mb-5">
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Total Hackathons</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem;">${totalHackathon}</h2>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-trophy fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Upcoming</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem; color:#d97706;">${upcomingHackathon}</h2>
                        </div>
                        <div class="bg-warning bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-calendar-plus fa-2x text-warning"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Ongoing</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem; color:#10b981;">${ongoingHackathon}</h2>
                        </div>
                        <div class="bg-success bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-play-circle fa-2x text-success"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Pending Submissions</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem; color:#ef4444;">${pendingReviewSubmission}</h2>
                        </div>
                        <div class="bg-danger bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-hourglass-half fa-2x text-danger"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Judge Workspace Panel -->
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-chalkboard-user me-2 text-primary"></i> Judge Workspace</h5>
                    <p class="text-muted mb-3">Open your assigned submissions, review each team, and save round‑wise scores from your judging panel.</p>
                    <a href="${pageContext.request.contextPath}/judge/submissions" class="btn-primary-custom">
                        <i class="fas fa-arrow-right"></i> Go to Submission Review
                    </a>
                </div>
            </div>

            <!-- Ongoing Hackathons Assigned -->
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-calendar-alt me-2 text-primary"></i> Ongoing Hackathons Assigned To You</h5>
                    <c:choose>
                        <c:when test="${empty ongoingHackathonList}">
                            <p class="text-muted text-center py-3">No ongoing hackathons assigned right now.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="row g-3">
                                <c:forEach items="${ongoingHackathonList}" var="h">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="hackathon-item">
                                            <div class="hackathon-title">${h.title}</div>
                                            <div class="text-muted small mt-1">
                                                <i class="fas fa-tag me-1"></i> ${h.eventType} | ${h.payment}
                                            </div>
                                            <div class="text-muted small mt-1">
                                                <i class="far fa-calendar-alt me-1"></i> ${h.registrationStartDate} to ${h.registrationEndDate}
                                            </div>
                                            <div class="mt-3">
                                                <a href="${pageContext.request.contextPath}/judge/viewHackathon?hackathonId=${h.hackathonId}" class="btn-outline-custom btn-sm">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Pending Submissions -->
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-hourglass-half me-2 text-warning"></i> Pending Submissions</h5>
                    <c:choose>
                        <c:when test="${empty pendingSubmissionList}">
                            <p class="text-muted text-center py-3">No pending submissions for your review.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom mb-0">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Hackathon</th>
                                            <th>Team</th>
                                            <th>Submitted Date</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </thead>
                                    <tbody>
                                        <c:forEach items="${pendingSubmissionList}" var="s" varStatus="i">
                                             <tr>
                                                <td>${i.count}</td>
                                                <td class="fw-semibold">${submissionHackathonMap[s.hackathonId].title}</td>
                                                <td>${submissionTeamMap[s.teamId].teamName}</td>
                                                <td>${s.submitedDate}</td>
                                                <td><span class="pill pill-pending">Pending</span></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-outline-custom btn-sm">
                                                        <i class="fas fa-pen"></i> Review
                                                    </a>
                                                </td>
                                             </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Reviewed Submissions -->
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-check-circle me-2 text-success"></i> Reviewed Submissions</h5>
                    <c:choose>
                        <c:when test="${empty reviewedSubmissionList}">
                            <p class="text-muted text-center py-3">No reviewed submissions yet.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom mb-0">
                                    <thead>
                                         <tr>
                                            <th>#</th>
                                            <th>Hackathon</th>
                                            <th>Team</th>
                                            <th>Submitted Date</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                         </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${reviewedSubmissionList}" var="s" varStatus="i">
                                             <tr>
                                                <td>${i.count}</td>
                                                <td class="fw-semibold">${submissionHackathonMap[s.hackathonId].title}</td>
                                                <td>${submissionTeamMap[s.teamId].teamName}</td>
                                                <td>${s.submitedDate}</td>
                                                <td><span class="pill pill-done">Reviewed</span></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-outline-custom btn-sm">
                                                        <i class="fas fa-edit"></i> Update Review
                                                    </a>
                                                </td>
                                             </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <footer class="footer">
            <div>© CodeVerse Judge Panel — Empowering fair evaluations</div>
            <div class="mt-1"><a href="#" class="text-decoration-none text-secondary">Support</a> | <a href="#" class="text-decoration-none text-secondary">Guidelines</a></div>
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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