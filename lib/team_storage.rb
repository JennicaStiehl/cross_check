require './lib/storage'

class TeamStorage < Storage
  attr_accessor   :data

  def initialize
    @data = {}
  end

  def add_team(team)
    @data[team.teamid.to_i] = team
    @data
  end

  def all
    @data.values
  end

  def team_info(teamid)
    team_info = {}
      team_info[@data[teamid]] = @data.values
      team_info
  end

end
