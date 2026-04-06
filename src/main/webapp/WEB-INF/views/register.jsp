<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Register User | CodeVerse Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Fonts & Icons -->
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
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar styles (copied from dashboard) */
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
            letter-spacing: 0.5px;
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
            overflow-y: auto;
            padding: 20px 0;
        }
        .sidebar-menu::-webkit-scrollbar {
            width: 4px;
        }
        .sidebar-menu::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.2);
            border-radius: 10px;
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

        /* Main content area */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            background: #f8fafc;
        }

        /* Header (from AdminHeader.jsp) – we include it, but define styles here for completeness */
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

        /* Form card */
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
            font-size: 1.8rem;
        }
        .form-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 30px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 15px;
        }

        /* Two-column grid */
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

        .input-group input,
        .input-group select {
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            transition: 0.2s;
            background: white;
            color: #1e293b;
        }
        .input-group input:focus,
        .input-group select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .input-group input[type="file"] {
            padding: 8px 16px;
        }

        /* Full width elements */
        .full-width {
            grid-column: span 2;
        }

        /* Button row */
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
            border-color: #cbd5e1;
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

        /* Mobile responsiveness */
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
            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            .full-width {
                grid-column: span 1;
            }
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }
            .btn {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="app-wrapper">
        <!-- Sidebar -->
        <jsp:include page="AdminSidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <jsp:include page="AdminHeader.jsp" />

            <!-- Content Area -->
            <div class="content-area">
                <!-- Page Title -->
                <h1 class="page-title" style="margin-bottom: 24px;">
                    <i class="fas fa-user-plus" style="color: #3b82f6; margin-right: 10px;"></i> User Registration
                </h1>

                <!-- Form Card -->
                <div class="form-card">
                    <div class="form-title">
                        <i class="fas fa-id-card"></i> Account Details
                    </div>
                    <div class="form-subtitle">
                        Fill in the information below to create a new user account on the CodeVerse platform.
                    </div>

                    <form action="stored" method="POST" enctype="multipart/form-data">
                        <div class="form-row">
                            <!-- First Name -->
                            <div class="input-group">
                                <label><i class="fas fa-user"></i> First Name *</label>
                                <input type="text" name="firstName" placeholder="e.g., John" required>
                            </div>
                            <!-- Last Name -->
                            <div class="input-group">
                                <label><i class="fas fa-user"></i> Last Name *</label>
                                <input type="text" name="LastName" placeholder="e.g., Doe" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- Email -->
                            <div class="input-group">
                                <label><i class="fas fa-envelope"></i> Email Address *</label>
                                <input type="email" name="email" placeholder="john.doe@example.com" required>
                            </div>
                            <!-- Contact Number -->
                            <div class="input-group">
                                <label><i class="fas fa-phone-alt"></i> Contact Number *</label>
                                <input type="text" name="contactNum" placeholder="+1 234 567 890" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- Birth Year -->
                            <div class="input-group">
                                <label><i class="fas fa-calendar-alt"></i> Birth Year *</label>
                                <input type="number" name="birthYear" placeholder="1990" min="1900" max="2026" required>
                            </div>
                            <!-- Gender -->
                            <div class="input-group">
                                <label><i class="fas fa-venus-mars"></i> Gender *</label>
                                <select name="gender" required>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- Qualification -->
                            <div class="input-group">
                                <label><i class="fas fa-graduation-cap"></i> Qualification *</label>
                                <input type="text" name="qualification" placeholder="e.g., B.Tech Computer Science" required>
                            </div>
                            <!-- City -->
                            <div class="input-group">
                                <label><i class="fas fa-city"></i> City *</label>
                                <input type="text" name="city" placeholder="e.g., New York" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- State -->
                            <div class="input-group">
                                <label><i class="fas fa-map-pin"></i> State/Province *</label>
                                <input type="text" name="state" placeholder="e.g., NY" required>
                            </div>
                            <!-- Country -->
                            <div class="input-group">
                                <label><i class="fas fa-globe"></i> Country *</label>
                                <input type="text" name="country" placeholder="e.g., USA" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- User Role (select) -->
                            <div class="input-group">
                                <label><i class="fas fa-user-tag"></i> User Role *</label>
                                <select name="userTypeId" required>
                                    <option value="-1">--- Select User Role ---</option>
                                    <c:forEach items="${allUserType}" var="ut">
                                        <option value="${ut.userTypeId}">${ut.userType}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <!-- Password -->
                            <div class="input-group">
                                <label><i class="fas fa-lock"></i> Password *</label>
                                <input type="password" name="password" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- Profile Picture (full width) -->
                            <div class="input-group full-width">
                                <label><i class="fas fa-image"></i> Profile Picture</label>
                                <input type="file" name="profilePic" accept="image/*">
                            </div>
                        </div>
						<div class="form-row">
						    <div class="input-group full-width">
						        <label><i class="fas fa-user-tag"></i> I am a *</label>
						        <select name="role" required>
						            <option value="participant">Participant – Join hackathons and form teams</option>
						            <option value="organizer">Organizer – Create and manage hackathons</option>
						        </select>
						    </div>
						</div>	
							
                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check-circle"></i> Create Account
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                <i class="fas fa-undo-alt"></i> Discard
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Footer -->
            <footer class="footer">
                &copy; 2026 CodeVerse. All rights reserved. Empowering hackathons.
            </footer>
        </div>
    </div>

    <!-- JavaScript for sidebar toggle and mobile menu -->
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