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



end
