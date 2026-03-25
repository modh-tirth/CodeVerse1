
package com.Grownited.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.entity.UserTypeEntity;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.UserTypeRepository;
import com.cloudinary.Cloudinary;

import jakarta.servlet.http.HttpSession;

@Controller
public class HackathonController {
	
	  @Autowired
		HackathonRepository hackathonRepository;
	    
	   @Autowired
	    UserTypeRepository userTypeRepository;
	   
	   @Autowired
	   Cloudinary cloudinary;
	
	@GetMapping("/create-hackathon")
	    public String createHackathon(Model model) {

	    	List<UserTypeEntity> allUserType = userTypeRepository.findAll(); 
			//userType -> send Signup->
			model.addAttribute("allUserType",allUserType);
	        return "create-hackathons";
	    }

	    @PostMapping("/save-hackathon")
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
	    }
	    
	    @GetMapping("listHackathon")
	    public String listHackathon(Model model)
	    {
	    	 
	    	List<HackathonEntity> allHackathons = hackathonRepository.findAll();
	    	model.addAttribute("allHackathons" , allHackathons);
	    	return "ListHackathon";
	    	
	    }
	    
	    @GetMapping("deleteHackathon")
		public String deleteHackathon(Integer hackthon_id) {
			hackathonRepository.deleteById(hackthon_id);
			
			return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
		}
	 // Show edit form with existing hackathon data
	    @GetMapping("/edit-hackathon")
	    public String editHackathon(@RequestParam("hackthon_id") Integer hackathonId, Model model) {
	        HackathonEntity hackathon = hackathonRepository.findById(hackathonId).orElse(null);
	        if (hackathon == null) {
	            return "redirect:/listHackathon";
	        }
	        model.addAttribute("hackathon", hackathon);

	        List<UserTypeEntity> allUserType = userTypeRepository.findAll();
	        model.addAttribute("allUserType", allUserType);
	        return "EditHackathon"; // we'll create this JSP
	    }

	    // Update existing hackathon
	    @PostMapping("/update-hackathon")
	    public String updateHackathon(@RequestParam("hackthon_id") Integer hackathonId,
	                                  @RequestParam("title") String title,
	                                  @RequestParam("description") String description,
	                                  @RequestParam("status") String status,
	                                  @RequestParam("event_type") String eventType,
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
	  

}
