require 'pry'
require './lib/game_team'
require './lib/game_team_storage'
require './lib/stat_tracker'

module GameTeamStats

  def highest_score
    high = @game_teams.values.max_by { |game| game.goals.to_i }
    high.goals.to_i
  end
  # Erin's Iteration 3: League and Season Stats

  def winningest_team
    team_with_highest_win_percentage_across_all_seasons = ""

    teams_by_id = @game_team_storage.game_teams.values.group_by do |game_team|
      game_team.team_id
    end

    game_win_percentage = {}
    teams_by_id.keys.each do |team_id|
      count = teams_by_id[team_id].count
      wins = teams_by_id[team_id].select do |game|
        game.won == "TRUE"
      end
      game_win_percentage.store(team_id, wins.count.to_f / count.to_f)
    end
    highest_win_percentage = game_win_percentage.keys.max do |team_id_1, team_id_2|
      game_win_percentage[team_id_1] <=> game_win_percentage[team_id_2]
    end

    team_with_highest_win_percentage_across_all_seasons = @team_storage.teams[highest_win_percentage.to_i].teamName

    team_with_highest_win_percentage_across_all_seasons
  end

  def best_fans
    biggest_home_away_win_percentage_difference = ""

    teams_by_id = @game_team_storage.game_teams.values.group_by do |game_team|
      game_team.team_id
    end

    game_win_percentage = {}
    teams_by_id.keys.each do |team_id|
      home_count = teams_by_id[team_id].select do |game|
        game.HoA == "home"
      end

      home_win_count = home_count.select do |game|
        game.won == "TRUE"
      end

      away_count = teams_by_id[team_id].select do |game|
        game.HoA == "away"
      end

      away_win_count = away_count.select do |game|
        game.won == "TRUE"
      end

    game_win_percentage.store(team_id, ((home_win_count.count.to_f / home_count.count.to_f) - (away_win_count.count.to_f / away_count.count.to_f)))
    end

    highest_win_percentage = game_win_percentage.keys.max do |team_id_1, team_id_2|
      game_win_percentage[team_id_1] <=> game_win_percentage[team_id_2]
    end

    biggest_home_away_win_percentage_difference = @team_storage.teams[highest_win_percentage.to_i].teamName

    biggest_home_away_win_percentage_difference
  end

  def worst_fans
    better_away_than_home_records = [] #["Team 1", "Team 2"]

    teams_by_id = @game_team_storage.game_teams.values.group_by do |game_team|
      game_team.team_id
    end

    game_away_win_percentage = {}
    teams_by_id.keys.each do |team_id|
      home_count = teams_by_id[team_id].select do |game|
        game.HoA == "home"
      end

      home_win_count = home_count.select do |game|
        game.won == "TRUE"
      end

      away_count = teams_by_id[team_id].select do |game|
        game.HoA == "away"
      end

      away_win_count = away_count.select do |game|
        game.won == "TRUE"
      end

      game_away_win_percentage.store(team_id, ((away_win_count.count.to_f / away_count.count.to_f) - (home_win_count.count.to_f / home_count.count.to_f)))

      if game_away_win_percentage[team_id] < 0.0
        better_away_than_home_records << @team_storage.teams[team_id.to_i].teamName
      end
    end
    better_away_than_home_records
  end

  #Erin's iteration 4
  def most_goals_scored(team_id)
    highest_number_of_goals = 0

    team = @game_team_storage.game_teams.values.select do |game_team|
      game_team.team_id == team_id
    end

    highest_number_of_goals = team.max do |team_1, team_2|
      team_1.goals <=> team_2.goals
    end

    highest_number_of_goals.goals.to_i
  end

  def fewest_goals_scored(team_id)
    lowest_number_of_goals = 0

    team = @game_team_storage.game_teams.values.select do |game_team|
      game_team.team_id == team_id
    end

    lowest_number_of_goals = team.min do |team_1, team_2|
      team_1.goals <=> team_2.goals
    end

    lowest_number_of_goals.goals.to_i
  end

  def worst_loss(team_id)
    biggest_goal_difference = 0
    lost_games_for_team = @game_team_storage.game_teams.values.select do |game_team|
      game_team.team_id == team_id && game_team.won == "FALSE"
    end

    lost_games_for_team.each do |losing_team|
        opponent_for_team = @game_team_storage.game_teams.values.select do |game_team|
          game_team.team_id != team_id && game_team.game_id == losing_team.game_id
        end
      if opponent_for_team.count != 0
        goal_difference = opponent_for_team[0].goals.to_i - losing_team.goals.to_i
          if goal_difference > biggest_goal_difference
            biggest_goal_difference = goal_difference
          end
      end
    end
    return biggest_goal_difference
  end
end
