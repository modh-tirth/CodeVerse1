package com.Grownited.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table (name = "hackathon_description")
public class HackathonDescriptionEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer hackathon_description_id;
	
	@Column(columnDefinition = "TEXT")
	private String hackathon_details;
	private Integer hackathonId;
	public Integer getHackathon_description_id() {
		return hackathon_description_id;
	}
	public void setHackathon_description_id(Integer hackathon_description_id) {
		this.hackathon_description_id = hackathon_description_id;
	}
	public String getHackathon_details() {
		return hackathon_details;
	}
	public void setHackathon_details(String hackathon_details) {
		this.hackathon_details = hackathon_details;
	}
	public Integer getHackathonId() {
		return hackathonId;
	}
	public void setHackathonId(Integer hackathonId) {
		this.hackathonId = hackathonId;
	}
	
}
