<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${hackathon.title} | Judge View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }
        .page-container {
            max-width: 1200px;
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
            margin-bottom: 1rem;
        }
        .btn-back {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.4);
            border-radius: 40px;
            padding: 0.5rem 1.25rem;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-back:hover {
            background: rgba(255,255,255,0.3);
            color: white;
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
        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1rem;
        }
        .meta-item {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1rem;
            border: 1px solid #e2e8f0;
        }
        .meta-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #64748b;
            letter-spacing: 0.5px;
        }
        .meta-value {
            font-weight: 700;
            color: #0f172a;
            margin-top: 0.25rem;
        }
        .description-card {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1.25rem;
            margin-top: 1rem;
            border: 1px solid #e2e8f0;
        }
        .judge-card {
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 1rem;
            transition: all 0.2s;
            background: white;
            height: 100%;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .judge-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
        }
        .judge-avatar {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e2e8f0;
        }
        .judge-name {
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        .judge-email {
            font-size: 0.75rem;
            color: #64748b;
        }
        .judge-meta {
            font-size: 0.7rem;
            color: #475569;
            margin-top: 0.25rem;
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
        .btn-action {
            background: #0f9d94;
            border: none;
            border-radius: 40px;
            padding: 0.35rem 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background: #0e8a82;
            color: white;
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
        <h1>${hackathon.title}</h1>
        <p>Judge view for assigned hackathon details.</p>
        <a href="/judge-dashboard" class="btn-back">
            <i class="fas fa-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>

    <!-- Hackathon Information -->
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-info-circle me-2 text-primary"></i> Hackathon Information
        </div>
        <div class="card-body">
            <div class="meta-grid">
                <div class="meta-item">
                    <div class="meta-label">Status</div>
                    <div class="meta-value">${hackathon.status}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Event Type</div>
                    <div class="meta-value">${hackathon.eventType}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Payment</div>
                    <div class="meta-value">${hackathon.payment}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Team Size</div>
                    <div class="meta-value">${hackathon.minTeamSize} - ${hackathon.maxTeamSize}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Location</div>
                    <div class="meta-value">${hackathon.location}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Registration</div>
                    <div class="meta-value">${hackathon.registrationStartDate} to ${hackathon.registrationEndDate}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Overview -->
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-align-left me-2 text-primary"></i> Overview
        </div>
        <div class="card-body">
            <p class="text-muted">${hackathon.description}</p>
            <div class="description-card">
                <c:choose>
                    <c:when test="${not empty hackathonDescription}">
                        <c:out value="${hackathonDescription.hackathonDetails}" escapeXml="false" />
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">No detailed description provided.</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Assigned Judges -->
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-users me-2 text-primary"></i> Assigned Judges
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty judgeUsers}">
                    <p class="text-muted text-center py-3">No judges assigned.</p>
                </c:when>
                <c:otherwise>
                    <div class="row g-3">
                        <c:forEach items="${judgeUsers}" var="j">
                            <div class="col-md-6 col-lg-4">
                                <div class="judge-card">
                                    <c:choose>
                                        <c:when test="${not empty j.profilePicURL}">
                                            <img src="${j.profilePicURL}" class="judge-avatar" alt="judge">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/assets/images/faces/dummy.jpg" class="judge-avatar" alt="judge">
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <div class="judge-name">${j.firstName} ${j.lastName}</div>
                                        <div class="judge-email">${j.email}</div>
                                        <c:if test="${not empty j.designation}">
                                            <div class="judge-meta"><i class="fas fa-briefcase me-1"></i> ${j.designation}</div>
                                        </c:if>
                                        <c:if test="${not empty j.organization}">
                                            <div class="judge-meta"><i class="fas fa-building me-1"></i> ${j.organization}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Prize Details -->
    <div class="dashboard-card">
        <div class="card-header">
            <i class="fas fa-trophy me-2 text-primary"></i> Prize Details
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty prizeList}">
                    <div class="p-4 text-center text-muted">No prize details available.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-custom mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Prize Title</th>
                                    <th>Prize Description</th>
                                 </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${prizeList}" var="p" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td class="fw-semibold">${p.prizeTitle}</td>
                                        <td>${p.prizeDescription}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
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
                    <div class="p-4 text-center text-muted">No pending submissions for this hackathon.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-custom mb-0">
                            <thead>
                                30
                                    <th>#</th>
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
                                        <td class="fw-semibold">${submissionTeamMap[s.teamId].teamName}</td>
                                        <td>${s.submitedDate}</td>
                                        <td><span class="pill pill-pending">Pending</span></td>
                                        <td>
                                            <a href="/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-action">
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
                    <div class="p-4 text-center text-muted">No reviewed submissions yet for this hackathon.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-custom mb-0">
                            <thead>
                                30
                                    <th>#</th>
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
                                        <td class="fw-semibold">${submissionTeamMap[s.teamId].teamName}</td>
                                        <td>${s.submitedDate}</td>
                                        <td><span class="pill pill-done">Reviewed</span></td>
                                        <td>
                                            <a href="/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-action">
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
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>