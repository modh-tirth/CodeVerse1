<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Invite Judge | CodeVerse Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* ========== DASHBOARD LAYOUT STYLES ========== */
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
        .logo-icon-img {
            height: 70px;
            width: auto;
            max-width: 100%;
            object-fit: contain;
            display: block;
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
            cursor: pointer;
            position: relative;
        }
        .menu-item i:first-child {
            font-size: 1.25rem;
            min-width: 36px;
        }
        .menu-item span {
            margin-left: 8px;
            font-weight: 500;
            flex: 1;
        }
        .menu-item .arrow-icon {
            font-size: 0.9rem;
            transition: transform 0.3s;
            margin-left: auto;
        }
        .menu-item.open .arrow-icon {
            transform: rotate(-90deg);
        }
        .menu-item:hover {
            background: rgba(59, 130, 246, 0.2);
            color: white;
        }
        .menu-item.active {
            background: rgba(59, 130, 246, 0.2);
            color: white;
        }
        .submenu {
            list-style: none;
            padding-left: 56px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
        }
        .submenu.open {
            max-height: 200px;
        }
        .submenu-item {
            padding: 10px 0 10px 12px;
            margin: 2px 8px 2px 0;
            border-radius: 10px;
            color: #a0afc0;
            font-size: 0.95rem;
            cursor: pointer;
            white-space: nowrap;
            display: flex;
            align-items: center;
        }
        .submenu-item:hover {
            color: white;
            background: rgba(255, 255, 255, 0.05);
        }
        .submenu-item i {
            margin-right: 10px;
            font-size: 1rem;
            width: 20px;
            color: #a0afc0;
        }
        .submenu-item a {
            color: inherit;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
        }
        .sidebar.collapsed .menu-item span,
        .sidebar.collapsed .menu-item .arrow-icon {
            display: none;
        }
        .sidebar.collapsed .submenu {
            display: none;
        }
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                left: -280px;
                width: 280px;
                z-index: 2000;
                transition: left 0.3s ease-in-out;
            }
            .sidebar.mobile-open {
                left: 0;
                box-shadow: 10px 0 25px rgba(0,0,0,0.2);
            }
            .main-content {
                width: 100%;
            }
            .mobile-menu-btn {
                display: block;
            }
        }

        /* Main content area */
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
        .user-dropdown {
            position: relative;
            cursor: pointer;
        }
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
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
        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 50px;
            background: white;
            min-width: 180px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 1px solid #edf2f7;
            overflow: hidden;
            z-index: 1001;
        }
        .dropdown-menu.show {
            display: block;
        }
        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            color: #1e293b;
            text-decoration: none;
            font-size: 0.95rem;
            transition: 0.2s;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
        }
        .dropdown-item:hover {
            background: #f1f5f9;
        }
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
        }
        .footer {
            background: white;
            padding: 20px 30px;
            border-top: 1px solid #e9eef2;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        @media (max-width: 768px) {
            .content-area {
                padding: 20px;
            }
        }

        /* ========== ENHANCED FORM STYLES ========== */
        .form-card {
            background: white;
            border-radius: 28px;
            padding: 35px;
            max-width: 850px;
            margin: 0 auto;
            box-shadow: 0 12px 40px rgba(0,0,0,0.04);
            border: 1px solid #eef2f6;
            transition: all 0.3s ease;
        }
        .card-header-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 32px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f5f9;
            flex-wrap: wrap;
            gap: 12px;
        }
        .card-header-custom h3 {
            font-size: 1.35rem;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .card-header-custom i {
            color: #3b82f6;
            font-size: 1.5rem;
        }
        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
            border-radius: 40px;
            padding: 8px 18px;
            font-weight: 500;
            text-decoration: none;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
        }
        .btn-secondary:hover {
            background: #e2e8f0;
            color: #0f172a;
        }
        .form-group {
            margin-bottom: 24px;
        }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
            letter-spacing: 0.3px;
        }
        .input-group {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            transition: all 0.2s ease;
        }
        .input-group:focus-within {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        .input-group-icon {
            padding: 0 16px;
            color: #3b82f6;
            font-size: 1rem;
        }
        .input-group input, .input-group select {
            width: 100%;
            padding: 14px 16px 14px 0;
            border: none;
            outline: none;
            font-size: 0.95rem;
            color: #1e293b;
            background: transparent;
            font-family: inherit;
        }
        .input-group input::placeholder {
            color: #94a3b8;
            font-weight: 400;
        }
        .radio-group {
            display: flex;
            gap: 24px;
            align-items: center;
            padding: 8px 0;
            flex-wrap: wrap;
        }
        .radio-group label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            text-transform: none;
            font-size: 0.9rem;
            color: #1e293b;
            cursor: pointer;
        }
        .radio-group input[type="radio"] {
            accent-color: #3b82f6;
            width: 16px;
            height: 16px;
            margin: 0;
        }
        .action-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            margin-top: 36px;
            border-top: 1px solid #f1f5f9;
            padding-top: 30px;
        }
        .btn {
            padding: 12px 28px;
            border-radius: 40px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 8px rgba(59, 130, 246, 0.2);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }
        .alert {
            margin-top: 20px;
            padding: 14px 18px;
            border-radius: 16px;
            background: #fee2e2;
            color: #991b1b;
            font-size: 0.9rem;
        }
        @media (max-width: 768px) {
            .form-card {
                padding: 24px;
            }
            .action-buttons {
                flex-direction: column;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
            .radio-group {
                gap: 16px;
            }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="OrganizerSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="OrganizerHeader.jsp" />
        <div class="content-area">
            <div style="margin-bottom: 24px;">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: #0f172a;">Invite Judge</h1>
            </div>

            <div class="form-card">
                <div class="card-header-custom">
                    <h3><i class="fas fa-user-plus"></i> Invite New Judge</h3>
                    <a href="listJudge" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
                <form action="saveJudge" method="post">
                    <div class="form-group">
                        <label>First Name</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-user"></i></span>
                            <input type="text" name="firstName" required placeholder="Enter first name" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Last Name</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-user"></i></span>
                            <input type="text" name="lastName" required placeholder="Enter last name" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" required placeholder="judge@example.com" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Contact Number</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-phone"></i></span>
                            <input type="text" name="contactNum" placeholder="+91 9876543210" />
                        </div>
                    </div>
                    <!-- Gender Field -->
                    <div class="form-group">
                        <label>Gender</label>
                        <div class="radio-group">
                            <label><input type="radio" name="gender" value="Male" required> Male</label>
                            <label><input type="radio" name="gender" value="Female"> Female</label>
                            <label><input type="radio" name="gender" value="Other"> Other</label>
                        </div>
                    </div>
                    <!-- Birth Year Field -->
                    <div class="form-group">
                        <label>Birth Year</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-calendar-alt"></i></span>
                            <input type="number" name="birthYear" placeholder="YYYY" min="1900" max="2026" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Qualification</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-graduation-cap"></i></span>
                            <input type="text" name="qualification" placeholder="e.g., M.Tech, PhD" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Designation</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-briefcase"></i></span>
                            <input type="text" name="designation" placeholder="e.g., Senior Engineer, Professor" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Organization</label>
                        <div class="input-group">
                            <span class="input-group-icon"><i class="fas fa-building"></i></span>
                            <input type="text" name="organization" placeholder="Company or Institute" />
                        </div>
                    </div>
                    <div class="action-buttons">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Send Invite
                        </button>
                    </div>
                    <c:if test="${not empty error}">
                        <div class="alert">${error}</div>
                    </c:if>
                </form>
            </div>
        </div>
        <footer class="footer">
            &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
        </footer>
    </div>
</div>

<!-- Sidebar and dropdown toggle script -->
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

    // User dropdown
    const userDropdown = document.getElementById('userDropdown');
    const dropdownMenu = document.getElementById('dropdownMenu');
    if (userDropdown) {
        userDropdown.addEventListener('click', (e) => {
            e.stopPropagation();
            dropdownMenu.classList.toggle('show');
        });
    }
    document.addEventListener('click', () => {
        if (dropdownMenu) dropdownMenu.classList.remove('show');
    });
</script>
</body>
</html>