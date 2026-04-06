<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Organizer Dashboard | CodeVerse</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .btn { background: #3b82f6; color: white; padding: 0.5rem 1rem; border-radius: 0.5rem; text-decoration: none; }
        .hackathon-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px,1fr)); gap: 1.5rem; }
        .card { background: white; border-radius: 1rem; padding: 1.5rem; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .card h3 { margin: 0 0 0.5rem 0; }
        .status { display: inline-block; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.75rem; font-weight: 600; }
        .status-upcoming { background: #fef9c3; color: #854d0e; }
        .status-live { background: #d1fae5; color: #065f46; }
        .status-completed { background: #e0e7ff; color: #3730a3; }
        .actions { margin-top: 1rem; display: flex; gap: 0.5rem; }
        .actions a { font-size: 0.8rem; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>My Hackathons</h1>
        <a href="${pageContext.request.contextPath}/organizer/create-hackathon" class="btn"><i class="fas fa-plus"></i> Create New Hackathon</a>
    </div>
    <div class="hackathon-grid">
        <c:forEach items="${hackathons}" var="h">
            <div class="card">
                <h3>${h.title}</h3>
                <p>${h.location}</p>
                <div>
                    <span class="status status-${fn:toLowerCase(h.status)}">${h.status}</span>
                </div>
                <div class="actions">
                    <a href="/organizer/edit-hackathon?hackathonId=${h.hackathonId}">Edit</a>
                    <a href="/organizer/manage-judges?hackathonId=${h.hackathonId}">Manage Judges</a>
                    <a href="/organizer/delete-hackathon?hackathonId=${h.hackathonId}" onclick="return confirm('Delete?')">Delete</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>