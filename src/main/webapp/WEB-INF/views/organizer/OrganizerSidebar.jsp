<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    /* ========== ORGANIZER SIDEBAR STYLES ========== */
    #organizer-sidebar {
        width: 260px;
        background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
        color: #e2e8f0;
        transition: width 0.3s ease, left 0.3s ease;
        display: flex;
        flex-direction: column;
        box-shadow: 4px 0 20px rgba(0,0,0,0.08);
        flex-shrink: 0;
        height: 100vh;
        overflow-y: auto;
    }

    #organizer-sidebar.collapsed {
        width: 80px;
    }

    .sidebar-header {
        padding: 24px 20px;
        display: flex;
        align-items: center;
        justify-content: center;
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

    #organizer-sidebar.collapsed .logo-text {
        display: none;
    }

    .sidebar-menu {
        flex: 1;
        padding: 20px 0;
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

    .menu-item i {
        font-size: 1.25rem;
        min-width: 36px;
    }

    .menu-item span {
        margin-left: 8px;
        font-weight: 500;
        flex: 1;
    }

    .menu-item a {
        color: inherit;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 10px;
        width: 100%;
    }

    .menu-item:hover,
    .menu-item.active {
        background: rgba(59, 130, 246, 0.2);
        color: white;
    }

    #organizer-sidebar.collapsed .menu-item span {
        display: none;
    }

    #organizer-sidebar.collapsed .menu-item {
        justify-content: center;
        padding: 12px 0;
    }

    /* Mobile styles */
    @media (max-width: 768px) {
        #organizer-sidebar {
            position: fixed;
            top: 0;
            left: -280px;
            width: 280px;
            z-index: 2000;
            transition: left 0.3s ease-in-out;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
        }
        #organizer-sidebar.mobile-open {
            left: 0;
            box-shadow: 10px 0 25px rgba(0,0,0,0.2);
        }
        .main-content {
            margin-left: 0 !important;
            width: 100% !important;
        }
    }

    /* Scrollbar styling */
    #organizer-sidebar::-webkit-scrollbar {
        width: 4px;
    }
    #organizer-sidebar::-webkit-scrollbar-thumb {
        background: rgba(255,255,255,0.2);
        border-radius: 10px;
    }
</style>

<aside id="organizer-sidebar">
    <div class="sidebar-header">
        <div class="logo-area">
            <img alt="CodeVerse Logo" src="${pageContext.request.contextPath}/img/logo/logo1.png" class="logo-icon-img">
            <span class="logo-text">CodeVerse</span>
        </div>
    </div>
    <div class="sidebar-menu">
        <div class="menu-item">
            <a href="/organizer/dashboard">
                <i class="fas fa-th-large"></i>
                <span>Dashboard</span>
            </a>
        </div>
        <div class="menu-item">
            <a href="/organizer/hackathons">
                <i class="fas fa-calendar-alt"></i>
                <span>My Hackathons</span>
            </a>
        </div>
        <div class="menu-item">
            <a href="/organizer/create-hackathon">
                <i class="fas fa-plus-circle"></i>
                <span>Create Hackathon</span>
            </a>
        </div>
        <div class="menu-item">
            <a href="/organizer/manage-judges">
                <i class="fas fa-users"></i>
                <span>Manage Judges</span>
            </a>
        </div>
        <div class="menu-item">
            <a href="/organizer/profile">
                <i class="fas fa-user-circle"></i>
                <span>Profile</span>
            </a>
        </div>
        <div class="menu-item">
            <a href="/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </div>
</aside>