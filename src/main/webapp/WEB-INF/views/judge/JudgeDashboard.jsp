<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Dashboard | CodeVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }
        .page-container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }
        .hero-card {
            background: linear-gradient(135deg, #0f9d94 0%, #127fcb 100%);
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }
        .hero-card h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .hero-card p {
            opacity: 0.9;
            margin-bottom: 0;
        }
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 1.25rem;
            text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 30px -12px rgba(0,0,0,0.1);
        }
        .stat-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #64748b;
            letter-spacing: 0.5px;
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #0f9d94;
            margin-top: 0.5rem;
            line-height: 1;
        }
        .dashboard-card {
            background: white;
            border-radius: 24px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .dashboard-card .card-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 1.25rem 1.5rem;
            font-weight: 700;
            font-size: 1.1rem;
        }
        .dashboard-card .card-body {
            padding: 1.5rem;
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
        .hackathon-title {
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }
        .btn-outline-light-custom {
            background: white;
            border: 1px solid #e2e8f0;
            color: #334155;
            border-radius: 40px;
            padding: 0.35rem 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-outline-light-custom:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #0f9d94, #127fcb);
            border: none;
            border-radius: 40px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-primary-custom:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15,157,148,0.3);
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
        }
        .table-custom td {
            vertical-align: middle;
            padding: 0.75rem;
            border-bottom: 1px solid #e2e8f0;
        }
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        footer {
            margin-top: 2rem;
            text-align: center;
            padding: 1rem;
            color: #64748b;
            font-size: 0.8rem;
        }
        @media (max-width: 768px) {
            .page-container { padding: 1rem; }
            .hero-card { padding: 1.5rem; }
            .hero-card h1 { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Hero Section -->
    <div class="hero-card">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div>
                <h1>Welcome Judge ${sessionScope.user.firstName}</h1>
                <p class="mb-0">Review hackathons and manage your judging tasks from one place.</p>
            </div>
            <div class="action-buttons">
                <a href="/judge/submissions" class="btn btn-light rounded-pill px-3 py-2 fw-semibold">
                    <i class="fas fa-file-alt me-2"></i>Review Submissions
                </a>
                <a href="/judge/profile" class="btn btn-light rounded-pill px-3 py-2 fw-semibold">
                    <i class="fas fa-user me-2"></i>My Profile
                </a>
                <a href="/judge/change-password" class="btn btn-light rounded-pill px-3 py-2 fw-semibold">
                    <i class="fas fa-key me-2"></i>Change Password
                </a>
                <a href="/logout" class="btn btn-light rounded-pill px-3 py-2 fw-semibold">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-label">Total Hackathons</div>
                <div class="stat-number">${totalHackathon}</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-label">Upcoming</div>
                <div class="stat-number">${upcomingHackathon}</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-label">Ongoing</div>
                <div class="stat-number">${ongoingHackathon}</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-label">Pending Submissions</div>
                <div class="stat-number">${pendingReviewSubmission}</div>
            </div>
        </div>
    </div>

    <!-- Judge Workspace Panel -->
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-chalkboard-user me-2 text-primary"></i> Judge Workspace
        </div>
        <div class="card-body">
            <p class="text-muted">Open your assigned submissions, review each team, and save round-wise scores from your judging panel.</p>
            <a href="/judge/submissions" class="btn btn-primary-custom">
                <i class="fas fa-arrow-right me-2"></i>Go to Submission Review
            </a>
        </div>
    </div>

    <!-- Ongoing Hackathons Assigned -->
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-calendar-alt me-2 text-primary"></i> Ongoing Hackathons Assigned To You
        </div>
        <div class="card-body">
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
                                        <a href="/judge/viewHackathon?hackathonId=${h.hackathonId}" class="btn btn-outline-light-custom btn-sm">
                                            <i class="fas fa-eye me-1"></i> View
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
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-hourglass-half me-2 text-warning"></i> Pending Submissions
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty pendingSubmissionList}">
                    <div class="p-4 text-center text-muted">No pending submissions for your review.</div>
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
                                <c:forEach items="${pendingSubmissionList}" var="s" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td>${submissionHackathonMap[s.hackathonId].title}</td>
                                        <td>${submissionTeamMap[s.teamId].teamName}</td>
                                        <td>${s.submitedDate}</td>
                                        <td><span class="pill pill-pending">Pending</span></td>
                                        <td>
                                            <a href="/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn btn-outline-light-custom btn-sm">
                                                <i class="fas fa-pen me-1"></i> Review
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
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-check-circle me-2 text-success"></i> Reviewed Submissions
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty reviewedSubmissionList}">
                    <div class="p-4 text-center text-muted">No reviewed submissions yet.</div>
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
                                        <td>${submissionHackathonMap[s.hackathonId].title}</td>
                                        <td>${submissionTeamMap[s.teamId].teamName}</td>
                                        <td>${s.submitedDate}</td>
                                        <td><span class="pill pill-done">Reviewed</span></td>
                                        <td>
                                            <a href="/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn btn-outline-light-custom btn-sm">
                                                <i class="fas fa-edit me-1"></i> Update Review
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

    <footer>
        <div>CodeVerse Judge Panel</div>
        <div class="mt-1">Need help? <a href="/logout" class="text-decoration-none">Contact Admin</a></div>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>