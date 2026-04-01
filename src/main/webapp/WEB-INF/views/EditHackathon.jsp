<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Edit Hackathon | CodeVerse Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* ========== DASHBOARD LAYOUT STYLES (fixed header & sidebar) ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: #f5f7fb;
            color: #1e293b;
            overflow-x: hidden;
        }
        .app-wrapper {
            display: flex;
            min-height: 100vh;
            height: 100vh;
            overflow: hidden;
        }
        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            color: #e2e8f0;
            transition: width 0.3s ease;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 20px rgba(0,0,0,0.08);
            height: 100vh;
        }
        .sidebar.collapsed {
            width: 80px;
        }
        .sidebar-header {
            padding: 24px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .logo-area {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .logo-icon {
            background: #3b82f6;
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            color: white;
        }
        .logo-text {
            font-size: 1.25rem;
            font-weight: 600;
            color: white;
            white-space: nowrap;
        }
        .sidebar.collapsed .logo-text {
            display: none;
        }
        .toggle-btn {
            background: rgba(255,255,255,0.1);
            border: none;
            color: #cbd5e1;
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
        }
        .toggle-btn:hover {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        .sidebar.collapsed .toggle-btn i {
            transform: rotate(180deg);
        }
        .sidebar-menu {
            flex: 1;
            padding: 20px 0;
            overflow-y: auto;
        }
        .menu-item {
            display: flex;
            align-items: center;
            padding: 12px 24px;
            margin: 4px 8px;
            border-radius: 12px;
            color: #cbd5e1;
            transition: 0.2s;
            white-space: nowrap;
        }
        .menu-item i {
            font-size: 1.25rem;
            min-width: 36px;
        }
        .menu-item span {
            margin-left: 8px;
            font-weight: 500;
        }
        .menu-item:hover, .menu-item.active {
            background: rgba(59, 130, 246, 0.2);
            color: white;
        }
        .sidebar.collapsed .menu-item span {
            display: none;
        }
        .sidebar.collapsed .menu-item {
            justify-content: center;
            padding: 12px 0;
        }
        /* Main content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8fafc;
            height: 100vh;
            overflow: hidden;
        }
        /* Header (fixed) */
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
        /* Scrollable content area */
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }
        /* Footer */
        .footer {
            background: white;
            padding: 20px 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                left: -260px;
                height: 100vh;
                z-index: 1000;
                transition: left 0.3s ease;
            }
            .sidebar.mobile-open {
                left: 0;
            }
            .main-content {
                width: 100%;
            }
            .mobile-menu-btn {
                display: block;
            }
            .top-header {
                padding: 16px 20px;
            }
            .content-area {
                padding: 20px;
            }
        }

        /* ========== FORM SPECIFIC STYLES ========== */
        .form-card {
            background: white;
            border-radius: 24px;
            padding: 35px;
            max-width: 100%;
            margin: 0 auto;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
        }
        .card-header-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f1f5f9;
        }
        .card-header-custom h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-header-custom i { color: #3b82f6; }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .input-group {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .input-group:focus-within {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        .input-group-icon {
            padding: 0 15px;
            color: #3b82f6;
            font-size: 1rem;
        }
        .input-group input, .input-group select, .input-group textarea, .input-group input[type="file"] {
            width: 100%;
            padding: 12px 15px 12px 0;
            border: none;
            outline: none;
            font-size: 0.95rem;
            color: #1e293b;
            background: transparent;
            font-family: inherit;
        }
        .input-group input[type="file"] {
            padding-top: 10px;
            padding-bottom: 10px;
            font-size: 0.9rem;
        }
        .input-group textarea { min-height: 100px; padding-top: 12px; }
        .input-group select {
            padding-right: 35px;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>") no-repeat right 15px center;
            background-size: 16px;
        }
        .section-divider {
            margin: 40px 0 30px;
            border: 0;
            border-top: 1px solid #e9eef2;
        }
        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .prize-row {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 20px;
            background: #f8fafc;
            padding: 20px;
            border-radius: 16px;
            margin-bottom: 15px;
        }
        .action-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 40px;
        }
        .btn {
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            border: none;
            font-size: 0.95rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(59, 130, 246, 0.3);
        }
        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
        }
        @media (max-width: 768px) {
            .form-grid, .prize-row { grid-template-columns: 1fr; }
            .content-area { padding: 15px; }
            .action-buttons { flex-direction: column; }
            .btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="AdminSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="AdminHeader.jsp" />
        <div class="content-area">
            <div class="page-header-section" style="margin-bottom: 24px;">
                <h1 class="page-title" style="font-size: 1.5rem; font-weight: 700; color: #0f172a; margin-bottom: 8px;">Edit Hackathon</h1>

            </div>

            <div class="form-card">
                <div class="card-header-custom">
                    <h3><i class="fas fa-edit"></i> Update Hackathon</h3>
                    <a href="listHackathon" class="btn btn-secondary" style="padding: 8px 15px; font-size: 0.8rem;">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>

                <form action="updateHackathon" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}" />
                    <input type="hidden" name="userId" value="${hackathon.userId}" />
                    <input type="hidden" name="leaderboardPublished" value="${hackathon.leaderboardPublished}" />

                    <div class="form-grid">
                        <!-- Left Column -->
                        <div class="form-col">
                            <div class="form-group">
                                <label>Hackathon Title</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-trophy"></i></span>
                                    <input type="text" name="title" value="${hackathon.title}" required />
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Short Description</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-align-left"></i></span>
                                    <textarea name="description" rows="4">${hackathon.description}</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-toggle-on"></i></span>
                                    <select name="status" required>
                                        <option value="UPCOMING" ${hackathon.status == 'UPCOMING' ? 'selected' : ''}>Upcoming</option>
                                        <!-- option value="ONGOING" ${hackathon.status == 'ONGOING' ? 'selected' : ''}>Ongoing</option-->
                                          <option value="LIVE" ${hackathon.status == 'LIVE' ? 'selected' : ''}>Live</option>
                                        <option value="COMPLETED" ${hackathon.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Event Type</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-globe"></i></span>
                                    <select name="eventType" required>
                                        <option value="ONLINE" ${hackathon.eventType == 'ONLINE' ? 'selected' : ''}>Online</option>
                                        <option value="OFFLINE" ${hackathon.eventType == 'OFFLINE' ? 'selected' : ''}>Offline</option>
                                        <option value="HYBRID" ${hackathon.eventType == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="form-col">
                            <div class="form-group">
                                <label>Payment Mode</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-credit-card"></i></span>
                                    <select name="payment" required>
                                        <option value="FREE" ${hackathon.payment == 'FREE' ? 'selected' : ''}>Free</option>
                                        <option value="PAID" ${hackathon.payment == 'PAID' ? 'selected' : ''}>Paid</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
							    <label>Registration Fee (₹)</label>
							    <div class="input-group">
							        <span class="input-group-icon"><i class="fas fa-rupee-sign"></i></span>
							        <input type="number" name="registrationFee" step="0.01" min="0" value="${hackathon.registrationFee}" placeholder="e.g., 100">
							    </div>
							</div>
                            <div class="form-group">
                                <label>Location / Venue</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-map-marker-alt"></i></span>
                                    <input type="text" name="location" value="${hackathon.location}" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Eligibility (User Type)</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-user-tag"></i></span>
                                   <select name="userTypeId" required>
									    <c:forEach var="u" items="${allUserType}">
									        <option value="${u.userTypeId}" ${hackathon.userType == u.userType ? 'selected' : ''}>
									            ${u.userType}
									        </option>
									    </c:forEach>
									</select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Registration Start</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-calendar-plus"></i></span>
                                    <input type="date" name="registrationStartDate" value="${hackathon.registrationStartDate}" required />
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Registration End</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-calendar-times"></i></span>
                                    <input type="date" name="registrationEndDate" value="${hackathon.registrationEndDate}" required />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-grid" style="margin-top: 0;">
                        <div class="form-col">
                            <div class="form-group">
                                <label>Minimum Team Size</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-users"></i></span>
                                    <input type="number" name="minTeamSize" min="1" value="${hackathon.minTeamSize}" required />
                                </div>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label>Maximum Team Size</label>
                                <div class="input-group">
                                    <span class="input-group-icon"><i class="fas fa-user-plus"></i></span>
                                    <input type="number" name="maxTeamSize" min="1" value="${hackathon.maxTeamSize}" required />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Hackathon Poster (optional) -->
                    <div class="form-group">
                        <label>Hackathon Poster (optional)</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-image"></i></span>
                            <input type="file" name="hackathonPoster" accept="image/*" />
                        </div>
                        <small class="text-muted">Leave empty to keep current poster.</small>
                        <c:if test="${not empty hackathon.hackathonPosterURL}">
                            <div style="margin-top: 8px; font-size: 0.85rem; color: #64748b;">
                                <i class="fas fa-check-circle" style="color: #10b981;"></i> Current poster uploaded
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>Full Hackathon Description (HTML)</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-code"></i></span>
                            <textarea name="hackathonDetails" rows="6" required>${hackathonDescription.hackathonDetails}</textarea>
                        </div>
                    </div>

                    <div class="section-divider"></div>
                    <h4 class="section-title"><i class="fas fa-gift"></i> Prize Details</h4>
                    <input type="hidden" name="prizeId1" value="${prize1.hackathonPrizeId}" />
                    <input type="hidden" name="prizeId2" value="${prize2.hackathonPrizeId}" />
                    <input type="hidden" name="prizeId3" value="${prize3.hackathonPrizeId}" />

                    <div class="prize-row">
                        <div class="form-group" style="margin-bottom:0">
                            <label>Prize 1 Title *</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-medal" style="color:#ffd700"></i></span>
                                <input type="text" name="prizeTitle1" value="${prize1.prizeTitle}" required />
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0">
                            <label>Prize 1 Description *</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-align-left"></i></span>
                                <textarea name="prizeDescription1" rows="2" required>${prize1.prizeDescription}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="prize-row">
                        <div class="form-group" style="margin-bottom:0">
                            <label>Prize 2 Title (Optional)</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-medal" style="color:#c0c0c0"></i></span>
                                <input type="text" name="prizeTitle2" value="${prize2.prizeTitle}" />
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0">
                            <label>Prize 2 Description (Optional)</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-align-left"></i></span>
                                <textarea name="prizeDescription2" rows="2">${prize2.prizeDescription}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="prize-row">
                        <div class="form-group" style="margin-bottom:0">
                            <label>Prize 3 Title (Optional)</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-medal" style="color:#cd7f32"></i></span>
                                <input type="text" name="prizeTitle3" value="${prize3.prizeTitle}" />
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0">
                            <label>Prize 3 Description (Optional)</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-align-left"></i></span>
                                <textarea name="prizeDescription3" rows="2">${prize3.prizeDescription}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="listHackathon" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Hackathon
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <footer class="footer">
            &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<!-- Sidebar toggle JavaScript (same as dashboard) -->
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