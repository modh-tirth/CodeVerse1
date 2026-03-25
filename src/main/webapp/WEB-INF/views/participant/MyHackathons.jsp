<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Hackathons | CodeVerse</title>
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
        .page-header {
            background: white;
            border-radius: 24px;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #64748b;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .back-link:hover {
            color: #3b82f6;
        }
        .title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0.75rem 0 0.25rem;
        }
        .subtitle {
            color: #64748b;
            margin-bottom: 0;
        }
        .total-badge {
            background: linear-gradient(135deg, #eef2ff, #e0e7ff);
            color: #1e40af;
            border-radius: 40px;
            padding: 0.5rem 1.25rem;
            font-weight: 600;
            font-size: 0.9rem;
        }
        .hackathon-card {
            border: none;
            border-radius: 20px;
            background: white;
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03), 0 1px 2px rgba(0,0,0,0.05);
        }
        .hackathon-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 30px -12px rgba(0,0,0,0.1);
        }
        .card-body-custom {
            padding: 1.5rem;
            flex: 1;
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #0f172a;
        }
        .badge-custom {
            font-size: 0.7rem;
            font-weight: 600;
            padding: 0.35rem 0.75rem;
            border-radius: 30px;
            background: #f1f5f9;
            color: #475569;
        }
        .badge-leader {
            background: #eef2ff;
            color: #2563eb;
        }
        .badge-member {
            background: #f3e8ff;
            color: #9333ea;
        }
        .badge-pending {
            background: #fef3c7;
            color: #d97706;
        }
        .desc {
            color: #475569;
            font-size: 0.9rem;
            line-height: 1.5;
            margin: 1rem 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-top: 1rem;
        }
        .btn-custom {
            border-radius: 40px;
            padding: 0.5rem 1rem;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.2s;
            flex: 1;
            text-align: center;
            white-space: nowrap;
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border: none;
            color: white;
        }
        .btn-primary-custom:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59,130,246,0.3);
            color: white;
        }
        .btn-outline-custom {
            background: white;
            border: 1px solid #e2e8f0;
            color: #334155;
        }
        .btn-outline-custom:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }
        .btn-submission {
            background: #0f766e;
            border: none;
            color: white;
        }
        .btn-leaderboard {
            background: #1d4ed8;
            border: none;
            color: white;
        }
        .btn-disabled-custom {
            background: #e2e8f0;
            border: none;
            color: #94a3b8;
            cursor: not-allowed;
            pointer-events: none;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        .empty-state i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
        .empty-state h4 {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        @media (max-width: 768px) {
            .page-container { padding: 1rem; }
            .page-header { padding: 1.25rem; }
            .title { font-size: 1.5rem; }
            .action-buttons { flex-wrap: wrap; }
            .btn-custom { white-space: normal; }
        }
    </style>
</head>
<body>


<div class="page-container">
    <!-- Header Section -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <a href="${pageContext.request.contextPath}/participant/home" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
                <h1 class="title">My Hackathons</h1>
                <p class="subtitle">Manage all hackathons where you are part of a team.</p>
            </div>
            <div class="total-badge">
                <i class="fas fa-calendar-alt me-2"></i> Total: ${totalCount}
            </div>
        </div>
    </div>

    <!-- Content: Grid of hackathons or empty state -->
    <c:choose>
        <c:when test="${empty myHackathons}">
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <h4>No joined hackathons yet</h4>
                <p class="text-muted">Join a hackathon from the home page and it will appear here.</p>
                <a href="${pageContext.request.contextPath}/participant/home" class="btn btn-primary mt-3">
                    <i class="fas fa-search me-2"></i> Explore Hackathons
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach items="${myHackathons}" var="m">
                    <div class="col-md-6 col-lg-4">
                        <div class="hackathon-card">
                            <div class="card-body-custom">
                                <h5 class="card-title">${m.hackathon.title}</h5>
                                
                                <!-- Meta badges -->
                                <div class="d-flex flex-wrap gap-2 mb-3">
                                    <span class="badge-custom">${m.hackathon.status}</span>
                                    <span class="badge-custom">${m.hackathon.eventType}</span>
                                    <span class="badge-custom"><i class="fas fa-users me-1"></i> ${m.teamSize} members</span>
                                    <span class="badge-custom"><i class="fas fa-envelope me-1"></i> ${m.pendingInvites} pending invites</span>
                                    <span class="badge-custom ${m.leader ? 'badge-leader' : 'badge-member'}">
                                        <i class="fas ${m.leader ? 'fa-crown' : 'fa-user'} me-1"></i> ${m.leader ? 'Team Leader' : m.roleTitle}
                                    </span>
                                </div>
                                
                                <p class="desc">${m.hackathon.description}</p>
                                
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/participant/hackathon/${m.hackathon.hackathonId}" 
                                       class="btn btn-outline-custom btn-custom">
                                        <i class="fas fa-eye me-1"></i> View Details
                                    </a>
                                    <a href="${pageContext.request.contextPath}/participant/hackathon/${m.hackathon.hackathonId}/team" 
                                       class="btn btn-primary-custom btn-custom">
                                        <i class="fas fa-users me-1"></i> Manage Team
                                    </a>
                                    
                                    <c:if test="${not empty m.teamId}">
                                        <c:choose>
                                            <c:when test="${m.submissionEnabled}">
                                                <a href="${pageContext.request.contextPath}/participant/hackathon/${m.hackathon.hackathonId}/submission" 
                                                   class="btn btn-submission btn-custom">
                                                    <i class="fas fa-upload me-1"></i> Submission
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="btn btn-disabled-custom btn-custom" title="Submission opens after registration end date">
                                                    <i class="fas fa-lock me-1"></i> Submission
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    
                                    <c:if test="${m.hackathon.status == 'COMPLETE' || m.hackathon.status == 'COMPLETED'}">
                                        <a href="${pageContext.request.contextPath}/participant/hackathon/${m.hackathon.hackathonId}/leaderboard" 
                                           class="btn btn-leaderboard btn-custom">
                                            <i class="fas fa-chart-line me-1"></i> Leaderboard
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>