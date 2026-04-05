<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${hackathon.title} | Judge View</title>
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

        /* ===== META GRID ===== */
        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .meta-item {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1rem;
            border: 1px solid var(--gray-200);
        }
        .meta-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            font-weight: 600;
            color: var(--gray-600);
            letter-spacing: 0.5px;
        }
        .meta-value {
            font-weight: 700;
            color: var(--gray-800);
            margin-top: 0.25rem;
        }

        /* ===== JUDGE CARDS ===== */
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
            box-shadow: var(--shadow-md);
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

        /* ===== PILLS ===== */
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

        /* ===== TABLE STYLES ===== */
        .table-modern {
            margin-bottom: 0;
        }
        .table-modern thead th {
            background: var(--gray-50);
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--gray-600);
            padding: 1rem 1.25rem;
            border-bottom: 1.5px solid var(--gray-200);
            white-space: nowrap;
        }
        .table-modern tbody td {
            padding: 1rem 1.25rem;
            vertical-align: middle;
            border-bottom: 1px solid var(--gray-200);
            font-size: 0.9rem;
        }
        .btn-action {
            background: linear-gradient(105deg, var(--primary) 0%, var(--primary-dark) 100%);
            border: none;
            border-radius: 40px;
            padding: 0.45rem 1.2rem;
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
            transform: translateY(-2px);
            background: linear-gradient(105deg, var(--primary-dark) 0%, var(--primary) 100%);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            color: white;
        }

        /* ===== FOOTER ===== */
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
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <h1 class="page-title mt-2">${hackathon.title}</h1>
                    <p class="text-muted mt-1">Judge view for assigned hackathon details</p>
                </div>
            </div>

            <!-- Hackathon Information -->
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
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
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <p class="text-muted">${hackathon.description}</p>
                    <c:if test="${not empty hackathonDescription}">
                        <div class="mt-3 p-3 bg-light rounded-4 border">
                            <c:out value="${hackathonDescription.hackathonDetails}" escapeXml="false" />
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Assigned Judges -->
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-users me-2 text-primary"></i> Assigned Judges</h5>
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
                                                    <div class="judge-avatar bg-secondary d-flex align-items-center justify-content-center text-white">
                                                        <i class="fas fa-user fa-lg"></i>
                                                    </div>
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
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-trophy me-2 text-primary"></i> Prize Details</h5>
                    <c:choose>
                        <c:when test="${empty prizeList}">
                            <p class="text-muted text-center py-3">No prize details available.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-modern">
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
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-hourglass-half me-2 text-warning"></i> Pending Submissions</h5>
                    <c:choose>
                        <c:when test="${empty pendingSubmissionList}">
                            <p class="text-muted text-center py-3">No pending submissions for this hackathon.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-modern">
                                    <thead>
                                        <tr>
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
                                                    <a href="${pageContext.request.contextPath}/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-action">
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
            <div class="glass-card mb-4">
                <div class="card-body-custom p-4">
                    <h5 class="mb-3 fw-bold"><i class="fas fa-check-circle me-2 text-success"></i> Reviewed Submissions</h5>
                    <c:choose>
                        <c:when test="${empty reviewedSubmissionList}">
                            <p class="text-muted text-center py-3">No reviewed submissions yet for this hackathon.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-modern">
                                    <thead>
                                        <tr>
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
                                                    <a href="${pageContext.request.contextPath}/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-action">
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
        <footer class="footer">
            <div>© CodeVerse Judge Panel — Empowering fair evaluations</div>
            <div class="mt-1"><a href="#" class="text-decoration-none text-secondary">Support</a> | <a href="#" class="text-decoration-none text-secondary">Guidelines</a></div>
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>