package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.UserEntity;
import com.Grownited.service.PaymentService;

import jakarta.servlet.http.HttpSession;


@Controller
public class PaymentController {

	
	@Autowired
	PaymentService paymentService;
	
	//input 
	@GetMapping("/charge")
	public String charge() {
		return "ChargeCreditCard";
	}
	
	
	@PostMapping("charge")
	public String chargeCreditCard(String cardNumber,String expMonth,String expYear,HttpSession session,Double amount) {

		UserEntity user  = (UserEntity) session.getAttribute("user");
		String email = user.getEmail();
		paymentService.chargeCreditCard(email, cardNumber, expMonth+expYear, amount);
		
		
		//logic -> payment gateway 
		return "ChargeCreditCard";
	}

	
	
	
	
}