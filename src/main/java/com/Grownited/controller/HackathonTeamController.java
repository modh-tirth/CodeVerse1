package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.HackathonTeamEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.HackathonTeamRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class HackathonTeamController {
	
	  @Autowired
	  HackathonTeamRepository hackathonTeamRepository;
	  
	  @Autowired
	  HackathonRepository hackathonRepository;
	  

	    @GetMapping("/teamManage")
	    public String showTeamForm(Integer hackathonId, Model model) {
	        model.addAttribute("hackathon_id", hackathonId);
	        return "participant/TeamManage";
	    }

	    @PostMapping("/saveteam")
	    public String saveTeam(@RequestParam("hackathon_id") Integer hackathonId,  String teamName,String memberEmails,String teamDescription, HttpSession session) {
	                                            
	       UserEntity user = (UserEntity) session.getAttribute("user");
	        if (user == null) {
	            return "redirect:/login";
	        }

	        HackathonTeamEntity team = new HackathonTeamEntity();
	        team.setHackathonId(hackathonId);
	        team.setTeamLeaderId(user.getUserId());
	        team.setTeamName(teamName);
	        team.setTeamStatus("QUALIFY"); // or "ACTIVE" depending on your workflow

	        hackathonTeamRepository.save(team);

	        return "redirect:/participant/home?hackathon_id=" + hackathonId;
	    }
	    @GetMapping("/participant/Hackathonteam")
	    public String Hackathonteam() {	
	    	return "/participant/HackathonteamMember";
	    }
	    @GetMapping("/participant/teamFormation")
	    public String teamFormation() {
	    	return "/participant/team-formation";
	    }
	    @GetMapping("/participant/myHackathons")
	    public String myHackathons(Model model,HttpSession session) {
	    	// 1. Get the logged-in user from session
	        UserEntity user = (UserEntity) session.getAttribute("user");
	        
	        if (user == null) {
	            return "redirect:/login"; // Redirect if session expired
	        }

	        // 2. Fetch only the hackathons registered by this user
	        // You will need to create this method in your Repository
	    

	        // 3. Add the list to the model so the JSP can see it
	    	return "/participant/MyHackathons";
	    }
	    
}


