package com.Grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table (name = "hackathon")
public class HackathonEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer	hackathonId;
	private String title;
	@Column(name = "description", length = 2000)
    private	String description; 
	private String hackathonPosterURL;
	private String status;
	private String eventType;
	private String payment;
	private Integer minTeamSize;
	private Integer maxTeamSize;
	private String location;
	private String userType;	
	private LocalDate registrationStartDate;
	private LocalDate registrationEndDate;
	Boolean leaderboardPublished;
	private Integer userId;
	
	public Integer getHackathonId() {
		return hackathonId;
	}
	public void setHackathonId(Integer hackathonId) {
		this.hackathonId = hackathonId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getEventType() {
		return eventType;
	}
	public void setEventType(String eventType) {
		this.eventType = eventType;
	}
	public String getPayment() {
		return payment;
	}
	public void setPayment(String payment) {
		this.payment = payment;
	}
	public Integer getMinTeamSize() {
		return minTeamSize;
	}
	public void setMinTeamSize(Integer minTeamSize) {
		this.minTeamSize = minTeamSize;
	}
	public Integer getMaxTeamSize() {
		return maxTeamSize;
	}
	public void setMaxTeamSize(Integer maxTeamSize) {
		this.maxTeamSize = maxTeamSize;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public LocalDate getRegistrationStartDate() {
		return registrationStartDate;
	}
	public void setRegistrationStartDate(LocalDate registrationStartDate) {
		this.registrationStartDate = registrationStartDate;
	}
	public LocalDate getRegistrationEndDate() {
		return registrationEndDate;
	}
	public void setRegistrationEndDate(LocalDate registrationEndDate) {
		this.registrationEndDate = registrationEndDate;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getHackathonPosterURL() {
		return hackathonPosterURL;
	}
	public void setHackathonPosterURL(String hackathonPosterURL) {
		this.hackathonPosterURL = hackathonPosterURL;
	}
	public Boolean getLeaderboardPublished() {
		return leaderboardPublished;
	}
	public void setLeaderboardPublished(Boolean leaderboardPublished) {
		this.leaderboardPublished = leaderboardPublished;
	}
	
}
