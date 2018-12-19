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
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    game = Game.new(stat_tracker.games)

    expected = ["20122013", "P", "2013-05-16", "3", "6", "2", "3", "home win OT", "left", "TD Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil]
    assert_equal expected, game.game_info(2012030221)
  end
end
