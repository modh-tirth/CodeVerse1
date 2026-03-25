<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Edit Hackathon | CodeVerse Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter', sans-serif; background:#f5f7fb; color:#1e293b; }
        .app-wrapper { display:flex; min-height:100vh; }
        .main-content { flex:1; display:flex; flex-direction:column; background:#f8fafc; }
        .top-header { background:white; padding:16px 30px; display:flex; align-items:center; justify-content:space-between; box-shadow:0 2px 10px rgba(0,0,0,0.02); border-bottom:1px solid #e9eef2; }
        .header-left { display:flex; align-items:center; gap:20px; }
        .mobile-menu-btn { display:none; background:none; border:none; font-size:1.5rem; color:#475569; cursor:pointer; }
        .page-title { font-size:1.25rem; font-weight:600; color:#0f172a; }
        .header-right { display:flex; align-items:center; gap:25px; }
        .notification-icon { position:relative; font-size:1.25rem; color:#475569; cursor:pointer; }
        .notification-badge { position:absolute; top:-6px; right:-6px; background:#ef4444; color:white; font-size:0.6rem; padding:2px 5px; border-radius:20px; }
        .user-profile { display:flex; align-items:center; gap:10px; cursor:pointer; }
        .user-avatar { width:40px; height:40px; background:#3b82f6; border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-weight:600; }
        .user-info { display:none; }
        @media (min-width:768px) { .user-info { display:block; } .user-info .name { font-weight:600; font-size:0.95rem; color:#1e293b; } .user-info .role { font-size:0.75rem; color:#64748b; } }
        .content-area { padding:30px; flex:1; }
        .form-card { background:white; border-radius:24px; padding:30px; max-width:900px; margin:0 auto; box-shadow:0 8px 30px rgba(0,0,0,0.02); border:1px solid #edf2f7; }
        .card-header { display:flex; align-items:center; gap:8px; margin-bottom:30px; }
        .card-header i { color:#3b82f6; font-size:1.4rem; }
        .card-header h3 { font-size:1.2rem; font-weight:600; color:#0f172a; }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:30px; }
        .form-group { margin-bottom:20px; }
        .form-group label { display:block; font-size:0.9rem; font-weight:500; color:#64748b; margin-bottom:8px; }
        .input-group { display:flex; align-items:center; background:white; border:1px solid #e2e8f0; border-radius:16px; overflow:hidden; transition:0.2s; }
        .input-group:focus-within { border-color:#3b82f6; box-shadow:0 0 0 3px rgba(59,130,246,0.1); }
        .input-group-icon { padding:0 15px; color:#3b82f6; font-size:1.1rem; }
        .input-group input, .input-group select, .input-group textarea { width:100%; padding:14px 15px 14px 0; border:none; outline:none; font-size:1rem; color:#1e293b; background:transparent; font-family:'Inter', sans-serif; }
        .input-group textarea { min-height:100px; resize:vertical; }
        .input-group select { padding-right:35px; -webkit-appearance:none; -moz-appearance:none; appearance:none; background:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>") no-repeat right 15px center; background-size:16px; }
        .input-group input[type="file"] { padding:10px 15px 10px 0; }
        .action-buttons { display:flex; justify-content:center; gap:15px; margin-top:30px; }
        .btn { padding:12px 35px; border-radius:50px; font-weight:600; border:none; cursor:pointer; transition:0.2s; font-size:1rem; }
        .btn-primary { background:linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); color:white; box-shadow:0 4px 10px rgba(59,130,246,0.3); }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(59,130,246,0.4); }
        .btn-secondary { background:#f1f5f9; color:#1e293b; }
        .btn-secondary:hover { background:#e2e8f0; transform:translateY(-2px); }
        .footer { background:white; padding:20px 30px; border-top:1px solid #e9eef2; text-align:center; color:#64748b; font-size:0.9rem; }
        @media (max-width:768px) { .mobile-menu-btn { display:block; } .top-header { padding:16px 20px; } .content-area { padding:20px; } .form-grid { grid-template-columns:1fr; } .action-buttons { flex-direction:column; align-items:center; } .btn { width:100%; max-width:300px; } }
    </style>
</head>
<body>
    <div class="app-wrapper">
        <jsp:include page="AdminSidebar.jsp" />
        <div class="main-content">
            <jsp:include page="AdminHeader.jsp" />
            <div class="content-area">
                <div class="form-card">
                    <div class="card-header">
                        <i class="fas fa-edit"></i>
                        <h3>Edit Hackathon</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/update-hackathon" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="hackthon_id" value="${hackathon.hackthon_id}">

                        <div class="form-grid">
                            <!-- Left Column -->
                            <div class="form-col">
                                <div class="form-group">
                                    <label>Event Title</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-trophy"></i></span>
                                        <input type="text" name="title" value="${hackathon.title}" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Description</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-align-left"></i></span>
                                        <textarea name="description">${hackathon.description}</textarea>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Status</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-toggle-on"></i></span>
                                        <select name="status" required>
                                            <option value="UPCOMING" ${hackathon.status == 'UPCOMING' ? 'selected' : ''}>Upcoming</option>
                                            <option value="LIVE" ${hackathon.status == 'LIVE' ? 'selected' : ''}>Live</option>
                                            <option value="EXPIRED" ${hackathon.status == 'EXPIRED' ? 'selected' : ''}>Expired</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Event Type</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-globe"></i></span>
                                        <select name="event_type" required>
                                            <option value="ONLINE" ${hackathon.event_type == 'ONLINE' ? 'selected' : ''}>Online</option>
                                            <option value="OFFLINE" ${hackathon.event_type == 'OFFLINE' ? 'selected' : ''}>Offline</option>
                                            <option value="HYBRID" ${hackathon.event_type == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Entry Fee</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-credit-card"></i></span>
                                        <select name="payment" required>
                                            <option value="FREE" ${hackathon.payment == 'FREE' ? 'selected' : ''}>Free</option>
                                            <option value="PAID" ${hackathon.payment == 'PAID' ? 'selected' : ''}>Paid</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Location</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-map-marker-alt"></i></span>
                                        <input type="text" name="location" value="${hackathon.location}" required>
                                    </div>
                                </div>
                            </div>
                            <!-- Right Column -->
                            <div class="form-col">
                                <div class="form-group">
                                    <label>Min Team Size</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-users"></i></span>
                                        <input type="number" name="minTeamSize" value="${hackathon.minTeamSize}" min="1" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Max Team Size</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-user-plus"></i></span>
                                        <input type="number" name="maxTeamSize" value="${hackathon.maxTeamSize}" min="1" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Allowed User Type</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-user-tag"></i></span>
                                        <select name="userType" required>
                                            <option value="">-- Select --</option>
                                            <c:forEach items="${allUserType}" var="ut">
                                                <option value="${ut.userType}" ${ut.userType == hackathon.userType ? 'selected' : ''}>${ut.userType}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Registration Start</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-calendar-check"></i></span>
                                        <input type="date" name="registrationStartDate" value="${hackathon.registrationStartDate}" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Registration End</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-calendar-times"></i></span>
                                        <input type="date" name="registrationEndDate" value="${hackathon.registrationEndDate}" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Hackathon Poster (leave empty to keep current)</label>
                                    <div class="input-group">
                                        <span class="input-group-icon"><i class="fas fa-image"></i></span>
                                        <input type="file" name="hackathonPoster" accept="image/*">
                                    </div>
                                    <c:if test="${not empty hackathon.hackathonPosterURL}">
                                        <div style="margin-top:8px; font-size:0.85rem; color:#64748b;">
                                            <i class="fas fa-check-circle" style="color:#10b981;"></i> Current poster uploaded
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <div class="action-buttons">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Hackathon</button>
                            <button type="submit" class="btn btn-secondary" onclick="location.href='listHackathon'"><i class="fas fa-times"></i> Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <footer class="footer">&copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.</footer>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Sidebar toggle script (same as in your dashboard) -->
    <script>
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('toggleSidebar');
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        if (toggleBtn) { /* ... your existing toggle code ... */ }
        if (mobileMenuBtn) { /* ... */ }
        // ... rest of your sidebar JS
    </script>
</body>
</html>