require './test/test_helper'
require './lib/game_team'
require './lib/stat_tracker'

class GameTeamTest < Minitest::Test

  def test_it_exists
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    game_team = GameTeam.new(stat_tracker.game_teams)
    assert_instance_of GameTeam, game_team
  end


end
