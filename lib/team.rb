class Team

  def initialize(team)
    @team = team
  end

  def team_info(teamid)
    info_info = {}
      team_info[@team[teamid]] = @team.values
      team_info
  end



end
