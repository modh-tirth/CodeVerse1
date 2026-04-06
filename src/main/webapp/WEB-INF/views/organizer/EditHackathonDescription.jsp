<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Edit Hackathon Description | CodeVerse Admin</title>

<!-- Additional modern styles -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body { font-family:'Inter', sans-serif; background:#f5f7fb; color:#1e293b; }
    .content-wrapper {
        background: #f8fafc;
        padding: 30px;
    }
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
        border-bottom: 1px solid #e9eef2;
        padding-bottom: 15px;
    }
    .card-header i {
        color: #3b82f6;
        font-size: 1.4rem;
    }
    .card-header h3 {
        font-size: 1.2rem;
        font-weight: 600;
        color: #0f172a;
        margin: 0;
    }
    .form-group {
        margin-bottom: 25px;
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
    .input-group select,
    .input-group textarea {
        width: 100%;
        padding: 14px 15px 14px 0;
        border: none;
        outline: none;
        font-size: 1rem;
        color: #1e293b;
        background: transparent;
        font-family: 'Inter', sans-serif;
    }
    .input-group textarea {
        min-height: 250px;
        resize: vertical;
    }
    .input-group select {
        padding-right: 35px;
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>") no-repeat right 15px center;
        background-size: 16px;
    }
    .action-buttons {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #e9eef2;
    }
    .btn {
        padding: 12px 35px;
        border-radius: 50px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        transition: 0.2s;
        font-size: 1rem;
        text-decoration: none;
        display: inline-block;
        text-align: center;
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
    @media (max-width: 768px) {
        .content-wrapper {
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
</style>
</head>
<body>
<div class="container-scroller">
    <jsp:include page="OrganizerHeader.jsp"></jsp:include>
    <div class="container-fluid page-body-wrapper">
        <jsp:include page="OrganizerSidebar.jsp"></jsp:include>
        <div class="main-panel">
            <div class="content-wrapper">
                <div class="row">
                    <div class="col-12 mb-3">
                        <h3 class="font-weight-bold">Edit Hackathon Description</h3>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="listHackathonDescription">Hackathon Descriptions</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Description</li>
                            </ol>
                        </nav>
                    </div>
                </div>

                <div class="form-card">
                    <div class="card-header">
                        <i class="fas fa-edit"></i>
                        <h3>Update Hackathon Description</h3>
                    </div>
                    <form action="updateHackathonDescription" method="post">
                        <input type="hidden" name="hackathonDescriptionId" value="${description.hackathonDescriptionId}">
                        
                        <div class="form-group">
                            <label>Select Hackathon</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-trophy"></i></span>
                                <select name="hackathonId" required>
                                    <option value="">-- Select Hackathon --</option>
                                    <c:forEach var="h" items="${allHackthon}">
                                        <option value="${h.hackathonId}" ${description.hackathonId == h.hackathonId ? 'selected' : ''}>${h.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label>Hackathon Details (HTML)</label>
                            <div class="input-group">
                                <span class="input-group-icon"><i class="fas fa-code"></i></span>
                                <textarea name="hackathonDetails" rows="10" required>${description.hackathonDetails}</textarea>
                            </div>
                        </div>
                        
                        <div class="action-buttons">
                            <a href="listHackathonDescription?hackathonId=${description.hackathonId}" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Update Description</button>
                        </div>
                    </form>
                </div>
            </div>
          
        </div>
    </div>
</div>
</body>
</html>