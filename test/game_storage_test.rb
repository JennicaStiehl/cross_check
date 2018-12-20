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
    game_storage = GameStorage.new
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal ([]), stat_tracker.parse_games('./data/sample_game.csv').all
  end

  def test_it_can_print_game_info
    game_storage = GameStorage.new
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    expected = ({1=>["23", "New Jersey", "Devils", "NJD", "/api/v1/games/1"]})
    assert_equal expected, stat_tracker.parse_games('./data/sample_game.csv').data
  end
end
