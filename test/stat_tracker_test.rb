require './test/test_helper'
require './lib/stat_tracker'
require './lib/team'
require './lib/game'
require './lib/game_team'
require './lib/team_storage'
require './lib/game_storage'
require './lib/game_team_storage'
require './lib/game_stats'

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
    # skip
    assert_equal "NJD", @stat_tracker.teams[1].abbreviation
  end

  def test_it_works_for_sample_game_info
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal "20122013", stat_tracker.games[2012030221].season
  end

  def test_it_works_for_sample_game_team_info
    # skip
    assert_equal "away", @stat_tracker.game_teams.values[2].HoA
  end

  def test_for_highest_total_score
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 7, stat_tracker.highest_total_score
  end

  def test_for_highest_score
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal 6, stat_tracker.highest_score
  end

  def test_it_can_get_goal_diff
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    assert_equal 3, stat_tracker.goal_differiential("4", "7", "3")
  end



  def test_it_can_calculate_biggest_blowout
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 3, stat_tracker.biggest_blowout
  end

  def test_it_can_calculate_biggest_team_blowout
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 10, stat_tracker.biggest_team_blowout("3")
  end

  def test_it_can_calculate_best_season
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal "20152016", stat_tracker.best_season(stat_tracker.games, "3")
  end

  def test_it_can_calculate_worst_season
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal "20122013", stat_tracker.worst_season(stat_tracker.games, "3")
  end

  def test_it_can_count_wins_by_season
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal ({"20122013"=>4, "20152016"=>5}), stat_tracker.wins_by_season(stat_tracker.games, "3")
  end

  def test_it_can_calculate_percentage_wins
    # skip
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
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Rangers", stat_tracker.get_team_name_from_id("3")
  end
  #
  def test_it_can_find_highest_scoring_home_team
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/game.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "Bruins", stat_tracker.highest_scoring_home_team
  end
  #
  #
  def test_it_can_calculate_percentage_home_wins
    assert_equal 0.8, @stat_tracker.percentage_home_wins
  end
  #
  def test_it_can_calculate_percentage_vistor_wins
    assert_equal 0.2, @stat_tracker.percentage_visitor_wins
  end
  #
  def test_it_can_calculate_season_with_most_games
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal 20122013, stat_tracker.season_with_most_games
  end

  def test_it_can_create_hash_by_season
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal 4, stat_tracker.create_hash_by_season.keys.count
  end

  def test_it_can_calculate_season_with_fewest_games
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    assert_equal 20162017, stat_tracker.season_with_fewest_games
  end

  def test_it_can_get_count_of_games_by_season
    # skip

    assert_equal ({"20122013" => 5}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_get_count_of_teams
    # skip

    assert_equal 7, @stat_tracker.count_of_teams
  end

  def test_it_can_group_game_teams_by_team_id
    # skip

    assert_equal 3, @stat_tracker.group_game_teams_by_team_id.keys.count
    #count number of team_ids
    assert_equal 6, @stat_tracker.group_game_teams_by_team_id["3"].count
    #count number of game_team objects associated with team_id "3"
  end

  def test_it_calculates_game_win_percentage
    # skip

    assert_equal ({"3"=>0.16666666666666666, "6"=>1.0, "5"=>0.75}), @stat_tracker.game_win_percentage
  end

  def test_it_can_calculate_the_winningest_team
    # skip

    assert_equal "Bruins", @stat_tracker.winningest_team
  end

  def test_home_game_count
    # skip
    teams_grouped_by_team_id = @stat_tracker.group_game_teams_by_team_id

    assert_equal 2, @stat_tracker.home_game_count(teams_grouped_by_team_id, "3")
  end

  def test_home_game_win_count
    # skip
    teams_grouped_by_team_id = @stat_tracker.group_game_teams_by_team_id

    assert_equal 0, @stat_tracker.home_game_win_count(teams_grouped_by_team_id, "3")
  end

  def away_game_count
    # skip
    teams_grouped_by_team_id = @stat_tracker.group_game_teams_by_team_id

    assert_equal 4, @stat_tracker.away_game_count(teams_grouped_by_team_id, "3")
  end

  def test_away_game_win_count
    # skip
    teams_grouped_by_team_id = @stat_tracker.group_game_teams_by_team_id

    assert_equal 1, @stat_tracker.away_game_win_count(teams_grouped_by_team_id, "3")
  end

  def test_it_can_calculate_best_fans
    # skip

    assert_equal "Bruins", @stat_tracker.best_fans
  end

  def test_it_can_calculate_worst_fans
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/worst_fans_sample_game_teams_stats.csv')
    stat_tracker.parse_games('./data/worst_fans_sample_game.csv')
    stat_tracker.parse_teams('./data/worst_fans_sample_team_info.csv')

    assert_equal ["Rangers", "Bruins"], stat_tracker.worst_fans
  end

  def test_it_can_find_lowest_scoring_home_team
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/game.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "Rangers", stat_tracker.lowest_scoring_home_team
  end


  def test_it_can_find_lowest_scoring_visitor
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal "Rangers", stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_find_most_goals_in_a_game
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal 7, stat_tracker.highest_total_score
  end

  def test_it_can_find_least_goals_in_a_game
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal 3, stat_tracker.lowest_total_score
  end

  def test_it_can_represent_head_to_head
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    expected = ({["Rangers"]=>["1:5"], ["Flyers"]=>["0:0"]})
    assert_equal expected, stat_tracker.head_to_head("3","4")
  end

  def test_it_can_count_losses
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    assert_equal 5, stat_tracker.losses("3")
  end

  def test_it_can_count_wins
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game.csv')

    assert_equal 1, stat_tracker.wins("3")
  end


  def test_for_most_popular_venue
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')
    assert_equal "United Center", stat_tracker.most_popular_venue
  end

  def test_for_least_popular_venue
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal "Scotiabank Place", stat_tracker.least_popular_venue
  end

  def test_for_average_goals_per_game
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal 4.98, stat_tracker.average_goals_per_game
  end

  def test_it_can_get_a_team_record
    # skip
    assert_equal 3, @stat_tracker.team_record("6").count
  end

  def test_it_can_find_most_goals_scored
    # skip

    assert_equal 6, @stat_tracker.most_goals_scored("6")
  end

  def test_it_can_find_fewest_goals_scored
    # skip

    assert_equal 0, @stat_tracker.fewest_goals_scored("3")
  end

  def test_it_can_calculate_worst_loss
    # skip

    assert_equal 5, @stat_tracker.worst_loss("3")
  end

  def test_it_can_calculate_average_win_percentage
    # skip

    assert_equal 0.17, @stat_tracker.average_win_percentage("3")
  end

  def test_it_can_sum_goals_scored
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = 16
    assert_equal expected, stat_tracker.goals_scored("3","20122013")
  end


  def test_it_can_sum_goals_against
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = 12
    assert_equal expected, stat_tracker.goals_against("3","20122013")
  end

  def test_it_can_sum_wins
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = 4#({"P"=>{6=>4, 3=>1}})
    assert_equal expected, stat_tracker.total_wins("3","20122013")
  end

  def test_it_can_count_games
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = 7
    assert_equal expected, stat_tracker.total_game_count("3","20122013")
  end

  def test_it_can_summarize_seasons
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = ({"20122013"=>
                  {"P"=>{
                    :win_percentage=>0.57,
                    :goals_scored=>16,
                    :goals_against=>12}}})
    assert_equal expected, stat_tracker.season_summary("3","20122013")
  end

  def test_it_can_give_a_seasonal_summary
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = ({"20122013"=>{"P"=>
      {:win_percentage=>0.57,
        :goals_scored=>16,
        :goals_against=>12}},
        "20142015"=>{"P"=>
          {:win_percentage=>0.0,
            :goals_scored=>0,
            :goals_against=>0}},
            "20152016"=>{"P"=>
              {:win_percentage=>0.25,
                :goals_scored=>7,
                :goals_against=>15}},
                "20162017"=>{"P"=>
                  {:win_percentage=>0.0,
                    :goals_scored=>0,
                    :goals_against=>0}}}
                    )
    assert_equal expected, stat_tracker.seasonal_summary("3")
  end

  def test_it_can_list_seasons
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_seasons.csv')

    expected = ["20122013", "20162017", "20142015", "20152016"]
    assert_equal expected, stat_tracker.all_seasons
  end

  def test_it_can_sort_teams_by_team_id
    # skip
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

  assert_equal ["3", "6", "5"], stat_tracker.sort_teams_by_team_id
  end

  def test_it_can_create_a_team_to_goals_hash
    # skip
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

  assert_equal ({"3" => 0, "6" => 0, "5" => 0}), stat_tracker.create_team_to_goals_hash
  end

  def test_it_can_add_goals_to_team_to_goals_hash
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal ({"3" => 12, "6" => 14, "5" => 15}), stat_tracker.add_goals_to_team_to_goals_hash
  end

  def test_it_can_create_a_hash_of_number_of_games_played
    # skip
  stat_tracker = StatTracker.new
  stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

  assert_equal ({"3" => 0, "5" => 0, "6" => 0}), stat_tracker.create_hash_of_games_played
  end

  def test_it_can_add_games_to_games_played_by_team_hash
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal ({"3" => 6, "6" => 3, "5" => 4}), stat_tracker.add_games_to_games_played_by_team
  end

  def test_it_can_average_team_goals_across_all_seasons
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')

    assert_equal ({"3" => 2.0, "6" => 4.67, "5" => 3.75}), stat_tracker.average_team_goals_across_all_seasons
  end

  def test_it_can_calculate_best_offense
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "Bruins", stat_tracker.best_offense
  end

  def test_it_can_calculate_worst_offense
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/sample_game_teams_stats.csv')
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "Rangers", stat_tracker.worst_offense
  end

  def test_for_average_goals_per_game_per_season
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal ({"20122013" => 249}), stat_tracker.average_goals_per_game_per_season
  end

  def test_for_average_goals_by_season
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/longer_sample_game.csv')

    assert_equal ({"20122013" => 4.98}), stat_tracker.average_goals_by_season
  end

  def test_to_create_game_teams_variable
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal ["2012030221", "2012030222"], stat_tracker.game_teams_variable.keys
  end

  def test_to_create_game_teams_hash_for_best_worst_defense
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal ({"3" => 0, "6" => 0}), stat_tracker.create_game_teams_hash
  end

  def test_it_can_populate_game_teams_hash_with_scores
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal ({"3" => 8, "6" => 4}), stat_tracker.add_scores_to_game_teams_hash
  end

  def test_for_best_defense
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal "Bruins", stat_tracker.best_defense
  end

  def test_for_worst_defense
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_game_teams('./data/shorter_sample_game_teams_stats.csv')

    assert_equal "Rangers", stat_tracker.worst_defense
  end

  def test_it_can_create_a_preseason_game_hash
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 5, stat_tracker.preseason_game_hash(stat_tracker.games, "20122013").length
  end

  def test_it_can_create_a_regular_season_hash
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 10, stat_tracker.regular_season_game_hash(stat_tracker.games, "20122013").length
  end

  def test_to_create_team_id_array
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal ["6", "3", "12", "2", "14", "10", "1", "8"], stat_tracker.create_team_id_array(stat_tracker.games, "20122013")
  end

  # def test_that_team_has_pre_and_regular_season_games
  #   skip
  #   stat_tracker = StatTracker.new
  #   stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')
  #
  #   assert_equal [], stat_tracker.check_for_pre_and_regular_season_games("20122013")
  # end

  def test_for_biggest_bust
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal "Bruins", stat_tracker.biggest_bust("20122013")
  end

  def test_for_biggest_surprise
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal "Rangers", stat_tracker.biggest_surprise("20122013")
  end

  def test_it_can_get_team_id_from_team_name
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')

    assert_equal "16", stat_tracker.team_id_from_team_name("Blackhawks")
  end

  def test_to_create_array_of_losses
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 6, stat_tracker.array_of_losses("3").length
  end

  def test_to_create_array_of_opponents
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 6, stat_tracker.array_of_opponents("3", stat_tracker.array_of_losses("3")).length
  end

  def test_for_rival
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal "Blackhawks", stat_tracker.rival("Lightning")
  end

  def test_to_create_array_of_wins
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal 6, stat_tracker.array_of_wins("3").length
  end

  def test_for_favorite_opponent
    # skip
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/team_info.csv')
    stat_tracker.parse_games('./data/sample_game_with_pre_reg_season_stats.csv')

    assert_equal "Maple Leafs", stat_tracker.favorite_opponent("Rangers")
  end

  def test_it_can_return_team_info
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')

    # expected = ({"abbreviation" => "NJD","teamid" => "1", "franchiseid" => "23", "shortname" => "", "teamname" => "Devils",  "link" =>"/api/v1/teams/1"})
    expected = ({"abbreviation"=>"NJD", "franchise_id"=>"23", "link"=>"/api/v1/teams/1", "short_name"=>"New Jersey", "team_id"=>"1", "team_name"=>"Devils"})
    assert_equal expected, stat_tracker.team_info(1)
  end
end
