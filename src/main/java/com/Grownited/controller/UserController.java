package com.Grownited.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Grownited.entity.UserDetailEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserDetailRepository;
import com.Grownited.repository.UserRepository;
import com.cloudinary.Cloudinary;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
public class UserController {


	@Autowired
	UserRepository userRepository;
	
	@Autowired
	UserDetailRepository userDetailRepository;
	
	@Autowired
	Cloudinary cloudinary;

	@GetMapping("listUser")
	public String listUser(Model model)
	{
		
		List<UserEntity> allUser = userRepository.findAll();
		
		model.addAttribute("userList",allUser);
		return "ListUser";
		
	}
	
	@GetMapping("viewUser")
	public String viewUser(Integer userId, Model model) {
		// read userId
		// select * from users where userId = rock?
		Optional<UserEntity> opUser = userRepository.findById(userId);// Optional
		Optional<UserDetailEntity> opUserDetail = userDetailRepository.findByUserId(userId);
		if (opUser.isEmpty()) {
			// error set
			// list redirect
			return "";
		} else {

			UserEntity userEntity = opUser.get();
			UserDetailEntity userDetailEntity = opUserDetail.get();

			model.addAttribute("user", userEntity);
			model.addAttribute("userDetail", userDetailEntity);
			return "ViewUser";
		}

	
	}
	
	 @GetMapping("deleteUser")
		public String deletUser(Integer userId) {
			userRepository.deleteById(userId);
			
			return "redirect:/listUser";//do not open jsp , open another url -> listHackathon
		}
	// Show edit form
	 @GetMapping("edit-user")
	 public String editUser(@RequestParam Integer userId, Model model) {
	     Optional<UserEntity> opUser = userRepository.findById(userId);
	     Optional<UserDetailEntity> opDetail = userDetailRepository.findByUserId(userId);
	     
	     if (opUser.isEmpty()) {
	         return "redirect:/listUser";
	     }
	     
	     model.addAttribute("user", opUser.get());
	     model.addAttribute("userDetail", opDetail.orElse(new UserDetailEntity()));
	     return "edit-user";
	 }

	 // Process update
	 @PostMapping("update-user")
	 @Transactional
	 public String updateUser(@RequestParam Integer userId,
	                          @RequestParam String firstName,
	                          @RequestParam String lastName,
	                          @RequestParam String email,
	                          @RequestParam String contactNum,
	                          @RequestParam String gender,
	                          @RequestParam Integer birthYear,
	                          @RequestParam String qualification,
	                          @RequestParam String city,
	                          @RequestParam String state,
	                          @RequestParam String country,
	                          @RequestParam(required = false) MultipartFile profilePic,
	                          @RequestParam(required = false) Boolean active,
	                          HttpSession session) {
	     
	     // 1. Update UserEntity
	     UserEntity user = userRepository.findById(userId).orElseThrow();
	     user.setFirstName(firstName);
	     user.setLastName(lastName);
	     user.setEmail(email);
	     user.setContactNum(contactNum);
	     user.setGender(gender);
	     user.setBirthYear(birthYear);
	     if (active != null) {
	         user.setActive(active);
	     }
	     
	     // Handle profile picture upload
	     if (profilePic != null && !profilePic.isEmpty()) {
	         try {
	             @SuppressWarnings("unchecked")
	             Map<String, Object> uploadResult = cloudinary.uploader().upload(profilePic.getBytes(), null);
	             String profilePicUrl = uploadResult.get("secure_url").toString();
	             user.setProfilePicURL(profilePicUrl);
	         } catch (IOException e) {
	             e.printStackTrace();
	         }
	     }
	     
	     userRepository.save(user);
	     
	     // 2. Update or create UserDetailEntity
	     UserDetailEntity detail = userDetailRepository.findByUserId(userId)
	             .orElse(new UserDetailEntity());
	     detail.setUserId(userId);
	     detail.setQualification(qualification);
	     detail.setCity(city);
	     detail.setState(state);
	     detail.setCountry(country);
	     userDetailRepository.save(detail);
	     
	     return "redirect:/viewUser?userId=" + userId;
	 }
}
