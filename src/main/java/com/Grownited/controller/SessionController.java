package com.Grownited.controller;
import com.Grownited.repository.UserDetailRepository;
import com.Grownited.repository.UserRepository;
import com.Grownited.repository.UserTypeRepository;
import com.Grownited.service.MailerService;
import com.cloudinary.Cloudinary;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

//import org.hibernate.sql.model.ast.builder.CollectionRowDeleteByUpdateSetNullBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Grownited.entity.UserDetailEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.entity.UserTypeEntity;

@Controller
public class SessionController {


	@Autowired
    UserRepository userRepository;
	
	@Autowired
	UserDetailRepository userDetailRepository;
	
	@Autowired
	UserTypeRepository userTypeRepository;
	
	@Autowired
	MailerService mailerService;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	Cloudinary cloudinary;
	

	@GetMapping("/signup")
	public String openSignupPage() {
		
		return "Signup";   //jsp name
	}
	
	// Routes to the login page
    @GetMapping("/login")
    public String showLoginPage() {
        return "Login"; // Refers to login.jsp
    }
    
    @PostMapping("/authenticate")
	public String authenticate(String email, String password,Model model,HttpSession session) {
		Optional<UserEntity> op = userRepository.findByEmail(email);

		/*if (op.isPresent()) {
			UserEntity dbUser = op.get();
			
			if (passwordEncoder.matches(password, dbUser.getPassword()))
			{
			{
				session.setAttribute("user", dbUser);
			//if (dbUser.getPassword().equals(password))
			  
				if (dbUser.getRole().equals("admin")) {
					System.out.println("demo");
					return "redirect:/dashboard";// url '
				} 
				else if (dbUser.getRole().equals("participant")) {
					System.out.println("demo");
					return "redirect:/participant/home";// url '
				}
				else if (dbUser.getRole().equals("judge")) {
					return "redirect:/judge/judge-dashboard";
				}
			}	
		  }
		}	*/
		if (op.isPresent()) {
		    UserEntity dbUser = op.get();

		    if (passwordEncoder.matches(password, dbUser.getPassword())) {

		        session.setAttribute("user", dbUser);

		        if ("admin".equals(dbUser.getRole())) {
		            return "redirect:/dashboard";
		        } 
		        else if ("participant".equals(dbUser.getRole())) {
		            return "redirect:/participant/home";
		        }
		        else if ("judge".equals(dbUser.getRole())) {
		            return "redirect:/judge/judge-dashboard";
		        }
		        else if ("organizer".equals(dbUser.getRole())) {
		            return "redirect:/organizer/dashboard";
		        }
		    }
		}
		model.addAttribute("error","Invalid Credentials");
		return "Login";
}

    
    @GetMapping("/forgetpassword")
    public String showPage() {
        return "forgetPassword"; // Points to /WEB-INF/jsp/forgot-password.jsp
    }
   
    @PostMapping("/resetPassword")
    public String resetPassword(String email, Model model) {
    	
    	Optional<UserEntity> userOpt = userRepository.findByEmail(email);

        if (userOpt.isPresent()) {
            UserEntity user = userOpt.get();
            
            // 1. Generate a 6-digit OTP
            String otp = String.valueOf((int)((Math.random() * 900000) + 100000));
            
            // 2. Save OTP to Database
            user.setOtp(otp);
            userRepository.save(user);
            
            // 3. Send OTP via Email
            mailerService.sendOtpMail(user.getEmail(), otp);
            
            model.addAttribute("success", "OTP sent to your email!");
            return "resetPassword"; // Redirects to your verification page
        } else {
            model.addAttribute("error", "Email not found!");
            return "forgetPassword";
        }
    	
    }
    @PostMapping("/update-password") // Triggered from resetpassword.jsp
    public String updatePassword( String email,  String otp,String newPassword,String confirmPassword,Model model) {
        
        Optional<UserEntity> userOpt = userRepository.findByEmail(email);

        if (userOpt.isPresent()) {
            UserEntity user = userOpt.get();
            
            // 1. Check if OTP matches the database
            if (user.getOtp() != null && user.getOtp().equals(otp)) {
                
                // 2. Check if passwords match
                if (newPassword.equals(confirmPassword)) {
                	String encodedPassword = passwordEncoder.encode(newPassword);
            		System.out.println(encodedPassword);
            		user.setPassword( encodedPassword);
                 //   user.setPassword(newPassword);
                    user.setOtp(null); // Clear OTP after use
                    userRepository.save(user);
                    
                    model.addAttribute("success", "Password updated! Please login.");
                    return "Login";
                } else {
                    model.addAttribute("error", "Passwords do not match!");
                }
            } else {
                model.addAttribute("error", "Invalid OTP!");
            }
        } else {
            model.addAttribute("error", "User not found!");
        }
        return "resetpassword";
    }
    // Routes to the registration page
    @GetMapping("/register")
    public String showRegisterPage(Model model) {
    	
    	List<UserTypeEntity> allUserType = userTypeRepository.findAll(); 
		//userType -> send Signup->
		model.addAttribute("allUserType",allUserType);
    	
        return "register"; // Refers to register.jsp
    }
    @PostMapping("/stored")
    public String showRegisterPage(UserEntity userEntity,UserDetailEntity userDetailEntity, MultipartFile profilePic, @RequestParam String role) {
    		System.out.println(userEntity.getFirstName());
    		System.out.println(userEntity.getLastName());
    		System.out.println(userDetailEntity.getCity());
    		System.out.println(userDetailEntity.getState());
    		
    		//userEntity.setRole("participant");
    		userEntity.setRole(role);
    		userEntity.setActive(true);
    		userEntity.setCreateAtDate(LocalDate.now());
    		
    		String encodedPassword = passwordEncoder.encode(userEntity.getPassword());
    		System.out.println(encodedPassword);
    		userEntity.setPassword( encodedPassword);
    		
    		System.out.println(profilePic.getOriginalFilename());
    		try {
    			@SuppressWarnings("unchecked")
    			Map<String, Object>  map = 	cloudinary.uploader().upload(profilePic.getBytes(), null);
    			String profilePicURL = map.get("secure_url").toString();
    			System.out.println(profilePicURL);
    			userEntity.setProfilePicURL(profilePicURL);
    			
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
    		
    		
    		userRepository.save(userEntity);
    		userDetailEntity.setUserId(userEntity.getUserId());
    		userDetailRepository.save(userDetailEntity);
    		mailerService.sendWelcomeMail(userEntity);
    		
        return "Login"; // Refers to register.jsp
    }
    
    
    @GetMapping("/submit-project")
    public String showSubmissionPage() {
        return "participant-submission";
    }

	@GetMapping("logout")
	public String logout(HttpSession session) {
		session.invalidate(); 
		return "Login";
	}
   
   
}
