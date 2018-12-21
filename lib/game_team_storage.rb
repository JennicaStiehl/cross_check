require './lib/storage'

class GameTeamStorage #< Storage
  attr_accessor   :game_team_storage,
                  :game_teams

  def initialize
    @game_teams = {}
  end

  def add_game_team(game_team)
    @game_teams[game_team.team_id.to_i] = game_team
    @game_teams
  end

end
