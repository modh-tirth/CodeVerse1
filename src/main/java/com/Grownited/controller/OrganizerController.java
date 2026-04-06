package com.Grownited.controller;

import com.Grownited.entity.*;
import com.Grownited.repository.*;
import com.Grownited.service.HackathonService;
import com.cloudinary.Cloudinary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Pageable;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/organizer")
public class OrganizerController {

    @Autowired private HackathonRepository hackathonRepository;
    @Autowired private UserTypeRepository userTypeRepository;
    @Autowired private Cloudinary cloudinary;
    @Autowired private HackathonDescriptionRepository hackathonDescriptionRepository;
    @Autowired private HackathonPrizeRepository hackathonPrizeRepository;
    @Autowired private HackathonJudgeRepository hackathonJudgeRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private HackathonService hackathonService;

    // Dashboard – list only hackathons created by this organizer
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        List<HackathonEntity> myHackathons = hackathonRepository.findByUserId(user.getUserId());
        model.addAttribute("hackathons", myHackathons);
        return "organizer/OrganizerDashboard";
    }

    // Show create form
    @GetMapping("/create-hackathon")
    public String createForm(Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        model.addAttribute("allUserType", userTypeRepository.findAll());
        return "organizer/create-hackathons";
    }

    // Save hackathon
    @PostMapping("/save-hackathon")
    public String saveHackathon(HackathonEntity hackathonEntity, HttpSession session,
                                @RequestParam(required = false) String hackathonDetails,
                                @RequestParam(required = false) String prizeTitle1,
                                @RequestParam(required = false) String prizeDescription1,
                                @RequestParam(required = false) String prizeTitle2,
                                @RequestParam(required = false) String prizeDescription2,
                                @RequestParam(required = false) String prizeTitle3,
                                @RequestParam(required = false) String prizeDescription3,
                                @RequestParam("userTypeId") Integer userTypeId,
                                @RequestParam(required = false) Double registrationFee,
                                MultipartFile hackathonPoster) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        hackathonEntity.setUserId(user.getUserId());
        if (hackathonEntity.getLeaderboardPublished() == null) hackathonEntity.setLeaderboardPublished(false);
        if ("COMPLETED".equalsIgnoreCase(hackathonEntity.getStatus())) hackathonEntity.setLeaderboardPublished(true);

        if (hackathonPoster != null && !hackathonPoster.isEmpty()) {
            try {
                Map map = cloudinary.uploader().upload(hackathonPoster.getBytes(), null);
                hackathonEntity.setHackathonPosterURL(map.get("secure_url").toString());
            } catch (IOException e) { e.printStackTrace(); }
        }

        if (userTypeId != null) {
            userTypeRepository.findById(userTypeId).ifPresent(ut -> hackathonEntity.setUserType(ut.getUserType()));
        }
        hackathonEntity.setRegistrationFee(registrationFee);
        hackathonService.updateHackathonStatus(hackathonEntity);
        hackathonRepository.save(hackathonEntity);

        Integer hackathonId = hackathonEntity.getHackathonId();
        saveDescription(hackathonId, hackathonDetails);
        savePrize(hackathonId, null, prizeTitle1, prizeDescription1);
        savePrize(hackathonId, null, prizeTitle2, prizeDescription2);
        savePrize(hackathonId, null, prizeTitle3, prizeDescription3);

        return "redirect:/organizer/hackathons";
    }

    // List my hackathons
    @GetMapping({"/hackathons","/listHackathon"})
    public String myHackathons(  @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String payment,
            @RequestParam(required = false) String eventType,HttpSession session, Model model) {
    	 UserEntity user = (UserEntity) session.getAttribute("user");
    	    if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";
    	    int pageSize = 10;
    	    Pageable pageable = PageRequest.of(page - 1, pageSize);


    	    // Use a custom repository method that filters by userId AND other criteria
    	    Page<HackathonEntity> hackathonPage = hackathonRepository.findByUserIdAndFilters(
    	            user.getUserId(), search, status, payment, eventType, pageable);

    	    model.addAttribute("allHackathons", hackathonPage.getContent());
    	    model.addAttribute("currentPage", page);
    	    model.addAttribute("totalPages", hackathonPage.getTotalPages());
    	    model.addAttribute("searchValue", search);
    	    model.addAttribute("statusValue", status);
    	    model.addAttribute("paymentValue", payment);
    	    model.addAttribute("eventTypeValue", eventType);
			/*
			 * UserEntity user = (UserEntity) session.getAttribute("user"); if (user == null
			 * || !"organizer".equals(user.getRole())) return "redirect:/login";
			 * 
			 * List<HackathonEntity> hackathons =
			 * hackathonRepository.findByUserId(user.getUserId());
			 * model.addAttribute("allHackathons", hackathons); // ← change attribute name
			 * model.addAttribute("currentPage", 1); // add default pagination values
			 * model.addAttribute("totalPages", 1);
			 */
        return "organizer/ListHackathon";
    }

    // Edit form
    @GetMapping("/edit-hackathon")
    public String editForm(@RequestParam Integer hackathonId, HttpSession session, Model model) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        Optional<HackathonEntity> op = hackathonRepository.findById(hackathonId);
        if (op.isEmpty() || !op.get().getUserId().equals(user.getUserId())) return "redirect:/organizer/hackathons";

        model.addAttribute("hackathon", op.get());
        model.addAttribute("allUserType", userTypeRepository.findAll());
        model.addAttribute("hackathonDescription", hackathonDescriptionRepository.findFirstByHackathonId(hackathonId).orElse(null));
        model.addAttribute("prize1", getPrize(hackathonId, 0));
        model.addAttribute("prize2", getPrize(hackathonId, 1));
        model.addAttribute("prize3", getPrize(hackathonId, 2));
        return "organizer/EditHackathon";
    }

    // Update hackathon
    @PostMapping("/update-hackathon")
    public String updateHackathon(HackathonEntity hackathonEntity, HttpSession session,
                                  @RequestParam(required = false) String hackathonDetails,
                                  @RequestParam(required = false) Integer prizeId1, @RequestParam(required = false) String prizeTitle1, @RequestParam(required = false) String prizeDescription1,
                                  @RequestParam(required = false) Integer prizeId2, @RequestParam(required = false) String prizeTitle2, @RequestParam(required = false) String prizeDescription2,
                                  @RequestParam(required = false) Integer prizeId3, @RequestParam(required = false) String prizeTitle3, @RequestParam(required = false) String prizeDescription3,
                                  @RequestParam("userTypeId") Integer userTypeId,
                                  MultipartFile hackathonPoster) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        Optional<HackathonEntity> existing = hackathonRepository.findById(hackathonEntity.getHackathonId());
        if (existing.isEmpty() || !existing.get().getUserId().equals(user.getUserId())) return "redirect:/organizer/hackathons";

        if (hackathonPoster != null && !hackathonPoster.isEmpty()) {
            try {
                Map map = cloudinary.uploader().upload(hackathonPoster.getBytes(), null);
                hackathonEntity.setHackathonPosterURL(map.get("secure_url").toString());
            } catch (IOException e) { e.printStackTrace(); }
        } else {
            hackathonEntity.setHackathonPosterURL(existing.get().getHackathonPosterURL());
        }

        if (userTypeId != null) {
            userTypeRepository.findById(userTypeId).ifPresent(ut -> hackathonEntity.setUserType(ut.getUserType()));
        }
        hackathonEntity.setUserId(user.getUserId()); // keep original owner
        hackathonService.updateHackathonStatus(hackathonEntity);
        hackathonRepository.save(hackathonEntity);

        saveDescription(hackathonEntity.getHackathonId(), hackathonDetails);
        savePrize(hackathonEntity.getHackathonId(), prizeId1, prizeTitle1, prizeDescription1);
        savePrize(hackathonEntity.getHackathonId(), prizeId2, prizeTitle2, prizeDescription2);
        savePrize(hackathonEntity.getHackathonId(), prizeId3, prizeTitle3, prizeDescription3);

        return "redirect:/organizer/hackathons";
    }

    // Delete hackathon
    @GetMapping("/delete-hackathon")
    public String deleteHackathon(@RequestParam Integer hackathonId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        Optional<HackathonEntity> op = hackathonRepository.findById(hackathonId);
        if (op.isPresent() && op.get().getUserId().equals(user.getUserId())) {
            hackathonRepository.deleteById(hackathonId);
        }
        return "redirect:/organizer/hackathons";
    }

    // Manage judges
    @GetMapping("/manage-judges")
    public String manageJudges(@RequestParam Integer hackathonId, HttpSession session, Model model) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        Optional<HackathonEntity> op = hackathonRepository.findById(hackathonId);
        if (op.isEmpty() || !op.get().getUserId().equals(user.getUserId())) return "redirect:/organizer/hackathons";

        List<HackathonJudgeEntity> assigned = hackathonJudgeRepository.findByHackathonId(hackathonId);
        List<UserEntity> availableJudges = userRepository.findByRole("judge");
        availableJudges.removeIf(j -> assigned.stream().anyMatch(a -> a.getUserId().equals(j.getUserId())));

        model.addAttribute("hackathon", op.get());
        model.addAttribute("assignedJudges", assigned);
        model.addAttribute("availableJudges", availableJudges);
        return "organizer/ManageHackathonJudge";
    }

    @PostMapping("/assign-judge")
    public String assignJudge(@RequestParam Integer hackathonId, @RequestParam Integer userId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        Optional<HackathonEntity> op = hackathonRepository.findById(hackathonId);
        if (op.isEmpty() || !op.get().getUserId().equals(user.getUserId())) return "redirect:/organizer/hackathons";

        if (!hackathonJudgeRepository.existsByHackathonIdAndUserId(hackathonId, userId)) {
            HackathonJudgeEntity judge = new HackathonJudgeEntity();
            judge.setHackathonId(hackathonId);
            judge.setUserId(userId);
            hackathonJudgeRepository.save(judge);
        }
        return "redirect:/organizer/manage-judges?hackathonId=" + hackathonId;
    }

    @GetMapping("/remove-judge")
    public String removeJudge(@RequestParam Integer hackathonJudgeId, @RequestParam Integer hackathonId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null || !"organizer".equals(user.getRole())) return "redirect:/login";

        Optional<HackathonJudgeEntity> op = hackathonJudgeRepository.findById(hackathonJudgeId);
        if (op.isPresent()) {
            Optional<HackathonEntity> hack = hackathonRepository.findById(op.get().getHackathonId());
            if (hack.isPresent() && hack.get().getUserId().equals(user.getUserId())) {
                hackathonJudgeRepository.deleteById(hackathonJudgeId);
            }
        }
        return "redirect:/organizer/manage-judges?hackathonId=" + hackathonId;
    }

    // Helper methods (unchanged)
    private void saveDescription(Integer hackathonId, String details) {
        if (details == null || details.trim().isEmpty()) return;
        HackathonDescriptionEntity desc = hackathonDescriptionRepository.findFirstByHackathonId(hackathonId)
                .orElse(new HackathonDescriptionEntity());
        desc.setHackathonId(hackathonId);
        desc.setHackathonDetails(details);
        hackathonDescriptionRepository.save(desc);
    }

    private void savePrize(Integer hackathonId, Integer prizeId, String title, String description) {
        if ((title == null || title.trim().isEmpty()) && (description == null || description.trim().isEmpty())) {
            if (prizeId != null) hackathonPrizeRepository.deleteById(prizeId);
            return;
        }
        HackathonPrizeEntity prize = (prizeId != null) ? hackathonPrizeRepository.findById(prizeId).orElse(new HackathonPrizeEntity()) : new HackathonPrizeEntity();
        prize.setHackathonId(hackathonId);
        prize.setPrizeTitle(title);
        prize.setPrizeDescription(description);
        hackathonPrizeRepository.save(prize);
    }

    private HackathonPrizeEntity getPrize(Integer hackathonId, int index) {
        List<HackathonPrizeEntity> prizes = hackathonPrizeRepository.findByHackathonIdOrderByHackathonPrizeIdAsc(hackathonId);
        return prizes.size() > index ? prizes.get(index) : new HackathonPrizeEntity();
    }
}