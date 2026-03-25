<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${hackathon.title} | Leaderboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }
        .page-container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }
        /* Header Card */
        .hero-card {
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
            color: #475569;
            margin-bottom: 0;
        }
        .badge-custom {
            background: #f1f5f9;
            color: #334155;
            border-radius: 40px;
            padding: 0.35rem 1rem;
            font-size: 0.8rem;
            font-weight: 500;
        }
        /* Leaderboard Table Card */
        .table-card {
            background: white;
            border-radius: 24px;
            padding: 0;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .table-custom {
            margin-bottom: 0;
        }
        .table-custom th {
            background: #f8fafc;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
            padding: 1rem 1rem;
        }
        .table-custom td {
            padding: 0.9rem 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
        }
        .table-custom tr:hover {
            background: #fefce8;
        }
        .rank-number {
            font-weight: 700;
            font-size: 1rem;
        }
        .rank-top3 {
            background: linear-gradient(135deg, #f59e0b, #ef4444);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            font-weight: 800;
        }
        .team-name {
            font-weight: 600;
            color: #0f172a;
        }
        .score-highlight {
            font-weight: 700;
            color: #3b82f6;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
        }
        .empty-state i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
        .empty-state h5 {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .info-note {
            background: #fef9e3;
            border-left: 4px solid #f59e0b;
            padding: 0.75rem 1rem;
            border-radius: 12px;
            margin-top: 1rem;
        }
        @media (max-width: 768px) {
            .page-container { padding: 1rem; }
            .hero-card { padding: 1.25rem; }
            .title { font-size: 1.5rem; }
            .table-custom th, .table-custom td { padding: 0.75rem; }
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Hero Section -->
    <div class="hero-card">
        <a href="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Hackathon
        </a>
        <h1 class="title">Leaderboard</h1>
        <p class="subtitle">${hackathon.title}</p>
        <div class="d-flex flex-wrap gap-2 mt-3">
            <span class="badge-custom"><i class="fas fa-chart-line me-1"></i> Status: ${hackathon.status}</span>
            <span class="badge-custom"><i class="fas fa-users me-1"></i> Teams: ${totalTeams}</span>
            <span class="badge-custom"><i class="fas fa-star me-1"></i> Total Reviews: ${totalEvaluations}</span>
        </div>
    </div>

    <!-- Leaderboard Table -->
    <div class="table-card">
        <c:choose>
            <c:when test="${empty leaderboardRows}">
                <div class="empty-state">
                    <i class="fas fa-chart-simple"></i>
                    <h5>No scores available yet</h5>
                    <p class="text-muted">Scores will appear after evaluations are completed.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th><i class="fas fa-trophy me-1"></i> Rank</th>
                                <th><i class="fas fa-users me-1"></i> Team</th>
                                <th><i class="fas fa-star me-1"></i> Total Score</th>
                                <th><i class="fas fa-chart-simple me-1"></i> Reviews</th>
                                <th><i class="fas fa-calculator me-1"></i> Average Score</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${leaderboardRows}" var="r">
                                <tr>
                                    <td>
                                        <span class="rank-number ${r.rank <= 3 ? 'rank-top3' : ''}">
                                            <c:choose>
                                                <c:when test="${r.rank == 1}"><i class="fas fa-crown text-warning me-1"></i></c:when>
                                                <c:when test="${r.rank == 2}"><i class="fas fa-medal text-secondary me-1"></i></c:when>
                                                <c:when test="${r.rank == 3}"><i class="fas fa-medal text-orange-600 me-1"></i></c:when>
                                            </c:choose>
                                            #${r.rank}
                                        </span>
                                    </td>
                                    <td class="team-name">${r.teamName}</td>
                                    <td class="score-highlight">${r.totalScore}</td>
                                    <td>${r.evaluationCount}</td>
                                    <td class="score-highlight">
                                        <fmt:formatNumber value="${r.averageScore}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="info-note">
                    <i class="fas fa-info-circle me-2"></i> Ranking is based on highest average score, then total score.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>