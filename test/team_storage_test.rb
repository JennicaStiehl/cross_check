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

    assert_equal "/api/v1/teams/1", stat_tracker.team_storage.teams[1].link
    assert_equal "New Jersey", stat_tracker.team_storage.teams[1].shortName
    assert_equal "Devils", stat_tracker.team_storage.teams[1].teamName
  end

  def test_it_can_return_team_info
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    expected = ({:teamid=>"1", :franchiseid=>"23", :shortname=>"New Jersey", :teamname=>"Devils", :abbreviation=>"NJD", :link=>"/api/v1/teams/1"})
    assert_equal expected, stat_tracker.team_storage.team_info(1)
  end

end
