require 'pry'
require './lib/game_team'
require './lib/game_team_storage'
require './lib/stat_tracker'

module GameTeamStats

  def highest_score
    high = @game_teams.values.max_by { |game| game.goals.to_i }
    high.goals.to_i
  end

  def group_game_teams_by_team_id
    @game_teams.values.group_by do |game_team|
      game_team.team_id
    end
  end

  def game_win_percentage
    game_win_percentage = {}
    teams_grouped_by_team_id = group_game_teams_by_team_id
    #loops through each team_id, calculate win percentage, store it into game win percentage
    teams_grouped_by_team_id.keys.each do |team_id|
      total_games_by_team = teams_grouped_by_team_id[team_id]
      total_wins_by_team = teams_grouped_by_team_id[team_id].select do |game|
        game.won == "TRUE"
      end
      game_win_percentage.store(team_id, total_wins_by_team.count.to_f / total_games_by_team.count.to_f)
    end
    game_win_percentage
  end

  def winningest_team
    highest_win_percentage = game_win_percentage.keys.max do |team_id_1, team_id_2|
      game_win_percentage[team_id_1] <=> game_win_percentage[team_id_2]
    end
    @teams[highest_win_percentage.to_i].teamName
  end

  def home_game_count(teams_grouped_by_team_id, team_id)
    home_games = teams_grouped_by_team_id[team_id].select do |game|
      game.HoA == "home"
    end
    home_games.count
  end

  def home_game_win_count(teams_grouped_by_team_id, team_id)
    home_win_games = teams_grouped_by_team_id[team_id].select do |game|
      game.HoA == "home" && game.won == "TRUE"
    end
    home_win_games.count
  end

  def away_game_count(teams_grouped_by_team_id, team_id)
    away_games = teams_grouped_by_team_id[team_id].select do |game|
      game.HoA == "away"
    end
    away_games.count
  end

  def away_game_win_count(teams_grouped_by_team_id, team_id)
    away_win_games = teams_grouped_by_team_id[team_id].select do |game|
      game.HoA == "away" && game.won == "TRUE"
    end
    away_win_games.count
  end

  def best_fans
    teams_grouped_by_team_id = group_game_teams_by_team_id
    game_win_percentages = {}
    teams_grouped_by_team_id.keys.each do |team_id|
      home_count = home_game_count(teams_grouped_by_team_id, team_id)
      home_win_count = home_game_win_count(teams_grouped_by_team_id, team_id)
      away_count = away_game_count(teams_grouped_by_team_id, team_id)
      away_win_count = away_game_win_count(teams_grouped_by_team_id, team_id)
      game_win_percentages.store(team_id, ((home_win_count.to_f / home_count.to_f) - (away_win_count.to_f / away_count.to_f)))
    end
    get_team_with_highest_win_percentage(game_win_percentages)
  end

  def get_team_with_highest_win_percentage(game_win_percentages)
    highest_win_percentage = game_win_percentages.keys.max do |team_id_1, team_id_2|
      game_win_percentages[team_id_1] <=> game_win_percentages[team_id_2]
    end
    @teams[highest_win_percentage.to_i].teamName
  end

  def worst_fans
    better_away_than_home_records = []
    teams_grouped_by_team_id = group_game_teams_by_team_id
    teams_grouped_by_team_id.keys.each do |team_id|
      home_count = home_game_count(teams_grouped_by_team_id, team_id)
      home_win_count = home_game_win_count(teams_grouped_by_team_id, team_id)
      away_count = away_game_count(teams_grouped_by_team_id, team_id)
      away_win_count = away_game_win_count(teams_grouped_by_team_id, team_id)
      win_percentage_difference = ((away_win_count.to_f / away_count.to_f) - (home_win_count.to_f / home_count.to_f))
      if win_percentage_difference > 0.0
        better_away_than_home_records << @team_storage.teams[team_id.to_i].teamName
      end
    end
    better_away_than_home_records
  end

  def team_record(team_id)
    @game_team_storage.game_teams.values.select do |game_team|
      game_team.team_id == team_id
  end

  end

  def most_goals_scored(team_id)
    highest_number_of_goals = 0
    highest_number_of_goals = team_record(team_id).max do |team_1, team_2|
      team_1.goals <=> team_2.goals
    end
    highest_number_of_goals.goals.to_i
  end

  def fewest_goals_scored(team_id)
    lowest_number_of_goals = 0
    lowest_number_of_goals = team_record(team_id).min do |team_1, team_2|
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
