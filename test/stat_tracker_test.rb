require './test/test_helper'
require './lib/stat_tracker'
require './lib/team'
require './lib/game'
require './lib/game_team'
require './lib/team_storage'
require './lib/game_storage'
require './lib/game_team_storage'
require './lib/game_stats_module'

class StatTrackerTest < Minitest::Test

  def setup
    @stat_tracker = StatTracker.new
    @get_team_info = @stat_tracker.parse_teams('./data/sample_team_info.csv')
    @get_game_info = @stat_tracker.parse_games('./data/sample_game.csv')
    @get_game_teams_info = @stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    # @team_storage = TeamStorage.new
    # @team_info_1 = {:team_id => 1, :franchiseid => 23, :shortname => "New Jersey",
    #       :teamname => "Devils", :abbreviation => "NJD", :link => "/api/v1/teams/1"}
    # @team_1 = Team.new(@team_info_1)
    # @team_4 = Team.new(@team_info)
    # @team_14 = Team.new(@team_info)
    # @team_26 = Team.new(@team_info)
    # @team_storage.add_team(@team_1)
    # @team_storage.add_team(@team_4)
    # @team_storage.add_team(@team_14)
    # @team_storage.add_team(@team_26)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_works_for_sample_team_info_file
    assert_equal "NJD", @stat_tracker.teams[1].abbreviation
  end

  def test_it_works_for_sample_game_info
    assert_equal "20122013", @stat_tracker.games[2012030221].season
  end

  def test_it_works_for_sample_game_team_info
    assert_equal "away", @stat_tracker.game_teams[3].HoA
  end

  # def test_it_works_for_sample_game_info_file
  #skip
  #   stat_tracker = StatTracker.new
  #   stat_tracker.parse_teams('./data/sample_game.csv')
  #   expected = ({2012030221=>["20122013", "P", "2013-05-16", "3", "6", "2", "3", "home win OT", "left", "TD Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil], 2012030222=>["20122013", "P", "2013-05-19", "3", "6", "2", "5", "home win REG", "left", "TD Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil], 2012030223=>["20122013", "P", "2013-05-21", "6", "3", "2", "1", "away win REG", "right", "Madison Square Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil], 2012030224=>["20122013", "P", "2013-05-23", "6", "3", "3", "4", "home win OT", "right", "Madison Square Garden", "/api/v1/venues/null", "America/New_York", "-4", "EDT", nil]})
  #
  #   assert_equal expected, stat_tracker.parse_games('./data/sample_game.csv')
  # end
  #
  # def test_it_works_for_sample_game_team_info_file
  #   skip
  #   stat_tracker = StatTracker.new
  #   stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
  #   expected = ({"2012030221_3"=>["3", "away", "FALSE", "OT", "John Tortorella", "2", "35", "44", "8", "3", "0", "44.8", "17", "7", nil], "2012030221_6"=>["6", "home", "TRUE", "OT", "Claude Julien", "3", "48", "51", "6", "4", "1", "55.2", "4", "5", nil], "2012030222_3"=>["3", "away", "FALSE", "REG", "John Tortorella", "2", "37", "33", "11", "5", "0", "51.7", "1", "4", nil], "2012030222_6"=>["6", "home", "TRUE", "REG", "Claude Julien", "5", "32", "36", "19", "1", "0", "48.3", "16", "6", nil]})
  #   assert_equal expected, stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
  # end

  def test_for_highest_total_score
    assert_equal 5, @stat_tracker.highest_score
  end

  def test_it_can_calculate_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

end
