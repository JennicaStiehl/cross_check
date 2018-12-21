require 'pry'
class Team

  attr_accessor :teamid,
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

#tested on team storage
  def team_info
    team_info = {}
    team_info[:teamid] = @teamid
    team_info[:franchiseid] = @franchiseId
    team_info[:shortname] = @shortName
    team_info[:teamname] = @teamName
    team_info[:abbreviation] = @abbreviation
    team_info[:link] = @link
    team_info
  end
end
