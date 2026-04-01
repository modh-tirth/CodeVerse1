<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Team | ${hackathon.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --success: #22c55e;
            --danger: #ef4444;
            --warning: #f59e0b;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-500: #64748b;
            --gray-700: #334155;
        }
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }
        .page-container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray-500);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .back-link:hover {
            color: var(--primary);
        }
        .team-header {
            background: white;
            border-radius: 24px;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 20px rgba(0,0,0,0.02), 0 2px 4px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .badge-team-size {
            background: linear-gradient(135deg, #eef2ff, #e0e7ff);
            color: var(--primary-dark);
            border-radius: 40px;
            padding: 0.5rem 1.25rem;
            font-weight: 600;
            font-size: 0.9rem;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .card-custom {
            border: none;
            border-radius: 24px;
            background: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.03), 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .card-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 30px -12px rgba(0,0,0,0.1);
        }
        .card-header-custom {
            background: white;
            border-bottom: 1px solid var(--gray-200);
            padding: 1.25rem 1.5rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 700;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .card-header-custom h5 i {
            color: var(--primary);
            font-size: 1.2rem;
        }
        .card-body-custom {
            padding: 1.5rem;
        }
        .table-custom {
            margin-bottom: 0;
        }
        .table-custom th {
            background: var(--gray-100);
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--gray-500);
            border-bottom: none;
            padding: 0.75rem 1rem;
        }
        .table-custom td {
            vertical-align: middle;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--gray-200);
        }
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .status-pending {
            background: #fef3c7;
            color: #d97706;
        }
        .status-accepted {
            background: #d1fae5;
            color: #059669;
        }
        .status-rejected {
            background: #fee2e2;
            color: #dc2626;
        }
        .status-expired {
            background: #f1f5f9;
            color: #475569;
        }
        .form-control, .form-select {
            border-radius: 14px;
            border: 1px solid var(--gray-200);
            padding: 0.7rem 1rem;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .form-label {
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border: none;
            border-radius: 40px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59,130,246,0.3);
        }
        .btn-outline-primary {
            border-radius: 40px;
            border: 1px solid var(--primary);
            color: var(--primary);
        }
        .btn-outline-primary:hover {
            background: var(--primary);
            border-color: var(--primary);
        }
        .btn-danger {
            border-radius: 40px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            border: none;
        }
        .btn-sm-icon {
            padding: 0.25rem 0.8rem;
            font-size: 0.75rem;
            border-radius: 30px;
        }
        .sticky-sidebar {
            position: sticky;
            top: 2rem;
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
            border-left: 4px solid var(--success);
        }
        .alert-danger-custom {
            border-left: 4px solid var(--danger);
        }
        .divider {
            border-top: 1px solid var(--gray-200);
            margin: 1.5rem 0;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in-up {
            animation: fadeInUp 0.4s ease-out;
        }
        @media (max-width: 992px) {
            .page-container { padding: 1.5rem; }
            .sticky-sidebar { position: static; margin-top: 1.5rem; }
        }
    </style>
</head>
<body>

<div class="page-container fade-in-up">
    <div class="team-header">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <a href="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Hackathon Details
                </a>
                <h1 class="fw-bold mt-3 mb-1" style="font-size: 2rem;">Manage Team</h1>
                <p class="text-muted mb-0">${hackathon.title}</p>
            </div>
            <div>
                <span class="badge-team-size">
                    <i class="fas fa-users me-1"></i> Team Size: ${teamSizeCount} / ${teamMaxSize}
                </span>
            </div>
        </div>
    </div>

    <!-- Messages area -->
    <div id="alert-container">
        <!-- Success messages -->
        <c:if test="${success == 'memberInvited'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Invitation sent to participant. They must accept to join.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'externalInvited'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> External invite saved successfully.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'memberRemoved'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Member removed from team successfully.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'teamCreated'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Team created successfully. You are now team leader.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'teamJoined'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> You joined team successfully.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'inviteAccepted'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Invitation accepted. You are now part of that team.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'inviteRejected'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Invitation rejected.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'requestSent'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Your join request has been sent to the team leader.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'requestAccepted'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> You accepted the join request. The participant is now a team member.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'requestRejected'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> You rejected the join request.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${success == 'requestCancelled'}">
            <div class="alert alert-custom alert-success-custom alert-dismissible fade show"><i class="fas fa-check-circle text-success me-2"></i> Your join request has been cancelled.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>

        <!-- Error messages -->
        <c:if test="${error == 'teamFull'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Your team is full. You cannot add more members.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'invalidUser'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Selected user is invalid for team invite.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'alreadyInHackathon'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> This participant is already part of a team in this hackathon.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'invalidTeamName'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Please enter valid team name.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'invalidTeam'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Selected team is invalid for this hackathon.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'invalidEmail'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Please enter a valid external email.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'inviteExists'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Pending invite already exists for this email.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'inviteNotFound' || error == 'inviteInvalid'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Invitation is invalid or no longer available.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'submissionLocked'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Submission is locked until registration period ends.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'inviteClosed'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Invitations are closed after registration end date.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'notLeader'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Only team leader can remove participants.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'cannotRemoveLeader'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Team leader cannot be removed from team.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'memberNotFound'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Selected member was not found in this team.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'requestExists'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> You already have a pending request for this team.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'invalidRequest'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> The join request is invalid or no longer exists.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'unauthorized'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> You are not authorized to cancel this request.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${error == 'alreadyInTeam'}">
            <div class="alert alert-custom alert-danger-custom alert-dismissible fade show"><i class="fas fa-exclamation-triangle text-danger me-2"></i> This participant is already in a team.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
    </div>

    <div class="row g-4">
        <!-- Left column -->
        <div class="col-lg-8">
            <!-- Pending Invitation Card (if any) -->
         <%--  <c:if test="${not hasTeam and not empty pendingInvite}">
    <div class="card-custom">
        <div class="card-header-custom">
            <h5><i class="fas fa-envelope-open-text"></i> Pending Team Invitation</h5>
        </div>
        <div class="card-body-custom">
            <p class="text-muted mb-3">
                You have been invited to join
                <strong>${pendingInviteTeam.teamName}</strong>.
            </p>
            <div class="d-flex gap-3">
                <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/invite/${pendingInvite.hackathonTeamInviteId}/accept" method="post">
                    <button type="submit" class="btn btn-primary">Accept</button>
                </form>
                <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/invite/${pendingInvite.hackathonTeamInviteId}/reject" method="post">
                    <button type="submit" class="btn btn-danger">Reject</button>
                </form>
            </div>
        </div>
    </div>
</c:if>> --%>
              <!-- Join Requests (for leader) -->
           <c:if test="${hasTeam and isTeamLeader and not empty joinRequests}">
    <div class="card-custom">
        <div class="card-header-custom">
            <h5><i class="fas fa-user-plus"></i> Join Requests</h5>
        </div>
        <div class="card-body-custom p-0">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr><th>Participant</th><th>Requested On</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${joinRequests}" var="req">
                            <tr>
                                <td>
                                    <c:set var="requester" value="${requesterMap[req.invitedUserId]}" />
                                    ${requester.firstName} ${requester.lastName} (${requester.email})
                                </td>
                                <td>${req.createdAt}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/request/${req.hackathonTeamInviteId}/accept" method="post" class="d-inline">
                                        <button type="submit" class="btn btn-sm btn-success">Accept</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/request/${req.hackathonTeamInviteId}/reject" method="post" class="d-inline">
                                        <button type="submit" class="btn btn-sm btn-danger">Reject</button>
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
            <!-- No team yet: Show create/request options -->
            <c:if test="${not hasTeam}">
                <div class="card-custom">
                    <div class="card-header-custom">
                        <h5><i class="fas fa-users"></i> Team Setup</h5>
                    </div>
                    <div class="card-body-custom">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="border rounded-4 p-3 h-100 bg-light">
                                    <h6 class="fw-bold mb-3"><i class="fas fa-plus-circle me-2 text-primary"></i>Create Your Team</h6>
                                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/create" method="post">
                                        <div class="mb-3">
                                            <label class="form-label">Team Name</label>
                                            <input type="text" name="teamName" class="form-control" placeholder="Enter team name" required>
                                        </div>
                                        <button type="submit" class="btn btn-primary w-100">Create Team</button>
                                    </form>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="border rounded-4 p-3 h-100 bg-light">
                                    <h6 class="fw-bold mb-3"><i class="fas fa-handshake me-2 text-primary"></i>Request to Join Team</h6>
                                    <c:choose>
                                        <c:when test="${empty availableTeams}">
                                            <p class="text-muted text-center py-3">No open teams available to join right now.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/request-join" method="post">
                                                <div class="mb-3">
                                                    <label class="form-label">Select Team</label>
                                                    <select name="requestTeamId" class="form-select" required>
                                                        <option value="">Choose team</option>
                                                        <c:forEach items="${availableTeams}" var="t">
                                                            <option value="${t.hackathonTeamId}">${t.teamName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <button type="submit" class="btn btn-primary w-100">Request to Join</button>
                                            </form>
                                            <p class="text-muted small mt-2 mb-0"><i class="fas fa-info-circle"></i> Your request will be sent to the team leader.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="divider"></div>
                        <p class="text-muted small text-center mb-0">
                            <i class="fas fa-info-circle me-1"></i> After joining one team, you cannot create another team in this hackathon.
                        </p>
                    </div>
                </div>
            </c:if>
			
			<%-- <c:if test="${pendingInvite != null}">
    <div class="alert alert-info">
        You have been invited to join team:
        <b>${pendingInviteTeam.teamName}</b>

        <form method="post"
              action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/invite/${pendingInvite.hackathonTeamInviteId}/accept">
            <button type="submit" class="btn btn-success">Accept</button>
        </form>

        <form method="post"
              action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/invite/${pendingInvite.hackathonTeamInviteId}/reject">
            <button type="submit" class="btn btn-danger">Reject</button>
        </form>
    </div>
</c:if> --%>
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

            <!-- Existing team: Show members -->
            <c:if test="${hasTeam}">
                <div class="card-custom">
                    <div class="card-header-custom">
                        <h5><i class="fas fa-users"></i> Team Members</h5>
                    </div>
                    <div class="card-body-custom p-0">
                        <div class="table-responsive">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr><th>#</th><th>Name</th><th>Email</th><th>Role</th><th>Action</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${teamMembers}" var="m" varStatus="i">
                                        <tr>
                                            <td>${i.count}</td>
                                            <td><i class="fas fa-user-circle text-primary me-2"></i>${memberMap[m.memberId].firstName} ${memberMap[m.memberId].lastName}</td>
                                            <td>${memberMap[m.memberId].email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.memberId == team.teamLeaderId}">
                                                        <span class="status-badge" style="background:#eef2ff; color:#2563eb;">LEADER</span>
                                                    </c:when>
                                                    <c:otherwise>${m.roleTitle}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${isTeamLeader and m.memberId != team.teamLeaderId}">
                                                    <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/remove-member" method="post" class="d-inline">
                                                        <input type="hidden" name="memberId" value="${m.memberId}">
                                                        <button type="submit" class="btn btn-sm btn-danger btn-sm-icon" onclick="return confirm('Remove this member from your team?')">
                                                            <i class="fas fa-user-minus"></i> Remove
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Invite Activity Table (only if team exists) -->
            <c:if test="${hasTeam}">
                <div class="card-custom">
                    <div class="card-header-custom">
                        <h5><i class="fas fa-paper-plane"></i> Invite Activity</h5>
                    </div>
                    <div class="card-body-custom p-0">
                        <div class="table-responsive">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr><th>Type</th><th>Invitee</th><th>Status</th><th>Sent On</th></tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty inviteList}">
                                        <tr><td colspan="4" class="text-center text-muted py-4">No invites yet.</td></tr>
                                    </c:if>
                                    <c:forEach items="${inviteList}" var="i">
                                        <tr>
                                            <td><span class="badge bg-secondary">${i.inviteType}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty i.invitedEmail}">${i.invitedEmail}</c:when>
                                                    <c:otherwise>User #${i.invitedUserId}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="status-badge
                                                    ${i.inviteStatus == 'PENDING' ? 'status-pending' :
                                                      i.inviteStatus == 'ACCEPTED' ? 'status-accepted' :
                                                      i.inviteStatus == 'REJECTED' ? 'status-rejected' : 'status-expired'}">
                                                    ${i.inviteStatus}
                                                </span>
                                            </td>
                                            <td>${i.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

            
        </div>

        <!-- Right column: Invite options (sticky) -->
        <div class="col-lg-4">
            <div class="sticky-sidebar">
              <c:if test="${hasTeam and isTeamLeader}">
           <div class="card-custom">
        <div class="card-header-custom">
            <h5><i class="fas fa-user-plus"></i> Invite Members</h5>
        </div>
        <div class="card-body-custom">
            <c:choose>
                <c:when test="${inviteAllowed}">
                    <div class="mb-4">
                        <h6>Registered Participants</h6>
                        <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/invite-member" method="post">
                            <select name="invitedUserId" class="form-select" required>
                                <option value="">Choose participant</option>
                                <c:forEach items="${participantUsers}" var="u">
                                    <option value="${u.userId}">${u.firstName} ${u.lastName} - ${u.email}</option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-primary mt-2 w-100">Send Invite</button>
                        </form>
                    </div>
                    <div class="divider"></div>
                    <div>
                        <h6>External User</h6>
                        <form action="${pageContext.request.contextPath}/participant/hackathon/${hackathon.hackathonId}/team/invite-external" method="post">
                            <input type="email" name="externalEmail" class="form-control" placeholder="name@example.com" required>
                            <input type="text" name="roleTitle" class="form-control mt-2" placeholder="Role (optional)">
                            <button type="submit" class="btn btn-primary mt-2 w-100">Send External Invite</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning">Invitations are closed after registration end date.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:if>
                <%-- <c:if test="${hasTeam and not isTeamLeader}">
                    <div class="card-custom">
                        <div class="card-header-custom">
                            <h5><i class="fas fa-user-plus"></i> Invite Members</h5>
                        </div>
                        <div class="card-body-custom text-center">
                            <i class="fas fa-lock fa-2x text-muted mb-2"></i>
                            <p class="text-muted">Only the team leader can send invitations.</p>
                        </div>
                    </div>
                </c:if> --%>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>