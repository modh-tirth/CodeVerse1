<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | CodeVerse Judge</title>
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }

        .page-container {
            width: 100%;
            max-width: 480px;
            margin: 0 auto;
        }

        /* Card Styles */
        .card {
            background: white;
            border-radius: 28px;
            padding: 2rem;
            box-shadow: 0 12px 40px rgba(0,0,0,0.04);
            border: 1px solid #eef2f6;
        }

        .card-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .card-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 0.5rem;
        }

        .card-header p {
            color: #64748b;
            font-size: 0.9rem;
        }

        /* Form Group */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.5rem;
            letter-spacing: 0.3px;
        }

        .input-group {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            transition: all 0.2s ease;
        }

        .input-group:focus-within {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .input-group-icon {
            padding: 0 1rem;
            color: #3b82f6;
            font-size: 1rem;
        }

        .input-group input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 0;
            border: none;
            outline: none;
            font-size: 0.95rem;
            color: #1e293b;
            background: transparent;
            font-family: 'Inter', sans-serif;
        }

        .input-group input::placeholder {
            color: #94a3b8;
        }

        /* Button */
        .btn-primary {
            width: 100%;
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
            justify-content: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        /* Error Alert */
        .alert-error {
            background: #fee2e2;
            border-left: 4px solid #ef4444;
            border-radius: 16px;
            padding: 0.75rem 1rem;
            margin-top: 1rem;
            color: #991b1b;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-error i {
            color: #ef4444;
        }

        /* Links */
        .links {
            text-align: center;
            margin-top: 1.5rem;
        }

        .links a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.85rem;
            transition: color 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .links a:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        /* Footer */
        .footer {
            text-align: center;
            margin-top: 1.5rem;
            color: #64748b;
            font-size: 0.8rem;
        }

        /* Responsive */
        @media (max-width: 480px) {
            body {
                padding: 1rem;
            }
            .card {
                padding: 1.5rem;
            }
            .card-header h2 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="card">
        <div class="card-header">
            <h2>Change Password</h2>
            <p>Set your own password to secure your account</p>
        </div>

        <form action="/judge/update-password" method="post">
            <div class="form-group">
                <label>New Password</label>
                <div class="input-group">
                    <span class="input-group-icon"><i class="fas fa-lock"></i></span>
                    <input type="password" name="newPassword" placeholder="Enter new password" required>
                </div>
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <div class="input-group">
                    <span class="input-group-icon"><i class="fas fa-check-circle"></i></span>
                    <input type="password" name="confirmPassword" placeholder="Confirm new password" required>
                </div>
            </div>

            <button type="submit" class="btn-primary">
                <i class="fas fa-save"></i> Update Password
            </button>

            <c:if test="${not empty error}">
                <div class="alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>${error}</span>
                </div>
            </c:if>
        </form>

        <div class="links">
            <a href="/judge/judge-dashboard">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </div>
    <div class="footer">
        &copy; 2026 CodeVerse – Judge Panel
    </div>
</div>
</body>
</html>