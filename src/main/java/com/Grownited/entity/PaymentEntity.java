package com.Grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

//this entity is not for codeverse 
//
@Entity
@Table(name = "payments")
public class PaymentEntity {
		
		@Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Integer paymentId;
	    private Integer hackathonId;       // <-- add this to link to hackathon
	    private Integer userId;            // <-- add this to link to user
	    private Double amount;
	    private String paymentMode;
	    private String gateway;
	    private String paymentStatus;
	    private LocalDate paymentDate;
	    private String paymentGatewayTransactionId;
	    private String paymentGatewayAuthCode;


	public Integer getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(Integer paymentId) {
		this.paymentId = paymentId;
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}

	public String getGateway() {
		return gateway;
	}

	public void setGateway(String gateway) {
		this.gateway = gateway;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public LocalDate getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(LocalDate paymentDate) {
		this.paymentDate = paymentDate;
	}

	public String getPaymentGatewayTransactionId() {
		return paymentGatewayTransactionId;
	}

	public void setPaymentGatewayTransactionId(String paymentGatewayTransactionId) {
		this.paymentGatewayTransactionId = paymentGatewayTransactionId;
	}

	public String getPaymentGatewayAuthCode() {
		return paymentGatewayAuthCode;
	}

	public void setPaymentGatewayAuthCode(String paymentGatewayAuthCode) {
		this.paymentGatewayAuthCode = paymentGatewayAuthCode;
	}

	public Integer getHackathonId() {
		return hackathonId;
	}

	public void setHackathonId(Integer hackathonId) {
		this.hackathonId = hackathonId;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

}
