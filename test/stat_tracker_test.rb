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
    # get_game_info =
    stat_tracker.parse_games('./data/sample_game.csv')

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
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal 20162017, stat_tracker.season_with_fewest_games
  end

  def test_it_can_get_count_of_games_by_season

    assert_equal ({20122013 => 5}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_get_count_of_teams

    assert_equal 7, @stat_tracker.count_of_teams
  end

  def test_it_can_calculate_the_winningest_team
    assert_equal "Bruins", @stat_tracker.winningest_team
  end

  def test_it_can_calculate_best_fans
    assert_equal "Bruins", @stat_tracker.best_fans
  end

  def test_it_can_calculate_worst_fans
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/longer_sample_game_teams_stats.csv')
    stat_tracker.parse_games('./data/game.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal ["Rangers", "Bruins"], stat_tracker.worst_fans
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

    assert_equal 0.17, @stat_tracker.average_win_percentage("3")
  end

  def test_it_can_sum_goals_scored
    skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/game.csv')

    assert_equal ({}), stat_tracker.goals_scored
  end

  def test_it_can_summarize_seasons
    skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/game.csv')

    expected = ({
      "P"=>{
        :win_percentage => 0.25,
        :goals_scored => 0,
        :goals_against => 10
      },
      "R"=>{
        :win_percentage => 0.25,
        :goals_scored => 0,
        :goals_against => 10
        }})
    assert_equal expected, stat_tracker.season_summary(collection = @games, "3")
  end

  def test_it_can_sort_teams_by_team_id
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

  assert_equal ["3", "6", "5"], stat_tracker.sort_teams_by_team_id
  end

  def test_it_can_create_a_team_to_goals_hash
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

  assert_equal ({"3" => 0, "6" => 0, "5" => 0}), stat_tracker.create_team_to_goals_hash
  end

  def test_it_can_add_goals_to_team_to_goals_hash
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal ({"3" => 12, "6" => 14, "5" => 15}), stat_tracker.add_goals_to_team_to_goals_hash
  end

  def test_it_can_create_a_hash_of_number_of_games_played
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

  assert_equal ({"3" => 0, "5" => 0, "6" => 0}), stat_tracker.create_hash_of_games_played
  end

  def test_it_can_add_games_to_games_played_by_team_hash
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal ({"3" => 6, "6" => 3, "5" => 4}), stat_tracker.add_games_to_games_played_by_team
  end

  def test_it_can_average_team_goals_across_all_seasons
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal ({"3" => 2, "6" => 4, "5" => 3}), stat_tracker.average_team_goals_across_all_seasons
  end

  def test_it_can_calculate_best_offense
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "Bruins", stat_tracker.best_offense
  end

  def test_it_can_calculate_worst_offense
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "Rangers", stat_tracker.worst_offense
  end

  def test_for_average_goals_per_game_per_season
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal ({"20122013" => 249}), stat_tracker.average_goals_per_game_per_season
  end

  def test_for_average_goals_by_season
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal ({20122013 => 4}), stat_tracker.average_goals_by_season
  end

  def test_to_create_game_teams_variable
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal ["2012030221", "2012030222"], stat_tracker.game_teams_variable.keys
  end

  def test_to_create_game_teams_hash_for_best_worst_defense
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal ({"3" => 0, "6" => 0}), stat_tracker.create_game_teams_hash
  end

  def test_it_can_populate_game_teams_hash_with_scores
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal ({"3" => 8, "6" => 4}), stat_tracker.add_scores_to_game_teams_hash
  end

  def test_for_best_defense
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal "Bruins", stat_tracker.best_defense
  end

  def test_for_worst_defense
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal "Rangers", stat_tracker.worst_defense
  end

  def test_it_can_create_a_preseason_game_hash
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 5, stat_tracker.preseason_game_hash("20122013").length
  end

  def test_it_can_create_a_regular_season_hash
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 10, stat_tracker.regular_season_game_hash("20122013").length
  end

  def test_for_biggest_bust
    skip

    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal "Bruins", stat_tracker.biggest_bust("20122013")
  end

end
