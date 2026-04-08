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
    justify-content: center;
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

  .menu-item:hover{
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

  /* Collapsed sidebar adjustments */
  .sidebar.collapsed .menu-item span,
  .sidebar.collapsed .menu-item .arrow-icon {
    display: none;
  }

  .sidebar.collapsed .submenu {
    display: none;
  }

  @media (max-width: 768px) {
    #sidebar {
        position: fixed;
        top: 0;
        left: -280px;
        width: 280px;
        height: 100vh;
        z-index: 2000;
        background: #1e293b;
        transition: left 0.3s ease-in-out;
        box-shadow: none;
    }
    #sidebar.mobile-open {
        left: 0;
        box-shadow: 10px 0 25px rgba(0,0,0,0.2);
    }
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
  </div>

  <div class="sidebar-menu">
    <!-- Dashboard -->
    <div class="menu-item active">
      <i class="fas fa-th-large"></i>
      <span>Dashboard</span>
      <a href="/dashboard" style="position:absolute; inset:0;"></a>
    </div>

    <!-- Hackathons submenu -->
    <div class="menu-item" id="hackathonMenu">
      <i class="fas fa-calendar-alt"></i>
      <span>Hackathons</span>
      <i class="fas fa-chevron-left arrow-icon"></i>
    </div>
    <ul class="submenu" id="hackathonSubmenu">
      <li class="submenu-item"><a href="/create-hackathon"><i class="fas fa-plus-circle"></i> Add Hackathon</a></li>
      <li class="submenu-item"><a href="/listHackathon"><i class="fas fa-list"></i> List Hackathons</a></li>
    </ul>

 <!-- Judges submenu -->
    <div class="menu-item" id="judgeMenu">
      <i class="fas fa-gavel"></i>
      <span>Judges</span>
      <i class="fas fa-chevron-left arrow-icon"></i>
    </div>
    <ul class="submenu" id="judgeSubmenu">
      <li class="submenu-item"><a href="/newJudge"><i class="fas fa-user-plus"></i> Invite Judge</a></li>
      <li class="submenu-item"><a href="/listJudge"><i class="fas fa-list"></i> List Judges</a></li>
    </ul>
    <!-- Users submenu -->
    <div class="menu-item" id="userMenu">
      <i class="fas fa-users"></i>
      <span>Users</span>
      <i class="fas fa-chevron-left arrow-icon"></i>
    </div>
    <ul class="submenu" id="userSubmenu">
      <li class="submenu-item"><a href="newUserType"><i class="fas fa-tag"></i> Add User Type</a></li>
      <li class="submenu-item"><a href="listUser"><i class="fas fa-list"></i> List Users</a></li>
    </ul>

   

    <!-- Logout (replaces Settings) -->
    <div class="menu-item">
      <i class="fas fa-sign-out-alt"></i>
      <span>Logout</span>
      <a href="${pageContext.request.contextPath}/logout" style="position:absolute; inset:0;"></a>
    </div>
  </div>

  <div class="sidebar-footer" style="padding: 20px;"></div>
</aside>

<script>
  const menuItems = document.querySelectorAll('.menu-item');
  menuItems.forEach(item => {
    item.addEventListener('click', function (e) {
      // Don't interfere if clicking on the logout link (let it navigate)
      if (this.querySelector('a') && this.querySelector('a').getAttribute('href') === '${pageContext.request.contextPath}/logout') {
        return; // allow normal navigation
      }
      menuItems.forEach(i => i.classList.remove('active'));
      this.classList.add('active');
    });
  });

  const sidebar = document.getElementById('sidebar');

  const hackathonMenu = document.getElementById('hackathonMenu');
  const hackathonSubmenu = document.getElementById('hackathonSubmenu');
  const userMenu = document.getElementById('userMenu');
  const judgeMenu = document.getElementById('judgeMenu');
  const userSubmenu = document.getElementById('userSubmenu');

  function setupSubmenu(menu, submenu) {
    if (!menu || !submenu) return;
    menu.addEventListener('click', (e) => {
      e.stopPropagation();
      if (!sidebar.classList.contains('collapsed')) {
        menu.classList.toggle('open');
        submenu.classList.toggle('open');
      }
    });
  }

  setupSubmenu(hackathonMenu, hackathonSubmenu);
  setupSubmenu(userMenu, userSubmenu);
  setupSubmenu(judgeMenu, judgeSubmenu);

  const currentPath = window.location.pathname;
  document.querySelectorAll('.submenu-item a').forEach(link => {
    const href = link.getAttribute('href');
    if (href === currentPath) {
      link.closest('.submenu-item').classList.add('active');
      const submenu = link.closest('.submenu');
      submenu.classList.add('open');
      const menuItem = submenu.previousElementSibling;
      if (menuItem) {
        menuItem.classList.add('active');
        menuItem.classList.add('open');
      }
    }
  });
</script>