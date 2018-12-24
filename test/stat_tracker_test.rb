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
    @get_game_season_info = @stat_tracker.parse_games('./data/sample_game_seasons.csv')
    @get_game_teams_info = @stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    @game_1 = mock("game")
    @game_teams_1 = mock("game_teams")
    @team_1 = mock("teams")
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_works_for_sample_team_info_file
    assert_equal "NJD", @stat_tracker.teams[1].abbreviation
  end

  def test_it_works_for_sample_game_info
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal "20122013", stat_tracker.games[2012030221].season
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
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 3, stat_tracker.biggest_blowout
  end

  def test_it_can_search_any_collection_by_id
    skip
    assert_equal @game_1, @stat_tracker.search_any_collection_by_id(@stat_tracker.games, 2012030166)
  end

  def test_it_can_search_any_collection_by_id_2
    skip
    assert_equal @game_teams_1, @stat_tracker.search_any_collection_by_id(@stat_tracker.game_teams, 3)
  end

  def test_it_can_search_any_collection_by_id_3
    skip
    assert_equal @team_1, @stat_tracker.search_any_collection_by_id(@stat_tracker.teams, 1)
  end

  def test_it_can_calculate_best_season
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal "20152016", stat_tracker.best_season(stat_tracker.games, "3")
  end

  def test_it_can_calculate_worst_season
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal "20122013", stat_tracker.worst_season(stat_tracker.games, "3")
  end

  def test_it_can_find_home_team_goals
    skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_game.csv')

    assert_equal 5, stat_tracker.find_home_team_goals_from_games(stat_tracker.games,"3")
  end

  def test_it_can_count_wins
    assert_equal ({"20122013"=>4, "20152016"=>5}), @stat_tracker.wins_by_season(@stat_tracker.games, "3")
  end

  def test_it_can_calculate_percentage_wins
    stat_tracker = StatTracker.new
    get_game_info = stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 20.0, stat_tracker.win_percentage(stat_tracker.games, "3")
  end

  def test_it_can_collect_seasons_list
    skip
    assert_equal ["20122013", "20122013", "20122013", "20122013"], @stat_tracker.seasons(@stat_tracker.games, "3")
  end

  def test_it_can_find_highest_scoring_visitor
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Rangers", stat_tracker.get_team_name_from_id("3")
    assert_equal "Bruins", stat_tracker.highest_scoring_visitor
  end

  def test_it_can_find_highest_scoring_home_team
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Bruins", stat_tracker.highest_scoring_home_team
  end

  def test_it_can_find_lowest_scoring_home_team
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Rangers", stat_tracker.lowest_scoring_home_team
  end

  def test_it_can_find_lowest_scoring_visitor
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Rangers", stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_find_most_goals_in_a_game
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal 7, stat_tracker.highest_total_score
  end

  def test_it_can_find_least_goals_in_a_game
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal 3, stat_tracker.lowest_total_score
  end
end
