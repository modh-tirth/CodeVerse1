<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Profile | CodeVerse</title>
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
            line-height: 1.5;
        }

        /* Layout */
        .page-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        /* Header Card */
        .profile-header {
            background: white;
            border-radius: 28px;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 12px 40px rgba(0,0,0,0.04);
            border: 1px solid #eef2f6;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .profile-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 0.25rem;
        }

        .profile-header p {
            color: #64748b;
            font-size: 0.9rem;
        }

        .header-actions {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn-outline-custom {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 40px;
            padding: 0.5rem 1.25rem;
            font-weight: 500;
            font-size: 0.85rem;
            color: #475569;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-outline-custom:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
            color: #0f172a;
        }

        /* Profile Card */
        .profile-card {
            background: white;
            border-radius: 28px;
            padding: 2rem;
            box-shadow: 0 12px 40px rgba(0,0,0,0.04);
            border: 1px solid #eef2f6;
        }

        /* Avatar Section */
        .avatar-section {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #f1f5f9;
        }

        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .file-input-wrapper {
            flex: 1;
        }

        .file-input-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.5rem;
            letter-spacing: 0.3px;
        }

        .file-input {
            width: 100%;
            padding: 0.6rem;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            background: #f8fafc;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
        }

        /* Form Grid */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.5rem;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: #3b82f6;
            width: 1.1rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            color: #1e293b;
            background: white;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .form-control[disabled] {
            background: #f8fafc;
            color: #64748b;
            cursor: not-allowed;
        }

        /* Alert Messages */
        .alert-custom {
            border-radius: 20px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .alert-success-custom {
            background: #d1fae5;
            border-left: 4px solid #10b981;
            color: #065f46;
        }

        .alert-danger-custom {
            background: #fee2e2;
            border-left: 4px solid #ef4444;
            color: #991b1b;
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
        }

        .btn-close:hover {
            opacity: 1;
        }

        /* Save Button */
        .btn-save {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            border-radius: 40px;
            padding: 0.85rem 1.5rem;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            width: 100%;
            justify-content: center;
            margin-top: 0.5rem;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        /* Footer */
        footer {
            margin-top: 2rem;
            text-align: center;
            padding: 1rem;
            color: #64748b;
            font-size: 0.85rem;
            border-top: 1px solid #e9eef2;
        }

        footer a {
            color: #3b82f6;
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-container {
                padding: 1rem;
            }
            .profile-header {
                padding: 1.25rem;
                flex-direction: column;
            }
            .form-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .form-group.full-width {
                grid-column: span 1;
            }
            .avatar-section {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .file-input-wrapper {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Header Section -->
    <div class="profile-header">
        <div>
            <h1>Judge Profile</h1>
            <p>Manage your profile details visible in assigned hackathons.</p>
        </div>
        <div class="header-actions">
            <a href="/judge/change-password" class="btn-outline-custom">
                <i class="fas fa-key"></i> Change Password
            </a>
            <a href="/judge/judge-dashboard" class="btn-outline-custom">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${param.updated == 'true'}">
        <div class="alert-custom alert-success-custom">
            <span><i class="fas fa-check-circle"></i> Profile updated successfully.</span>
            <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-custom alert-danger-custom">
            <span><i class="fas fa-exclamation-triangle"></i> ${error}</span>
            <button type="button" class="btn-close" onclick="this.parentElement.style.display='none';">&times;</button>
        </div>
    </c:if>

    <!-- Profile Form -->
    <div class="profile-card">
        <form action="/judge/profile/update" method="post" enctype="multipart/form-data">
            <!-- Avatar Section -->
            <div class="avatar-section">
                <c:choose>
                    <c:when test="${not empty judge.profilePicURL}">
                        <img src="${judge.profilePicURL}" class="avatar" alt="Profile Picture">
                    </c:when>
                    <c:otherwise>
                        <img src="/assets/images/faces/dummy.jpg" class="avatar" alt="Default Avatar">
                    </c:otherwise>
                </c:choose>
                <div class="file-input-wrapper">
                    <label class="file-input-label"><i class="fas fa-camera"></i> Profile Picture</label>
                    <input type="file" name="profilePic" class="file-input" accept="image/*">
                </div>
            </div>

            <!-- Form Fields -->
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-user"></i> First Name</label>
                    <input type="text" name="firstName" class="form-control" value="${judge.firstName}" required>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-user"></i> Last Name</label>
                    <input type="text" name="lastName" class="form-control" value="${judge.lastName}" required>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" class="form-control" value="${judge.email}" disabled>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-phone"></i> Contact Number</label>
                    <input type="text" name="contactNum" class="form-control" value="${judge.contactNum}">
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-graduation-cap"></i> Qualification</label>
                    <input type="text" name="qualification" class="form-control" value="${judge.qualification}">
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-briefcase"></i> Designation</label>
                    <input type="text" name="designation" class="form-control" value="${judge.designation}">
                </div>
                <div class="form-group full-width">
                    <label class="form-label"><i class="fas fa-building"></i> Organization</label>
                    <input type="text" name="organization" class="form-control" value="${judge.organization}">
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i> Save Profile
                </button>
            </div>
        </form>
    </div>

    <footer>
        <div>© 2026 CodeVerse – Judge Panel</div>
        <div class="mt-1">Need help? <a href="/judge-dashboard">Go to Dashboard</a></div>
    </footer>
</div>

<script>
    // Auto-dismiss alerts after 5 seconds
    setTimeout(() => {
        document.querySelectorAll('.alert-custom').forEach(alert => {
            alert.style.display = 'none';
        });
    }, 5000);
</script>
</body>
</html>