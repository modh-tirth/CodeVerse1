<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Participant Header with user dropdown -->
<header class="participant-header">
    <div class="header-left">
        <!-- Single hamburger button for both desktop collapse and mobile menu -->
        <button class="menu-toggle-btn" id="menuToggleBtn" title="Toggle sidebar">
            <i class="fas fa-bars"></i>
        </button>
    </div>
    <div class="header-right">
        <!-- User Profile with Dropdown -->
        <div class="user-dropdown" id="userDropdown">
            <div class="user-profile">
                <div class="user-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.profilePicURL}">
                            <img src="${sessionScope.user.profilePicURL}" alt="Profile" class="avatar-img">
                        </c:when>
                        <c:otherwise>
                            <span class="avatar-initials"><c:out value="${sessionScope.user.firstName.charAt(0)}" /></span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="user-info">
                    <div class="name"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" /></div>
                    <div class="role">${sessionScope.user.role}</div>
                </div>
            </div>
            <!-- Dropdown Menu -->
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="/participant/profile" class="dropdown-item">
                    <i class="fas fa-user-circle"></i> Profile
                </a>
                <div class="dropdown-divider"></div>
                <form action="${pageContext.request.contextPath}/logout" method="get" style="margin:0;">
                    <button type="submit" class="dropdown-item">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>
        </div>
    </div>
</header>

<style>
    /* Global reset – ensure no unwanted spacing */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    html, body {
        max-width: 100vw;
        overflow-x: hidden;
        margin: 0;
        padding: 0;
    }

    /* Fixed Header */
    .participant-header {
        position:sticky; 
        top: 0;
        left: 0;
        width: 100%;
        height: 70px; /* Consistent height */
        z-index: 1000; 
        background: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        box-sizing: border-box;
        border-bottom: 1px solid #e9eef2;
        font-family: 'Inter', sans-serif;
        padding-left:260;
        }
    .header-left {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .menu-toggle-btn {
        background: transparent;
        border: none;
        color: #475569;
        font-size: 1.5rem;
        cursor: pointer;
        padding: 8px 12px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: 0.2s;
    }
    .menu-toggle-btn:hover {
        background: #f1f5f9;
        color: #0f172a;
    }

    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    /* User dropdown container */
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
        font-size: 1rem;
        overflow: hidden;
        flex-shrink: 0;
    }
    .avatar-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .avatar-initials {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #3b82f6;
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

    /* Dropdown menu */
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
    .dropdown-item i {
        color: #3b82f6;
        width: 20px;
    }
    .dropdown-item:hover {
        background: #f1f5f9;
    }
    .dropdown-divider {
        height: 1px;
        background: #edf2f7;
        margin: 4px 0;
    }

    /* Mobile body lock */
    body.mobile-menu-active {
        overflow: hidden;
        height: 100vh;
    }
</style>

<script>
    // Wait for DOM and sidebar (must be included before this header)
    document.addEventListener('DOMContentLoaded', function() {
        const menuToggleBtn = document.getElementById('menuToggleBtn');
        const userDropdown = document.getElementById('userDropdown');
        const dropdownMenu = document.getElementById('dropdownMenu');
        const sidebar = document.getElementById('sidebar'); // defined in sidebar.jsp

        if (menuToggleBtn) {
            menuToggleBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (!sidebar) return;

                if (window.innerWidth <= 768) {
                    // Mobile: toggle sidebar slide and body lock
                    const isOpen = sidebar.classList.toggle('mobile-open');
                    document.body.classList.toggle('mobile-menu-active', isOpen);
                } else {
                    // Desktop: toggle collapsed mode
                    sidebar.classList.toggle('collapsed');
                }
            });
        }

        // Close dropdown when clicking outside
        if (userDropdown) {
            userDropdown.addEventListener('click', (e) => {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });
        }

        // Global click: close dropdown and close mobile sidebar if outside
        document.addEventListener('click', (e) => {
            // Close dropdown if click outside userDropdown
            if (userDropdown && !userDropdown.contains(e.target)) {
                dropdownMenu.classList.remove('show');
            }

            // Close mobile sidebar if open and click outside
            if (window.innerWidth <= 768 && sidebar && sidebar.classList.contains('mobile-open')) {
                if (!sidebar.contains(e.target) && !menuToggleBtn.contains(e.target)) {
                    sidebar.classList.remove('mobile-open');
                    document.body.classList.remove('mobile-menu-active');
                }
            }
        });

        // Reset on resize
        window.addEventListener('resize', () => {
            if (window.innerWidth > 768) {
                if (sidebar) {
                    sidebar.classList.remove('mobile-open');
                }
                document.body.classList.remove('mobile-menu-active');
            }
        });
    });
</script>