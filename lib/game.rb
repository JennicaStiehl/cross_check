class Game

  def initialize(games)
    @games = games
  end

  def game_info(game_id)
    @games[game_id]
  end

  

end
