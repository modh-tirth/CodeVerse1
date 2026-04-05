<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Judge Submissions | CodeVerse</title>
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
            transition: background 0.2s;
        }

        .table-modern tbody tr {
            transition: all 0.2s;
        }

        .table-modern tbody tr:hover {
            background-color: rgba(79, 70, 229, 0.02);
            cursor: pointer;
        }

        /* ===== BADGES & STATUS ===== */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.3rem 1rem;
            border-radius: 40px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            width: fit-content;
            backdrop-filter: blur(2px);
        }

        .badge-pending {
            background: #fffbeb;
            color: #b45309;
            border: 1px solid #fed7aa;
        }

        .badge-reviewed {
            background: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        .pending-dot {
            width: 8px;
            height: 8px;
            background-color: #f97316;
            border-radius: 50%;
            display: inline-block;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0% { opacity: 0.4; transform: scale(0.8);}
            100% { opacity: 1; transform: scale(1.2);}
        }

        /* ===== BUTTONS ===== */
        .btn-review-modern {
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
            gap: 0.5rem;
            transition: all 0.25s;
            box-shadow: var(--shadow-sm);
        }

        .btn-review-modern:hover {
            transform: translateY(-2px);
            background: linear-gradient(105deg, var(--primary-dark) 0%, var(--primary) 100%);
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.3);
            color: white;
        }

        .filter-input {
            border-radius: 48px;
            padding: 0.6rem 1rem;
            border: 1px solid var(--gray-200);
            background: white;
            font-size: 0.9rem;
            transition: all 0.2s;
        }

        .filter-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            outline: none;
        }

        /* ===== PAGINATION ===== */
        .pagination-modern .page-link {
            border-radius: 12px;
            margin: 0 4px;
            border: none;
            color: var(--gray-700);
            font-weight: 500;
            padding: 0.5rem 1rem;
            background: white;
            box-shadow: var(--shadow-sm);
        }

        .pagination-modern .page-item.active .page-link {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3);
        }

        /* ===== ALERT ===== */
        .alert-modern {
            border-radius: 20px;
            border: none;
            background: white;
            box-shadow: var(--shadow-md);
            border-left: 4px solid #22c55e;
            padding: 1rem 1.5rem;
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

        .page-title {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--gray-900), var(--primary-dark));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            letter-spacing: -0.02em;
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
            .stat-card { padding: 0.8rem 1rem; }
            .table-modern th, .table-modern td { padding: 0.75rem; }
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 28px;
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="JudgeSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="JudgeHeader.jsp" />
        <div class="content-area">
            <!-- Stats calculation using JSTL -->
            <c:set var="reviewedCount" value="0" />
            <c:set var="pendingCount" value="0" />
            <c:forEach items="${submissions}" var="subStat">
                <c:choose>
                    <c:when test="${reviewedMap[subStat.hackathonSubmissionId]}">
                        <c:set var="reviewedCount" value="${reviewedCount + 1}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:set var="totalSubmissions" value="${reviewedCount + pendingCount}" />

            <!-- Header & Back -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
                <div>
                    <a href="${pageContext.request.contextPath}/judge/judge-dashboard" class="back-link-modern mb-2 d-inline-block">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <h1 class="page-title mt-2">Submissions Review</h1>
                    <p class="text-muted mt-1">Evaluate and score hackathon projects</p>
                </div>
                <div class="mt-2 mt-sm-0">
                    <span class="badge bg-light text-dark p-2 px-3 rounded-pill shadow-sm">
                        <i class="far fa-calendar-alt me-1"></i> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMM dd, yyyy" />
                    </span>
                </div>
            </div>

            <!-- Success Message -->
            <c:if test="${param.saved == 'true'}">
                <div class="alert-modern alert-dismissible fade show mb-4" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle text-success fs-5 me-2"></i>
                        <span>Review score saved successfully! Your evaluation has been recorded.</span>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Stats Row -->
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Total Submissions</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem;">${totalSubmissions}</h2>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-file-alt fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Pending Review</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem; color:#d97706;">${pendingCount}</h2>
                        </div>
                        <div class="bg-warning bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-hourglass-half fa-2x text-warning"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted text-uppercase small fw-semibold mb-1">Completed</p>
                            <h2 class="mb-0 fw-bold" style="font-size: 2rem; color:#10b981;">${reviewedCount}</h2>
                        </div>
                        <div class="bg-success bg-opacity-10 p-3 rounded-4">
                            <i class="fas fa-check-double fa-2x text-success"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="glass-card p-3 mb-4">
                <div class="row g-3 align-items-center">
                    <div class="col-md-6">
                        <div class="position-relative">
                            <i class="fas fa-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted small"></i>
                            <input type="text" id="searchInput" class="form-control filter-input ps-5" placeholder="Search by hackathon name or team...">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select id="statusFilter" class="form-select filter-input">
                            <option value="all">All Submissions</option>
                            <option value="pending">Pending Review</option>
                            <option value="reviewed">Reviewed</option>
                        </select>
                    </div>
                    <div class="col-md-2 text-md-end">
                        <span class="text-muted small"><i class="fas fa-info-circle"></i> Click row to review</span>
                    </div>
                </div>
            </div>

            <!-- Submissions Table -->
            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table table-modern" id="submissionsTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th><i class="fas fa-trophy me-1"></i> Hackathon</th>
                                <th><i class="fas fa-users me-1"></i> Team</th>
                                <th><i class="far fa-calendar-alt me-1"></i> Submitted Date</th>
                                <th><i class="fas fa-flag-checkered me-1"></i> Status</th>
                                <th><i class="fas fa-cog me-1"></i> Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty submissions}">
                                <tr class="empty-state-row">
                                    <td colspan="6" class="text-center py-5">
                                        <div class="empty-state">
                                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                            <h5 class="fw-semibold">No submissions assigned</h5>
                                            <p class="text-muted">You haven't been assigned any hackathon submissions yet.<br>Check back later or contact the admin.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach items="${submissions}" var="s" varStatus="i">
                                <tr class="submission-row" data-status="${reviewedMap[s.hackathonSubmissionId] ? 'reviewed' : 'pending'}" data-hackathon="${hackathonMap[s.hackathonId].title}" data-team="${teamMap[s.teamId].teamName}">
                                    <td class="fw-semibold">${i.count}</td>
                                    <td class="fw-semibold">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="badge bg-primary bg-opacity-10 text-primary p-2 rounded-circle" style="width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-code fa-sm"></i>
                                            </span>
                                            ${hackathonMap[s.hackathonId].title}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="fas fa-user-circle text-secondary"></i>
                                            ${teamMap[s.teamId].teamName}
                                        </div>
                                    </td>
                                    <td><i class="far fa-clock text-muted me-1"></i> ${s.submitedDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${reviewedMap[s.hackathonSubmissionId]}">
                                                <span class="status-badge badge-reviewed">
                                                    <i class="fas fa-check-circle"></i> Reviewed
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge badge-pending">
                                                    <span class="pending-dot"></span> Pending
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/judge/submissions/review?submissionId=${s.hackathonSubmissionId}" class="btn-review-modern">
                                            <i class="fas fa-pen-fancy"></i> Evaluate
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- Pagination placeholder (modern) -->
                <c:if test="${not empty submissions and submissions.size() > 5}">
                    <div class="d-flex justify-content-center p-3 border-top">
                        <nav>
                            <ul class="pagination pagination-modern mb-0">
                                <li class="page-item disabled"><a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a></li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
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
    (function() {
        // Search + filter functionality (client side)
        const searchInput = document.getElementById('searchInput');
        const statusFilter = document.getElementById('statusFilter');
        const tableRows = document.querySelectorAll('#submissionsTable tbody tr.submission-row');

        function filterTable() {
            const searchTerm = searchInput ? searchInput.value.toLowerCase() : '';
            const statusValue = statusFilter ? statusFilter.value : 'all';

            tableRows.forEach(row => {
                const hackathon = row.getAttribute('data-hackathon')?.toLowerCase() || '';
                const team = row.getAttribute('data-team')?.toLowerCase() || '';
                const rowStatus = row.getAttribute('data-status') || 'pending';

                let matchesSearch = (hackathon.includes(searchTerm) || team.includes(searchTerm));
                let matchesStatus = (statusValue === 'all') || (statusValue === rowStatus);

                if (matchesSearch && matchesStatus) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            // Show "no results" message if all rows hidden and submissions exist
            const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none');
            const emptyMessageRow = document.querySelector('.empty-state-row');
            if (tableRows.length > 0 && visibleRows.length === 0 && !emptyMessageRow) {
                let tbody = document.querySelector('#submissionsTable tbody');
                let noResultRow = document.getElementById('noResultMsg');
                if (!noResultRow) {
                    noResultRow = document.createElement('tr');
                    noResultRow.id = 'noResultMsg';
                    noResultRow.innerHTML = '<td colspan="6" class="text-center py-4 text-muted"><i class="fas fa-filter"></i> No submissions match your filters.</td>';
                    tbody.appendChild(noResultRow);
                }
            } else {
                let noResultRow = document.getElementById('noResultMsg');
                if (noResultRow) noResultRow.remove();
            }
        }

        if (searchInput) searchInput.addEventListener('keyup', filterTable);
        if (statusFilter) statusFilter.addEventListener('change', filterTable);
    })();
</script>
</body>
</html>