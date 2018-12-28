require './lib/storage'

class GameStorage #< Storage
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
