
package com.Grownited.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.HackathonDescriptionEntity;
import com.Grownited.entity.HackathonPrizeEntity;
import com.Grownited.repository.HackathonDescriptionRepository;
import com.Grownited.repository.HackathonPrizeRepository;
import com.Grownited.repository.HackathonRepository;

@Controller
public class HackathonExtraController {

	@Autowired
	HackathonDescriptionRepository hackathonDescriptionRepository;

	@Autowired
	HackathonPrizeRepository hackathonPrizeRepository;

	@Autowired
	HackathonRepository hackathonRepository;

	@GetMapping("newHackathonDescription")
	public String newHackathonDescription(@RequestParam(required = false) Integer hackathonId, Model model) {
		model.addAttribute("allHackthon", hackathonRepository.findAll());
		model.addAttribute("hackathonId", hackathonId);
		return "NewHackathonDescription";
	}

	@PostMapping("saveHackathonDescription")
	public String saveHackathonDescription(HackathonDescriptionEntity hackathonDescriptionEntity) {
		hackathonDescriptionRepository.save(hackathonDescriptionEntity);
		return "redirect:/listHackathonDescription?hackathonId=" + hackathonDescriptionEntity.getHackathonId();
	}

	@GetMapping("listHackathonDescription")
	public String listHackathonDescription(@RequestParam(required = false) Integer hackathonId, Model model) {
		List<HackathonDescriptionEntity> descriptionList = hackathonId == null
				? hackathonDescriptionRepository.findAll()
				: hackathonDescriptionRepository.findByHackathonId(hackathonId);
		model.addAttribute("descriptionList", descriptionList);
		model.addAttribute("hackathonId", hackathonId);
		return "ListHackathonDescription";
	}

	@GetMapping("editHackathonDescription")
	public String editHackathonDescription(Integer hackathonDescriptionId, Model model) {
		HackathonDescriptionEntity description = hackathonDescriptionRepository.findById(hackathonDescriptionId).orElse(null);
		model.addAttribute("description", description);
		model.addAttribute("allHackthon", hackathonRepository.findAll());
		return "EditHackathonDescription";
	}

	@PostMapping("updateHackathonDescription")
	public String updateHackathonDescription(HackathonDescriptionEntity hackathonDescriptionEntity) {
		hackathonDescriptionRepository.save(hackathonDescriptionEntity);
		return "redirect:/listHackathonDescription?hackathonId=" + hackathonDescriptionEntity.getHackathonId();
	}

	@GetMapping("deleteHackathonDescription")
	public String deleteHackathonDescription(Integer hackathonDescriptionId, @RequestParam(required = false) Integer hackathonId) {
		if (hackathonId == null) {
			HackathonDescriptionEntity entity = hackathonDescriptionRepository.findById(hackathonDescriptionId).orElse(null);
			if (entity != null) {
				hackathonId = entity.getHackathonId();
			}
		}
		hackathonDescriptionRepository.deleteById(hackathonDescriptionId);
		return "redirect:/listHackathonDescription" + (hackathonId != null ? "?hackathonId=" + hackathonId : "");
	}

	@GetMapping("newHackathonPrize")
	public String newHackathonPrize(@RequestParam(required = false) Integer hackathonId, Model model) {
		model.addAttribute("allHackthon", hackathonRepository.findAll());
		model.addAttribute("hackathonId", hackathonId);
		return "NewHackathonPrize";
	}

	@PostMapping("saveHackathonPrize")
	public String saveHackathonPrize(HackathonPrizeEntity hackathonPrizeEntity) {
		hackathonPrizeRepository.save(hackathonPrizeEntity);
		return "redirect:/listHackathonPrize?hackathonId=" + hackathonPrizeEntity.getHackathonId();
	}

	@GetMapping("listHackathonPrize")
	public String listHackathonPrize(@RequestParam(required = false) Integer hackathonId, Model model) {
		List<HackathonPrizeEntity> prizeList = hackathonId == null
				? hackathonPrizeRepository.findAll()
				: hackathonPrizeRepository.findByHackathonId(hackathonId);
		model.addAttribute("prizeList", prizeList);
		model.addAttribute("hackathonId", hackathonId);
		return "ListHackathonPrize";
	}

	@GetMapping("editHackathonPrize")
	public String editHackathonPrize(Integer hackathonPrizeId, Model model) {
		HackathonPrizeEntity prize = hackathonPrizeRepository.findById(hackathonPrizeId).orElse(null);
		model.addAttribute("prize", prize);
		model.addAttribute("allHackthon", hackathonRepository.findAll());
		return "EditHackathonPrize";
	}

	@PostMapping("updateHackathonPrize")
	public String updateHackathonPrize(HackathonPrizeEntity hackathonPrizeEntity) {
		hackathonPrizeRepository.save(hackathonPrizeEntity);
		return "redirect:/listHackathonPrize?hackathonId=" + hackathonPrizeEntity.getHackathonId();
	}

	@GetMapping("deleteHackathonPrize")
	public String deleteHackathonPrize(Integer hackathonPrizeId, @RequestParam(required = false) Integer hackathonId) {
		if (hackathonId == null) {
			HackathonPrizeEntity entity = hackathonPrizeRepository.findById(hackathonPrizeId).orElse(null);
			if (entity != null) {
				hackathonId = entity.getHackathonId();
			}
		}
		hackathonPrizeRepository.deleteById(hackathonPrizeId);
		return "redirect:/listHackathonPrize" + (hackathonId != null ? "?hackathonId=" + hackathonId : "");
	}
}
