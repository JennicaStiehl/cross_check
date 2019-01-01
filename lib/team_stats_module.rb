require 'pry'
require './lib/team'
require './lib/team_storage'
require './lib/stat_tracker'

module TeamStats

  def get_team_name_from_id(team_id)
    name = @teams.values.find do |team|
      team.teamid == team_id
    end.teamName
  end

  def count_of_teams
    @team_storage.teams.count
  end
 
end
