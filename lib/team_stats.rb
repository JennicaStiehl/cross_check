# require 'pry'
require_relative './team'
require_relative './team_storage'
require_relative './stat_tracker'

module TeamStats

  def get_team_name_from_id(team_id)
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

  # def seasonal_summary(team_id)
  #   season_summary(team_id, all_seasons)
  # end

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

  def seasonal_summary(team_id, the_season = all_seasons)
  summary = {}
  seasons = []
  seasons << the_season
  s = seasons.flatten.sort
  average_goals_by_season
  s.each do |season|
  @games.values.inject(Hash.new(0)) do |stats, game|
    game_type = if game.type == 'R'
      :regular_season
    elsif game.type = 'P'
      :preseason
    end
      stats[game_type] = {average_goals_against: average_goals_against(team_id = "3", the_season = all_seasons),
                          average_goals_scored: average_goals_scored(team_id = "3", the_season = all_seasons),
                          total_goals_against: goals_against(team_id, season),
                          total_goals_scored: goals_scored(team_id, season),
                          win_percentage: win_percentage_helper(team_id = "3", season)
                          }
      summary[season] = stats
    end
  end
  summary
  end

end
