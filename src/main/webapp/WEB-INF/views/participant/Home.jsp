<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Participant Dashboard | CodeVerse</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f5f7fb;
            color: #1e293b;
        }

        .app-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8fafc;
            height: 100vh;
            overflow: hidden;
        }

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
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }

        .filter-panel {
            background: white;
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            border: 1px solid #e9eef2;
        }

        .filter-title {
            font-weight: 600;
            margin-bottom: 15px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #0f172a;
        }

        .filter-group {
            margin-bottom: 20px;
        }

        .filter-label {
            font-weight: 500;
            font-size: 0.85rem;
            margin-bottom: 8px;
            display: block;
            color: #475569;
        }

        .radio-group {
            display: flex;
            gap: 15px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .radio-option input {
            margin: 0;
        }

        .radio-option label {
            font-size: 0.9rem;
            font-weight: normal;
            color: #334155;
            cursor: pointer;
            margin: 0;
        }

        .form-select-sm {
            font-size: 0.9rem;
            border-radius: 10px;
        }

        .reset-btn {
            background: #f1f5f9;
            border: none;
            color: #475569;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 12px;
            transition: all 0.2s;
        }

        .reset-btn:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        .stats-row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 15px 20px;
            flex: 1;
            text-align: center;
            border: 1px solid #e9eef2;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }

        .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #3b82f6;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .hackathon-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            background: white;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .hackathon-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08);
        }

        .badge-status {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 1;
        }

        .card-body {
            flex: 1;
            padding: 1.25rem;
        }

        .card-footer {
            background: transparent;
            border-top: 1px solid #f1f1f1;
            padding: 1rem 1.25rem;
        }

        .tag {
            background: #f1f5f9;
            color: #334155;
            border-radius: 30px;
            padding: 4px 12px;
            font-size: 0.7rem;
            font-weight: 500;
            display: inline-block;
            margin-right: 6px;
            margin-bottom: 6px;
        }

        .no-results-msg {
            display: none;
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 20px;
            margin-top: 30px;
        }
        .no-results-msg.visible {
            display: block;
        }
        .no-results-msg i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 15px;
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
            .mobile-menu-btn {
                display: block;
            }
            .content-area {
                padding: 20px;
            }
            .filter-panel {
                padding: 15px;
            }
            .stats-row {
                flex-direction: column;
            }
        }

        /* Sidebar full height and scroll */
        .sidebar {
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .sidebar-menu {
            flex: 1;
            overflow-y: auto;
        }
        .sidebar-menu::-webkit-scrollbar {
            width: 4px;
        }
        .sidebar-menu::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.2);
            border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <!-- Include Sidebar -->
    <jsp:include page="ParticipantSidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Shared Participant Header -->
        <jsp:include page="ParticipantHeader.jsp" />

        <!-- Content Area -->
        <div class="content-area">
            <!-- Page Title & Count -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Available Hackathons</h3>
                <span class="badge bg-primary fs-6" id="resultsCount">${hackathons.size()} Events Found</span>
            </div>

            

            <!-- Filter Panel -->
            <div class="filter-panel">
                <div class="row g-3 align-items-end">
                    <!-- Search -->
                    <div class="col-md-4">
                        <div class="filter-label"><i class="fas fa-search me-1"></i> Search</div>
                        <input type="text" id="searchInput" class="form-control form-control-sm" placeholder="Name, theme, technology...">
                    </div>

                    <!-- Entry Type -->
                    <div class="col-md-2">
                        <div class="filter-label">Entry Type</div>
                        <div class="radio-group">
                            <div class="radio-option">
                                <input type="radio" name="type" value="" id="type-all" checked>
                                <label for="type-all">All</label>
                            </div>
                            <div class="radio-option">
                                <input type="radio" name="type" value="FREE" id="type-free">
                                <label for="type-free">Free</label>
                            </div>
                            <div class="radio-option">
                                <input type="radio" name="type" value="PAID" id="type-paid">
                                <label for="type-paid">Paid</label>
                            </div>
                        </div>
                    </div>

                    <!-- Team Size -->
                    <div class="col-md-2">
                        <div class="filter-label">Team Size</div>
                        <select id="teamSizeFilter" class="form-select form-select-sm">
                            <option value="">Any size</option>
                            <option value="1">Solo (1)</option>
                            <option value="2">Duo (2)</option>
                            <option value="4">Squad (4)</option>
                            <option value="6">Large (6)</option>
                        </select>
                    </div>

                    <!-- Eligibility -->
                    <div class="col-md-2">
                        <div class="filter-label">Eligibility</div>
                        <select id="eligibilityFilter" class="form-select form-select-sm">
                            <option value="">Everyone</option>
                            <option value="2">Fresher</option>
                            <option value="1">Working Professional</option>
                            <option value="3">College Student</option>
                            <option value="4">School Student</option>
                        </select>
                    </div>

                    <!-- Sort -->
                    <div class="col-md-2">
                        <div class="filter-label">Sort by</div>
                        <select id="sortSelect" class="form-select form-select-sm">
                            <option value="default">Latest</option>
                            <option value="title-asc">Name A to Z</option>
                            <option value="title-desc">Name Z to A</option>
                            <option value="team-asc">Team Size (Low to High)</option>
                            <option value="team-desc">Team Size (High to Low)</option>
                        </select>
                    </div>

                    <!-- Reset Button -->
                    <div class="col-md-auto">
                        <button id="resetBtn" class="reset-btn btn btn-sm w-100"><i class="fas fa-undo-alt me-1"></i> Reset</button>
                    </div>
                </div>
            </div>

            <!-- Cards Grid -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="cardsGrid">
                <c:choose>
                    <c:when test="${empty hackathons}">
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                            <p class="lead">No hackathons available at the moment.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="hack" items="${hackathons}">
                            <div class="col">
                                <div class="card h-100 hackathon-card"
                                     data-title="${fn:toLowerCase(hack.title)}"
                                     data-desc="${fn:toLowerCase(hack.description)}"
                                     data-type="${hack.payment}"
                                     data-minteam="${hack.minTeamSize}"
                                     data-maxteam="${hack.maxTeamSize}"
                                     data-eligibility="${fn:toLowerCase(hack.userType)}"
                                     data-status="${hack.status}">
                                    <span class="badge badge-status 
                                        ${hack.status == 'LIVE' ? 'bg-success' : 
                                          hack.status == 'UPCOMING' ? 'bg-warning' : 
                                          'bg-secondary'} text-white">
                                        ${hack.status}
                                    </span>
                                    <div class="card-body">
                                        <h5 class="card-title text-primary fw-bold mb-3 text-truncate">${hack.title}</h5>
                                        <div class="mb-2">
                                            <small class="text-muted"><i class="fas fa-tag me-1"></i> ${hack.eventType}</small>
                                        </div>
                                        <!-- p class="card-text small text-muted mb-3">${fn:substring(hack.description, 0, 80)}...</p-->
                                        <div class="mb-2">
                                            <small class="text-muted"><i class="fas fa-wallet me-1"></i> Payment: <strong>${hack.payment}</strong></small>
                                        </div>
                                        <div class="mb-2">
                                            <small class="text-muted"><i class="fas fa-users me-1"></i> Team: ${hack.minTeamSize} - ${hack.maxTeamSize} members</small>
                                        </div>
                                        <div>
                                            <span class="tag"><i class="fas fa-graduation-cap me-1"></i> ${hack.userType}</span>
                                        </div>
                                    </div>
                                    <div class="card-footer d-grid">
                                        <a href="<c:url value='/participant/hackathon?hackathon_id=${hack.hackathonId}'/>" class="btn btn-outline-primary rounded-pill">
                                            View Details <i class="fas fa-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                <!-- No results message -->
                <div class="col-12 no-results-msg" id="noResults">
                    <i class="fas fa-search"></i>
                    <h5>No hackathons match</h5>
                    <p class="text-muted">Try different keywords or reset the filters.</p>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<!-- JavaScript for Sidebar Toggle (from original) -->
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
            if (sidebar && !sidebar.contains(e.target) && mobileMenuBtn && !mobileMenuBtn.contains(e.target)) {
                sidebar.classList.remove('mobile-open');
            }
        }
    });

    window.addEventListener('resize', () => {
        if (window.innerWidth > 768) {
            if (sidebar) sidebar.classList.remove('mobile-open');
        }
    });
