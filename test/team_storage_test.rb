require './test/test_helper'
require './lib/team_storage'
require './lib/storage'
require './lib/stat_tracker'

class TeamStorageTest < Minitest::Test

  def test_it_exists
    team_storage = TeamStorage.new
    assert_instance_of TeamStorage, team_storage
  end

  def test_it_can_get_all_of_the_team_data
    team_storage = TeamStorage.new
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal ([]), stat_tracker.parse_teams('./data/sample_team_info.csv').all
  end

  def test_it_can_print_team_info
    team_storage = TeamStorage.new
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    expected = ({1=>["23", "New Jersey", "Devils", "NJD", "/api/v1/teams/1"]})
    assert_equal expected, stat_tracker.parse_teams('./data/sample_team_info.csv').data
  end
end
