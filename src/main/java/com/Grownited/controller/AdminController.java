package com.Grownited.controller;
import com.Grownited.repository.HackathonJudgeRepository;
import com.Grownited.repository.HackathonParticipantRepository;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.HackathonResultRepository;
import com.Grownited.repository.HackathonSubmissionRepository;
import com.Grownited.repository.HackathonTeamRepository;
import com.Grownited.repository.PaymentRepository;
import com.Grownited.repository.UserRepository;


import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {

  
     @Autowired
     HackathonRepository hackathonRepository;
     
     @Autowired
     UserRepository userRepository;
     
     @Autowired
     HackathonSubmissionRepository hackathonSubmissionRepository;
     
     @Autowired
     HackathonResultRepository hackathonResultRepository;
     
     @Autowired
     PaymentRepository paymentRepository;
     
     @Autowired
     HackathonTeamRepository hackathonTeamRepository;
     
     @Autowired
     HackathonJudgeRepository hackathonJudgeRepository;
     
     @Autowired
     HackathonParticipantRepository hackathonParticipantRepository;
	
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
	        
	        long paymentSuccessCount = paymentRepository.countByPaymentStatus("SUCCESS");
	        long paymentFailedCount = paymentRepository.countByPaymentStatus("FAILED");

	        model.addAttribute("paymentSuccessCount", paymentSuccessCount);
	        model.addAttribute("paymentFailedCount", paymentFailedCount);
	        
	        List<Object[]> revenueData = paymentRepository.getMonthlyRevenue();
	        List<String> revenueMonths = new ArrayList<>();
	        List<Double> revenueAmounts = new ArrayList<>();
	        for (Object[] row : revenueData) {
	            revenueMonths.add((String) row[0]);      // month name, e.g. "Apr 2026"
	            revenueAmounts.add((Double) row[1]);     // total revenue for that month
	        }
	        model.addAttribute("revenueMonths", revenueMonths);
	        model.addAttribute("revenueAmounts", revenueAmounts);
	        
	        List<Object[]> workloadData = hackathonJudgeRepository.getJudgeWorkload();
	        List<String> judgeNames = new ArrayList<>();
	        List<Long> workloads = new ArrayList<>();
	        for (Object[] row : workloadData) {
	            judgeNames.add(row[0] + " " + row[1]);
	            workloads.add(((Number) row[2]).longValue());
	        }
	        model.addAttribute("judgeNames", judgeNames);
	        model.addAttribute("judgeWorkloads", workloads);
	        
	        List<Object[]> topData = hackathonRepository.getTopHackathonsByParticipants();
	        List<String> topHackathonNames = new ArrayList<>();
	        List<Long> topHackathonParticipants = new ArrayList<>();

	        for (Object[] row : topData) {
	            topHackathonNames.add((String) row[0]);
	            topHackathonParticipants.add(((Number) row[1]).longValue());
	        }

	        model.addAttribute("topHackathonNames", topHackathonNames);
	        model.addAttribute("topHackathonParticipants", topHackathonParticipants);
	   
	        
	        List<Object[]> regData = hackathonParticipantRepository.getMonthlyRegistrations();
	        List<String> monthLabels = new ArrayList<>();
	        List<Long> registrationCounts = new ArrayList<>();

	        for (Object[] row : regData) {
	            monthLabels.add((String) row[0]);   // e.g. "Apr 2026"
	            registrationCounts.add(((Number) row[1]).longValue());
	        }

	        model.addAttribute("monthLabels", monthLabels);
	        model.addAttribute("registrationCounts", registrationCounts);
	        
	        List<Object[]> teamSizeData = hackathonTeamRepository.getTeamSizeDistribution();
	        int[] teamSizes = new int[5]; // index 0 -> size 1, index 4 -> size 5+
	        for (Object[] row : teamSizeData) {
	            int size = ((Number) row[0]).intValue();
	            long count = ((Number) row[1]).longValue();
	            if (size >= 5) teamSizes[4] += count;
	            else if (size >= 1 && size <= 4) teamSizes[size - 1] = (int) count;
	        }
	        model.addAttribute("teamSize1", teamSizes[0]);
	        model.addAttribute("teamSize2", teamSizes[1]);
	        model.addAttribute("teamSize3", teamSizes[2]);
	        model.addAttribute("teamSize4", teamSizes[3]);
	        model.addAttribute("teamSize5", teamSizes[4]);
	
	       
	        
	        long totalSubmissions = hackathonSubmissionRepository.getTotalSubmissions();
	        long evaluatedSubmissions = hackathonSubmissionRepository.getEvaluatedSubmissions();
	
	        List<Long> judgeAssignments = new ArrayList<>();
	    
	        // ... etc.
	        model.addAttribute("totalSubmissions", totalSubmissions);
	        model.addAttribute("evaluatedSubmissions", evaluatedSubmissions);
	        model.addAttribute("judgeNames", judgeNames);
	        model.addAttribute("judgeAssignments", judgeAssignments);
	        
	        return "AdminDashboard"; // Maps to /WEB-INF/views/admin-dashboard.jsp
	    }
	 


}
