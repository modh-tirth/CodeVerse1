<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Hackathon Description | CodeVerse</title>
    <%-- Standard pathing for your CSS in STS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dashboard.css">
</head>
<body>
    <div class="dashboard">
        <aside class="sidebar">
            <div class="logo">Code<span>Verse</span></div>
            <nav>
                <a href="dashboard" class="nav-item">📊 Dashboard Overview</a>
                <a href="manage-hackathons" class="nav-item">🏆 Manage Hackathons</a>
                <a href="newhackathon" class="nav-item active">➕ New Hackathon</a>
                <a href="settings" class="nav-item">⚙️ Settings</a>
            </nav>
            <div class="logout-section">
                <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">
                    <svg class="icon-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                        <polyline points="16 17 21 12 16 7"></polyline>
                        <line x1="21" y1="12" x2="9" y2="12"></line>
                    </svg>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <main class="content">
            <header class="header">
                <h1 style="color: #f8fafc;">Add Hackathon Details</h1>
                <p style="color: #94a3b8;">Provide a clear description and rules for participants.</p>
            </header>

            <div class="card" style="max-width: 800px; margin-top: 20px;">
                <form action="saveHackathonDescription" method="POST">
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="color: #94a3b8; display: block; margin-bottom: 8px;">Hackathon Title</label>
                        <input type="text" name="title" placeholder="e.g., CodeSprint 2026" required 
                               style="background: #0b0f19; color: white; border: 1px solid #30363d; padding: 12px; width: 100%; border-radius: 6px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="color: #94a3b8; display: block; margin-bottom: 8px;">Detailed Description</label>
                        <textarea name="hackathon_details" rows="6" placeholder="Describe the theme, objectives, and what you are looking for..." required 
                                  style="background: #0b0f19; color: white; border: 1px solid #30363d; padding: 12px; width: 100%; border-radius: 6px; resize: vertical;"></textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="color: #94a3b8; display: block; margin-bottom: 8px;">Rules & Regulations</label>
                        <textarea name="rules" rows="4" placeholder="Enter specific rules, eligibility, and judging criteria..." required 
                                  style="background: #0b0f19; color: white; border: 1px solid #30363d; padding: 12px; width: 100%; border-radius: 6px; resize: vertical;"></textarea>
                    </div>

                    <div style="margin-top: 30px; display: flex; gap: 15px;">
                        <button type="submit" class="btn-primary" style="flex: 1; padding: 12px; border-radius: 6px; cursor: pointer;">
                            🚀 Publish Hackathon
                        </button>
                        <button type="button" onclick="location.href='manage-hackathons'" 
                                style="flex: 1; background: #161b22; color: #f8fafc; border: 1px solid #30363d; padding: 12px; border-radius: 6px; cursor: pointer;">
                            ✖ Cancel
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>