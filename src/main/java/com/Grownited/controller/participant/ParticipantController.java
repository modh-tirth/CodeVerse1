package com.Grownited.controller.participant;

import com.Grownited.entity.HackathonDescriptionEntity;
import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonParticipantEntity;
import com.Grownited.entity.HackathonPrizeEntity;
import com.Grownited.entity.HackathonResultEntity;
import com.Grownited.entity.HackathonSubmissionEntity;
import com.Grownited.entity.HackathonTeamEntity;
import com.Grownited.entity.HackathonTeamInviteEntity;
import com.Grownited.entity.HackathonTeamMembersEntity;
import com.Grownited.entity.UserDetailEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.HackathonDescriptionRepository;
import com.Grownited.repository.HackathonParticipantRepository;
import com.Grownited.repository.HackathonPrizeRepository;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.HackathonResultRepository;
import com.Grownited.repository.HackathonSubmissionRepository;
import com.Grownited.repository.HackathonTeamInviteRepository;
import com.Grownited.repository.HackathonTeamMembersRepository;
//import com.Grownited.repository.HackathonTeamMembersRepository;
import com.Grownited.repository.HackathonTeamRepository;
import com.Grownited.repository.UserDetailRepository;
import com.Grownited.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
public class ParticipantController {

	@Autowired
	HackathonRepository hackathonRepository; 

	@Autowired
	HackathonDescriptionRepository hackathonDescriptionRepository;

	@Autowired
	HackathonPrizeRepository hackathonPrizeRepository;

	@Autowired
	HackathonTeamRepository hackathonTeamRepository;

	@Autowired
	HackathonTeamMembersRepository hackathonTeamMemberRepository;

	@Autowired
	HackathonTeamInviteRepository hackathonTeamInviteRepository;

	@Autowired
	UserRepository userRepository;

	@Autowired
	HackathonSubmissionRepository hackathonSubmissionRepository;

	@Autowired
	HackathonResultRepository hackathonResultRepository;

	@Autowired
	HackathonParticipantRepository hackathonParticipantRepository;

	@Autowired
	UserDetailRepository userDetailRepository;

  /*  @Autowired
    private HackathonTeamMembersRepository hackathonTeamMembersRepository;*/

    @GetMapping("/participant/home")
    public String participantDashboard(Model model) {
        List<HackathonEntity> hackathons = hackathonRepository.findAll();
        model.addAttribute("hackathons", hackathons);
        model.addAttribute("today", LocalDate.now());
        return "participant/Home";
    }
    @GetMapping("/participant/hackathon")
     public String showDetails(@RequestParam("hackathon_id")Integer hackathonId, Model model, HttpSession session) {
       Optional<HackathonEntity> hackathonOpt = hackathonRepository.findById(hackathonId);
        if (hackathonOpt.isEmpty()) {
            return "redirect:/participant/participant-dashboard";
        }

        HackathonEntity hackathon = hackathonOpt.get();
        model.addAttribute("hackathon", hackathon);

        // Fetch prizes
        List<HackathonPrizeEntity> prizes = hackathonPrizeRepository.findByHackathonId(hackathonId);
        model.addAttribute("prizes", prizes);

        // Today's date for deadline comparison
        model.addAttribute("today", LocalDate.now());

        // Check if current user is already registered (as leader or member)
        Integer userId = (Integer) session.getAttribute("userId");
     
        
        return "participant/ViewHackathons";
    }
    
