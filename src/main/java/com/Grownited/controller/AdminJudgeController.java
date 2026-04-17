package com.Grownited.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserRepository;
import com.Grownited.service.MailerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminJudgeController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private MailerService mailerService;

    // ==================== LIST JUDGES ====================
    @GetMapping("/listJudge")
    public String listJudges(Model model, HttpSession session) {
      
        List<UserEntity> judgeList = userRepository.findByRole("JUDGE");
        model.addAttribute("judgeList", judgeList);
        return "ListJudge";
    }

    // ==================== SHOW INVITE FORM ====================
    @GetMapping("/newJudge")
    public String showInviteJudgeForm() {
        return "NewJudge";
    }

    // ==================== SAVE NEW JUDGE (INVITE) ====================
    @PostMapping("/saveJudge")
    public String saveJudge(UserEntity judge, Model model, HttpSession session) {
      
        // 1. Check if email already exists
        if (userRepository.findByEmail(judge.getEmail()).isPresent()) {
            model.addAttribute("error", "Email already exists");
            return "NewJudge";
        }
        // 2. Generate random temporary password (e.g., 8 characters alphanumeric)
        String tempPassword = generateRandomPassword(8);
        judge.setPassword(passwordEncoder.encode(tempPassword));
        judge.setRole("judge");
        judge.setActive(true);
        judge.setPasswordResetRequired(true);
        // Set any other default values
        judge.setProfilePicURL(null); // or default

        // 3. Save judge
        userRepository.save(judge);

        // 4. Optionally send email (commented for now)
        mailerService.sendJudgeInviteMail(judge, tempPassword);

        // 5. Redirect with success and temp password (or just success flag)
        return "redirect:/listJudge?invited=true&tempPassword=" + tempPassword;
    }

    // Helper to generate random password
    private String generateRandomPassword(int length) {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * characters.length());
            sb.append(characters.charAt(index));
        }
        return sb.toString();
    }
}