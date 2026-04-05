package com.Grownited.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Grownited.repository.HackathonRepository;
import com.Grownited.entity.HackathonEntity;

@Service
public class HackathonService {

    @Autowired
    private HackathonRepository hackathonRepository;

    public List<HackathonEntity> getAllHackathons() {
        return hackathonRepository.findAll();
    }
}