require './lib/storage'

class GameStorage < Storage
  attr_accessor   :data

  def initialize
    @data = {}
  end

  def add_game(game)
    @data[game.game_id.to_i] = game
    @data
  end

#commented out due to inheriting from storage class
  # def all
  #   @data.values
  # end

  def game_info(gameid)
    game_info = {}
      game_info[@data[game_id]] = all
      game_info
  end

end
