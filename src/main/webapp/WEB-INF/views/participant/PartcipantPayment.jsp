<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment | ${hackathon.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f8fafc; }
        .payment-card { max-width: 500px; margin: 2rem auto; }
    </style>
</head>
<body>
<div class="container">
    <div class="card payment-card">
        <div class="card-header bg-primary text-white">
            <h4>Pay Registration Fee</h4>
        </div>
        <div class="card-body">
            <p>Hackathon: <strong>${hackathon.title}</strong></p>
            <p>Amount: <strong>₹ ${hackathon.registrationFee}</strong></p>
            <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/pay/process" method="post">
                <input type="hidden" name="amount" value="${hackathon.registrationFee}">
                <div class="mb-3">
                    <label>Card Number</label>
                    <input type="text" name="cardNumber" class="form-control" required>
                </div>
                <div class="row">
                    <div class="col">
                        <label>Expiry Month</label>
                        <input type="text" name="expMonth" class="form-control" placeholder="MM" required>
                    </div>
                    <div class="col">
                        <label>Expiry Year</label>
                        <input type="text" name="expYear" class="form-control" placeholder="YYYY" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label>CVV</label>
                    <input type="password" name="cvv" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Pay Now</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>