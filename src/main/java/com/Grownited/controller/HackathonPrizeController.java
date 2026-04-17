package com.Grownited.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonPrizeEntity;
import com.Grownited.repository.HackathonPrizeRepository;
import com.Grownited.repository.HackathonRepository;

@Controller
public class HackathonPrizeController {
	
	@Autowired
	HackathonPrizeRepository hackathonPrizeRepository;
	
	@Autowired
	HackathonRepository hackathonRepository;
	
	@GetMapping("/hackathonPrize")
	public String hakckathonPrize(Model model) {
		
		List<HackathonEntity> allhackathons = hackathonRepository.findAll(); 
		model.addAttribute("allhackathons", allhackathons);
		
		return "HackathonPrize";
	}
	@PostMapping("/savePrize")
	public String savePrizedetail(HackathonEntity hackathonEntity, HackathonPrizeEntity hackathonPrizeEntity)
	{
		 
        // hackathonPrizeEntity.setHackathon_id(hackathonEntity.getHackthon_id());
          // Save to database
         hackathonPrizeRepository.save(hackathonPrizeEntity);
		return "redirect:/hackathonPrize";
	}
	

}
