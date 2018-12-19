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
    skip
  stat_tracker = StatTracker.new
  stat_tracker.parse_teams('./data/sample_team_info.csv')
  expected = ({1=>["23", "New Jersey", "Devils", "NJD", "/api/v1/teams/1"], 4=>["16", "Philadelphia", "Flyers", "PHI", "/api/v1/teams/4"], 26=>["14", "Los Angeles", "Kings", "LAK", "/api/v1/teams/26"], 14=>["31", "Tampa Bay", "Lightning", "TBL", "/api/v1/teams/14"]})
  assert_equal expected, stat_tracker.parse_teams('./data/sample_team_info.csv')
  end

  def test_it_works_for_sample_game_info_file
    # skip
  stat_tracker = StatTracker.new
  stat_tracker.parse_teams('./data/sample_game.csv')
  expected = ({2012030221=>["20122013", "P", "2013-05-16", "3", "6", "2", "3", "home win OT", "left", "TD Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil], 2012030222=>["20122013", "P", "2013-05-19", "3", "6", "2", "5", "home win REG", "left", "TD Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil], 2012030223=>["20122013", "P", "2013-05-21", "6", "3", "2", "1", "away win REG", "right", "Madison Square Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil], 2012030224=>["20122013", "P", "2013-05-23", "6", "3", "3", "4", "home win OT", "right", "Madison Square Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil]})

  assert_equal expected, stat_tracker.parse_games('./data/sample_game.csv')
  end

  def test_it_works_for_sample_game_team_info_file
    # skip
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
  expected = ({"2012030221_3"=>["3", "away", "FALSE", "OT", "John Tortorella", "2", "35", "44", "8", "3", "0", "44.8", "17", "7", nil], "2012030221_6"=>["6", "home", "TRUE", "OT", "Claude Julien", "3", "48", "51", "6", "4", "1", "55.2", "4", "5", nil], "2012030222_3"=>["3", "away", "FALSE", "REG", "John Tortorella", "2", "37", "33", "11", "5", "0", "51.7", "1", "4", nil], "2012030222_6"=>["6", "home", "TRUE", "REG", "Claude Julien", "5", "32", "36", "19", "1", "0", "48.3", "16", "6", nil]})
  assert_equal expected, stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
  end

end
