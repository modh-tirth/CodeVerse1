<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | CodeVerse</title>
    <!-- Fonts & Icons -->
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 420px;
        }

        .auth-card {
            background: white;
            border-radius: 24px;
            padding: 40px 35px;
            box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.1);
            border: 1px solid #edf2f7;
        }

        .auth-card h2 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: #0f172a;
        }

        .auth-card p {
            color: #64748b;
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            color: #1e293b;
            margin-bottom: 6px;
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

        .input-group input {
            width: 100%;
            padding: 14px 15px 14px 0;
            border: none;
            outline: none;
            font-size: 1rem;
            color: #1e293b;
            background: transparent;
        }
        .input-group input::placeholder {
            color: #94a3b8;
        }

        .forgot-pass {
            text-align: right;
            margin-bottom: 25px;
        }
        .forgot-pass a {
            color: #3b82f6;
            font-size: 0.85rem;
            text-decoration: none;
            font-weight: 500;
            transition: 0.2s;
        }
        .forgot-pass a:hover {
            text-decoration: underline;
        }

        .btn-auth {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            border: none;
            border-radius: 50px;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            box-shadow: 0 4px 10px rgba(59,130,246,0.3);
        }
        .btn-auth:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59,130,246,0.4);
        }

        .auth-footer {
            text-align: center;
            margin-top: 25px;
            color: #64748b;
            font-size: 0.9rem;
        }
        .auth-footer a {
            color: #3b82f6;
            font-weight: 600;
            text-decoration: none;
            margin-left: 5px;
        }
        .auth-footer a:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .auth-card {
                padding: 30px 20px;
            }
            .auth-card h2 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <h2>Welcome Back</h2>
            <p>Login to your CodeVerse dashboard.</p>
            
            <form action="authenticate" method="POST">
                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-group">
                        <span class="input-group-icon"><i class="fas fa-envelope"></i></span>
                        <input type="email" name="email" placeholder="Enter your email" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-group">
                        <span class="input-group-icon"><i class="fas fa-lock"></i></span>
                        <input type="password" name="password" placeholder="Enter your password" required>
                    </div>
                </div>
                <div class="forgot-pass">
                    <a href="forgetpassword">Forgot Password?</a>
                </div>
                <button type="submit" class="btn-auth">Login</button>
            </form>
            <p class="auth-footer">New to the platform? <a href="signup">Signup now</a></p>
        </div>
    </div>
</body>
</html>