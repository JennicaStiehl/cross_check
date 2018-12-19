require './test/test_helper'
require './lib/game'
require './lib/stat_tracker'

class GameTest < Minitest::Test

  def test_it_exists
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    game = Game.new(stat_tracker.games)
    assert_instance_of Game, game
  end

  def test_it_can_print_game_info
    skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    game = Game.new(stat_tracker.games)

    expected = 
    assert_equal expected, game.game_info(1)
  end
end
