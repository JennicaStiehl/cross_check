require './test/test_helper'
require './lib/game_team_storage'
require './lib/game_team'
require './lib/stat_tracker'

class GameTeamStorageTest < Minitest::Test

  def test_it_exists
    game_team_storage = GameTeamStorage.new
    assert_instance_of GameTeamStorage, game_team_storage
  end

  def test_it_can_get_game_team_data
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal "2012030222", stat_tracker.game_teams[3].game_id
    assert_equal "John Tortorella", stat_tracker.game_teams[3].head_coach
    assert_equal "Claude Julien", stat_tracker.game_teams[6].head_coach
  end

end
