package com.Grownited.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Grownited.entity.HackathonDescriptionEntity;
import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonPrizeEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.entity.UserTypeEntity;
import com.Grownited.repository.HackathonDescriptionRepository;
import com.Grownited.repository.HackathonJudgeRepository;
import com.Grownited.repository.HackathonPrizeRepository;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.UserRepository;
import com.Grownited.repository.UserTypeRepository;
import com.Grownited.service.HackathonService;
import com.cloudinary.Cloudinary;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class HackathonController {
	
	  @Autowired
		HackathonRepository hackathonRepository;
	    
	   @Autowired
	    UserTypeRepository userTypeRepository;
	   
	   @Autowired
	   Cloudinary cloudinary;
	   
		
		@Autowired
		HackathonDescriptionRepository hackathonDescriptionRepository;

		@Autowired
		HackathonPrizeRepository hackathonPrizeRepository;

		@Autowired
		HackathonJudgeRepository hackathonJudgeRepository;

		@Autowired
		UserRepository userRepository;
		
		@Autowired
		HackathonService hackathonService;
	
	@GetMapping("/create-hackathon")
	    public String createHackathon(Model model) {

	    	List<UserTypeEntity> allUserType = userTypeRepository.findAll(); 
			//userType -> send Signup->
			model.addAttribute("allUserType",allUserType);
	        return "create-hackathons";
	    }

	  /*  @PostMapping("/save-hackathon")
	    public String saveHackathon(HackathonEntity hackathonEntity,HttpSession session, MultipartFile hackathonPoster) {
		    
		    System.out.println(hackathonEntity.getTitle());
		    UserEntity currentLogInUser = (UserEntity) session.getAttribute("user");
			hackathonEntity.setUserId(currentLogInUser.getUserId());
			try {
    			Map  map = 	cloudinary.uploader().upload(hackathonPoster.getBytes(), null);
    			String hackathonPosterURL = map.get("secure_url").toString();
    			System.out.println(hackathonPosterURL);
    			hackathonEntity.setHackathonPosterURL(hackathonPosterURL);
    			
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
		    hackathonRepository.save(hackathonEntity);
	        return "redirect:/listHackathon";
	    }*/
	    @PostMapping("saveHackathon")
		@Transactional
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
				// @RequestParam(value = "leaderboardPublished", required = false) String leaderboardPublishedParam,
				 MultipartFile hackathonPoster) {
			if (hackathonEntity.getLeaderboardPublished() == null) {
				hackathonEntity.setLeaderboardPublished(false);
			}
			if ("COMPLETED".equalsIgnoreCase(hackathonEntity.getStatus())) {
			    hackathonEntity.setLeaderboardPublished(true);
			}
			UserEntity currentLogInUser = (UserEntity) session.getAttribute("user");
			if (currentLogInUser != null) {
				hackathonEntity.setUserId(currentLogInUser.getUserId());
			}
			try {
    			@SuppressWarnings("unchecked")
    			Map<String, Object>  map = 	cloudinary.uploader().upload(hackathonPoster.getBytes(), null);
    			String hackathonPosterURL = map.get("secure_url").toString();
    			System.out.println(hackathonPosterURL);
    			hackathonEntity.setHackathonPosterURL(hackathonPosterURL);
    			
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
			
			  if (userTypeId != null) {
			        Optional<UserTypeEntity> ut = userTypeRepository.findById(userTypeId);
			        ut.ifPresent(u -> hackathonEntity.setUserType(u.getUserType()));
			    }
			//  hackathonEntity.setLeaderboardPublished("on".equals(leaderboardPublishedParam));
			  hackathonEntity.setRegistrationFee(registrationFee);  
			  hackathonService.updateHackathonStatus(hackathonEntity);
			hackathonRepository.save(hackathonEntity);
			Integer hackathonId = hackathonEntity.getHackathonId();

			saveOrUpdateDescription(hackathonId, hackathonDetails);

			saveOrUpdatePrize(hackathonId, null, prizeTitle1, prizeDescription1);
			saveOrUpdatePrize(hackathonId, null, prizeTitle2, prizeDescription2);
			saveOrUpdatePrize(hackathonId, null, prizeTitle3, prizeDescription3);

			return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
		}

	    @GetMapping("/listHackathon")
	    public String listHackathon(@RequestParam(defaultValue = "1") int page,Model model,@RequestParam(required = false) String search,
	            @RequestParam(required = false) String status,
	            @RequestParam(required = false) String payment,
	            @RequestParam(required = false) String eventType)
	    {
	    	 
	    	/*List<HackathonEntity> allHackathons = hackathonRepository.findAll();
	    	model.addAttribute("allHackathons" , allHackathons);
	    	return "ListHackathon";*/
			/*
			 * int pageSize = 10;
			 * 
			 * Pageable pageable = PageRequest.of(page - 1, pageSize); Page<HackathonEntity>
			 * hackathonPage = hackathonRepository.findAll(pageable);
			 * 
			 * model.addAttribute("allHackathons", hackathonPage.getContent());
			 * model.addAttribute("currentPage", page); model.addAttribute("totalPages",
			 * hackathonPage.getTotalPages());
			 */
	    	 int pageSize = 10;
	    	    Pageable pageable = PageRequest.of(page - 1, pageSize);

	    	    // Apply filters (search term is used on title)
	    	    Page<HackathonEntity> hackathonPage = hackathonRepository.findAllWithFilters(
	    	            search, status, payment, eventType, pageable);

	    	    model.addAttribute("allHackathons", hackathonPage.getContent());
	    	    model.addAttribute("currentPage", page);
	    	    model.addAttribute("totalPages", hackathonPage.getTotalPages());

	    	    // Preserve filter values in the model to populate the inputs
	    	    model.addAttribute("searchValue", search);
	    	    model.addAttribute("statusValue", status);
	    	    model.addAttribute("paymentValue", payment);
	    	    model.addAttribute("eventTypeValue", eventType);

	    	    return "ListHackathon";
	    	
	    }
	    
	    @GetMapping("deleteHackathon")
		public String deleteHackathon(Integer hackathonId) {
			hackathonRepository.deleteById(hackathonId);
			
			return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
		}
	 // Show edit form with existing hackathon data
	  /*  @GetMapping("/edit-hackathon")
	    public String editHackathon(@RequestParam("hackathonId") Integer hackathonId, Model model) {
	        HackathonEntity hackathon = hackathonRepository.findById(hackathonId).orElse(null);
	        if (hackathon == null) {
	            return "redirect:/listHackathon";
	        }
	        model.addAttribute("hackathon", hackathon);

	        List<UserTypeEntity> allUserType = userTypeRepository.findAll();
	        model.addAttribute("allUserType", allUserType);
	        return "EditHackathon"; // we'll create this JSP
	    }*/
	    @GetMapping("editHackathon")
		public String editHackathon(@RequestParam Integer hackathonId, Model model) {
			Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
			if (opHackathon.isEmpty()) {
				return "redirect:/listHackathon";
			}
			List<UserTypeEntity> allUserType = userTypeRepository.findAll();
			Optional<HackathonDescriptionEntity> description = hackathonDescriptionRepository.findFirstByHackathonId(hackathonId);
			List<HackathonPrizeEntity> prizeList = hackathonPrizeRepository.findByHackathonIdOrderByHackathonPrizeIdAsc(hackathonId);
			model.addAttribute("allUserType", allUserType);
			model.addAttribute("hackathon", opHackathon.get());
			model.addAttribute("hackathonDescription", description.orElse(new HackathonDescriptionEntity()));
			model.addAttribute("prize1", getPrizeOrNew(prizeList, 0));
			model.addAttribute("prize2", getPrizeOrNew(prizeList, 1));
			model.addAttribute("prize3", getPrizeOrNew(prizeList, 2));
			return "EditHackathon";
		}

		// Update existing hackathon
	   /* @PostMapping("/update-hackathon")
	    public String updateHackathon(@RequestParam("hackathonId") Integer hackathonId,
	                                  @RequestParam("title") String title,
	                                  @RequestParam("description") String description,
	                                  @RequestParam("status") String status,
	                                  @RequestParam("eventType") String eventType,
	                                  @RequestParam("payment") String payment,
	                                  @RequestParam("minTeamSize") Integer minTeamSize,
	                                  @RequestParam("maxTeamSize") Integer maxTeamSize,
	                                  @RequestParam("location") String location,
	                                  @RequestParam("userType") String userType,
	                                  @RequestParam("registrationStartDate") String regStart,
	                                  @RequestParam("registrationEndDate") String regEnd,
	                                  @RequestParam(value = "hackathonPoster", required = false) MultipartFile hackathonPoster,
	                                  HttpSession session) {

	        HackathonEntity hackathon = hackathonRepository.findById(hackathonId).orElse(null);
	        if (hackathon == null) {
	            return "redirect:/listHackathon";
	        }

	        // Update fields
	        hackathon.setTitle(title);
	        hackathon.setDescription(description);
	        hackathon.setStatus(status);
	        hackathon.setEventType(eventType);
	        hackathon.setPayment(payment);
	        hackathon.setMinTeamSize(minTeamSize);
	        hackathon.setMaxTeamSize(maxTeamSize);
	        hackathon.setLocation(location);
	        hackathon.setUserType(userType);
	        hackathon.setRegistrationStartDate(LocalDate.parse(regStart));
	        hackathon.setRegistrationEndDate(LocalDate.parse(regEnd));

	        // Only update poster if a new file was uploaded
	        if (hackathonPoster != null && !hackathonPoster.isEmpty()) {
	            try {
	                Map map = cloudinary.uploader().upload(hackathonPoster.getBytes(), null);
	                String posterUrl = map.get("secure_url").toString();
	                hackathon.setHackathonPosterURL(posterUrl);
	            } catch (IOException e) {
	                e.printStackTrace();
	                // keep old poster if upload fails
	            }
	        }

	        // UserId remains the same (creator)
	        hackathonRepository.save(hackathon);
	        return "redirect:/listHackathon";
	    }
	  
     */
	    @PostMapping("updateHackathon")
		@Transactional
		public String updateHackathon(HackathonEntity hackathonEntity, HttpSession session,
				@RequestParam(required = false) String hackathonDetails,
				@RequestParam(required = false) Integer prizeId1,
				@RequestParam(required = false) String prizeTitle1,
				@RequestParam(required = false) String prizeDescription1,
				@RequestParam(required = false) Integer prizeId2,
				@RequestParam(required = false) String prizeTitle2,
				@RequestParam(required = false) String prizeDescription2,
				@RequestParam(required = false) Integer prizeId3,
				@RequestParam(required = false) String prizeTitle3,
				@RequestParam(required = false) String prizeDescription3,
			//	 @RequestParam(value = "leaderboardPublished", required = false) String leaderboardPublishedParam,
					
				@RequestParam("userTypeId") Integer userTypeId,  
				 MultipartFile hackathonPoster) {
			Optional<HackathonEntity> existing = hackathonRepository.findById(hackathonEntity.getHackathonId());
			if (hackathonEntity.getLeaderboardPublished() == null && existing.isPresent()) {
				hackathonEntity.setLeaderboardPublished(existing.get().getLeaderboardPublished());
			}
			
			if ("COMPLETED".equalsIgnoreCase(hackathonEntity.getStatus())) {
			    hackathonEntity.setLeaderboardPublished(true);
			}
			if (hackathonEntity.getUserId() == null) {
				UserEntity currentLogInUser = (UserEntity) session.getAttribute("user");
				if (currentLogInUser != null) {
					hackathonEntity.setUserId(currentLogInUser.getUserId());
				}
			}
			 if (hackathonPoster != null && !hackathonPoster.isEmpty()) {
			try {
    			@SuppressWarnings("unchecked")
    			Map<String, Object>  map = 	cloudinary.uploader().upload(hackathonPoster.getBytes(), null);
    			String hackathonPosterURL = map.get("secure_url").toString();
    			System.out.println(hackathonPosterURL);
    			hackathonEntity.setHackathonPosterURL(hackathonPosterURL);
    			
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    			 existing.ifPresent(eh -> hackathonEntity.setHackathonPosterURL(eh.getHackathonPosterURL()));
    		}
			 }
			 else {
			        // No new file: preserve the existing poster URL
			        existing.ifPresent(eh -> hackathonEntity.setHackathonPosterURL(eh.getHackathonPosterURL()));
			    }
		    if (userTypeId != null) {
		        Optional<UserTypeEntity> ut = userTypeRepository.findById(userTypeId);
		        ut.ifPresent(u -> hackathonEntity.setUserType(u.getUserType()));
		    }
		    
		 //   hackathonEntity.setLeaderboardPublished("on".equals(leaderboardPublishedParam));
		    hackathonService.updateHackathonStatus(hackathonEntity);
			hackathonRepository.save(hackathonEntity);

			Integer hackathonId = hackathonEntity.getHackathonId();
			saveOrUpdateDescription(hackathonId, hackathonDetails);

			saveOrUpdatePrize(hackathonId, prizeId1, prizeTitle1, prizeDescription1);
			saveOrUpdatePrize(hackathonId, prizeId2, prizeTitle2, prizeDescription2);
			saveOrUpdatePrize(hackathonId, prizeId3, prizeTitle3, prizeDescription3);

			return "redirect:/listHackathon";
		}
	    
	    private HackathonPrizeEntity getPrizeOrNew(List<HackathonPrizeEntity> prizeList, int index) {
			if (prizeList.size() > index) {
				return prizeList.get(index);
			}
			return new HackathonPrizeEntity();
		}
	    
	    private void saveOrUpdateDescription(Integer hackathonId, String details) {
			if (!StringUtils.hasText(details)) {
				return;
			}
			HackathonDescriptionEntity description = hackathonDescriptionRepository.findFirstByHackathonId(hackathonId)
					.orElse(new HackathonDescriptionEntity());
			description.setHackathonId(hackathonId);
			description.setHackathonDetails(details);
			hackathonDescriptionRepository.save(description);
		}

		private void saveOrUpdatePrize(Integer hackathonId, Integer prizeId, String title, String descriptionText) {
			boolean hasData = StringUtils.hasText(title) || StringUtils.hasText(descriptionText);
			if (!hasData && prizeId == null) {
				return;
			}

			if (!hasData && prizeId != null) {
				hackathonPrizeRepository.deleteById(prizeId);
				return;
			}

			HackathonPrizeEntity prize = prizeId != null
					? hackathonPrizeRepository.findById(prizeId).orElse(new HackathonPrizeEntity())
					: new HackathonPrizeEntity();

			prize.setHackathonId(hackathonId);
			prize.setPrizeTitle(title);
			prize.setPrizeDescription(descriptionText);
			hackathonPrizeRepository.save(prize);
		}

		@GetMapping("/exportHackathons")
		public void exportHackathons(HttpServletResponse response) throws IOException {

		    response.setContentType("text/csv");
		    response.setHeader("Content-Disposition", "attachment; filename=hackathons.csv");

		    List<HackathonEntity> list = hackathonService.getAllHackathons();

		    PrintWriter writer = response.getWriter();

		    // Header
		    writer.println("ID,Title,Type,Payment,User Type,Team Size,Start Date,End Date,Location,Status");

		    // Data
		    for (HackathonEntity h : list) {
		        writer.println(
		            h.getHackathonId() + "," +
		            h.getTitle() + "," +
		            h.getEventType() + "," +
		            h.getPayment() + "," +
		            h.getUserType() + "," +
		            h.getMinTeamSize() + "-" + h.getMaxTeamSize() + "," +
		            h.getRegistrationStartDate() + "," +
		            h.getRegistrationEndDate() + "," +
		            h.getLocation() + "," +
		            h.getStatus()
		        );
		    }

		    writer.flush();
		    writer.close();
		}
		
}
