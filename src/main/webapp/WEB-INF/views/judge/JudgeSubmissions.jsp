<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Submissions | CodeVerse</title>
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
            color: #0f9d94;
        }
        .title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0.5rem 0 0;
        }
        .dashboard-card {
            background: white;
            border-radius: 24px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            margin-top: 1.5rem;
            overflow: hidden;
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
            color: #64748b;
            border-bottom: 1px solid #e2e8f0;
            padding: 0.75rem 1rem;
        }
        .table-custom td {
            vertical-align: middle;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        .badge-custom {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-pending {
            background: #fef3c7;
            color: #d97706;
        }
        .badge-reviewed {
            background: #d1fae5;
            color: #059669;
        }
        .btn-review {
            background: linear-gradient(135deg, #0f9d94, #127fcb);
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
        .btn-review:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15,157,148,0.3);
            color: white;
        }
        .alert-success-custom {
            background: white;
            border-left: 4px solid #22c55e;
            border-radius: 20px;
            padding: 1rem 1.25rem;
            margin-top: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        @media (max-width: 768px) {
            .page-container { padding: 1rem; }
            .title { font-size: 1.5rem; }
            .table-custom th, .table-custom td { padding: 0.5rem; }
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Header -->
    <div>
        <a href="/judge-dashboard" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <h1 class="title">Hackathon Submissions</h1>
    </div>

    <!-- Success message -->
    <c:if test="${param.saved == 'true'}">
        <div class="alert-success-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle text-success me-2"></i> Review score saved successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Submissions Table -->
    <div class="dashboard-card">
        <div class="table-responsive">
            <table class="table table-custom">
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
                    <c:if test="${empty submissions}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                <i class="fas fa-inbox me-2"></i> No submissions assigned yet.
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach items="${submissions}" var="s" varStatus="i">
                        <tr>
                            <td>${i.count}</td>
                            <td class="fw-semibold">${hackathonMap[s.hackathonId].title}</td>
                            <td>${teamMap[s.teamId].teamName}</td>
                            <td>${s.submitedDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${reviewedMap[s.hackathonSubmissionId]}">
                                        <span class="badge-custom badge-reviewed">Reviewed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-custom badge-pending">Pending</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-review">
                                    <i class="fas fa-pen me-1"></i> Review
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>