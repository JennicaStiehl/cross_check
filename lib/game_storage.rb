require_relative './stat_tracker'
require_relative './team_storage'

class GameStorage

  attr_reader :games

  attr_accessor   :games,
                  :game_storage

  def initialize
    @games = {}
  end

  def add_game(game)
    @games[game.game_id.to_i] = game
    @games
  end

end
