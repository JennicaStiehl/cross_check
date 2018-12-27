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

    assert_equal "away", @stat_tracker.game_teams.values[2].HoA
  end

  def test_for_highest_total_score
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 7, stat_tracker.highest_total_score
  end

  def test_for_highest_score
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal 6, stat_tracker.highest_score
  end

  def test_it_can_calculate_biggest_blowout
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 3, stat_tracker.biggest_blowout
  end

  def test_it_can_calculate_biggest_team_blowout
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 3, stat_tracker.biggest_team_blowout("3")
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

  def test_it_can_count_wins_by_season
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal ({"20122013"=>4, "20152016"=>5}), stat_tracker.wins_by_season(stat_tracker.games, "3")
  end

  def test_it_can_calculate_percentage_wins
    stat_tracker = StatTracker.new
    get_game_info = stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 20.0, stat_tracker.win_percentage(stat_tracker.games, "3")
  end

  def test_it_can_find_highest_scoring_visitor
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Bruins", stat_tracker.highest_scoring_visitor
  end

  def test_it_can_get_team_name_from_id

    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Rangers", stat_tracker.get_team_name_from_id("3")
  end

  def test_it_can_find_highest_scoring_home_team
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Bruins", stat_tracker.highest_scoring_home_team
  end


  def test_it_can_calculate_percentage_home_wins
    @stat_tracker
    @get_game_info

    assert_equal 0.8, @stat_tracker.percentage_home_wins
  end

  def test_it_can_calculate_percentage_vistor_wins

    assert_equal 0.2, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_calculate_season_with_most_games
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal 20122013, stat_tracker.season_with_most_games
  end

  def test_it_can_create_hash_by_season
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal 4, stat_tracker.create_hash_by_season.keys.count
  end

  def test_it_can_calculate_season_with_fewest_games

    assert_equal 20122013, @stat_tracker.season_with_fewest_games
  end

  def test_it_can_get_count_of_games_by_season


    assert_equal ({20122013 => 5}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_get_count_of_teams
    @stat_tracker
    @get_team_info

    assert_equal 7, @stat_tracker.count_of_teams
  end

  def test_it_can_calculate_the_winningest_team

    assert_equal "Bruins", @stat_tracker.winningest_team
  end

  def test_it_can_calculate_best_fans

    assert_equal "Bruins", @stat_tracker.best_fans
  end

  def test_it_can_calculate_worst_fans

    assert_equal [], @stat_tracker.worst_fans
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

  def test_it_can_represent_head_to_head
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    expected = ({["Rangers"]=>["1:5"], ["Flyers"]=>["0:0"]})
    assert_equal expected, stat_tracker.head_to_head("3","4")
  end

  def test_it_can_count_losses
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal 5, stat_tracker.losses("3")
  end

  def test_it_can_count_wins
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 1, stat_tracker.wins("3")
  end


  def test_for_most_popular_venue
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')
    assert_equal "United Center", stat_tracker.most_popular_venue
  end

  def test_for_least_popular_venue
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal "Scotiabank Place", stat_tracker.least_popular_venue
  end

  def test_for_average_goals_per_game
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal 4.98, stat_tracker.avg_goals_per_game
  end
  #Erin's iteration 4
  def test_it_can_find_most_goals_scored

    assert_equal 6, @stat_tracker.most_goals_scored("6")
  end

  def test_it_can_find_fewest_goals_scored

    assert_equal 0, @stat_tracker.fewest_goals_scored("3")
  end

  def test_it_can_calculate_worst_loss

    assert_equal 5, @stat_tracker.worst_loss("3")
  end

  def test_it_can_calculate_average_win_percentage
    skip
    assert_equal 0.5, @stat_tracker.average_win_percentage("3")
  end
end
