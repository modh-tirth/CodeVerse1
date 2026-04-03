package com.Grownited.controller.participant;

import com.Grownited.entity.*;
import com.Grownited.repository.*;
import com.Grownited.service.PaymentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import net.authorize.api.contract.v1.ANetApiResponse;
import net.authorize.api.contract.v1.CreateTransactionResponse;
import net.authorize.api.contract.v1.MessageTypeEnum;
import net.authorize.api.contract.v1.TransactionResponse;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ParticipantController {

    @Autowired
    private HackathonRepository hackathonRepository;

    @Autowired
    private HackathonDescriptionRepository hackathonDescriptionRepository;

    @Autowired
    private HackathonPrizeRepository hackathonPrizeRepository;

    @Autowired
    private HackathonTeamRepository hackathonTeamRepository;

    @Autowired
    private HackathonTeamMembersRepository hackathonTeamMemberRepository;

    @Autowired
    private HackathonTeamInviteRepository hackathonTeamInviteRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HackathonSubmissionRepository hackathonSubmissionRepository;

    @Autowired
    private HackathonResultRepository hackathonResultRepository;

    @Autowired
    private HackathonParticipantRepository hackathonParticipantRepository;

    @Autowired
    private UserDetailRepository userDetailRepository;

    @Autowired
    private PaymentRepository paymentRepository;
    
    @Autowired
    PaymentService paymentService;
    // ==================== PARTICIPANT DASHBOARD ====================

    @GetMapping("/participant/home")
    public String participantDashboard(Model model,HttpSession session) {
    	   List<HackathonEntity> hackathons = hackathonRepository.findAll();
    	    model.addAttribute("hackathons", hackathons);
    	    model.addAttribute("today", LocalDate.now());
    	    
    	    // Fetch distinct userType values for eligibility filter
    	    List<String> eligibilityOptions = hackathonRepository.findDistinctUserType();
    	    model.addAttribute("eligibilityOptions", eligibilityOptions);
    	    UserEntity user = (UserEntity) session.getAttribute("user");
    	    List<PendingInviteDto> pendingInvites = new ArrayList<>();

    	    if (user != null) {
    	        // 1. Find invites by userId (internal invites)
    	        List<HackathonTeamInviteEntity> invites = hackathonTeamInviteRepository
    	                .findByInvitedUserIdAndInviteStatus(user.getUserId(), "PENDING");

    	        // 2. Find invites by email (external invites)
    	        List<HackathonTeamInviteEntity> emailInvites = hackathonTeamInviteRepository
    	                .findByInvitedEmailAndInviteStatus(user.getEmail(), "PENDING");

    	        for (HackathonTeamInviteEntity inv : emailInvites) {
    	            if (inv.getInvitedUserId() == null) {
    	                inv.setInvitedUserId(user.getUserId());
    	                hackathonTeamInviteRepository.save(inv);
    	            }
    	            if (!invites.contains(inv)) invites.add(inv);
    	        }

    	        // 3. Build DTOs for display
    	        for (HackathonTeamInviteEntity inv : invites) {
    	            if ("REQUEST".equals(inv.getInviteType())) continue; // skip join requests

    	            Optional<HackathonEntity> hOpt = hackathonRepository.findById(inv.getHackathonId());
    	            Optional<HackathonTeamEntity> tOpt = hackathonTeamRepository.findById(inv.getTeamId());

    	            if (hOpt.isPresent() && tOpt.isPresent()) {
    	                PendingInviteDto dto = new PendingInviteDto();
    	                dto.setInvite(inv);
    	                dto.setHackathon(hOpt.get());
    	                dto.setTeam(tOpt.get());
    	                pendingInvites.add(dto);
    	            }
    	        }
    	    }

    	    model.addAttribute("pendingInvites", pendingInvites);
        return "participant/Home";
    }

    @GetMapping("/participant/hackathon")
    public String showDetails(@RequestParam("hackathon_id") Integer hackathonId, Model model, HttpSession session) {
        Optional<HackathonEntity> hackathonOpt = hackathonRepository.findById(hackathonId);
        if (hackathonOpt.isEmpty()) {
            return "redirect:/participant/home";
        }
        HackathonEntity hackathon = hackathonOpt.get();
        model.addAttribute("hackathon", hackathon);
        List<HackathonPrizeEntity> prizes = hackathonPrizeRepository.findByHackathonId(hackathonId);
        model.addAttribute("prizes", prizes);
        model.addAttribute("today", LocalDate.now());
        List<HackathonPrizeEntity> prize = hackathonPrizeRepository.findByHackathonIdOrderByHackathonPrizeIdAsc(hackathonId);
        System.out.println("Hackathon " + hackathonId + " -> prizeList size = " + prizes.size());
        model.addAttribute("prizeList", prize);
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

	
		Optional<HackathonDescriptionEntity> description = hackathonDescriptionRepository.findFirstByHackathonId(hackathonId);
		UserEntity user = (UserEntity) session.getAttribute("user");

		LocalDate today = LocalDate.now();
		boolean registrationOpen = hackathon.getRegistrationStartDate() != null && hackathon.getRegistrationEndDate() != null
				&& !today.isBefore(hackathon.getRegistrationStartDate()) && !today.isAfter(hackathon.getRegistrationEndDate());

		boolean alreadyRegistered = false;
		boolean alreadyInTeam = false;
		Integer teamId = null;
		HackathonTeamInviteEntity pendingInvite = null;
		if (user != null) {
			alreadyRegistered = hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId());
			alreadyInTeam = hackathonTeamRepository.existsByHackathonIdAndTeamLeaderId(hackathonId, user.getUserId())
					|| hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, user.getUserId());
			teamId = findTeamIdForUser(hackathonId, user.getUserId());
			pendingInvite = hackathonTeamInviteRepository
					.findFirstByHackathonIdAndInvitedUserIdAndInviteStatus(hackathonId, user.getUserId(), "PENDING")
					.orElse(null);
		}

		model.addAttribute("hackathon", hackathon);
		model.addAttribute("hackathonDescription", description.orElse(null));
		model.addAttribute("prizeList", prizes);
		model.addAttribute("registrationOpen", registrationOpen);
		model.addAttribute("alreadyRegistered", alreadyRegistered);
		model.addAttribute("alreadyInTeam", alreadyInTeam);
		model.addAttribute("canJoin", user != null && registrationOpen && !alreadyRegistered);
		model.addAttribute("pendingInvite", pendingInvite);
		model.addAttribute("teamId", teamId);
		model.addAttribute("teamCount", hackathonTeamRepository.countByHackathonId(hackathonId));
	
		boolean completed = "COMPLETE".equalsIgnoreCase(hackathon.getStatus())
				|| "COMPLETED".equalsIgnoreCase(hackathon.getStatus());
		model.addAttribute("leaderboardAvailable", completed && Boolean.TRUE.equals(hackathon.getLeaderboardPublished()));
	
        return "participant/ViewHackathons";
    }

    // ==================== PROFILE ====================

    @GetMapping("participant/profile")
    public String profile(@RequestParam(required = false) String success,
                          @RequestParam(required = false) String error,
                          Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        UserDetailEntity userDetail = userDetailRepository.findByUserId(user.getUserId()).orElse(new UserDetailEntity());
        model.addAttribute("user", user);
        model.addAttribute("userDetail", userDetail);
        model.addAttribute("success", success);
        model.addAttribute("error", error);
        return "participant/ParticipantProfile";
    }

    @PostMapping("participant/profile/save")
    @Transactional
    public String saveProfile(@RequestParam String firstName, @RequestParam String lastName,
                              @RequestParam(required = false) String contactNum, @RequestParam(required = false) String gender,
                              @RequestParam(required = false) Integer birthYear, @RequestParam(required = false) String qualification,
                              @RequestParam(required = false) String designation, @RequestParam(required = false) String organization,
                              @RequestParam(required = false) String city, @RequestParam(required = false) String state,
                              @RequestParam(required = false) String country, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!StringUtils.hasText(firstName) || !StringUtils.hasText(lastName)) {
            return "redirect:/participant/profile?error=invalidName";
        }
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setContactNum(StringUtils.hasText(contactNum) ? contactNum.trim() : null);
        user.setGender(StringUtils.hasText(gender) ? gender.trim() : null);
        user.setBirthYear(birthYear);
        userRepository.save(user);

        UserDetailEntity userDetail = userDetailRepository.findByUserId(user.getUserId()).orElse(new UserDetailEntity());
        userDetail.setUserId(user.getUserId());
        userDetail.setQualification(StringUtils.hasText(qualification) ? qualification.trim() : null);
        userDetail.setCity(StringUtils.hasText(city) ? city.trim() : null);
        userDetail.setState(StringUtils.hasText(state) ? state.trim() : null);
        userDetail.setCountry(StringUtils.hasText(country) ? country.trim() : null);
        userDetailRepository.save(userDetail);

        session.setAttribute("user", user);
        return "redirect:/participant/profile?success=updated";
    }

    // ==================== MY HACKATHONS ====================

    @GetMapping("participant/my-hackathons")
    public String myHackathons(Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        LocalDate today = LocalDate.now();
        Map<Integer, MyHackathonRow> rowMap = new LinkedHashMap<>();

        // Joined hackathons (no team yet)
        List<HackathonParticipantEntity> joined = hackathonParticipantRepository.findByParticipantId(user.getUserId());
        for (HackathonParticipantEntity p : joined) {
            Integer hid = p.getHackathonId();
            hackathonRepository.findById(hid).ifPresent(h -> {
                MyHackathonRow row = new MyHackathonRow();
                row.setHackathon(h);
                row.setTeamId(null);
                row.setTeamName("Not Joined Any Team");
                row.setLeader(false);
                row.setRoleTitle("PARTICIPANT");
                row.setTeamSize(0);
                row.setPendingInvites(0);
                row.setSubmissionEnabled(isSubmissionOpen(h, today));
                rowMap.put(h.getHackathonId(), row);
            });
        }

        // Teams where user is leader
        List<HackathonTeamEntity> leaderTeams = hackathonTeamRepository.findByTeamLeaderId(user.getUserId());
        for (HackathonTeamEntity team : leaderTeams) {
            Integer hid = team.getHackathonId();
            hackathonRepository.findById(hid).ifPresent(h -> {
                MyHackathonRow row = new MyHackathonRow();
                row.setHackathon(h);
                row.setTeamId(team.getHackathonTeamId());
                row.setTeamName(team.getTeamName());
                row.setLeader(true);
                row.setRoleTitle("TEAM_LEADER");
                row.setTeamSize((int) hackathonTeamMemberRepository.countByTeamId(team.getHackathonTeamId()));
                row.setPendingInvites((int) hackathonTeamInviteRepository.countByTeamIdAndInviteStatus(team.getHackathonTeamId(), "PENDING"));
                row.setSubmissionEnabled(isSubmissionOpen(h, today));
                rowMap.put(h.getHackathonId(), row);
            });
        }

        // Teams where user is member
        List<HackathonTeamMembersEntity> memberships = hackathonTeamMemberRepository.findByMemberId(user.getUserId());
        for (HackathonTeamMembersEntity member : memberships) {
            Integer hid = member.getHackathonId();
            Integer tid = member.getTeamId();
            if (rowMap.containsKey(hid)) continue;
            Optional<HackathonEntity> opH = hackathonRepository.findById(hid);
            Optional<HackathonTeamEntity> opT = hackathonTeamRepository.findById(tid);
            if (opH.isPresent() && opT.isPresent()) {
                HackathonEntity h = opH.get();
                HackathonTeamEntity team = opT.get();
                MyHackathonRow row = new MyHackathonRow();
                row.setHackathon(h);
                row.setTeamId(team.getHackathonTeamId());
                row.setTeamName(team.getTeamName());
                row.setLeader(user.getUserId().equals(team.getTeamLeaderId()));
                row.setRoleTitle(member.getRoleTitle());
                row.setTeamSize((int) hackathonTeamMemberRepository.countByTeamId(team.getHackathonTeamId()));
                row.setPendingInvites((int) hackathonTeamInviteRepository.countByTeamIdAndInviteStatus(team.getHackathonTeamId(), "PENDING"));
                row.setSubmissionEnabled(isSubmissionOpen(h, today));
                rowMap.put(h.getHackathonId(), row);
            }
        }

        model.addAttribute("myHackathons", rowMap.values());
        model.addAttribute("totalCount", rowMap.size());
        return "participant/MyHackathons";
    }

    // ==================== HACKATHON DETAILS ====================

    @GetMapping("participant/hackathon/{hackathonId}")
    public String hackathonDetails(@PathVariable Integer hackathonId,
                                   @RequestParam(required = false) String joined,
                                   @RequestParam(required = false) String success,
                                   @RequestParam(required = false) String error,
                                   Model model, HttpSession session) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        HackathonEntity hackathon = opHackathon.get();
        Optional<HackathonDescriptionEntity> description = hackathonDescriptionRepository.findFirstByHackathonId(hackathonId);
        List<HackathonPrizeEntity> prizes = hackathonPrizeRepository.findByHackathonIdOrderByHackathonPrizeIdAsc(hackathonId);
        UserEntity user = (UserEntity) session.getAttribute("user");

        LocalDate today = LocalDate.now();
        boolean registrationOpen = hackathon.getRegistrationStartDate() != null && hackathon.getRegistrationEndDate() != null
                && !today.isBefore(hackathon.getRegistrationStartDate()) && !today.isAfter(hackathon.getRegistrationEndDate());

        boolean alreadyRegistered = false;
        boolean alreadyInTeam = false;
        Integer teamId = null;
        HackathonTeamInviteEntity pendingInvite = null;

        if (user != null) {
            alreadyRegistered = hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId());
            alreadyInTeam = hackathonTeamRepository.existsByHackathonIdAndTeamLeaderId(hackathonId, user.getUserId())
                    || hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, user.getUserId());
            teamId = findTeamIdForUser(hackathonId, user.getUserId());

            // Try to find pending invite by userId
            pendingInvite = hackathonTeamInviteRepository
                    .findFirstByHackathonIdAndInvitedUserIdAndInviteStatus(hackathonId, user.getUserId(), "PENDING")
                    .orElse(null);
            // If not found, try by email (external invites)
            if (pendingInvite == null) {
                pendingInvite = hackathonTeamInviteRepository
                        .findFirstByHackathonIdAndInvitedEmailAndInviteStatus(hackathonId, user.getEmail(), "PENDING")
                        .orElse(null);
                if (pendingInvite != null && pendingInvite.getInvitedUserId() == null) {
                    pendingInvite.setInvitedUserId(user.getUserId());
                    hackathonTeamInviteRepository.save(pendingInvite);
                }
            }
        }

        boolean completed = "COMPLETE".equalsIgnoreCase(hackathon.getStatus())
                || "COMPLETED".equalsIgnoreCase(hackathon.getStatus());
        boolean leaderboardAvailable = completed && Boolean.TRUE.equals(hackathon.getLeaderboardPublished());
        
        boolean hasPaid = false;
        if (user != null && hackathon.getPayment().equalsIgnoreCase("PAID")) {
            hasPaid = paymentRepository.findByHackathonIdAndUserIdAndPaymentStatus(hackathonId, user.getUserId(), "SUCCESS").isPresent();
        }
        model.addAttribute("hasPaid", hasPaid);
        model.addAttribute("hackathon", hackathon);
        model.addAttribute("hackathonDescription", description.orElse(null));
        model.addAttribute("prizeList", prizes);
        model.addAttribute("registrationOpen", registrationOpen);
        model.addAttribute("alreadyRegistered", alreadyRegistered);
        model.addAttribute("alreadyInTeam", alreadyInTeam);
        model.addAttribute("canJoin", user != null && registrationOpen && !alreadyRegistered);
        model.addAttribute("pendingInvite", pendingInvite);
        model.addAttribute("teamId", teamId);
        model.addAttribute("teamCount", hackathonTeamRepository.countByHackathonId(hackathonId));
        model.addAttribute("joined", joined);
        model.addAttribute("success", success);
        model.addAttribute("error", error);
        model.addAttribute("leaderboardAvailable", leaderboardAvailable);
        return "participant/ViewHackathons";
    }

    // ==================== LEADERBOARD ====================

    @GetMapping("participant/hackathon/{hackathonId}/leaderboard")
    public String leaderboard(@PathVariable Integer hackathonId, Model model) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        HackathonEntity hackathon = opHackathon.get();
        boolean completed = "COMPLETE".equalsIgnoreCase(hackathon.getStatus())
                || "COMPLETED".equalsIgnoreCase(hackathon.getStatus());
        boolean published = Boolean.TRUE.equals(hackathon.getLeaderboardPublished());
        if (!completed || !published) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=leaderboardNotReady";
        }

        List<HackathonTeamEntity> teams = hackathonTeamRepository.findByHackathonId(hackathonId);
        List<HackathonResultEntity> results = hackathonResultRepository.findByHackathonId(hackathonId);

        Map<Integer, LeaderboardRow> rowMap = new HashMap<>();
        for (HackathonTeamEntity team : teams) {
            LeaderboardRow row = new LeaderboardRow();
            row.setTeamId(team.getHackathonTeamId());
            row.setTeamName(team.getTeamName());
            rowMap.put(team.getHackathonTeamId(), row);
        }

        for (HackathonResultEntity result : results) {
            LeaderboardRow row = rowMap.get(result.getTeamId());
            if (row == null) continue;
            int innovation = result.getInnovation() == null ? 0 : result.getInnovation();
            int implementation = result.getImplementation() == null ? 0 : result.getImplementation();
            int codingStandard = result.getCodingStandard() == null ? 0 : result.getCodingStandard();
            int total = innovation + implementation + codingStandard;
            row.setTotalScore(row.getTotalScore() + total);
            row.setEvaluationCount(row.getEvaluationCount() + 1);
        }

        List<LeaderboardRow> leaderboardRows = new ArrayList<>(rowMap.values());
        for (LeaderboardRow row : leaderboardRows) {
            if (row.getEvaluationCount() > 0) {
                row.setAverageScore((double) row.getTotalScore() / row.getEvaluationCount());
            }
        }

        leaderboardRows.sort(Comparator.comparingDouble(LeaderboardRow::getAverageScore).reversed()
                .thenComparing(Comparator.comparingInt(LeaderboardRow::getTotalScore).reversed())
                .thenComparing(LeaderboardRow::getTeamName, String.CASE_INSENSITIVE_ORDER));

        int rank = 0;
        double prevAvg = -1d;
        int prevTotal = -1;
        int tieRank = 0;
        for (LeaderboardRow row : leaderboardRows) {
            tieRank++;
            if (Double.compare(row.getAverageScore(), prevAvg) != 0 || row.getTotalScore() != prevTotal) {
                rank = tieRank;
                prevAvg = row.getAverageScore();
                prevTotal = row.getTotalScore();
            }
            row.setRank(rank);
        }

        model.addAttribute("hackathon", hackathon);
        model.addAttribute("leaderboardRows", leaderboardRows);
        model.addAttribute("totalTeams", teams.size());
        model.addAttribute("totalEvaluations", results.size());
        return "participant/Leaderboard";
    }

    // ==================== JOIN HACKATHON ====================

    @PostMapping("participant/hackathon/{hackathonId}/join")
    @Transactional
    public String joinHackathon(@PathVariable Integer hackathonId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        HackathonEntity hackathon = opHackathon.get();
        LocalDate today = LocalDate.now();
        boolean registrationOpen = hackathon.getRegistrationStartDate() != null && hackathon.getRegistrationEndDate() != null
                && !today.isBefore(hackathon.getRegistrationStartDate()) && !today.isAfter(hackathon.getRegistrationEndDate());
        if (!registrationOpen) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=registrationClosed";
        }
        if (hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=alreadyRegistered";
        }

        HackathonParticipantEntity participant = new HackathonParticipantEntity();
        participant.setHackathonId(hackathonId);
        participant.setParticipantId(user.getUserId());
        participant.setJoinedDate(LocalDate.now());
        hackathonParticipantRepository.save(participant);

        return "redirect:/participant/hackathon/" + hackathonId + "?joined=true";
    }

    // ==================== TEAM MANAGEMENT ====================

    @GetMapping("/participant/hackathon/{hackathonId}/team")
    public String manageTeam(@PathVariable Integer hackathonId,
                             @RequestParam(required = false) String success,
                             @RequestParam(required = false) String error,
                             Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());

        boolean joinedHackathon =
                hackathonParticipantRepository.existsByHackathonIdAndParticipantId(
                        hackathonId, user.getUserId());

        if (!joinedHackathon) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        }

        boolean hasTeam = teamId != null;
        boolean isTeamLeader = false;

        HackathonTeamEntity team = null;
        HackathonTeamInviteEntity pendingInvite = null;
        HackathonTeamEntity pendingInviteTeam = null;

        List<HackathonTeamMembersEntity> teamMembers = new ArrayList<>();
        Map<Integer, UserEntity> memberMap = new HashMap<>();

        List<UserEntity> participantUsers = new ArrayList<>();
        List<HackathonTeamInviteEntity> inviteList = new ArrayList<>();
        List<HackathonTeamInviteEntity> joinRequests = new ArrayList<>();
        Map<Integer, UserEntity> requesterMap = new HashMap<>();
        List<HackathonTeamInviteEntity> myPendingRequests = new ArrayList<>();

        if (hasTeam) {

            Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
            if (opTeam.isEmpty()) {
                return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
            }

            team = opTeam.get();
            isTeamLeader = user.getUserId().equals(team.getTeamLeaderId());

            // 👥 Team Members
            teamMembers = hackathonTeamMemberRepository
                    .findByTeamIdOrderByHackathonTeamMemberIdAsc(teamId);

            for (HackathonTeamMembersEntity m : teamMembers) {
                userRepository.findById(m.getMemberId())
                        .ifPresent(u -> memberMap.put(m.getMemberId(), u));
            }

            // 🧪 STEP 1: Get all participant IDs
            List<Integer> joinedParticipantIds =
                    hackathonParticipantRepository.findByHackathonId(hackathonId)
                            .stream()
                            .map(HackathonParticipantEntity::getParticipantId)
                            .collect(Collectors.toList());

            System.out.println("Participant IDs: " + joinedParticipantIds);

            // 🧪 STEP 2: Fetch users
            List<UserEntity> allUsers = userRepository.findAllById(joinedParticipantIds);

            System.out.println("All users fetched: " + allUsers.size());

            // 🧪 DEBUG PRINT
            allUsers.forEach(u -> System.out.println(
                    "User: " + u.getEmail() +
                    " | role=" + u.getRole() +
                    " | active=" + u.getActive()
            ));

            List<Integer> existingMemberIds = teamMembers.stream()
                    .map(HackathonTeamMembersEntity::getMemberId)
                    .collect(Collectors.toList());

            List<Integer> usersInOtherTeams = hackathonTeamMemberRepository
                    .findByHackathonId(hackathonId)
                    .stream()
                    .map(HackathonTeamMembersEntity::getMemberId)
                    .collect(Collectors.toList());

            List<Integer> usersWithPendingInvites =
                    hackathonTeamInviteRepository
                            .findByHackathonIdAndInviteStatus(hackathonId, "PENDING")
                            .stream()
                            .map(HackathonTeamInviteEntity::getInvitedUserId)
                            .filter(Objects::nonNull)
                            .collect(Collectors.toList());

            // ✅ FIXED FILTER LOGIC
            participantUsers = allUsers.stream()
                    .filter(u -> u.getRole() != null &&
                            u.getRole().equalsIgnoreCase("PARTICIPANT")) // FIX
                    .filter(u -> u.getActive() == null || u.getActive()) // SAFE FIX
                    .filter(u -> !u.getUserId().equals(user.getUserId()))
                    .filter(u -> !existingMemberIds.contains(u.getUserId()))
                    .filter(u ->  !usersInOtherTeams.contains(u.getUserId()))
                    .filter(u -> !usersWithPendingInvites.contains(u.getUserId()))
                    .collect(Collectors.toList());

            System.out.println("Filtered participants: " + participantUsers.size());

            inviteList = hackathonTeamInviteRepository
                    .findByTeamIdOrderByHackathonTeamInviteIdDesc(teamId);

            joinRequests = hackathonTeamInviteRepository
                    .findByTeamIdAndInviteTypeAndInviteStatus(teamId, "REQUEST", "PENDING");

            for (HackathonTeamInviteEntity req : joinRequests) {
                userRepository.findById(req.getInvitedUserId())
                        .ifPresent(u -> requesterMap.put(req.getInvitedUserId(), u));
            }

        } else {

            pendingInvite = hackathonTeamInviteRepository
                    .findFirstByHackathonIdAndInvitedUserIdAndInviteStatus(
                            hackathonId, user.getUserId(), "PENDING")
                    .orElse(null);

            if (pendingInvite == null) {
                pendingInvite = hackathonTeamInviteRepository
                        .findFirstByHackathonIdAndInvitedEmailAndInviteStatus(
                                hackathonId, user.getEmail(), "PENDING")
                        .orElse(null);

                if (pendingInvite != null && pendingInvite.getInvitedUserId() == null) {
                    pendingInvite.setInvitedUserId(user.getUserId());
                    hackathonTeamInviteRepository.save(pendingInvite);
                }
            }

            if (pendingInvite != null && pendingInvite.getTeamId() != null) {
                pendingInviteTeam = hackathonTeamRepository
                        .findById(pendingInvite.getTeamId())
                        .orElse(null);
            }

            myPendingRequests = hackathonTeamInviteRepository
                    .findByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteType(
                            hackathonId, user.getUserId(), "PENDING", "REQUEST");
        }

        // 📌 Available Teams
        List<HackathonTeamEntity> availableTeams =
                hackathonTeamRepository.findByHackathonId(hackathonId);

        availableTeams = availableTeams.stream()
                .filter(t -> {
                    long size = hackathonTeamMemberRepository.countByTeamId(t.getHackathonTeamId());
                    return opHackathon.get().getMaxTeamSize() == null ||
                            size < opHackathon.get().getMaxTeamSize();
                })
                .collect(Collectors.toList());

        if (hasTeam) {
            Integer myTeamId = teamId;
            availableTeams = availableTeams.stream()
                    .filter(t -> !t.getHackathonTeamId().equals(myTeamId))
                    .collect(Collectors.toList());
        } else {
            Set<Integer> teamsWithPendingRequest =
                    myPendingRequests.stream()
                            .map(HackathonTeamInviteEntity::getTeamId)
                            .collect(Collectors.toSet());

            availableTeams = availableTeams.stream()
                    .filter(t -> !teamsWithPendingRequest.contains(t.getHackathonTeamId()))
                    .collect(Collectors.toList());
        }

        // 📦 Model Attributes
        model.addAttribute("hackathon", opHackathon.get());
        model.addAttribute("teamId", teamId);
        model.addAttribute("teamMembers", teamMembers);
        model.addAttribute("memberMap", memberMap);
        model.addAttribute("participantUsers", participantUsers);
        model.addAttribute("inviteList", inviteList);
        model.addAttribute("team", team);
        model.addAttribute("isTeamLeader", isTeamLeader);
        model.addAttribute("hasTeam", hasTeam);
        model.addAttribute("pendingInvite", pendingInvite);
        model.addAttribute("pendingInviteTeam", pendingInviteTeam);
        model.addAttribute("availableTeams", availableTeams);
        model.addAttribute("teamSizeCount", hasTeam ? teamMembers.size() : 0);
        model.addAttribute("teamMaxSize", opHackathon.get().getMaxTeamSize());
        model.addAttribute("inviteAllowed",
                opHackathon.get().getRegistrationEndDate() == null ||
                        !LocalDate.now().isAfter(opHackathon.get().getRegistrationEndDate()));
        model.addAttribute("success", success);
        model.addAttribute("error", error);
        model.addAttribute("joinRequests", joinRequests);
        model.addAttribute("requesterMap", requesterMap);
        model.addAttribute("myPendingRequests", myPendingRequests);

        return "participant/ManageTeam";
    }
    // ==================== TEAM ACTIONS ====================

    @PostMapping("participant/hackathon/{hackathonId}/team/create")
    @Transactional
    public String createTeam(@PathVariable Integer hackathonId, @RequestParam String teamName, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        if (!hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        }
        if (findTeamIdForUser(hackathonId, user.getUserId()) != null) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
        }
        if (!StringUtils.hasText(teamName)) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidTeamName";
        }

        HackathonTeamEntity team = new HackathonTeamEntity();
        team.setHackathonId(hackathonId);
        team.setTeamLeaderId(user.getUserId());
        team.setTeamStatus("QUALIFY");
        team.setTeamName(teamName.trim());
        hackathonTeamRepository.save(team);

        HackathonTeamMembersEntity leader = new HackathonTeamMembersEntity();
        leader.setTeamId(team.getHackathonTeamId());
        leader.setHackathonId(hackathonId);
        leader.setMemberId(user.getUserId());
        leader.setRoleTitle("TEAM_LEADER");
        hackathonTeamMemberRepository.save(leader);

        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=teamCreated";
    }

    // Participant requests to join a team
    @PostMapping("participant/hackathon/{hackathonId}/team/request-join")
    @Transactional
    public String requestJoinTeam(@PathVariable Integer hackathonId, @RequestParam Integer requestTeamId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        if (!hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        }
        if (findTeamIdForUser(hackathonId, user.getUserId()) != null) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
        }
        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(requestTeamId);
        if (opTeam.isEmpty() || !hackathonId.equals(opTeam.get().getHackathonId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidTeam";
        }
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";
        if (opHackathon.get().getRegistrationEndDate() != null && LocalDate.now().isAfter(opHackathon.get().getRegistrationEndDate())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteClosed";
        }
        long teamSize = hackathonTeamMemberRepository.countByTeamId(requestTeamId);
        Integer maxSize = opHackathon.get().getMaxTeamSize();
        if (maxSize != null && teamSize >= maxSize) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=teamFull";
        }
        boolean pendingRequestExists = hackathonTeamInviteRepository.existsByHackathonIdAndInvitedUserIdAndInviteStatusAndInviteType(
                hackathonId, user.getUserId(), "PENDING", "REQUEST");
        if (pendingRequestExists) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=requestExists";
        }

        HackathonTeamInviteEntity request = new HackathonTeamInviteEntity();
        request.setTeamId(requestTeamId);
        request.setHackathonId(hackathonId);
        request.setInvitedBy(user.getUserId());
        request.setInviteType("REQUEST");
        request.setInvitedUserId(user.getUserId());
        request.setInvitedEmail(user.getEmail());
        request.setRoleTitle("MEMBER");
        request.setInviteStatus("PENDING");
        request.setCreatedAt(LocalDate.now());
        hackathonTeamInviteRepository.save(request);

        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestSent";
    }

    // Leader accepts join request
    @PostMapping("participant/hackathon/{hackathonId}/team/request/{requestId}/accept")
    @Transactional
    public String acceptJoinRequest(@PathVariable Integer hackathonId, @PathVariable Integer requestId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonTeamInviteEntity> opRequest = hackathonTeamInviteRepository.findById(requestId);
        if (opRequest.isEmpty() || !"REQUEST".equals(opRequest.get().getInviteType()) || !"PENDING".equals(opRequest.get().getInviteStatus())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidRequest";
        }
        HackathonTeamInviteEntity request = opRequest.get();

        HackathonTeamEntity team = hackathonTeamRepository.findById(request.getTeamId()).orElse(null);
        if (team == null || !user.getUserId().equals(team.getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }

        HackathonEntity hackathon = hackathonRepository.findById(hackathonId).orElse(null);
        long size = hackathonTeamMemberRepository.countByTeamId(team.getHackathonTeamId());
        if (hackathon.getMaxTeamSize() != null && size >= hackathon.getMaxTeamSize()) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=teamFull";
        }

        if (hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, request.getInvitedUserId())) {
            request.setInviteStatus("REJECTED");
            hackathonTeamInviteRepository.save(request);
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
        }

        HackathonTeamMembersEntity member = new HackathonTeamMembersEntity();
        member.setTeamId(team.getHackathonTeamId());
        member.setHackathonId(hackathonId);
        member.setMemberId(request.getInvitedUserId());
        member.setRoleTitle("MEMBER");
        hackathonTeamMemberRepository.save(member);

        request.setInviteStatus("ACCEPTED");
        hackathonTeamInviteRepository.save(request);
        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestAccepted";
    }

    // Leader rejects join request
    @PostMapping("participant/hackathon/{hackathonId}/team/request/{requestId}/reject")
    @Transactional
    public String rejectJoinRequest(@PathVariable Integer hackathonId, @PathVariable Integer requestId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonTeamInviteEntity> opRequest = hackathonTeamInviteRepository.findById(requestId);
        if (opRequest.isEmpty() || !"REQUEST".equals(opRequest.get().getInviteType()) || !"PENDING".equals(opRequest.get().getInviteStatus())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidRequest";
        }
        HackathonTeamInviteEntity request = opRequest.get();

        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(request.getTeamId());
        if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }

        request.setInviteStatus("REJECTED");
        hackathonTeamInviteRepository.save(request);
        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestRejected";
    }

    // Participant cancels own join request
    @PostMapping("participant/hackathon/{hackathonId}/team/request/{requestId}/cancel")
    @Transactional
    public String cancelJoinRequest(@PathVariable Integer hackathonId, @PathVariable Integer requestId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonTeamInviteEntity> opRequest = hackathonTeamInviteRepository.findById(requestId);
        if (opRequest.isEmpty() || !"REQUEST".equals(opRequest.get().getInviteType()) || !"PENDING".equals(opRequest.get().getInviteStatus())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidRequest";
        }
        HackathonTeamInviteEntity request = opRequest.get();

        if (!user.getUserId().equals(request.getInvitedUserId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=unauthorized";
        }

        request.setInviteStatus("CANCELLED");
        hackathonTeamInviteRepository.save(request);
        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestCancelled";
    }

    // Internal invite
    @PostMapping("participant/hackathon/{hackathonId}/team/invite-member")
    @Transactional
    public String inviteRegisteredMember(@PathVariable Integer hackathonId, @RequestParam Integer invitedUserId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";
        if (opHackathon.get().getRegistrationEndDate() != null && LocalDate.now().isAfter(opHackathon.get().getRegistrationEndDate())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteClosed";
        }

        Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
        if (teamId == null) return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
        if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }

        long teamSize = hackathonTeamMemberRepository.countByTeamId(teamId);
        if (opHackathon.get().getMaxTeamSize() != null && teamSize >= opHackathon.get().getMaxTeamSize()) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=teamFull";
        }

        Optional<UserEntity> opInvited = userRepository.findById(invitedUserId);
        if (opInvited.isEmpty() || !"PARTICIPANT".equalsIgnoreCase(opInvited.get().getRole())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidUser";
        }
        if (hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, invitedUserId)) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
        }
        if (hackathonTeamInviteRepository.existsByHackathonIdAndInvitedUserIdAndInviteStatus(hackathonId, invitedUserId, "PENDING")) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteExists";
        }

        HackathonTeamInviteEntity invite = new HackathonTeamInviteEntity();
        invite.setTeamId(teamId);
        invite.setHackathonId(hackathonId);
        invite.setInvitedBy(user.getUserId());
        invite.setInviteType("INTERNAL");
        invite.setInvitedUserId(invitedUserId);
        invite.setInvitedEmail(opInvited.get().getEmail());
        invite.setRoleTitle("MEMBER");
        invite.setInviteStatus("PENDING");
        invite.setCreatedAt(LocalDate.now());
        hackathonTeamInviteRepository.save(invite);

        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=memberInvited";
    }

    // External invite
    @PostMapping("participant/hackathon/{hackathonId}/team/invite-external")
    @Transactional
    public String inviteExternalMember(@PathVariable Integer hackathonId, @RequestParam String externalEmail,
                                       @RequestParam(required = false) String roleTitle, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
        if (teamId == null) return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
        if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }

        if (!StringUtils.hasText(externalEmail) || !externalEmail.contains("@")) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidEmail";
        }
        if (hackathonTeamInviteRepository.existsByTeamIdAndInvitedEmailAndInviteStatus(teamId, externalEmail.trim(), "PENDING")) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteExists";
        }

        HackathonTeamInviteEntity invite = new HackathonTeamInviteEntity();
        invite.setTeamId(teamId);
        invite.setHackathonId(hackathonId);
        invite.setInvitedBy(user.getUserId());
        invite.setInviteType("EXTERNAL");
        invite.setInvitedEmail(externalEmail.trim());
        invite.setRoleTitle(StringUtils.hasText(roleTitle) ? roleTitle.trim() : "MEMBER");
        invite.setInviteStatus("PENDING");
        invite.setCreatedAt(LocalDate.now());
        hackathonTeamInviteRepository.save(invite);

        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=externalInvited";
    }

    // Remove member (leader only)
    @PostMapping("participant/hackathon/{hackathonId}/team/remove-member")
    @Transactional
    public String removeMember(@PathVariable Integer hackathonId, @RequestParam Integer memberId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
        if (teamId == null) return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";

        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
        if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }
        if (memberId.equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=cannotRemoveLeader";
        }
        Optional<HackathonTeamMembersEntity> opMember = hackathonTeamMemberRepository.findFirstByTeamIdAndMemberId(teamId, memberId);
        if (opMember.isEmpty()) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=memberNotFound";
        }
        hackathonTeamMemberRepository.deleteById(opMember.get().getHackathonTeamMemberId());
        return "redirect:/participant/hackathon/" + hackathonId + "/team?success=memberRemoved";
    }

    // ==================== ACCEPT/REJECT INVITES ====================

    @PostMapping("participant/hackathon/{hackathonId}/invite/{inviteId}/accept")
    @Transactional
    public String acceptInvitation(@PathVariable Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
        return handleInvitationResponse(hackathonId, inviteId, session, true, false);
    }

    @PostMapping("participant/hackathon/{hackathonId}/invite/{inviteId}/reject")
    @Transactional
    public String rejectInvitation(@PathVariable Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
        return handleInvitationResponse(hackathonId, inviteId, session, false, false);
    }

    @PostMapping("participant/hackathon/{hackathonId}/team/invite/{inviteId}/accept")
    @Transactional
    public String acceptInvitationFromTeamPage(@PathVariable Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
        return handleInvitationResponse(hackathonId, inviteId, session, true, true);
    }

    @PostMapping("participant/hackathon/{hackathonId}/team/invite/{inviteId}/reject")
    @Transactional
    public String rejectInvitationFromTeamPage(@PathVariable Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
        return handleInvitationResponse(hackathonId, inviteId, session, false, true);
    }

	/*
	 * private String handleInvitationResponse(Integer hackathonId, Integer
	 * inviteId, HttpSession session, boolean accept, boolean redirectToTeamPage) {
	 * UserEntity user = (UserEntity) session.getAttribute("user"); if (user ==
	 * null) return "redirect:/login";
	 * 
	 * String basePath = "redirect:/participant/hackathon/" + hackathonId; if
	 * (redirectToTeamPage) basePath += "/team";
	 * 
	 * Optional<HackathonTeamInviteEntity> opInvite =
	 * hackathonTeamInviteRepository.findById(inviteId); if (opInvite.isEmpty())
	 * return basePath + "?error=inviteNotFound";
	 * 
	 * HackathonTeamInviteEntity invite = opInvite.get(); if
	 * (!"PENDING".equals(invite.getInviteStatus()) || invite.getHackathonId() ==
	 * null || !invite.getHackathonId().equals(hackathonId)) { return basePath +
	 * "?error=inviteInvalid"; }
	 * 
	 * // For external invites, link user if needed if (invite.getInvitedUserId() ==
	 * null && invite.getInvitedEmail() != null &&
	 * invite.getInvitedEmail().equalsIgnoreCase(user.getEmail())) {
	 * invite.setInvitedUserId(user.getUserId());
	 * hackathonTeamInviteRepository.save(invite); }
	 * 
	 * // Ensure invite belongs to this user if (invite.getInvitedUserId() != null
	 * && !invite.getInvitedUserId().equals(user.getUserId())) { return basePath +
	 * "?error=inviteInvalid"; }
	 * 
	 * if (!accept) { invite.setInviteStatus("REJECTED");
	 * hackathonTeamInviteRepository.save(invite); return basePath +
	 * "?success=inviteRejected"; }
	 * 
	 * // Already in a team? if
	 * (hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId,
	 * user.getUserId())) { invite.setInviteStatus("REJECTED");
	 * hackathonTeamInviteRepository.save(invite); return basePath +
	 * "?error=alreadyInHackathon"; }
	 * 
	 * Optional<HackathonEntity> opHackathon =
	 * hackathonRepository.findById(hackathonId); if (opHackathon.isEmpty()) return
	 * "redirect:/participant/home"; ensureParticipantRegistration(hackathonId,
	 * user.getUserId());
	 * 
	 * long teamSize =
	 * hackathonTeamMemberRepository.countByTeamId(invite.getTeamId()); Integer
	 * maxSize = opHackathon.get().getMaxTeamSize(); if (maxSize != null && teamSize
	 * >= maxSize) { return basePath + "?error=teamFull"; }
	 * 
	 * // Add to team HackathonTeamMembersEntity member = new
	 * HackathonTeamMembersEntity(); member.setTeamId(invite.getTeamId());
	 * member.setHackathonId(hackathonId); member.setMemberId(user.getUserId());
	 * member.setRoleTitle(StringUtils.hasText(invite.getRoleTitle()) ?
	 * invite.getRoleTitle() : "MEMBER");
	 * hackathonTeamMemberRepository.save(member);
	 * 
	 * invite.setInviteStatus("ACCEPTED");
	 * hackathonTeamInviteRepository.save(invite); return basePath +
	 * "?success=inviteAccepted"; }
	 */
    
    private String handleInvitationResponse(Integer hackathonId, Integer inviteId, HttpSession session,
            boolean accept, boolean redirectToTeamPage) {
UserEntity user = (UserEntity) session.getAttribute("user");
if (user == null) return "redirect:/login";

String basePath = "redirect:/participant/hackathon/" + hackathonId;
if (redirectToTeamPage) basePath += "/team";

Optional<HackathonTeamInviteEntity> opInvite = hackathonTeamInviteRepository.findById(inviteId);
if (opInvite.isEmpty()) return basePath + "?error=inviteNotFound";

HackathonTeamInviteEntity invite = opInvite.get();
if (!"PENDING".equals(invite.getInviteStatus()) || !invite.getHackathonId().equals(hackathonId)) {
return basePath + "?error=inviteInvalid";
}

// Link external invite to user
if (invite.getInvitedUserId() == null && invite.getInvitedEmail() != null
&& invite.getInvitedEmail().equalsIgnoreCase(user.getEmail())) {
invite.setInvitedUserId(user.getUserId());
hackathonTeamInviteRepository.save(invite);
}

if (invite.getInvitedUserId() != null && !invite.getInvitedUserId().equals(user.getUserId())) {
return basePath + "?error=inviteInvalid";
}

if (!accept) {
invite.setInviteStatus("REJECTED");
hackathonTeamInviteRepository.save(invite);
return basePath + "?success=inviteRejected";
}

// ========== PAYMENT CHECK FOR PAID HACKATHONS ==========
Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
if (opHackathon.isEmpty()) return "redirect:/participant/home";
HackathonEntity hackathon = opHackathon.get();

if ("PAID".equalsIgnoreCase(hackathon.getPayment())) {
boolean hasPaid = paymentRepository.findByHackathonIdAndUserIdAndPaymentStatus(
hackathonId, user.getUserId(), "SUCCESS").isPresent();
if (!hasPaid) {
// Redirect to payment page with inviteId
return "redirect:/participant/hackathon/" + hackathonId + "/pay?inviteId=" + inviteId;
}
}

// Already in a team?
if (hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, user.getUserId())) {
invite.setInviteStatus("REJECTED");
hackathonTeamInviteRepository.save(invite);
return basePath + "?error=alreadyInHackathon";
}

