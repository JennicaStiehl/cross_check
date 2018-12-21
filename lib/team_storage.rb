require './lib/storage'

class TeamStorage #< Storage
  attr_accessor   :team_storage,
                  :teams

  def initialize
    @teams = {}
  end

  def add_team(team)
    @teams[team.teamid.to_i] = team
    @teams
  end

  def team_info(teamid)
      @teams[teamid].team_info
  end

end
