<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hackathon Submission | CodeVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }
        .page-container {
            max-width: 900px;
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
        .title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0.5rem 0 0.25rem;
        }
        .subtitle {
            color: #64748b;
            margin-bottom: 0;
        }
        .submission-card {
            background: white;
            border-radius: 24px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            margin-top: 1.5rem;
            overflow: hidden;
        }
        .card-body-custom {
            padding: 1.5rem;
        }
        .form-label {
            font-weight: 500;
            color: #334155;
            margin-bottom: 0.5rem;
        }
        .input-group-custom {
            position: relative;
        }
        .input-group-custom i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }
        .form-control {
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            padding: 0.7rem 1rem 0.7rem 2.5rem;
            transition: all 0.2s;
        }
        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .btn-submit {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border: none;
            border-radius: 40px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-submit:hover {
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
        .last-submitted {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e2e8f0;
            color: #64748b;
            font-size: 0.85rem;
        }
        @media (max-width: 768px) {
            .page-container { padding: 1rem; }
            .title { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Header -->
    <div>
        <a href="${pageContext.request.contextPath}/participant/my-hackathons" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to My Hackathons
        </a>
        <h1 class="title">Submission</h1>
        <p class="subtitle">${hackathon.title}</p>
    </div>

    <!-- Messages -->
    <c:if test="${success == 'saved'}">
        <div class="alert alert-custom alert-success-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle text-success me-2"></i> Submission saved successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-custom alert-danger-custom alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle text-danger me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Submission Form -->
    <div class="submission-card">
        <div class="card-body-custom">
            <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/submission/save" method="post">
                <input type="hidden" name="hackathonSubmissionId" value="${submission.hackathonSubmissionId}">

                <div class="mb-4">
                    <label class="form-label"><i class="fas fa-code me-1"></i> Code Base URL</label>
                    <div class="input-group-custom">
                        <i class="fab fa-github"></i>
                        <input type="url" name="codeBaseUrl" class="form-control" value="${submission.codeBaseUrl}" placeholder="https://github.com/your-repo" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label"><i class="fas fa-file-alt me-1"></i> Documentation URL</label>
                    <div class="input-group-custom">
                        <i class="fas fa-link"></i>
                        <input type="url" name="documentationUrl" class="form-control" value="${submission.documentationUrl}" placeholder="https://docs.google.com/..." required>
                    </div>
                </div>

                <button type="submit" class="btn btn-submit">
                    <i class="fas fa-save me-2"></i> Save Submission
                </button>
            </form>

            <c:if test="${not empty submission.submitedDate}">
                <div class="last-submitted">
                    <i class="fas fa-clock me-1"></i> Last submitted: ${submission.submitedDate}
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>