    @GetMapping("participant/profile")
	public String profile(@RequestParam(required = false) String success, @RequestParam(required = false) String error,
			Model model, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

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
		if (user == null) {
			return "redirect:/login";
		}

		if (!StringUtils.hasText(firstName) || !StringUtils.hasText(lastName)) {
			return "redirect:/participant/profile?error=invalidName";
		}

		user.setFirstName(firstName.trim());
		user.setLastName(lastName.trim());
		user.setContactNum(StringUtils.hasText(contactNum) ? contactNum.trim() : null);
		user.setGender(StringUtils.hasText(gender) ? gender.trim() : null);
		user.setBirthYear(birthYear);
		user.setQualification(StringUtils.hasText(qualification) ? qualification.trim() : null);
		user.setDesignation(StringUtils.hasText(designation) ? designation.trim() : null);
		user.setOrganization(StringUtils.hasText(organization) ? organization.trim() : null);
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

	
	  @GetMapping("participant/my-hackathons") public String myHackathons(Model
	  model, HttpSession session) { UserEntity user = (UserEntity)
	  session.getAttribute("user"); if (user == null) { return "redirect:/login"; }
	  LocalDate today = LocalDate.now();
	  
	  Map<Integer, MyHackathonRow> rowMap = new LinkedHashMap<>();
	  
	  List<HackathonParticipantEntity> joinedHackathons =
	  hackathonParticipantRepository.findByParticipantId(user.getUserId()); for
	  (HackathonParticipantEntity joined : joinedHackathons) {
	  Optional<HackathonEntity> opHackathon =
	  hackathonRepository.findById(joined.getHackathonId()); if
	  (opHackathon.isPresent()) { MyHackathonRow row = new MyHackathonRow();
	  row.setHackathon(opHackathon.get()); row.setTeamId(null);
	  row.setTeamName("Not Joined Any Team"); row.setLeader(false);
	  row.setRoleTitle("PARTICIPANT"); row.setTeamSize(0);
	  row.setPendingInvites(0);
	  row.setSubmissionEnabled(isSubmissionOpen(opHackathon.get(), today));
	  rowMap.put(opHackathon.get().getHackathonId(), row); } }
	  
	  List<HackathonTeamEntity> leaderTeams =
	  hackathonTeamRepository.findByTeamLeaderId(user.getUserId()); for
	  (HackathonTeamEntity team : leaderTeams) { Optional<HackathonEntity>
	  opHackathon = hackathonRepository.findById(team.getHackathonId()); if
	  (opHackathon.isPresent()) { HackathonEntity h = opHackathon.get();
	  MyHackathonRow row = new MyHackathonRow(); row.setHackathon(h);
	  row.setTeamId(team.getHackathonTeamId());
	  row.setTeamName(team.getTeamName()); row.setLeader(true);
	  row.setRoleTitle("TEAM_LEADER"); row.setTeamSize((int)
	  hackathonTeamMemberRepository.countByTeamId(team.getHackathonTeamId()));
	  row.setPendingInvites((int)
	  hackathonTeamInviteRepository.countByTeamIdAndInviteStatus(team.
	  getHackathonTeamId(), "PENDING"));
	  row.setSubmissionEnabled(isSubmissionOpen(h, today));
	  rowMap.put(h.getHackathonId(), row); } }
	  
	  List<HackathonTeamMembersEntity> memberships =
	  hackathonTeamMemberRepository.findByMemberId(user.getUserId()); for
	  (HackathonTeamMembersEntity member : memberships) { if
	  (rowMap.containsKey(member.getHackathonId())) { continue; }
	  Optional<HackathonEntity> opHackathon =
	  hackathonRepository.findById(member.getHackathonId());
	  Optional<HackathonTeamEntity> opTeam =
	  hackathonTeamRepository.findById(member.getTeamId()); if
	  (opHackathon.isPresent() && opTeam.isPresent()) { MyHackathonRow row = new
	  MyHackathonRow(); row.setHackathon(opHackathon.get());
	  row.setTeamId(opTeam.get().getHackathonTeamId());
	  row.setTeamName(opTeam.get().getTeamName());
	  row.setLeader(user.getUserId().equals(opTeam.get().getTeamLeaderId()));
	  row.setRoleTitle(member.getRoleTitle()); row.setTeamSize((int)
	  hackathonTeamMemberRepository.countByTeamId(opTeam.get().getHackathonTeamId()
	  )); row.setPendingInvites((int)
	  hackathonTeamInviteRepository.countByTeamIdAndInviteStatus(opTeam.get().
	  getHackathonTeamId(), "PENDING"));
	  row.setSubmissionEnabled(isSubmissionOpen(opHackathon.get(), today));
	  rowMap.put(opHackathon.get().getHackathonId(), row); } }
	  
	  model.addAttribute("myHackathons", rowMap.values());
	  model.addAttribute("totalCount", rowMap.size()); return
	  "participant/MyHackathons"; }
	 
	@GetMapping("participant/hackathon/{hackathonId}")
	public String hackathonDetails(@PathVariable Integer hackathonId, @RequestParam(required = false) String joined,
			@RequestParam(required = false) String success, @RequestParam(required = false) String error, Model model,
			HttpSession session) {
		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

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
		model.addAttribute("joined", joined);
		model.addAttribute("success", success);
		model.addAttribute("error", error);
		boolean completed = "COMPLETE".equalsIgnoreCase(hackathon.getStatus())
				|| "COMPLETED".equalsIgnoreCase(hackathon.getStatus());
		model.addAttribute("leaderboardAvailable", completed && Boolean.TRUE.equals(hackathon.getLeaderboardPublished()));
		return "participant/ViewHackathons";
	}

	@GetMapping("participant/hackathon/{hackathonId}/leaderboard")
	public String leaderboard(@PathVariable Integer hackathonId, Model model) {
		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

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
			if (row == null) {
				continue;
			}
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

	@PostMapping("participant/hackathon/{hackathonId}/join")
	@Transactional
	public String joinHackathon(@PathVariable Integer hackathonId, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

		HackathonEntity hackathon = opHackathon.get();
		LocalDate today = LocalDate.now();
		boolean registrationOpen = hackathon.getRegistrationStartDate() != null && hackathon.getRegistrationEndDate() != null
				&& !today.isBefore(hackathon.getRegistrationStartDate()) && !today.isAfter(hackathon.getRegistrationEndDate());
		if (!registrationOpen) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=registrationClosed";
		}

		boolean alreadyRegistered = hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId());
		if (alreadyRegistered) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=alreadyRegistered";
		}

