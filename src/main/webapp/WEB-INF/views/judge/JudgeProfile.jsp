<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Profile | CodeVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }
        .page-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }
        .profile-header {
            background: white;
            border-radius: 24px;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .profile-header h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .profile-header p {
            color: #64748b;
            margin-bottom: 0;
        }
        .btn-outline-custom {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 40px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            color: #334155;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-outline-custom:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .profile-card {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .avatar-container {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e2e8f0;
        }
        .file-input-wrapper {
            flex: 1;
        }
        .file-input-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 500;
            color: #334155;
            margin-bottom: 0.5rem;
        }
        .file-input {
            display: block;
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
        }
        .form-label-custom {
            font-weight: 500;
            color: #334155;
            margin-bottom: 0.5rem;
        }
        .form-control, .form-select {
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            padding: 0.6rem 1rem;
            transition: all 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #0f9d94;
            box-shadow: 0 0 0 3px rgba(15,157,148,0.1);
        }
        .form-control[disabled] {
            background: #f8fafc;
            opacity: 0.8;
        }
        .btn-save {
            background: linear-gradient(135deg, #0f9d94, #127fcb);
            border: none;
            border-radius: 40px;
            padding: 0.7rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
            width: 100%;
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15,157,148,0.3);
        }
        .alert-custom {
            border-radius: 20px;
            border: none;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .alert-success-custom {
            border-left: 4px solid #22c55e;
        }
        .alert-danger-custom {
            border-left: 4px solid #ef4444;
        }
        footer {
            margin-top: 2rem;
            text-align: center;
            padding: 1rem;
            color: #64748b;
            font-size: 0.8rem;
        }
        @media (max-width: 768px) {
            .page-container { padding: 1rem; }
            .profile-header { padding: 1.25rem; }
            .profile-header h1 { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Header -->
    <div class="profile-header">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div>
                <h1>Judge Profile</h1>
                <p>Manage your profile details visible in assigned hackathons.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="/judge/change-password" class="btn-outline-custom">
                    <i class="fas fa-key me-1"></i> Change Password
                </a>
                <a href="/judge-dashboard" class="btn-outline-custom">
                    <i class="fas fa-tachometer-alt me-1"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-custom alert-success-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle text-success me-2"></i> Profile updated successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-custom alert-danger-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle text-danger me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Profile Form -->
    <div class="profile-card">
        <form action="/judge/profile/update" method="post" enctype="multipart/form-data">
            <!-- Profile Picture -->
            <div class="avatar-container">
                <c:choose>
                    <c:when test="${not empty judge.profilePicURL}">
                        <img src="${judge.profilePicURL}" class="avatar" alt="profile">
                    </c:when>
                    <c:otherwise>
                        <img src="/assets/images/faces/dummy.jpg" class="avatar" alt="profile">
                    </c:otherwise>
                </c:choose>
                <div class="file-input-wrapper">
                    <label class="file-input-label">Profile Picture</label>
                    <input type="file" name="profilePic" class="file-input">
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label-custom"><i class="fas fa-user me-1"></i> First Name</label>
                    <input type="text" name="firstName" class="form-control" value="${judge.firstName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom"><i class="fas fa-user me-1"></i> Last Name</label>
                    <input type="text" name="lastName" class="form-control" value="${judge.lastName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom"><i class="fas fa-envelope me-1"></i> Email</label>
                    <input type="email" class="form-control" value="${judge.email}" disabled>
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom"><i class="fas fa-phone me-1"></i> Contact Number</label>
                    <input type="text" name="contactNum" class="form-control" value="${judge.contactNum}">
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom"><i class="fas fa-graduation-cap me-1"></i> Qualification</label>
                    <input type="text" name="qualification" class="form-control" value="${judge.qualification}">
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom"><i class="fas fa-briefcase me-1"></i> Designation</label>
                    <input type="text" name="designation" class="form-control" value="${judge.designation}">
                </div>
                <div class="col-12">
                    <label class="form-label-custom"><i class="fas fa-building me-1"></i> Organization</label>
                    <input type="text" name="organization" class="form-control" value="${judge.organization}">
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-save"><i class="fas fa-save me-2"></i>Save Profile</button>
            </div>
        </form>
    </div>

    <footer>
        <div>CodeVerse Judge Panel</div>
        <div class="mt-1">Need help? <a href="/judge-dashboard" class="text-decoration-none">Go to Dashboard</a></div>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>