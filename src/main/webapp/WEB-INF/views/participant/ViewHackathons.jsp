<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${hackathon.title} | Hackathon Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .detail-card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        .quick-facts {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            position: sticky;
            top: 20px;
        }
        .fact-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #edf2f7;
        }
        .fact-item:last-child {
            border-bottom: none;
        }
        .fact-icon {
            width: 40px;
            height: 40px;
            background: #eef2ff;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #3b82f6;
            margin-right: 15px;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 0.5rem 1.2rem;
            border-radius: 30px;
        }
        .prize-item {
            padding: 1rem;
            background: #f8fafc;
            border-radius: 16px;
            margin-bottom: 1rem;
            border: 1px solid #edf2f7;
        }
        .prize-title {
            font-weight: 600;
            color: #3b82f6;
            margin-bottom: 5px;
        }
        .prize-desc {
            color: #64748b;
            font-size: 0.9rem;
        }
        .poster-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .poster-img {
            max-width: 100%;
            max-height: 600px;
            width: auto;
            height: auto;
            object-fit: contain;
            border-radius: 16px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .no-poster {
            width: 100%;
            height: 150px;
            background: #e2e8f0;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }
        .description-card {
            background: #f9fafc;
            border-radius: 20px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            border: 1px solid #edf2f7;
            transition: all 0.2s ease;
        }
        .description-card h5 {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #1e293b;
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }
        .description-card h5 i {
            color: #3b82f6;
            font-size: 1.2rem;
        }
        .description-card p {
            color: #334155;
            line-height: 1.6;
            font-size: 1rem;
        }
        .btn-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .msg {
            margin-top: 15px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 14px;
        }
        .msg.success {
            background: rgba(34, 197, 94, 0.14);
            border: 1px solid rgba(34, 197, 94, 0.4);
            color: #166534;
        }
        .msg.error {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #991b1b;
        }
    </style>
</head>
<body>
<c:if test="${param.success == 'paymentSuccess'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i> Payment successful! You are now registered.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${param.error == 'paymentFailed'}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-triangle"></i> Payment failed. Please try again or contact support.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<div class="container py-5">
    <!-- Back button -->
    <a href="${pageContext.request.contextPath}/participant/home" class="btn btn-link text-decoration-none mb-4">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>

    <!-- Display success/error messages from actions (join, invite) -->
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
   

    
 <!-- Pending Join Requests (for participant) -->
            <c:if test="${not hasTeam and not empty myPendingRequests}">
                <div class="card-custom">
                    <div class="card-header-custom">
                        <h5><i class="fas fa-clock"></i> Your Pending Join Requests</h5>
                    </div>
                    <div class="card-body-custom p-0">
                        <div class="table-responsive">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr><th>Team</th><th>Status</th><th>Action</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${myPendingRequests}" var="req">
                                        <c:set var="teamNameForReq" value="" />
                                        <c:forEach items="${availableTeams}" var="t">
                                            <c:if test="${t.hackathonTeamId == req.teamId}">
                                                <c:set var="teamNameForReq" value="${t.teamName}" />
                                            </c:if>
                                        </c:forEach>
                                        <tr>
                                            <td>${teamNameForReq}</td>
                                            <td><span class="status-badge status-pending">PENDING</span></td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/request/${req.hackathonTeamInviteId}/cancel" method="post">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">Cancel</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
 
    <div class="row">
        <!-- Main Details -->
        <div class="col-lg-8">
            <div class="detail-card card p-4 mb-4">
                <!-- Poster image -->
                <div class="poster-container">
                    <c:choose>
                        <c:when test="${not empty hackathon.hackathonPosterURL}">
                            <img src="${hackathon.hackathonPosterURL}" alt="${hackathon.title}" class="poster-img">
                        </c:when>
                        <c:otherwise>
                            <div class="no-poster">
                                <i class="fas fa-image me-2"></i> No poster available
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h1 class="fw-bold">${hackathon.title}</h1>
                    <span class="status-badge ${hackathon.status == 'LIVE' ? 'bg-success' : hackathon.status == 'UPCOMING' ? 'bg-warning' : 'bg-secondary'} text-white">
                        ${hackathon.status}
                    </span>
                </div>

                <p class="text-muted">
                    <i class="fas fa-map-marker-alt me-2"></i>${hackathon.location} | ${hackathon.eventType}
                </p>
                <hr>

                <!-- Description (supports HTML) -->
                <div class="description-card">
                    <h5><i class="fas fa-align-left"></i> Description</h5>
                    <p>
                        <c:choose>
                            <c:when test="${not empty hackathonDescription.hackathonDetails}">
                                ${hackathonDescription.hackathonDetails}
                            </c:when>
                            <c:otherwise>
                                ${hackathon.description}
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <h5 class="fw-bold mt-4">Registration Timeline</h5>
                <div class="row text-center bg-white border rounded p-3 my-3">
                    <div class="col-md-6 border-end">
                        <p class="text-muted mb-1 small">Starts On</p>
                        <p class="fw-bold text-primary mb-0">${hackathon.registrationStartDate}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="text-muted mb-1 small">Ends On</p>
                        <p class="fw-bold text-danger mb-0">${hackathon.registrationEndDate}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Facts & Registration -->
        <div class="col-lg-4">
            <div class="quick-facts">
                <h5 class="mb-4">Quick Facts</h5>

                <div class="fact-item">
                    <div class="fact-icon"><i class="fas fa-users"></i></div>
                    <div>
                        <small class="text-secondary d-block">Team Size</small>
                        <span class="fw-bold">${hackathon.minTeamSize} - ${hackathon.maxTeamSize} Members</span>
                    </div>
                </div>

                <div class="fact-item">
                    <div class="fact-icon"><i class="fas fa-credit-card"></i></div>
                    <div>
                        <small class="text-secondary d-block">Entry Fee</small>
                        <span class="fw-bold">${hackathon.payment}</span>
                    </div>
                </div>

                <div class="fact-item">
                    <div class="fact-icon"><i class="fas fa-user-tag"></i></div>
                    <div>
                        <small class="text-secondary d-block">Allowed User Type</small>
                        <span class="fw-bold">${hackathon.userType}</span>
                    </div>
                </div>

                <div class="fact-item">
                    <div class="fact-icon"><i class="fas fa-chart-line"></i></div>
                    <div>
                        <small class="text-secondary d-block">Teams Joined</small>
                        <span class="fw-bold">${teamCount} Teams</span>
                    </div>
                </div>

                <hr class="my-4">

<%--                 <!-- Registration / Team Action Area -->
                <c:choose>
                    Registration not started yet
                    <c:when test="${today lt hackathon.registrationStartDate}">
                        <div class="alert alert-info text-center mb-3" role="alert">
                            <i class="fas fa-clock me-2"></i> Registration opens on ${hackathon.registrationStartDate}
                        </div>
                        <button class="btn btn-secondary w-100 py-2 fw-bold" disabled>
                            Not Started
                        </button>
                    </c:when>

                    Deadline passed
                    <c:when test="${today gt hackathon.registrationEndDate}">
                        <div class="alert alert-danger text-center mb-3" role="alert">
                            <i class="fas fa-clock me-2"></i> Registration Deadline Passed
                        </div>
                        <button class="btn btn-secondary w-100 py-2 fw-bold" disabled>
                            Deadline Expired
                        </button>
                    </c:when>

                    Registration is open (status UPCOMING or LIVE)
                    <c:when test="${hackathon.status eq 'UPCOMING' or hackathon.status eq 'LIVE'}">
                        <c:choose>
                            Already registered
                            <c:when test="${alreadyRegistered}">
                                <div class="alert alert-info text-center mb-3" role="alert">
                                    <i class="fas fa-check-circle me-2"></i> You are already registered in this hackathon.
                                </div>
                                <a href="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team" 
                                   class="btn btn-outline-info w-100 py-2 fw-bold">
                                    <i class="fas fa-users me-2"></i> Manage Team
                                </a>
                            </c:when>

                            Pending invitation
                            <c:when test="${not empty pendingInvite}">
                                <div class="alert alert-warning text-center mb-3" role="alert">
                                    <i class="fas fa-envelope me-2"></i> You have a pending team invitation.
                                </div>
                                <div class="btn-row">
                                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/invite/${pendingInvite.hackathonTeamInviteId}/accept" method="post">
                                        <button type="submit" class="btn btn-success w-100 py-2 fw-bold">
                                            <i class="fas fa-check me-2"></i> Accept Invitation
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/invite/${pendingInvite.hackathonTeamInviteId}/reject" method="post">
                                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold">
                                            <i class="fas fa-times me-2"></i> Reject Invitation
                                        </button>
                                    </form>
                                </div>
                            </c:when>
								
                            Can join directly (no pending invite, not registered)
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/join" method="post">
                                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow">
                                        <i class="fas fa-pen me-2"></i> Join Hackathon
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:when>

                    Hackathon is completed or expired (no registration)
                    <c:otherwise>
                        <div class="alert alert-secondary text-center mb-3" role="alert">
                            <i class="fas fa-ban me-2"></i> Registration Not Available
                        </div>
                        <button class="btn btn-secondary w-100 py-2 fw-bold" disabled>
                            ${hackathon.status == 'COMPLETED' ? 'Event Completed' : 'Closed'}
                        </button>
                    </c:otherwise>
                </c:choose>

 --%>   
 
 <c:choose>
    <%-- Registration not started yet --%>
    <c:when test="${today lt hackathon.registrationStartDate}">
        <div class="alert alert-info text-center mb-3" role="alert">
            <i class="fas fa-clock me-2"></i> Registration opens on ${hackathon.registrationStartDate}
        </div>
        <button class="btn btn-secondary w-100 py-2 fw-bold" disabled>Not Started</button>
    </c:when>

    <%-- Registration deadline passed --%>
    <c:when test="${today gt hackathon.registrationEndDate}">
        <div class="alert alert-danger text-center mb-3" role="alert">
            <i class="fas fa-clock me-2"></i> Registration Deadline Passed
        </div>
        <button class="btn btn-secondary w-100 py-2 fw-bold" disabled>Deadline Expired</button>
    </c:when>

    <%-- Registration is open --%>
    <c:when test="${hackathon.status eq 'UPCOMING' or hackathon.status eq 'LIVE'}">
        <c:choose>
            <%-- Already registered --%>
            <c:when test="${alreadyRegistered}">
                <div class="alert alert-info text-center mb-3" role="alert">
                    <i class="fas fa-check-circle me-2"></i> You are already registered in this hackathon.
                </div>
                <a href="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team" 
                   class="btn btn-outline-info w-100 py-2 fw-bold">
                    <i class="fas fa-users me-2"></i> Manage Team
                </a>
            </c:when>

            <%-- Pending invitation (accept/reject) --%>
            <c:when test="${not empty pendingInvite}">
                <div class="alert alert-warning text-center mb-3" role="alert">
                    <i class="fas fa-envelope me-2"></i> You have a pending team invitation.
                </div>
                <div class="btn-row">
                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/invite/${pendingInvite.hackathonTeamInviteId}/accept" method="post">
                        <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Accept Invitation</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/invite/${pendingInvite.hackathonTeamInviteId}/reject" method="post">
                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold">Reject Invitation</button>
                    </form>
                </div>
            </c:when>

            <%-- Paid hackathon flow --%>
            <c:when test="${hackathon.payment eq 'PAID'}">
                <c:choose>
                    <c:when test="${hasPaid}">
                        <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/join" method="post">
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow">
                                <i class="fas fa-pen me-2"></i> Join Hackathon (Already Paid)
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/pay" 
                           class="btn btn-warning w-100 py-2 fw-bold shadow">
                            <i class="fas fa-credit-card me-2"></i> Pay ₹ ${hackathon.registrationFee} and Register
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:when>

            <%-- Free hackathon (default) --%>
            <c:otherwise>
                <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/join" method="post">
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow">
                        <i class="fas fa-pen me-2"></i> Join Hackathon
                    </button>
                </form>
            </c:otherwise>
        </c:choose>
    </c:when>

    <%-- Hackathon completed or expired – no registration --%>
    <c:otherwise>
        <div class="alert alert-secondary text-center mb-3" role="alert">
            <i class="fas fa-ban me-2"></i> Registration Not Available
        </div>
        <button class="btn btn-secondary w-100 py-2 fw-bold" disabled>
            ${hackathon.status == 'COMPLETED' ? 'Event Completed' : 'Closed'}
        </button>
    </c:otherwise>
</c:choose>             <!-- Leaderboard link (if available) -->
                <c:if test="${leaderboardAvailable}">
                    <hr class="my-4">
                    <a href="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/leaderboard" 
                       class="btn btn-outline-secondary w-100 py-2 fw-bold">
                        <i class="fas fa-chart-simple me-2"></i> View Leaderboard
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Prizes Section -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="detail-card card p-4">
                <h5 class="fw-bold mb-4"><i class="fas fa-trophy text-warning me-2"></i> Prizes</h5>
                <c:choose>
                    <c:when test="${not empty prizeList}">
                        <div class="row">
                            <c:forEach var="prize" items="${prizeList}">
                                <div class="col-md-6">
                                    <div class="prize-item">
                                        <div class="prize-title">
                                            <i class="fas fa-medal me-2" style="color: #f59e0b;"></i> ${prize.prizeTitle}
                                        </div>
                                        <div class="prize-desc">${prize.prizeDescription}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted">No prizes have been announced yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>