</script>

<!-- JavaScript for Filtering and Sorting -->
<script>
    (function () {
        const cardsContainer = document.getElementById('cardsGrid');
        const cards = Array.from(document.querySelectorAll('.hackathon-card'));
        const searchInput = document.getElementById('searchInput');
        const teamSizeSel = document.getElementById('teamSizeFilter');
        const eligSel = document.getElementById('eligibilityFilter');
        const sortSel = document.getElementById('sortSelect');
        const resetBtn = document.getElementById('resetBtn');
        const noResultsDiv = document.getElementById('noResults');
        const resultsCountSpan = document.getElementById('resultsCount');
        const activeEventsSpan = document.getElementById('activeEventsCount');

        function getFilters() {
            return {
                keyword: searchInput ? searchInput.value.trim().toLowerCase() : '',
                type: (document.querySelector('input[name="type"]:checked') || {}).value || '',
                teamSize: teamSizeSel.value,
                eligibility: eligSel.value,
                sort: sortSel.value
            };
        }

        function applyFilters() {
            const f = getFilters();
            let visible = [];

            cards.forEach(card => {
                const title = card.dataset.title || '';
                const desc = card.dataset.desc || '';
                const type = card.dataset.type || '';
                const minT = parseInt(card.dataset.minteam) || 0;
                const maxT = parseInt(card.dataset.maxteam) || 99;
                const elig = card.dataset.eligibility || '';

                const kwMatch = !f.keyword || title.includes(f.keyword) || desc.includes(f.keyword) || 
                                type.toLowerCase().includes(f.keyword) || elig.includes(f.keyword);
                const typeMatch = !f.type || type.toUpperCase() === f.type.toUpperCase();
                let teamMatch = true;
                if (f.teamSize) {
                    const sz = parseInt(f.teamSize);
                    teamMatch = sz >= minT && sz <= maxT;
                }
                const eligMatch = !f.eligibility || elig.toUpperCase() === f.eligibility.toUpperCase();

                const show = kwMatch && typeMatch && teamMatch && eligMatch;
                const cardCol = card.closest('.col');
                if (cardCol) {
                    cardCol.style.display = show ? '' : 'none';
                }
                if (show) visible.push(card);
            });

            const count = visible.length;
            resultsCountSpan.textContent = count + (count === 1 ? ' Event Found' : ' Events Found');

            const activeCount = visible.filter(c => c.dataset.status === 'LIVE').length;
            if (activeEventsSpan) activeEventsSpan.innerText = activeCount;

            if (count === 0) {
                noResultsDiv.classList.add('visible');
            } else {
                noResultsDiv.classList.remove('visible');
            }

            sortCards(visible, f.sort);
        }

        function sortCards(visibleCards, mode) {
            if (mode === 'default') return;

            const parent = cardsContainer;
            const allCols = Array.from(parent.children).filter(child => 
                child.classList && child.classList.contains('col') && !child.classList.contains('no-results-msg')
            );
            let sortedCols = [...allCols];

            switch (mode) {
                case 'title-asc':
                    sortedCols.sort((a, b) => {
                        const titleA = a.querySelector('.hackathon-card').dataset.title || '';
                        const titleB = b.querySelector('.hackathon-card').dataset.title || '';
                        return titleA.localeCompare(titleB);
                    });
                    break;
                case 'title-desc':
                    sortedCols.sort((a, b) => {
                        const titleA = a.querySelector('.hackathon-card').dataset.title || '';
                        const titleB = b.querySelector('.hackathon-card').dataset.title || '';
                        return titleB.localeCompare(titleA);
                    });
                    break;
                case 'team-asc':
                    sortedCols.sort((a, b) => {
                        const minA = parseInt(a.querySelector('.hackathon-card').dataset.minteam) || 0;
                        const minB = parseInt(b.querySelector('.hackathon-card').dataset.minteam) || 0;
                        return minA - minB;
                    });
                    break;
                case 'team-desc':
                    sortedCols.sort((a, b) => {
                        const maxA = parseInt(a.querySelector('.hackathon-card').dataset.maxteam) || 0;
                        const maxB = parseInt(b.querySelector('.hackathon-card').dataset.maxteam) || 0;
                        return maxB - maxA;
                    });
                    break;
                default:
                    return;
            }

            sortedCols.forEach(col => parent.appendChild(col));
            if (noResultsDiv.parentNode === parent) parent.appendChild(noResultsDiv);
        }

        function resetFilters() {
            if (searchInput) searchInput.value = '';
            const typeAll = document.getElementById('type-all');
            if (typeAll) typeAll.checked = true;
            teamSizeSel.value = '';
            eligSel.value = '';
            sortSel.value = 'default';
            applyFilters();
        }

        if (searchInput) searchInput.addEventListener('input', applyFilters);
        document.querySelectorAll('input[name="type"]').forEach(r => r.addEventListener('change', applyFilters));
        if (teamSizeSel) teamSizeSel.addEventListener('change', applyFilters);
        if (eligSel) eligSel.addEventListener('change', applyFilters);
        if (sortSel) sortSel.addEventListener('change', applyFilters);
        if (resetBtn) resetBtn.addEventListener('click', resetFilters);

        applyFilters();
    })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>