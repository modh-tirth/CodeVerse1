package com.Grownited.controller.participant;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.Grownited.entity.HackathonEntity;
import com.Grownited.entity.HackathonResultEntity;
import com.Grownited.entity.HackathonTeamEntity;
import com.Grownited.repository.HackathonRepository;
import com.Grownited.repository.HackathonResultRepository;
import com.Grownited.repository.HackathonTeamRepository;

@Controller
public class ParticipantLeaderboardController {

	@Autowired
	HackathonRepository hackathonRepository;

	@Autowired
	HackathonTeamRepository hackathonTeamRepository;

	@Autowired
	HackathonResultRepository hackathonResultRepository;

	@GetMapping("participant/leaderboard/{hackathonId}")
	public String leaderboard(@PathVariable Integer hackathonId, Model model) {
		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

		HackathonEntity hackathon = opHackathon.get();
		boolean published = Boolean.TRUE.equals(hackathon.getLeaderboardPublished());
		if (!published) {
			return "redirect:/participant/hackathon/" + hackathonId + "?error=leaderboardNotReady";
		}

		List<HackathonTeamEntity> teams = hackathonTeamRepository.findByHackathonId(hackathonId);
		List<HackathonResultEntity> results = hackathonResultRepository.findByHackathonId(hackathonId);

		Map<Integer, LeaderboardRow> rowMap = new HashMap<>();
		for (HackathonTeamEntity team : teams) {
			LeaderboardRow row = new LeaderboardRow();
			row.setTeamId(team.getHackathonTeamId());
			row.setTeamName(team.getTeamName());
			rowMap.put(team.getHackathonTeamId(), row);
		}

		for (HackathonResultEntity result : results) {
			LeaderboardRow row = rowMap.get(result.getTeamId());
			if (row == null) {
				continue;
			}
			int innovation = result.getInnovation() == null ? 0 : result.getInnovation();
			int implementation = result.getImplementation() == null ? 0 : result.getImplementation();
			int codingStandard = result.getCodingStandard() == null ? 0 : result.getCodingStandard();
			int total = innovation + implementation + codingStandard;
			row.setTotalScore(row.getTotalScore() + total);
			row.setEvaluationCount(row.getEvaluationCount() + 1);
		}

		List<LeaderboardRow> leaderboardRows = new ArrayList<>(rowMap.values());
		for (LeaderboardRow row : leaderboardRows) {
			if (row.getEvaluationCount() > 0) {
				row.setAverageScore((double) row.getTotalScore() / row.getEvaluationCount());
			}
		}

		leaderboardRows.sort(Comparator.comparingDouble(LeaderboardRow::getAverageScore).reversed()
				.thenComparing(Comparator.comparingInt(LeaderboardRow::getTotalScore).reversed())
				.thenComparing(LeaderboardRow::getTeamName, String.CASE_INSENSITIVE_ORDER));

		int rank = 0;
		double prevAvg = -1d;
		int prevTotal = -1;
		int tieRank = 0;
		for (LeaderboardRow row : leaderboardRows) {
			tieRank++;
			if (Double.compare(row.getAverageScore(), prevAvg) != 0 || row.getTotalScore() != prevTotal) {
				rank = tieRank;
				prevAvg = row.getAverageScore();
				prevTotal = row.getTotalScore();
			}
			row.setRank(rank);
		}

		model.addAttribute("hackathon", hackathon);
		model.addAttribute("leaderboardRows", leaderboardRows);
		model.addAttribute("totalTeams", teams.size());
		model.addAttribute("totalEvaluations", results.size());
		return "participant/Leaderboard";
	}

	public static class LeaderboardRow {
		private Integer teamId;
		private String teamName;
		private int totalScore;
		private int evaluationCount;
		private double averageScore;
		private int rank;

		public Integer getTeamId() {
			return teamId;
		}

		public void setTeamId(Integer teamId) {
			this.teamId = teamId;
		}

		public String getTeamName() {
			return teamName;
		}

		public void setTeamName(String teamName) {
			this.teamName = teamName;
		}

		public int getTotalScore() {
			return totalScore;
		}

		public void setTotalScore(int totalScore) {
			this.totalScore = totalScore;
		}

		public int getEvaluationCount() {
			return evaluationCount;
		}

		public void setEvaluationCount(int evaluationCount) {
			this.evaluationCount = evaluationCount;
		}

		public double getAverageScore() {
			return averageScore;
		}

		public void setAverageScore(double averageScore) {
			this.averageScore = averageScore;
		}

		public int getRank() {
			return rank;
		}

		public void setRank(int rank) {
			this.rank = rank;
		}
	}
}