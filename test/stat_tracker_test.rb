require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
# require './data/sample_team_info.csv'

class StatTrackerTest < Minitest::Test

  def test_it_exists
    stat_tracker = StatTracker.new

    assert_instance_of StatTracker, stat_tracker
  end


  def test_it_works_for_sample_team_info_file
  stat_tracker = StatTracker.new
  stat_tracker.parse_teams('./data/sample_team_info.csv')
  expected = ({1=>["23", "New Jersey", "Devils", "NJD", "/api/v1/teams/1"], 4=>["16", "Philadelphia", "Flyers", "PHI", "/api/v1/teams/4"], 26=>["14", "Los Angeles", "Kings", "LAK", "/api/v1/teams/26"], 14=>["31", "Tampa Bay", "Lightning", "TBL", "/api/v1/teams/14"]})
  assert_equal expected, stat_tracker.parse_teams('./data/sample_team_info.csv')
  end
end