ensureParticipantRegistration(hackathonId, user.getUserId());

long teamSize = hackathonTeamMemberRepository.countByTeamId(invite.getTeamId());
Integer maxSize = hackathon.getMaxTeamSize();
if (maxSize != null && teamSize >= maxSize) {
return basePath + "?error=teamFull";
}

// Add to team
HackathonTeamMembersEntity member = new HackathonTeamMembersEntity();
member.setTeamId(invite.getTeamId());
member.setHackathonId(hackathonId);
member.setMemberId(user.getUserId());
member.setRoleTitle(StringUtils.hasText(invite.getRoleTitle()) ? invite.getRoleTitle() : "MEMBER");
hackathonTeamMemberRepository.save(member);

invite.setInviteStatus("ACCEPTED");
hackathonTeamInviteRepository.save(invite);
return basePath + "?success=inviteAccepted";
}
    // ==================== SUBMISSION ====================

    @GetMapping("participant/hackathon/{hackathonId}/submission")
    public String openSubmission(@PathVariable Integer hackathonId,
                                 @RequestParam(required = false) String success,
                                 @RequestParam(required = false) String error,
                                 Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
        if (teamId == null) return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
        if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }

        HackathonSubmissionEntity submission = hackathonSubmissionRepository
                .findByHackathonIdAndTeamId(hackathonId, teamId)
                .orElse(new HackathonSubmissionEntity());
        submission.setHackathonId(hackathonId);
        submission.setTeamId(teamId);

        model.addAttribute("hackathon", opHackathon.get());
        model.addAttribute("submission", submission);
        model.addAttribute("success", success);
        model.addAttribute("error", error);
        return "participant/HackathonSubmission";
    }

    @PostMapping("participant/hackathon/{hackathonId}/submission/save")
    @Transactional
    public String saveSubmission(@PathVariable Integer hackathonId,
                                 HackathonSubmissionEntity formSubmission,
                                 HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
        if (teamId == null) return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
        Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
        if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
            return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
        }

        HackathonSubmissionEntity submission = hackathonSubmissionRepository
                .findByHackathonIdAndTeamId(hackathonId, teamId)
                .orElse(new HackathonSubmissionEntity());
        submission.setHackathonId(hackathonId);
        submission.setTeamId(teamId);
        submission.setCodeBaseUrl(formSubmission.getCodeBaseUrl());
        submission.setDocumentationUrl(formSubmission.getDocumentationUrl());
        submission.setSubmitedDate(LocalDate.now());
        hackathonSubmissionRepository.save(submission);

        return "redirect:/participant/hackathon/" + hackathonId + "/submission?success=saved";
    }
    
	/*
	 * @GetMapping("participant/hackathon/{hackathonId}/pay") public String
	 * showPaymentForm(@PathVariable Integer hackathonId, Model model, HttpSession
	 * session) { UserEntity user = (UserEntity) session.getAttribute("user"); if
	 * (user == null) return "redirect:/login";
	 * 
	 * Optional<HackathonEntity> opHackathon =
	 * hackathonRepository.findById(hackathonId); if (opHackathon.isEmpty()) return
	 * "redirect:/participant/home";
	 * 
	 * HackathonEntity hackathon = opHackathon.get(); // Check if already paid if
	 * (paymentRepository.findByHackathonIdAndUserIdAndPaymentStatus(hackathonId,
	 * user.getUserId(), "SUCCESS").isPresent()) { return
	 * "redirect:/participant/hackathon/" + hackathonId + "?error=alreadyPaid"; }
	 * model.addAttribute("hackathon", hackathon); return
	 * "participant/ParticipantPayment"; }
	 */
    @GetMapping("participant/hackathon/{hackathonId}/pay")
    public String showPaymentForm(@PathVariable Integer hackathonId,
                                  @RequestParam(required = false) Integer inviteId,
                                  Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";

        HackathonEntity hackathon = opHackathon.get();
        if (paymentRepository.findByHackathonIdAndUserIdAndPaymentStatus(hackathonId, user.getUserId(), "SUCCESS").isPresent()) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=alreadyPaid";
        }
        model.addAttribute("hackathon", hackathon);
        model.addAttribute("inviteId", inviteId);  // pass to JSP
        return "participant/ParticipantPayment";
    }

	/*
	 * @PostMapping("participant/hackathon/{hackathonId}/pay/process")
	 * 
	 * @Transactional public String processPayment(@PathVariable Integer
	 * hackathonId,
	 * 
	 * @RequestParam String cardNumber,
	 * 
	 * @RequestParam String expMonth,
	 * 
	 * @RequestParam String expYear,
	 * 
	 * @RequestParam String cvv, HttpSession session) { UserEntity user =
	 * (UserEntity) session.getAttribute("user"); if (user == null) return
	 * "redirect:/login";
	 * 
	 * Optional<HackathonEntity> opHackathon =
	 * hackathonRepository.findById(hackathonId); if (opHackathon.isEmpty()) return
	 * "redirect:/participant/home";
	 * 
	 * HackathonEntity hackathon = opHackathon.get();
	 * 
	 * // Check registration period LocalDate today = LocalDate.now(); if
	 * (hackathon.getRegistrationStartDate() != null &&
	 * hackathon.getRegistrationEndDate() != null &&
	 * (today.isBefore(hackathon.getRegistrationStartDate()) ||
	 * today.isAfter(hackathon.getRegistrationEndDate()))) { return
	 * "redirect:/participant/hackathon/" + hackathonId +
	 * "?error=registrationClosed"; }
	 * 
	 * // Check if already paid or registered if
	 * (paymentRepository.findByHackathonIdAndUserIdAndPaymentStatus(hackathonId,
	 * user.getUserId(), "SUCCESS").isPresent()) { return
	 * "redirect:/participant/hackathon/" + hackathonId + "?error=alreadyPaid"; } if
	 * (hackathonParticipantRepository.existsByHackathonIdAndParticipantId(
	 * hackathonId, user.getUserId())) { return "redirect:/participant/hackathon/" +
	 * hackathonId + "?error=alreadyRegistered"; }
	 * 
	 * // Process payment String expiredDate = expMonth + expYear; // Ensure format
	 * is MMYY (Authorize.net expects 2-digit year) // Convert year to last two
	 * digits if needed if (expYear.length() > 2) { expiredDate = expMonth +
	 * expYear.substring(expYear.length() - 2); } Double amount =
	 * hackathon.getRegistrationFee(); ANetApiResponse response =
	 * paymentService.chargeCreditCard(user.getEmail(), cardNumber, expiredDate,
	 * amount);
	 * 
	 * // Check response if (response != null &&
	 * response.getMessages().getResultCode() == MessageTypeEnum.OK) {
	 * CreateTransactionResponse trResponse = (CreateTransactionResponse) response;
	 * TransactionResponse result = trResponse.getTransactionResponse(); if (result
	 * != null && result.getMessages() != null) { // Save payment record
	 * PaymentEntity payment = new PaymentEntity();
	 * payment.setHackathonId(hackathonId); payment.setUserId(user.getUserId());
	 * payment.setAmount(amount); payment.setGateway("AUTHORIZE.NET");
	 * payment.setPaymentDate(LocalDate.now());
	 * payment.setPaymentGatewayAuthCode(result.getAuthCode());
	 * payment.setPaymentGatewayTransactionId(result.getTransId());
	 * payment.setPaymentMode("CARD"); payment.setPaymentStatus("SUCCESS");
	 * paymentRepository.save(payment);
	 * 
	 * // Register user for hackathon ensureParticipantRegistration(hackathonId,
	 * user.getUserId());
	 * 
	 * return "redirect:/participant/hackathon/" + hackathonId +
	 * "?success=paymentSuccess"; } } // Payment failed return
	 * "redirect:/participant/hackathon/" + hackathonId +
	 * "/pay?error=paymentFailed"; }
	 */
    
    @PostMapping("participant/hackathon/{hackathonId}/pay/process")
    @Transactional
    public String processPayment(@PathVariable Integer hackathonId,
                                 @RequestParam String cardNumber,
                                 @RequestParam String expMonth,
                                 @RequestParam String expYear,
                                 @RequestParam String cvv,
                                 @RequestParam(required = false) Integer inviteId,
                                 HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) return "redirect:/participant/home";
        HackathonEntity hackathon = opHackathon.get();

        // Registration period check
        LocalDate today = LocalDate.now();
        if (hackathon.getRegistrationStartDate() != null && hackathon.getRegistrationEndDate() != null &&
            (today.isBefore(hackathon.getRegistrationStartDate()) || today.isAfter(hackathon.getRegistrationEndDate()))) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=registrationClosed";
        }

        // Already paid?
        if (paymentRepository.findByHackathonIdAndUserIdAndPaymentStatus(hackathonId, user.getUserId(), "SUCCESS").isPresent()) {
            return "redirect:/participant/hackathon/" + hackathonId + "?error=alreadyPaid";
        }

        // Process payment
        String expiredDate = expMonth + (expYear.length() > 2 ? expYear.substring(expYear.length() - 2) : expYear);
        Double amount = hackathon.getRegistrationFee();
        ANetApiResponse response = paymentService.chargeCreditCard(user.getEmail(), cardNumber, expiredDate, amount);

        if (response != null && response.getMessages().getResultCode() == MessageTypeEnum.OK) {
            CreateTransactionResponse trResponse = (CreateTransactionResponse) response;
            TransactionResponse result = trResponse.getTransactionResponse();
            if (result != null && result.getMessages() != null) {
                // Save payment record
                PaymentEntity payment = new PaymentEntity();
                payment.setHackathonId(hackathonId);
                payment.setUserId(user.getUserId());
                payment.setAmount(amount);
                payment.setGateway("AUTHORIZE.NET");
                payment.setPaymentDate(LocalDate.now());
                payment.setPaymentGatewayAuthCode(result.getAuthCode());
                payment.setPaymentGatewayTransactionId(result.getTransId());
                payment.setPaymentMode("CARD");
                payment.setPaymentStatus("SUCCESS");
                paymentRepository.save(payment);

                // Register user for hackathon (if not already)
                ensureParticipantRegistration(hackathonId, user.getUserId());

                // If this payment is for accepting an invitation, auto‑accept the invite
                if (inviteId != null) {
                    Optional<HackathonTeamInviteEntity> opInvite = hackathonTeamInviteRepository.findById(inviteId);
                    if (opInvite.isPresent()) {
                        HackathonTeamInviteEntity invite = opInvite.get();
                        if ("PENDING".equals(invite.getInviteStatus()) &&
                            (invite.getInvitedUserId() != null && invite.getInvitedUserId().equals(user.getUserId()))) {
                            // Add to team
                            if (!hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, user.getUserId())) {
                                long teamSize = hackathonTeamMemberRepository.countByTeamId(invite.getTeamId());
                                Integer maxSize = hackathon.getMaxTeamSize();
                                if (maxSize == null || teamSize < maxSize) {
                                    HackathonTeamMembersEntity member = new HackathonTeamMembersEntity();
                                    member.setTeamId(invite.getTeamId());
                                    member.setHackathonId(hackathonId);
                                    member.setMemberId(user.getUserId());
                                    member.setRoleTitle(invite.getRoleTitle() != null ? invite.getRoleTitle() : "MEMBER");
                                    hackathonTeamMemberRepository.save(member);
                                    invite.setInviteStatus("ACCEPTED");
                                    hackathonTeamInviteRepository.save(invite);
                                }
                            }
                            // After accepting, redirect to Manage Team
                            return "redirect:/participant/hackathon/" + hackathonId + "/team?success=inviteAccepted";
                        }
                    }
                }

                // No inviteId → normal registration
                return "redirect:/participant/hackathon/" + hackathonId + "?success=paymentSuccess";
            }
        }
        // Payment failed
        return "redirect:/participant/hackathon/" + hackathonId + "/pay?error=paymentFailed";
    }
    // ==================== UTILITIES ====================

    private void ensureParticipantRegistration(Integer hackathonId, Integer userId) {
        if (!hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, userId)) {
            HackathonParticipantEntity p = new HackathonParticipantEntity();
            p.setHackathonId(hackathonId);
            p.setParticipantId(userId);
            p.setJoinedDate(LocalDate.now());
            hackathonParticipantRepository.save(p);
        }
    }

    private Integer findTeamIdForUser(Integer hackathonId, Integer userId) {
        Optional<HackathonTeamMembersEntity> member = hackathonTeamMemberRepository
                .findFirstByHackathonIdAndMemberId(hackathonId, userId);
        if (member.isPresent()) return member.get().getTeamId();
        Optional<HackathonTeamEntity> leaderTeam = hackathonTeamRepository
                .findFirstByHackathonIdAndTeamLeaderId(hackathonId, userId);
        return leaderTeam.map(HackathonTeamEntity::getHackathonTeamId).orElse(null);
    }

    private boolean isSubmissionOpen(HackathonEntity hackathon, LocalDate today) {
        if (hackathon == null || hackathon.getRegistrationEndDate() == null) return false;
        return today.isAfter(hackathon.getRegistrationEndDate());
    }

    // ==================== INNER CLASSES ====================

    public static class MyHackathonRow {
        private HackathonEntity hackathon;
        private Integer teamId;
        private String teamName;
        private boolean leader;
        private String roleTitle;
        private int teamSize;
        private int pendingInvites;
        private boolean submissionEnabled;

        // getters & setters
        public HackathonEntity getHackathon() { return hackathon; }
        public void setHackathon(HackathonEntity hackathon) { this.hackathon = hackathon; }
        public Integer getTeamId() { return teamId; }
        public void setTeamId(Integer teamId) { this.teamId = teamId; }
        public String getTeamName() { return teamName; }
        public void setTeamName(String teamName) { this.teamName = teamName; }
        public boolean isLeader() { return leader; }
        public void setLeader(boolean leader) { this.leader = leader; }
        public String getRoleTitle() { return roleTitle; }
        public void setRoleTitle(String roleTitle) { this.roleTitle = roleTitle; }
        public int getTeamSize() { return teamSize; }
        public void setTeamSize(int teamSize) { this.teamSize = teamSize; }
        public int getPendingInvites() { return pendingInvites; }
        public void setPendingInvites(int pendingInvites) { this.pendingInvites = pendingInvites; }
        public boolean isSubmissionEnabled() { return submissionEnabled; }
        public void setSubmissionEnabled(boolean submissionEnabled) { this.submissionEnabled = submissionEnabled; }
    }

    public static class LeaderboardRow {
        private Integer teamId;
        private String teamName;
        private int totalScore;
        private int evaluationCount;
        private double averageScore;
        private int rank;

        // getters & setters
        public Integer getTeamId() { return teamId; }
        public void setTeamId(Integer teamId) { this.teamId = teamId; }
        public String getTeamName() { return teamName; }
        public void setTeamName(String teamName) { this.teamName = teamName; }
        public int getTotalScore() { return totalScore; }
        public void setTotalScore(int totalScore) { this.totalScore = totalScore; }
        public int getEvaluationCount() { return evaluationCount; }
        public void setEvaluationCount(int evaluationCount) { this.evaluationCount = evaluationCount; }
        public double getAverageScore() { return averageScore; }
        public void setAverageScore(double averageScore) { this.averageScore = averageScore; }
        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
    }
    
    public static class PendingInviteDto {
        private HackathonTeamInviteEntity invite;
        private HackathonEntity hackathon;
        private HackathonTeamEntity team;

        // getters & setters
        public HackathonTeamInviteEntity getInvite() { return invite; }
        public void setInvite(HackathonTeamInviteEntity invite) { this.invite = invite; }
        public HackathonEntity getHackathon() { return hackathon; }
        public void setHackathon(HackathonEntity hackathon) { this.hackathon = hackathon; }
        public HackathonTeamEntity getTeam() { return team; }
        public void setTeam(HackathonTeamEntity team) { this.team = team; }
    }
}