		HackathonParticipantEntity participant = new HackathonParticipantEntity();
		participant.setHackathonId(hackathonId);
		participant.setParticipantId(user.getUserId());
		participant.setJoinedDate(LocalDate.now());
		hackathonParticipantRepository.save(participant);

		return "redirect:/participant/hackathon/" + hackathonId + "?joined=true";
	}

	@GetMapping("participant/hackathon/{hackathonId}/team")
	public String manageTeam(@PathVariable Integer hackathonId, @RequestParam(required = false) String success,
			@RequestParam(required = false) String error, Model model, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

		Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
		boolean joinedHackathon = hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId());
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

		if (hasTeam) {
			Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
			if (opTeam.isEmpty()) {
				return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
			}
			team = opTeam.get();
			isTeamLeader = user.getUserId().equals(team.getTeamLeaderId());

			teamMembers = hackathonTeamMemberRepository.findByTeamIdOrderByHackathonTeamMemberIdAsc(teamId);
			for (HackathonTeamMembersEntity member : teamMembers) {
				Optional<UserEntity> opMember = userRepository.findById(member.getMemberId());
				opMember.ifPresent(userEntity -> memberMap.put(member.getMemberId(), userEntity));
			}
			/*List<HackathonTeamInviteEntity> joinRequests = new ArrayList<>();

			if (isTeamLeader) {
			    joinRequests = hackathonTeamInviteRepository.findByTeamIdAndInviteTypeAndInviteStatus(teamId, "JOIN_REQUEST", "PENDING");
			}
*/
			List<HackathonTeamInviteEntity> joinRequests = hackathonTeamInviteRepository.findByTeamIdAndInviteTypeAndInviteStatus(teamId, "REQUEST", "PENDING");
			model.addAttribute("joinRequests", joinRequests);
			List<Integer> existingMemberIds = teamMembers.stream().map(HackathonTeamMembersEntity::getMemberId)
					.collect(Collectors.toList());
			// ... after teamMembers and existingMemberIds are fetch
			// Get eligible participants using the new query
		/*	List<Integer> eligibleIds = hackathonParticipantRepository
			        .findParticipantIdsNotInAnyTeamAndNoPendingInvite(hackathonId);
			eligibleIds.remove(user.getUserId()); // remove the current user (self)
*/
			List<Integer> eligibleIds = hackathonParticipantRepository
			        .findParticipantIdsNotInAnyTeamAndNoPendingInvite(hackathonId);

			eligibleIds.remove(user.getUserId());

			participantUsers = userRepository.findAllById(eligibleIds)
			        .stream()
			        .filter(u -> "PARTICIPANT".equals(u.getRole()))
			        .filter(u -> u.getActive() != null && u.getActive())
			        .collect(Collectors.toList());

			model.addAttribute("participantUsers", participantUsers);
			
			List<Integer> joinedParticipantIds = hackathonParticipantRepository.findByHackathonId(hackathonId).stream()
					.map(HackathonParticipantEntity::getParticipantId).collect(Collectors.toList());
			participantUsers = userRepository.findAllById(joinedParticipantIds).stream()
					.filter(u -> "PARTICIPANT".equals(u.getRole()))
					.filter(u -> u.getActive() != null && u.getActive())
				//	.filter(u -> !existingMemberIds.contains(u.getUserId()))
					//.filter(u -> !u.getUserId().equals(user.getUserId()))
					.filter(u -> !hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, u.getUserId()))
					.collect(Collectors.toList());
			
		/*	participantUsers = userRepository.findAllById(joinedParticipantIds).stream()
				   .filter(u -> "PARTICIPANT".equals(u.getRole()))
				    .filter(u -> u.getActive() != null && u.getActive())

				    // ❌ Exclude already in THIS team
				   .filter(u -> !existingMemberIds.contains(u.getUserId()))

				    // ❌ Exclude self
				    .filter(u -> !u.getUserId().equals(user.getUserId()))

				    // ❌ Exclude users already in ANY team of this hackathon
				    .filter(u -> !hackathonTeamMemberRepository
				        .existsByHackathonIdAndMemberId(hackathonId, u.getUserId()))

				    // ❌ Exclude users who already have PENDING invite
				    .filter(u -> !hackathonTeamInviteRepository
				        .existsByHackathonIdAndInvitedUserIdAndInviteStatus(
				            hackathonId, u.getUserId(), "PENDING"))

			    .collect(Collectors.toList());*/
			
			if (!participantUsers.isEmpty()) {
			    participantUsers.forEach(u -> System.out.println(" - " + u.getFirstName() + " " + u.getLastName()));
			}

			inviteList = hackathonTeamInviteRepository.findByTeamIdOrderByHackathonTeamInviteIdDesc(teamId);
		} else {
			pendingInvite = hackathonTeamInviteRepository
					.findFirstByHackathonIdAndInvitedUserIdAndInviteStatus(hackathonId, user.getUserId(), "PENDING")
					.orElse(null);
			if (pendingInvite != null && pendingInvite.getTeamId() != null) {
				pendingInviteTeam = hackathonTeamRepository.findById(pendingInvite.getTeamId()).orElse(null);
				
			}
		}

		List<HackathonTeamEntity> availableTeams = hackathonTeamRepository.findByHackathonId(hackathonId);
		availableTeams = availableTeams.stream().filter(t -> {
			long size = hackathonTeamMemberRepository.countByTeamId(t.getHackathonTeamId());
			return opHackathon.get().getMaxTeamSize() == null || size < opHackathon.get().getMaxTeamSize();
		}).collect(Collectors.toList());
		if (hasTeam) {
			Integer myTeamId = teamId;
			availableTeams = availableTeams.stream().filter(t -> !t.getHackathonTeamId().equals(myTeamId)).collect(Collectors.toList());
		}

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
		model.addAttribute("teamSizeCount", teamMembers.size());
		model.addAttribute("teamMaxSize", opHackathon.get().getMaxTeamSize());
		boolean inviteAllowed = opHackathon.get().getRegistrationEndDate() == null
				|| !LocalDate.now().isAfter(opHackathon.get().getRegistrationEndDate());
		model.addAttribute("inviteAllowed", inviteAllowed);
		model.addAttribute("success", success);
		model.addAttribute("error", error);
		return "participant/ManageTeam";
	}

	@PostMapping("participant/hackathon/{hackathonId}/team/create")
	@Transactional
	public String createTeam(@PathVariable Integer hackathonId, @RequestParam String teamName, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		if (!hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId())) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
		}

		Integer existingTeamId = findTeamIdForUser(hackathonId, user.getUserId());
		if (existingTeamId != null) {
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

		HackathonTeamMembersEntity leaderMember = new HackathonTeamMembersEntity();
		leaderMember.setTeamId(team.getHackathonTeamId());
		leaderMember.setHackathonId(hackathonId);
		leaderMember.setMemberId(user.getUserId());
		leaderMember.setRoleTitle("TEAM_LEADER");
		hackathonTeamMemberRepository.save(leaderMember);

		return "redirect:/participant/hackathon/" + hackathonId + "/team?success=teamCreated";
	}

	@PostMapping("participant/hackathon/{hackathonId}/team/join-existing")
	@Transactional
	public String joinExistingTeam(@PathVariable Integer hackathonId, @RequestParam Integer joinTeamId, HttpSession session) {
	    UserEntity user = (UserEntity) session.getAttribute("user");
	    if (user == null) {
	        return "redirect:/login";
	    }

	    if (!hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, user.getUserId())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
	    }

	    Integer existingTeamId = findTeamIdForUser(hackathonId, user.getUserId());
	    if (existingTeamId != null) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
	    }

	    Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(joinTeamId);
	    if (opTeam.isEmpty() || !hackathonId.equals(opTeam.get().getHackathonId())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidTeam";
	    }

	    Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
	    if (opHackathon.isEmpty()) {
	        return "redirect:/participant/home";
	    }
	    if (opHackathon.get().getRegistrationEndDate() != null
	            && LocalDate.now().isAfter(opHackathon.get().getRegistrationEndDate())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteClosed";
	    }

	    long teamSize = hackathonTeamMemberRepository.countByTeamId(joinTeamId);
	    Integer maxSize = opHackathon.get().getMaxTeamSize();
	    if (maxSize != null && teamSize >= maxSize) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=teamFull";
	    }

	    // Check if a pending request already exists for this user and team
	    boolean pendingExists = hackathonTeamInviteRepository.existsByTeamIdAndInvitedUserIdAndInviteStatus(joinTeamId, user.getUserId(), "PENDING");
	    if (pendingExists) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteExists";
	    }

	    // Create a join request (invite of type REQUEST)
	    HackathonTeamInviteEntity request = new HackathonTeamInviteEntity();
	    request.setTeamId(joinTeamId);
	    request.setHackathonId(hackathonId);
	    request.setInvitedBy(user.getUserId());  // the user who requests to join
	    request.setInviteType("REQUEST");
	    request.setInvitedUserId(user.getUserId());
	    request.setInvitedEmail(user.getEmail());
	    request.setRoleTitle("MEMBER");
	    request.setInviteStatus("PENDING");
	    request.setCreatedAt(LocalDate.now());
	    hackathonTeamInviteRepository.save(request);

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=joinRequestSent";
	}
	@PostMapping("participant/hackathon/{hackathonId}/team/request/{inviteId}/accept")
	@Transactional
	public String acceptJoinRequest(@PathVariable Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
	    UserEntity user = (UserEntity) session.getAttribute("user");
	    if (user == null) {
	        return "redirect:/login";
	    }

	    Optional<HackathonTeamInviteEntity> opInvite = hackathonTeamInviteRepository.findById(inviteId);
	    if (opInvite.isEmpty()) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteNotFound";
	    }

	    HackathonTeamInviteEntity invite = opInvite.get();
	    if (!"PENDING".equals(invite.getInviteStatus()) || !"REQUEST".equals(invite.getInviteType())
	            || !invite.getHackathonId().equals(hackathonId)) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteInvalid";
	    }

	    // Verify that the current user is the team leader of the team
	    Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(invite.getTeamId());
	    if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
	    }

	    // Check if the invited user is already in a team
	    if (hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, invite.getInvitedUserId())) {
	        invite.setInviteStatus("REJECTED"); // or mark as already in team
	        hackathonTeamInviteRepository.save(invite);
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
	    }

	    // Check team capacity
	    long teamSize = hackathonTeamMemberRepository.countByTeamId(invite.getTeamId());
	    Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
	    if (opHackathon.isPresent() && opHackathon.get().getMaxTeamSize() != null
	            && teamSize >= opHackathon.get().getMaxTeamSize()) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=teamFull";
	    }

	    // Add member to team
	    HackathonTeamMembersEntity member = new HackathonTeamMembersEntity();
	    member.setTeamId(invite.getTeamId());
	    member.setHackathonId(hackathonId);
	    member.setMemberId(invite.getInvitedUserId());
	    member.setRoleTitle(invite.getRoleTitle());
	    hackathonTeamMemberRepository.save(member);

	    // Update invite status
	    invite.setInviteStatus("ACCEPTED");
	    hackathonTeamInviteRepository.save(invite);

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestAccepted";
	}

	@PostMapping("participant/hackathon/{hackathonId}/team/request/{inviteId}/reject")
	@Transactional
	public String rejectJoinRequest(@PathVariable Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
	    UserEntity user = (UserEntity) session.getAttribute("user");
	    if (user == null) {
	        return "redirect:/login";
	    }

	    Optional<HackathonTeamInviteEntity> opInvite = hackathonTeamInviteRepository.findById(inviteId);
	    if (opInvite.isEmpty()) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteNotFound";
	    }

	    HackathonTeamInviteEntity invite = opInvite.get();
	    if (!"PENDING".equals(invite.getInviteStatus()) || !"REQUEST".equals(invite.getInviteType())
	            || !invite.getHackathonId().equals(hackathonId)) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteInvalid";
	    }

	    // Verify leader
	    Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(invite.getTeamId());
	    if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
	    }

	    invite.setInviteStatus("REJECTED");
	    hackathonTeamInviteRepository.save(invite);

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestRejected";
	}
	@PostMapping("participant/hackathon/{hackathonId}/team/invite-member")
	@Transactional
	public String inviteRegisteredMember(@PathVariable Integer hackathonId, @RequestParam Integer invitedUserId, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}
		if (opHackathon.get().getRegistrationEndDate() != null
				&& LocalDate.now().isAfter(opHackathon.get().getRegistrationEndDate())) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteClosed";
		}

		Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
		if (teamId == null) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
		}
		Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
		if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
		}

		long teamSize = hackathonTeamMemberRepository.countByTeamId(teamId);
		if (opHackathon.get().getMaxTeamSize() != null && teamSize >= opHackathon.get().getMaxTeamSize()) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=teamFull";
		}

		Optional<UserEntity> opInvited = userRepository.findById(invitedUserId);
		if (opInvited.isEmpty() || !"PARTICIPANT".equals(opInvited.get().getRole())) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidUser";
		}

		boolean alreadyInHackathon = hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, invitedUserId);
		if (alreadyInHackathon) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=alreadyInHackathon";
		}

		boolean pendingInviteExists = hackathonTeamInviteRepository.existsByHackathonIdAndInvitedUserIdAndInviteStatus(hackathonId,
				invitedUserId, "PENDING");
		if (pendingInviteExists) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteExists";
		}

		HackathonTeamInviteEntity internalInvite = new HackathonTeamInviteEntity();
		internalInvite.setTeamId(teamId);
		internalInvite.setHackathonId(hackathonId);
		internalInvite.setInvitedBy(user.getUserId());
		internalInvite.setInviteType("INTERNAL");
		internalInvite.setInvitedUserId(invitedUserId);
		internalInvite.setInvitedEmail(opInvited.get().getEmail());
		internalInvite.setRoleTitle("MEMBER");
		internalInvite.setInviteStatus("PENDING");
		internalInvite.setCreatedAt(LocalDate.now());
		hackathonTeamInviteRepository.save(internalInvite);

		return "redirect:/participant/hackathon/" + hackathonId + "/team?success=memberInvited";
	}

	@PostMapping("participant/hackathon/{hackathonId}/team/invite-external")
	@Transactional
	public String inviteExternalMember(@PathVariable Integer hackathonId, @RequestParam String externalEmail,
			@RequestParam(required = false) String roleTitle, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

		Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
		if (teamId == null) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
		}
		Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
		if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
		}

		if (!StringUtils.hasText(externalEmail) || !externalEmail.contains("@")) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidEmail";
		}

		boolean duplicatePending = hackathonTeamInviteRepository.existsByTeamIdAndInvitedEmailAndInviteStatus(teamId,
				externalEmail.trim(), "PENDING");
		if (duplicatePending) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteExists";
		}

		HackathonTeamInviteEntity externalInvite = new HackathonTeamInviteEntity();
		externalInvite.setTeamId(teamId);
		externalInvite.setHackathonId(hackathonId);
		externalInvite.setInvitedBy(user.getUserId());
		externalInvite.setInviteType("EXTERNAL");
		externalInvite.setInvitedEmail(externalEmail.trim());
		externalInvite.setRoleTitle(StringUtils.hasText(roleTitle) ? roleTitle.trim() : "MEMBER");
		externalInvite.setInviteStatus("PENDING");
		externalInvite.setCreatedAt(LocalDate.now());
		hackathonTeamInviteRepository.save(externalInvite);

		return "redirect:/participant/hackathon/" + hackathonId + "/team?success=externalInvited";
	}

	@PostMapping("participant/hackathon/{hackathonId}/team/remove-member")
	@Transactional
	public String removeMember(@PathVariable Integer hackathonId, @RequestParam Integer memberId, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
		if (teamId == null) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
		}

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
	@PostMapping("/participant/hackathon/{hackathonId}/team/request/{requestId}/accept")
	@Transactional
	public String acceptJoinRequest(@PathVariable Integer hackathonId,
	                               @PathVariable Integer requestId) {

	    HackathonTeamInviteEntity request = hackathonTeamInviteRepository.findById(requestId).orElse(null);

	    if (request == null || !"JOIN_REQUEST".equals(request.getInviteType())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=invalidRequest";
	    }

	    // Add member
	    HackathonTeamMembersEntity member = new HackathonTeamMembersEntity();
	    member.setTeamId(request.getTeamId());
	    member.setHackathonId(hackathonId);
	    member.setMemberId(request.getInvitedUserId());
	    member.setRoleTitle("MEMBER");

	    hackathonTeamMemberRepository.save(member);

	    request.setInviteStatus("ACCEPTED");
	    hackathonTeamInviteRepository.save(request);

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestAccepted";
	}
	@PostMapping("/participant/hackathon/{hackathonId}/team/request/{requestId}/reject")
	@Transactional
	public String rejectJoinRequest(@PathVariable Integer hackathonId,
	                               @PathVariable Integer requestId) {

	    HackathonTeamInviteEntity request = hackathonTeamInviteRepository.findById(requestId).orElse(null);

	    if (request != null) {
	        request.setInviteStatus("REJECTED");
	        hackathonTeamInviteRepository.save(request);
	    }

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=requestRejected";
	}
	/*
	 * @PostMapping(
	 * "participant/hackathon/{hackathonId}/team/invite/{inviteId}/accept")
	 * 
	 * @Transactional public String acceptInvitationFromTeamPage(@PathVariable
	 * Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
	 * return handleInvitationResponse(hackathonId, inviteId, session, true, true);
	 * }
	 */
	@PostMapping("/participant/hackathon/{hackathonId}/team/invite/{inviteId}/accept")
	@Transactional
	public String acceptInvite(@PathVariable Integer hackathonId,
	                           @PathVariable Integer inviteId,
	                           HttpSession session) {

	    UserEntity user = (UserEntity) session.getAttribute("user");

	    HackathonTeamInviteEntity invite = hackathonTeamInviteRepository.findById(inviteId).orElse(null);

	    if (invite == null || !"PENDING".equals(invite.getInviteStatus())) {
	        return "redirect:/participant/hackathon/" + hackathonId + "/team?error=inviteInvalid";
	    }

	    // Add member to team
	    HackathonTeamMembersEntity member = new HackathonTeamMembersEntity();
	    member.setTeamId(invite.getTeamId());
	    member.setHackathonId(hackathonId);
	    member.setMemberId(user.getUserId());
	    member.setRoleTitle("MEMBER");

	    hackathonTeamMemberRepository.save(member);

	    // Update invite status
	    invite.setInviteStatus("ACCEPTED");
	    hackathonTeamInviteRepository.save(invite);

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=inviteAccepted";
	}

	/*
	 * @PostMapping(
	 * "participant/hackathon/{hackathonId}/team/invite/{inviteId}/reject")
	 * 
	 * @Transactional public String rejectInvitationFromTeamPage(@PathVariable
	 * Integer hackathonId, @PathVariable Integer inviteId, HttpSession session) {
	 * return handleInvitationResponse(hackathonId, inviteId, session, false, true);
	 * }
	 */
	@PostMapping("/participant/hackathon/{hackathonId}/team/invite/{inviteId}/reject")
	@Transactional
	public String rejectInvite(@PathVariable Integer hackathonId,
	                           @PathVariable Integer inviteId) {

	    HackathonTeamInviteEntity invite = hackathonTeamInviteRepository.findById(inviteId).orElse(null);

	    if (invite != null) {
	        invite.setInviteStatus("REJECTED");
	        hackathonTeamInviteRepository.save(invite);
	    }

	    return "redirect:/participant/hackathon/" + hackathonId + "/team?success=inviteRejected";
	}
	private String handleInvitationResponse(Integer hackathonId, Integer inviteId, HttpSession session, boolean accept,
			boolean redirectToTeamPage) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		String basePath = "redirect:/participant/hackathon/" + hackathonId;
		if (redirectToTeamPage) {
			basePath += "/team";
		}

		Optional<HackathonTeamInviteEntity> opInvite = hackathonTeamInviteRepository.findById(inviteId);
		if (opInvite.isEmpty()) {
			return basePath + "?error=inviteNotFound";
		}

		HackathonTeamInviteEntity invite = opInvite.get();
		if (!"PENDING".equals(invite.getInviteStatus()) || invite.getHackathonId() == null
				|| !invite.getHackathonId().equals(hackathonId) || invite.getInvitedUserId() == null
				|| !invite.getInvitedUserId().equals(user.getUserId())) {
			return basePath + "?error=inviteInvalid";
		}

		if (!accept) {
			invite.setInviteStatus("REJECTED");
			hackathonTeamInviteRepository.save(invite);
			return basePath + "?success=inviteRejected";
		}

		boolean alreadyInHackathon = hackathonTeamMemberRepository.existsByHackathonIdAndMemberId(hackathonId, user.getUserId());
		if (alreadyInHackathon) {
			invite.setInviteStatus("REJECTED");
			hackathonTeamInviteRepository.save(invite);
			return basePath + "?error=alreadyInHackathon";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}
		ensureParticipantRegistration(hackathonId, user.getUserId());

		long teamSize = hackathonTeamMemberRepository.countByTeamId(invite.getTeamId());
		Integer maxSize = opHackathon.get().getMaxTeamSize();
		if (maxSize != null && teamSize >= maxSize) {
			return basePath + "?error=teamFull";
		}

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

	@GetMapping("participant/hackathon/{hackathonId}/submission")
	public String openSubmission(@PathVariable Integer hackathonId, @RequestParam(required = false) String success,
			@RequestParam(required = false) String error, Model model, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

		Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
		if (teamId == null) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
		}
		Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
		if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
		}

		HackathonSubmissionEntity submission = hackathonSubmissionRepository.findByHackathonIdAndTeamId(hackathonId, teamId)
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
	public String saveSubmission(@PathVariable Integer hackathonId, HackathonSubmissionEntity formSubmission, HttpSession session) {
		UserEntity user = (UserEntity) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		Integer teamId = findTeamIdForUser(hackathonId, user.getUserId());
		if (teamId == null) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=notRegistered";
		}
		Optional<HackathonTeamEntity> opTeam = hackathonTeamRepository.findById(teamId);
		if (opTeam.isEmpty() || !user.getUserId().equals(opTeam.get().getTeamLeaderId())) {
			return "redirect:/participant/hackathon/" + hackathonId + "/team?error=notLeader";
		}

		HackathonSubmissionEntity submission = hackathonSubmissionRepository.findByHackathonIdAndTeamId(hackathonId, teamId)
				.orElse(new HackathonSubmissionEntity());

		submission.setHackathonId(hackathonId);
		submission.setTeamId(teamId);
		submission.setCodeBaseUrl(formSubmission.getCodeBaseUrl());
		submission.setDocumentationUrl(formSubmission.getDocumentationUrl());
		submission.setSubmitedDate(LocalDate.now());
		hackathonSubmissionRepository.save(submission);

		return "redirect:/participant/hackathon/" + hackathonId + "/submission?success=saved";
	}

	private void ensureParticipantRegistration(Integer hackathonId, Integer userId) {
		boolean exists = hackathonParticipantRepository.existsByHackathonIdAndParticipantId(hackathonId, userId);
		if (exists) {
			return;
		}
		HackathonParticipantEntity participant = new HackathonParticipantEntity();
		participant.setHackathonId(hackathonId);
		participant.setParticipantId(userId);
		participant.setJoinedDate(LocalDate.now());
		hackathonParticipantRepository.save(participant);
	}

	private Integer findTeamIdForUser(Integer hackathonId, Integer userId) {
		Optional<HackathonTeamMembersEntity> memberRow = hackathonTeamMemberRepository.findFirstByHackathonIdAndMemberId(hackathonId,
				userId);
		if (memberRow.isPresent()) {
			return memberRow.get().getTeamId();
		}
		Optional<HackathonTeamEntity> leaderTeam = hackathonTeamRepository.findFirstByHackathonIdAndTeamLeaderId(hackathonId, userId);
		return leaderTeam.map(HackathonTeamEntity::getHackathonTeamId).orElse(null);
	}

	private boolean isSubmissionOpen(HackathonEntity hackathon, LocalDate today) {
		if (hackathon == null || hackathon.getRegistrationEndDate() == null) {
			return false;
		}
		return today.isAfter(hackathon.getRegistrationEndDate());
	}
	
	public static class MyHackathonRow {
		private HackathonEntity hackathon;
		private Integer teamId;
		private String teamName;
		private boolean leader;
		private String roleTitle;
		private int teamSize;
		private int pendingInvites;
		private boolean submissionEnabled;

		public HackathonEntity getHackathon() {
			return hackathon;
		}

		public void setHackathon(HackathonEntity hackathon) {
			this.hackathon = hackathon;
		}

		public Integer getTeamId() {
			return teamId;
		}

		public void setTeamId(Integer teamId) {
			this.teamId = teamId;
		}

		public String getTeamName() {
			return teamName;
		}

		public void setTeamName(String teamName) {
			this.teamName = teamName;
		}

		public boolean isLeader() {
			return leader;
		}

		public void setLeader(boolean leader) {
			this.leader = leader;
		}

		public String getRoleTitle() {
			return roleTitle;
		}

		public void setRoleTitle(String roleTitle) {
			this.roleTitle = roleTitle;
		}

		public int getTeamSize() {
			return teamSize;
		}

		public void setTeamSize(int teamSize) {
			this.teamSize = teamSize;
		}

		public int getPendingInvites() {
			return pendingInvites;
		}

		public void setPendingInvites(int pendingInvites) {
			this.pendingInvites = pendingInvites;
		}

		public boolean isSubmissionEnabled() {
			return submissionEnabled;
		}

		public void setSubmissionEnabled(boolean submissionEnabled) {
			this.submissionEnabled = submissionEnabled;
		}
	}

	public static class LeaderboardRow {
		private Integer teamId;
		private String teamName;
		private int totalScore;
		private int evaluationCount;
		private double averageScore;
		private int rank;

		public Integer getTeamId() {
			return teamId;
		}

		public void setTeamId(Integer teamId) {
			this.teamId = teamId;
		}

		public String getTeamName() {
			return teamName;
		}

		public void setTeamName(String teamName) {
			this.teamName = teamName;
		}

		public int getTotalScore() {
			return totalScore;
		}

		public void setTotalScore(int totalScore) {
			this.totalScore = totalScore;
		}

		public int getEvaluationCount() {
			return evaluationCount;
		}

		public void setEvaluationCount(int evaluationCount) {
			this.evaluationCount = evaluationCount;
		}

		public double getAverageScore() {
			return averageScore;
		}

		public void setAverageScore(double averageScore) {
			this.averageScore = averageScore;
		}

		public int getRank() {
			return rank;
		}

		public void setRank(int rank) {
			this.rank = rank;
		}
	}
	
	
}