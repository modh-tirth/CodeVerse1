<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Create Category | CodeVerse Admin</title>
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

        /* Layout */
        .app-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar styles are assumed to be in AdminSidebar.jsp */
        /* We'll include the toggle button functionality later */

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8fafc;
        }

        /* Header */
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

        /* Content Area */
        .content-area {
            padding: 30px;
            flex: 1;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            max-width: 800px;
            margin: 0 auto;
            box-shadow: 0 8px 30px rgba(0,0,0,0.02);
            border: 1px solid #edf2f7;
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 30px;
        }

        .card-header h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #0f172a;
        }

        .card-header i {
            color: #3b82f6;
            font-size: 1.4rem;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            color: #64748b;
            margin-bottom: 8px;
        }

        .input-group {
            display: flex;
            align-items: center;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            overflow: hidden;
            transition: 0.2s;
        }
        .input-group:focus-within {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }

        .input-group-icon {
            padding: 0 15px;
            color: #3b82f6;
            font-size: 1.1rem;
        }

        .input-group input {
            width: 100%;
            padding: 14px 15px 14px 0;
            border: none;
            outline: none;
            font-size: 1rem;
            color: #1e293b;
            background: transparent;
        }

        .helper-text {
            color: #64748b;
            font-size: 0.85rem;
            margin-top: 8px;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 35px;
            border-radius: 50px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: 0.2s;
            font-size: 1rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 10px rgba(59,130,246,0.3);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59,130,246,0.4);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #1e293b;
        }
        .btn-secondary:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
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
            .mobile-menu-btn {
                display: block;
            }
            .top-header {
                padding: 16px 20px;
            }
            .content-area {
                padding: 20px;
            }
            .form-card {
                padding: 20px;
            }
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            .btn {
                width: 100%;
                max-width: 300px;
            }
        }

        /* Additional style for logout button if not in shared header */
        .logout-btn {
            background: transparent;
            border: none;
            color: #475569;
            font-size: 1.25rem;
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
            margin-right: 8px;
        }
        .logout-btn:hover {
            background: #f1f5f9;
            color: #ef4444;
        }
    </style>
</head>
<body>
    <div class="app-wrapper">
        <!-- Sidebar (unchanged) -->
        <jsp:include page="OrganizerSidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Shared Header (includes notification, logout, user profile) -->
            <jsp:include page="OrganizerHeader.jsp" />

            <!-- Content Area -->
            <div class="content-area">
                <!-- Page title moved here -->
                <h1 class="page-title" style="margin-bottom: 24px;">Create Category</h1>

                <div class="form-card">
                    <div class="card-header">
                        <i class="fas fa-folder"></i>
                        <h3>Competition Category</h3>
                    </div>

                    <form action="saveCategory" method="POST">
                        <div class="form-group">
                            <label>Track Name</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-tag"></i></span>
                                <input type="text" name="categoryName" placeholder="e.g. Artificial Intelligence, Web Dev, FinTech" required>
                            </div>
                            <div class="helper-text">
                                <i class="fas fa-info-circle"></i> Categories help participants filter competitions based on their skill sets.
                            </div>
                        </div>

                        <div class="action-buttons">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Category</button>
                            <button type="button" onclick="location.href='listcategories'" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</button>
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

    <!-- JavaScript for Sidebar Toggle & Mobile Menu -->
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

        mobileMenuBtn.addEventListener('click', () => {
            sidebar.classList.add('mobile-open');
        });

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