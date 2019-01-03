require './test/test_helper'
require './lib/game'
require './lib/stat_tracker'
require './lib/game_stats'

class GameTest < Minitest::Test

  def setup
    @stat_tracker = StatTracker.new
    @stat_tracker.parse_games('./data/sample_game.csv')
    @game = Game.new(@stat_tracker.games)
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

end
