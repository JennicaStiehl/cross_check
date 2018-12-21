require './test/test_helper'
require './lib/game_storage'
require './lib/storage'
require './lib/stat_tracker'

class GameStorageTest < Minitest::Test

  def test_it_exists
    game_storage = GameStorage.new
    assert_instance_of GameStorage, game_storage
  end

  def test_it_can_get_all_of_the_game_data
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal "P", stat_tracker.games[2012030221].type
    assert_equal "2012030221", stat_tracker.games[2012030221].game_id
    assert_equal "3", stat_tracker.games[2012030221].home_goals
    assert_equal "2", stat_tracker.games[2012030221].away_goals
  end


end
