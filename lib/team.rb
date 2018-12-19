class Team

  attr_accessor :team_id,
                :franchiseId,
                :shortName,
                :teamName,
                :abbreviation,
                :link

  def initialize(team_info)
    @teamid = team_info[:team_id]
    @franchiseId = team_info[:franchiseid]
    @shortName = team_info[:shortname]
    @teamName = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]

  end

  # def team_info(teamid)
  #   info_info = {}
  #     team_info[@team[teamid]] = @team.values
  #     team_info
  # end

end
