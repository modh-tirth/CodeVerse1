<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management | CodeVerse</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; color: #1e293b; }
        .app-wrapper { display: flex; min-height: 100vh; }
        .main-content { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; }
        .content-area { padding: 30px; flex: 1; overflow-y: auto; background: #f8fafc; }
        .table-card { background: white; border-radius: 24px; padding: 24px; box-shadow: 0 8px 30px rgba(0,0,0,0.02); border: 1px solid #edf2f7; }
        .card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        .card-header h3 { font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .card-header h3 i { color: #3b82f6; }
        .add-btn { background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; border: none; border-radius: 30px; padding: 8px 20px; font-weight: 500; display: flex; align-items: center; gap: 8px; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .add-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(59,130,246,0.3); }
        .filter-bar { margin-bottom: 25px; display: flex; justify-content: flex-end; }
        .filter-input { padding: 10px 16px; border: 1px solid #e2e8f0; border-radius: 30px; width: 260px; font-family: 'Inter', sans-serif; font-size: 0.9rem; outline: none; transition: 0.2s; margin-left:45rem;margin-top:10px; }
        .filter-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
        .responsive-table { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 16px 12px; font-weight: 600; font-size: 0.85rem; color: #64748b; text-transform: uppercase; border-bottom: 2px solid #e2e8f0; }
        td { padding: 16px 12px; border-bottom: 1px solid #edf2f7; color: #1e293b; vertical-align: middle; }
        .profile-img-small { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid #fff; }
        .user-name { font-weight: 600; display: block; }
        .user-email { color: #3b82f6; font-size: 0.85rem; }
        .user-role { font-size: 0.75rem; color: #64748b; text-transform: uppercase; }
        .status-badge { padding: 6px 14px; border-radius: 30px; font-size: 0.75rem; font-weight: 600; display: inline-block; }
        .status-active { background: #d1fae5; color: #065f46; }
        .status-disabled { background: #fee2e2; color: #991b1b; }
        .action-btns { display: flex; gap: 8px; }
        .btn-icon { width: 36px; height: 36px; border-radius: 10px; border: none; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; color: white; }
        .btn-view { background: #10b981; }
        .btn-edit { background: #3b82f6; }
        .btn-delete { background: #ef4444; }
        .pagination { display: flex; justify-content: center; margin-top: 24px; gap: 12px; align-items: center; }
        .page-link { padding: 8px 18px; border-radius: 30px; background: white; border: 1px solid #e2e8f0; color: #1e293b; cursor: pointer; font-size: 0.9rem; font-weight: 500; transition: 0.2s; }
        .page-link:hover { background: #f1f5f9; border-color: #cbd5e1; }
        .page-link.disabled { opacity: 0.5; cursor: not-allowed; pointer-events: none; }
        .current-page-indicator { font-size: 0.95rem; font-weight: 600; background:#38bdf8; padding: 6px 14px; border-radius: 30px; color: #1e293b; }
        .footer { background: white; padding: 20px 30px; border-top: 1px solid #e9eef2; text-align: center; color: #64748b; font-size: 0.9rem; flex-shrink: 0; }
        @media (max-width: 768px) { .content-area { padding: 20px; } .card-header { flex-direction: column; align-items: flex-start; } .filter-bar { justify-content: stretch; } .filter-input { width: 100%; } .pagination { gap: 8px; } .page-link { padding: 6px 14px; } }
    </style>
</head>
<body>
<div class="app-wrapper">
    <jsp:include page="OrganizerSidebar.jsp" />
    <div class="main-content">
        <jsp:include page="OrganizerHeader.jsp" />
        <div class="content-area">
            <h1 style="margin-bottom: 24px;">User Management</h1>
            <div class="table-card">
                <div class="card-header">
                    <h3><i class="fas fa-users"></i> Platform User Directory</h3>
                    <div class="filter-bar">
                    <input type="text" id="filterInput" class="filter-input" placeholder="🔍 Filter by name, email or role...">
                </div>
                    <a href="register" class="add-btn"><i class="fas fa-user-plus"></i> Add User</a>
                     <!-- Filter input above table -->
                
                </div>
               
                <div class="responsive-table">
                    <table id="userTable">
                        <thead>
                        <tr><th>#</th><th>Image</th><th>Name</th><th>Email / Role</th><th>Gender / YOB</th><th>Status</th><th>Actions</th></tr>
                        </thead>
                        <tbody id="userTableBody">
                        <c:forEach var="user" items="${userList}" varStatus="s">
                            <tr data-user-id="${user.userId}">
                                <td>${s.count}</td>
                                <td><c:choose><c:when test="${not empty user.profilePicURL}"><img src="${user.profilePicURL}" class="profile-img-small" alt="Profile" /></c:when><c:otherwise><img src="img/contact/1.jpg" class="profile-img-small" alt="Default" /></c:otherwise></c:choose></td>
                                <td><span class="user-name">${user.firstName} ${user.lastName}</span></td>
                                <td><div class="user-email">${user.email}</div><div class="user-role">${user.role}</div></td>
                                <td><div>${user.gender}</div><div style="font-size:0.75rem;color:#64748b;">Born: ${user.birthYear}</div></td>
                                <td><c:choose><c:when test="${user.active}"><span class="status-badge status-active">Active</span></c:when><c:otherwise><span class="status-badge status-disabled">Disabled</span></c:otherwise></c:choose></td>
                                <td><div class="action-btns">
                                    <button class="btn-icon btn-view" onclick="location.href='viewUser?userId=${user.userId}'"><i class="fas fa-eye"></i></button>
                                    <button class="btn-icon btn-edit" onclick="location.href='edit-user?userId=${user.userId}'"><i class="fas fa-pencil-alt"></i></button>
                                    <button class="btn-icon btn-delete" onclick="if(confirm('Delete this user?')) location.href='deleteUser?userId=${user.userId}'"><i class="fas fa-trash"></i></button>
                                </div></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty userList}">
                            <tr id="noDataRow"><td colspan="7" style="text-align:center;padding:60px;">No users found.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
                <div id="paginationControls" class="pagination"></div>
            </div>
        </div>
        <footer class="footer">&copy; 2026 CodeVerse. All rights reserved.</footer>
    </div>
</div>

<script>
    // Client-side filter + pagination (10 rows per page) with Prev/Next and current page indicator
    (function() {
        var tbody = document.getElementById('userTableBody');
        var paginationDiv = document.getElementById('paginationControls');
        var filterInput = document.getElementById('filterInput');
        
        // Get all rows (original data)
        var allRows = Array.from(tbody.querySelectorAll('tr'));
        // Check if there is a "no data" row from JSP
        var noDataRow = allRows.find(function(r) { return r.id === 'noDataRow'; });
        if (noDataRow) {
            paginationDiv.style.display = 'none';
            filterInput.style.display = 'none';
            return;
        }
        
        var rowsPerPage = 10;
        var currentPage = 1;
        var filteredRows = [];  // will hold rows after filtering
        
        // Function to filter rows based on input text
        function filterRows() {
            var searchTerm = filterInput.value.trim().toLowerCase();
            if (searchTerm === '') {
                filteredRows = allRows.slice(); // all rows
            } else {
                filteredRows = allRows.filter(function(row) {
                    var text = row.innerText.toLowerCase();
                    return text.includes(searchTerm);
                });
            }
            // Reset to first page after filtering
            currentPage = 1;
            updatePaginationAndDisplay();
        }
        
        // Update display and pagination buttons
        function updatePaginationAndDisplay() {
            var totalFiltered = filteredRows.length;
            var totalPages = Math.ceil(totalFiltered / rowsPerPage);
            
            if (totalFiltered === 0) {
                // Show empty message
                tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;padding:60px;">No matching users found.</td></tr>';
                paginationDiv.innerHTML = '';
                return;
            }
            
            // Ensure currentPage is within bounds
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages;
            
            // Calculate slice
            var start = (currentPage - 1) * rowsPerPage;
            var end = Math.min(start + rowsPerPage, totalFiltered);
            var rowsToShow = filteredRows.slice(start, end);
            
            // Rebuild tbody with only the rows to show
            tbody.innerHTML = '';
            rowsToShow.forEach(function(row) {
                tbody.appendChild(row.cloneNode(true)); // clone to preserve event handlers? but buttons have inline onclick, that's fine.
            });
            
            // Re-attach any dynamic event listeners if needed (inline onclick works on clones)
            // Re-render pagination controls
            renderPaginationControls(currentPage, totalPages);
        }
        
        function renderPaginationControls(page, totalPages) {
            paginationDiv.innerHTML = '';
            if (totalPages <= 1) return;
            
            // Previous button
            var prevBtn = document.createElement('button');
            prevBtn.className = 'page-link' + (page === 1 ? ' disabled' : '');
            prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i> Previous';
            if (page !== 1) {
                prevBtn.addEventListener('click', function() {
                    currentPage--;
                    updatePaginationAndDisplay();
                });
            }
            paginationDiv.appendChild(prevBtn);
            
            // Current page indicator (just the number)
            var pageIndicator = document.createElement('span');
            pageIndicator.className = 'current-page-indicator';
            pageIndicator.textContent =  page;
            paginationDiv.appendChild(pageIndicator);
            
            // Next button
            var nextBtn = document.createElement('button');
            nextBtn.className = 'page-link' + (page === totalPages ? ' disabled' : '');
            nextBtn.innerHTML = 'Next <i class="fas fa-chevron-right"></i>';
            if (page !== totalPages) {
                nextBtn.addEventListener('click', function() {
                    currentPage++;
                    updatePaginationAndDisplay();
                });
            }
            paginationDiv.appendChild(nextBtn);
        }
        
        // Initialize filteredRows with all rows
        filteredRows = allRows.slice();
        updatePaginationAndDisplay();
        
        // Add filter event listener (debounced for better performance)
        var debounceTimer;
        filterInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                filterRows();
            }, 300);
        });
    })();
</script>
</body>
</html>