package com.Grownited.controller;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.UserRepository;
import com.Grownited.repository.UserTypeRepository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.UserTypeEntity;

@Controller
public class AdminController {

  
     @Autowired
     HackathonRepository hackathonRepository;
     
     @Autowired
     UserRepository userRepository;
	
	 @GetMapping("/dashboard")
	    public String showDashboard(Model model) {
	        // You can later replace these hardcoded values with Service calls
		    long totalHackathon = hackathonRepository.count();
		    long upcomingHackathon = hackathonRepository.countByStatus("UPCOMING");
		    long liveHackathon = hackathonRepository.countByStatus("LIVE");
		    long totalUsers = userRepository.count();	
		    long totalParticipants = userRepository.countByRole("participant");
		    long totalJudges = userRepository.countByRole("judge");
		    long totalAdmins = userRepository.countByRole("admin");
		     
	        model.addAttribute("totalHackathon", totalHackathon);
	        model.addAttribute("upcomingHackathon", upcomingHackathon);
	        model.addAttribute("liveHackathon", liveHackathon);
	        model.addAttribute("totalUsers",totalUsers);
	        model.addAttribute("totalParticipants",totalParticipants);
	        model.addAttribute("totalJudges",totalJudges);
	        model.addAttribute("totalAdmins",totalAdmins);
	        
	        
	        return "AdminDashboard"; // Maps to /WEB-INF/views/admin-dashboard.jsp
	    }
	 
	 /**
	     * Form Processing: Handles approval or rejection of organizers/judges.
	     
	    @PostMapping("/approvals")
	    public String processApproval(@RequestParam("userId") Long userId, 
	                                  @RequestParam("action") String action) {
	        if ("approve".equals(action)) {
	            // Logic to update user status to 'APPROVED' in database
	        } else {
	            // Logic for 'REJECT'
	        }
	        return "redirect:/admin/admin-approvals"; // Refresh the dashboard after action
	    }
	    
	 // Inside AdminController.java

	   
	    @GetMapping("/reports")
	    public String showReports(Model model) {
	        model.addAttribute("totalSubmissions", 1240);
	        model.addAttribute("evalProgress", 88);
	        // In a real scenario, you'd pass a List of Log objects here
	        // model.addAttribute("activityLogs", reportService.getRecentLogs());
	        return "/admin/admin-reports";
	    }
	    

	    @GetMapping("/manage-hackathons")
	    public String manageHackathons(Model model) {
	        // In the future, fetch your list of hackathons from a service here
	        // List<Hackathon> hackathons = hackathonService.getAll();
	        // model.addAttribute("hackathonList", hackathons);
	        return "/admin/manage-hackathons";
	    }
	    
	   */

}
