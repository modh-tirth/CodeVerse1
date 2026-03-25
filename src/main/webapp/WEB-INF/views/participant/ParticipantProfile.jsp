<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CodeVerse</title>
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
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #64748b;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .back-link:hover {
            color: #3b82f6;
        }
        .profile-header {
            background: white;
            border-radius: 24px;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .profile-card {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .form-label {
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
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .form-control[readonly] {
            background: #f8fafc;
            opacity: 0.8;
        }
        .btn-save {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border: none;
            border-radius: 40px;
            padding: 0.7rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59,130,246,0.3);
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
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in-up {
            animation: fadeInUp 0.4s ease-out;
        }
    </style>
</head>
<body>

<div class="page-container fade-in-up">
    <!-- Header -->
    <div class="profile-header">
        <a href="${pageContext.request.contextPath}/participant/home" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>
        <h1 class="fw-bold mt-3 mb-1" style="font-size: 2rem;">My Profile</h1>
        <p class="text-muted mb-0">View and update your participant profile details.</p>
    </div>

    <!-- Messages -->
    <c:if test="${success == 'updated'}">
        <div class="alert alert-custom alert-success-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle text-success me-2"></i> Profile updated successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${error == 'invalidName'}">
        <div class="alert alert-custom alert-danger-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle text-danger me-2"></i> First name and last name are required.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Profile Form -->
    <div class="profile-card">
        <form action="${pageContext.request.contextPath}/participant/profile/save" method="post">
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-user me-1"></i> First Name</label>
                    <input type="text" name="firstName" class="form-control" value="${user.firstName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-user me-1"></i> Last Name</label>
                    <input type="text" name="lastName" class="form-control" value="${user.lastName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-envelope me-1"></i> Email</label>
                    <input type="email" class="form-control" value="${user.email}" readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-phone me-1"></i> Contact Number</label>
                    <input type="text" name="contactNum" class="form-control" value="${user.contactNum}">
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-venus-mars me-1"></i> Gender</label>
                    <select name="gender" class="form-select">
                        <option value="">Select gender</option>
                        <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                        <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                        <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-calendar me-1"></i> Birth Year</label>
                    <input type="number" name="birthYear" class="form-control" min="1950" max="2100" value="${user.birthYear}">
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-graduation-cap me-1"></i> Qualification</label>
                    <input type="text" name="qualification" class="form-control" value="${userDetail.qualification}">
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-briefcase me-1"></i> Designation</label>
                    <input type="text" name="designation" class="form-control" value="${user.designation}">
                </div>
                <div class="col-12">
                    <label class="form-label"><i class="fas fa-building me-1"></i> Organization</label>
                    <input type="text" name="organization" class="form-control" value="${user.organization}">
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-city me-1"></i> City</label>
                    <input type="text" name="city" class="form-control" value="${userDetail.city}">
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fas fa-map-marker-alt me-1"></i> State</label>
                    <input type="text" name="state" class="form-control" value="${userDetail.state}">
                </div>
                <div class="col-12">
                    <label class="form-label"><i class="fas fa-globe me-1"></i> Country</label>
                    <input type="text" name="country" class="form-control" value="${userDetail.country}">
                </div>
            </div>
            <div class="mt-4">
                <button type="submit" class="btn btn-save"><i class="fas fa-save me-2"></i>Save Profile</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>