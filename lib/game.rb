class Game

  def initialize(game)
    @game = game
  end

  def game_info(gameid)
    info_info = {}
      game_info[@game[gameid]] = @game.values
      game_info
  end



end
