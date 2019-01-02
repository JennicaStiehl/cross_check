require 'pry'
require './lib/team'
require './lib/team_storage'
require './lib/stat_tracker'

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

end
