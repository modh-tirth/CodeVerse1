<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Submission | CodeVerse</title>
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
            color: #0f9d94;
        }
        .title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0.5rem 0 0;
        }
        .dashboard-card {
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
        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .meta-item {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1rem;
            border: 1px solid #e2e8f0;
        }
        .meta-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #64748b;
            letter-spacing: 0.5px;
        }
        .meta-value {
            font-weight: 700;
            color: #0f172a;
            margin-top: 0.25rem;
        }
        .link-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin-bottom: 1rem;
        }
        .btn-link-custom {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 40px;
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            color: #334155;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }
        .btn-link-custom:hover {
            background: #e2e8f0;
            color: #0f172a;
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
        .form-text {
            font-size: 0.75rem;
            color: #64748b;
            margin-top: 0.25rem;
        }
        .btn-save {
            background: linear-gradient(135deg, #0f9d94, #127fcb);
            border: none;
            border-radius: 40px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15,157,148,0.3);
        }
        .btn-cancel {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 40px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            color: #334155;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-cancel:hover {
            background: #e2e8f0;
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
        <a href="/judge/submissions" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Submissions
        </a>
        <h1 class="title">Review Team Submission</h1>
    </div>

    <!-- Submission Info Card -->
    <div class="dashboard-card">
        <div class="card-body-custom">
            <div class="meta-grid">
                <div class="meta-item">
                    <div class="meta-label">Hackathon</div>
                    <div class="meta-value">${hackathon.title}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Team</div>
                    <div class="meta-value">${team.teamName}</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Submitted Date</div>
                    <div class="meta-value">${submission.submitedDate}</div>
                </div>
            </div>
            <div class="link-buttons">
                <a href="${submission.codeBaseUrl}" target="_blank" class="btn-link-custom">
                    <i class="fab fa-github me-1"></i> Open Code Base
                </a>
                <a href="${submission.documentationUrl}" target="_blank" class="btn-link-custom">
                    <i class="fas fa-file-alt me-1"></i> Open Documentation
                </a>
            </div>
        </div>
    </div>

    <!-- Review Form Card -->
    <div class="dashboard-card">
        <div class="card-body-custom">
            <form action="/judge/submissions/review/save" method="post">
                <input type="hidden" name="hackathonResultId" value="${result.hackathonResultId}">
                <input type="hidden" name="hackathonId" value="${submission.hackathonId}">
                <input type="hidden" name="teamId" value="${submission.teamId}">

                <div class="row g-4">
                    <div class="col-md-4">
                        <label class="form-label-custom">Innovation (1-10)</label>
                        <input type="number" name="innovation" class="form-control" min="1" max="10" value="${result.innovation}" required>
                        <div class="form-text">How unique and creative is the solution?</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label-custom">Implementation (1-10)</label>
                        <input type="number" name="implementation" class="form-control" min="1" max="10" value="${result.implementation}" required>
                        <div class="form-text">How complete and functional is the build?</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label-custom">Coding Standard (1-10)</label>
                        <input type="number" name="codingStandard" class="form-control" min="1" max="10" value="${result.codingStandard}" required>
                        <div class="form-text">Code quality, readability, and maintainability.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-custom">Round</label>
                        <select name="round" class="form-select" required>
                            <option value="">Select Round</option>
                            <option value="ROUND_1" ${result.round == 'ROUND_1' ? 'selected' : ''}>Round 1</option>
                            <option value="ROUND_2" ${result.round == 'ROUND_2' ? 'selected' : ''}>Round 2</option>
                            <option value="FINAL" ${result.round == 'FINAL' ? 'selected' : ''}>Final</option>
                        </select>
                    </div>
                </div>

                <div class="mt-4 d-flex gap-3">
                    <button type="submit" class="btn btn-save">
                        <i class="fas fa-save me-2"></i>Save Review
                    </button>
                    <a href="/judge/submissions" class="btn-cancel">
                        <i class="fas fa-times me-2"></i>Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>