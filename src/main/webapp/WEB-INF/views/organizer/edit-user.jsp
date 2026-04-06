<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User | CodeVerse Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
        }
        .top-header {
            background: white;
            padding: 16px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
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
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }
        .form-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
            margin-bottom: 30px;
        }
        .form-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-title i {
            color: #3b82f6;
        }
        .form-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 30px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 15px;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        .input-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .input-group label {
            font-weight: 500;
            font-size: 0.9rem;
            color: #475569;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .input-group label i {
            color: #3b82f6;
            width: 18px;
        }
        .input-group input, .input-group select {
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            transition: 0.2s;
            background: white;
            color: #1e293b;
        }
        .input-group input:focus, .input-group select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .full-width {
            grid-column: span 2;
        }
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 12px 30px;
            border-radius: 40px;
            font-weight: 600;
            font-size: 0.95rem;
            border: none;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary {
            background: #3b82f6;
            color: white;
            box-shadow: 0 4px 10px rgba(59,130,246,0.3);
        }
        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: white;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        .btn-secondary:hover {
            background: #f8fafc;
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
            .mobile-menu-btn { display: block; }
            .form-row { grid-template-columns: 1fr; }
            .full-width { grid-column: span 1; }
            .form-actions { flex-direction: column; align-items: stretch; }
            .btn { justify-content: center; }
        }
        /* Simple checkbox style */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
        }
        .checkbox-group label {
            font-weight: normal;
            margin: 0;
        }
        .checkbox-group input {
            width: auto;
            margin: 0;
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="OrganizerSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="OrganizerHeader.jsp" />
        <div class="content-area">
            <h1 class="page-title" style="margin-bottom: 24px;">
                <i class="fas fa-user-edit" style="color: #3b82f6; margin-right: 10px;"></i> Edit User
            </h1>
            <div class="form-card">
                <div class="form-title">
                    <i class="fas fa-id-card"></i> User Information
                </div>
                <div class="form-subtitle">
                    Update the user's profile and account details.
                </div>

                <form action="update-user" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="userId" value="${user.userId}">

                    <div class="form-row">
                        <div class="input-group">
                            <label><i class="fas fa-user"></i> First Name *</label>
                            <input type="text" name="firstName" value="${user.firstName}" required>
                        </div>
                        <div class="input-group">
                            <label><i class="fas fa-user"></i> Last Name *</label>
                            <input type="text" name="lastName" value="${user.lastName}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label><i class="fas fa-envelope"></i> Email *</label>
                            <input type="email" name="email" value="${user.email}" required>
                        </div>
                        <div class="input-group">
                            <label><i class="fas fa-phone-alt"></i> Contact Number *</label>
                            <input type="text" name="contactNum" value="${user.contactNum}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label><i class="fas fa-venus-mars"></i> Gender</label>
                            <select name="gender">
                                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                        <div class="input-group">
                            <label><i class="fas fa-calendar-alt"></i> Birth Year</label>
                            <input type="number" name="birthYear" value="${user.birthYear}" min="1900" max="2026">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label><i class="fas fa-graduation-cap"></i> Qualification</label>
                            <input type="text" name="qualification" value="${userDetail.qualification}">
                        </div>
                        <div class="input-group">
                            <label><i class="fas fa-city"></i> City</label>
                            <input type="text" name="city" value="${userDetail.city}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label><i class="fas fa-map-pin"></i> State</label>
                            <input type="text" name="state" value="${userDetail.state}">
                        </div>
                        <div class="input-group">
                            <label><i class="fas fa-globe"></i> Country</label>
                            <input type="text" name="country" value="${userDetail.country}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group full-width">
                            <label><i class="fas fa-image"></i> Profile Picture</label>
                            <input type="file" name="profilePic" accept="image/*">
                            <c:if test="${not empty user.profilePicURL}">
                                <div class="mt-2">
                                    <img src="${user.profilePicURL}" width="80" height="80" style="border-radius: 50%; object-fit: cover;">
                                    <span class="text-muted ms-2">Current picture</span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group full-width">
                            <div class="checkbox-group">
                                <input type="checkbox" name="active" value="true" id="activeCheck" ${user.active ? 'checked' : ''}>
                                <label for="activeCheck"><i class="fas fa-power-off"></i> Account Active</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="history.back()">
                            <i class="fas fa-times"></i> Cancel
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