<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
  .logo-icon-img {
    height: 70px;
    width: auto;
    max-width: 100%;
    object-fit: contain;
    display: block;
  }
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

  /* Sidebar */
  .sidebar {
    width: 260px;
    background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
    color: #e2e8f0;
    transition: width 0.3s ease, left 0.3s ease;
    display: flex;
    flex-direction: column;
    box-shadow: 4px 0 20px rgba(0,0,0,0.08);
  }

  .sidebar.collapsed {
    width: 80px;
  }

  .sidebar-header {
    padding: 24px 20px;
    display: flex;
    align-items: center;
    justify-content: center; /* centered because toggle button removed */
    border-bottom: 1px solid rgba(255,255,255,0.1);
  }

  .logo-area {
    display: flex;
    align-items: center;
    gap: 12px;
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

  /* Sidebar Menu */
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
  }

  .menu-item i {
    font-size: 1.25rem;
    min-width: 36px;
  }

  .menu-item span {
    margin-left: 8px;
    font-weight: 500;
  }

  .menu-item:hover,
  .menu-item.active {
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

  a {
    color: white;
    text-decoration: none;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
  }

  .menu-item a {
    display: flex;
    align-items: center;
    width: 100%;
  }

  /* Mobile behaviour */
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
  }
   /* Add this to your Sidebar CSS if not present */
@media (max-width: 768px) {
    #sidebar {
        position: fixed;
        top: 0;
        left: -260px; /* Start hidden */
        width: 260px;
        height: 100vh;
        z-index: 9999; /* Higher than header */
        transition: left 0.3s ease;
    }
    
    #sidebar.mobile-open {
        left: 0; /* Slide in */
    }
}

/* Default Mobile Sidebar State (Hidden) */
@media (max-width: 768px) {
    #sidebar {
        position: fixed;
        top: 0;
        left: -280px; /* Fully hidden off-screen (adjust to sidebar width) */
        width: 280px;
        height: 100vh;
        z-index: 2000; /* Must be above header and content */
        background: #1e293b; /* Match your dashboard color */
        transition: left 0.3s ease-in-out;
        box-shadow: none;
    }

    /* Shown State when toggled */
    #sidebar.mobile-open {
        left: 0; 
        box-shadow: 10px 0 25px rgba(0,0,0,0.2);
    }
    
    /* Ensure the main content takes full width on mobile */
    .main-content {
        margin-left: 0 !important;
        width: 100% !important;
    }
}
  
</style>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
  <div class="sidebar-header">
    <div class="logo-area">
      <img alt="CodeVerse Logo" src="${pageContext.request.contextPath}/img/logo/logo1.png" class="logo-icon-img">
      <span class="logo-text">CodeVerse</span>
    </div>
    <!-- Internal toggle button removed – now controlled from header -->
  </div>

  <div class="sidebar-menu">
    <!-- Dashboard -->
    <div class="menu-item active">
      <a href="/participant/participant-dashboard">
        <i class="fas fa-th-large"></i>
        <span>Dashboard</span>
      </a>
    </div>

    <!-- My Hackathons -->
    <div class="menu-item">
      <a href="/participant/my-hackathons">
        <i class="fas fa-calendar-alt"></i>
        <span>My Hackathons</span>
      </a>
    </div>

    <!-- My Team -->
    <div class="menu-item">
      <a href="/participant/my-team">
        <i class="fas fa-users"></i>
        <span>My Team</span>
      </a>
    </div>

    <!-- Profile -->
    <div class="menu-item">
      <a href="/participant/profile">
        <i class="fas fa-user-circle"></i>
        <span>Profile</span>
      </a>
    </div>

    <!-- Logout -->
    <div class="menu-item">
      <a href="/logout">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
      </a>
    </div>
  </div>

  <div class="sidebar-footer" style="padding: 20px;">
    <!-- optional -->
  </div>
</aside>

<!-- No internal toggle script needed – header handles collapse and mobile -->