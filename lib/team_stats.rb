# require 'pry'
require_relative './team'
require_relative './team_storage'
require_relative './stat_tracker'

module TeamStats

  def get_team_name_from_id(team_id)
    # binding.pry
    name = @teams.values.find do |team|
      team.teamid == team_id
    end.teamName
  end

  def count_of_teams
    @team_storage.teams.count
  end

  def best_offense
    team_id = average_team_goals_across_all_seasons.key(average_team_goals_across_all_seasons.values.max)
    get_team_name_from_id(team_id)
  end

  def worst_offense
    team_id = average_team_goals_across_all_seasons.key(average_team_goals_across_all_seasons.values.min)
    get_team_name_from_id(team_id)
  end

  def seasonal_summary(team_id)
    season_summary(team_id, all_seasons)
  end

  def team_info(id)
    team_info = {}
    team_values = @teams.find do |team|
      team[0] == id.to_i
    end
    team_info[team_values[1].teamid] = team_values[1].teamid
    team_info[team_values[1].franchiseId] = team_values[1].franchiseId
    team_info[team_values[1].shortName] = team_values[1].shortName
    team_info[team_values[1].teamName] = team_values[1].teamName
    team_info[team_values[1].abbreviation] = team_values[1].abbreviation
    team_info[team_values[1].link] = team_values[1].link
    team_info
  end
end
