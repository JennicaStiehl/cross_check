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
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal ([]), stat_tracker.data
  end

end
