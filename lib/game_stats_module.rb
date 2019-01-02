require 'pry'
require './lib/game'
require './lib/game_storage'
require './lib/stat_tracker'

module GameStats

  def biggest_blowout#win; maybe game_team & use win/lose column
    blowout = @games.values.max_by do |game|
      (game.away_goals.to_i - game.home_goals.to_i).abs
    end
    (blowout.away_goals.to_i - blowout.home_goals.to_i).abs
  end

  def biggest_team_blowout(team_id)#win
    blowout = @games.values.max_by do |game|
      if game.home_team_id == team_id || game.away_team_id == team_id
        (game.away_goals.to_i - game.home_goals.to_i).abs
      end
    end
    (blowout.away_goals.to_i - blowout.home_goals.to_i).abs
  end

  def best_season(collection = @games, team_id)
    wins = wins_by_season(collection, team_id)
    best = wins.max_by do |season, num_wins|
      num_wins
    end
    best = best[1]
    wins.key(best)
  end

  def worst_season(collection = @games, team_id)
    wins = wins_by_season(collection, team_id)
    worst = wins.min_by do |season, num_wins|
      num_wins
    end
    worst = worst[1]
    wins.key(worst)
  end

  def wins(collection = @games, team_id)
    wins = 0
    collection.values.each do |game|
      if (game.outcome.include?("home win") && game.home_team_id == team_id) || (game.outcome.include?("away win") && game.away_team_id == team_id)
        wins += 1
      end
    end
    wins
  end

  def losses(collection = @games, team_id)
    loses = 0
    collection.values.each do |game|
      if (game.outcome != "home win" && game.home_team_id == team_id) || (game.outcome != "away win" && game.away_team_id == team_id)
        loses += 1
      end
    end
    loses
  end

  def wins_by_season(collection = @games, team_id)
    wins = 0
    wins_by_season = {}
    collection.values.each do |game|
      if (game.outcome.include?("home win") && game.home_team_id == team_id) || (game.outcome.include?("away win") && game.away_team_id == team_id)
        wins_by_season[game.season] = (wins += 1)
      end
    end
    wins_by_season
  end

  def win_percentage(collection = @games, team_id)
    wins = wins(collection, team_id)
    total_games = collection.values.count do |game|
      game.game_id.to_i
    end
    (wins.to_f / total_games.to_f) * 100
  end

  # def find_home_team_goals_from_games(collection = @games, team_id)
  #   goals = 0
  #   collection.values.find_all do |game|
  #     if game.home_team_id == team_id
  #       goals += game.home_goals.to_i
  #     end
  #   end
  #   goals
  # end

  def percentage_home_wins
    total_games_played = @games.keys.count
    total_home_games_won = @games.values.select do |game|
      game.outcome.include?("home")
    end
    total_home_games_won.count.to_f / total_games_played.to_f
  end

  def percentage_visitor_wins
    total_games_played = @games.keys.count
    total_visitor_games_won = @games.values.select do |game|
      game.outcome.include?("away")
    end
    total_visitor_games_won.count.to_f / total_games_played.to_f
  end

  def create_hash_by_season
    total_games_by_season = @games.values.group_by do |game|
      game.season
    end
    total_games_by_season
  end

  def season_with_most_games
    season_with_most_games = create_hash_by_season.keys.max do |season_1, season_2|
      create_hash_by_season[season_1].count <=> create_hash_by_season[season_2].count
    end
    season_with_most_games.to_i
  end

  def season_with_fewest_games
    season_with_fewest_games = create_hash_by_season.keys.min do |season_1, season_2|
      create_hash_by_season[season_1].count <=> create_hash_by_season[season_2].count
    end
    season_with_fewest_games.to_i
  end

  def count_of_games_by_season
    count_of_games_by_season = {}
    total_games_by_season = @games.values.group_by do |game|
      game.season
    end
    total_games_by_season.keys.each do |season|
      count_of_games_by_season.store(season.to_i, total_games_by_season[season].count)
    end
    count_of_games_by_season
  end

  def win_loss(team_id)
    h2h = {}
    w = wins(team_id)
    l = losses(team_id)
    t = get_team_name_from_id(team_id)
    h2h[t] = "#{w}:#{l}"
    h2h
  end

  def head_to_head(team_id, opponent_id)
    head_to_head = {}
    t = win_loss(team_id)
    o = win_loss(opponent_id)
    head_to_head[t.keys] = t.values.flatten
    head_to_head[o.keys] = o.values.flatten
    head_to_head
  end

#needed to set up most/least popular venue
  def sort_games_by_venue
    venues = []
    @games.each do |game|
      venues << game[1].venue
    end
    venues
  end

#needed to set up most/least popular venue
  def order_games_by_venue
    most_popular_venue = Hash.new(0)
    sort_games_by_venue.each do |venue|
      most_popular_venue[venue] += 1
    end
    most_popular_venue
  end

  def most_popular_venue
    popular_venue_array = []
    popular_venue_array = order_games_by_venue.sort_by do |key, value|
      value
    end
    popular_venue_array[-1][0]
  end

  def least_popular_venue
    unpopular_venue_array = []
    unpopular_venue_array = order_games_by_venue.sort_by do |key, value|
      value
    end
    unpopular_venue_array[0][0]
  end

#needed to setup avg goals per game
  def total_goals_per_game
    total_goals = 0.00
    @games.each do |game|
      total_goals += (game[1].away_goals.to_f + game[1].home_goals.to_f)
      end
      total_goals
  end

  def avg_goals_per_game
    average_goals = 0.00
    average_goals = total_goals_per_game / @games.length.to_f
    average_goals
  end

  def highest_scoring_visitor
    score = @games.values.max_by { |game| game.away_goals.to_i}
    get_team_name_from_id(score.away_team_id)
  end

  def highest_scoring_home_team
    score = @games.values.max_by { |game| game.home_goals.to_i}
    get_team_name_from_id(score.home_team_id)
  end

  def lowest_scoring_visitor
    score = @games.values.min_by { |game| game.away_goals.to_i}
    get_team_name_from_id(score.away_team_id)
  end

  def lowest_scoring_home_team
    score = @games.values.min_by { |game| game.home_goals.to_i}
    get_team_name_from_id(score.home_team_id)
  end

  def highest_total_score
    sum = @games.values.max_by { |game| game.away_goals.to_i + game.home_goals.to_i }
    sum.away_goals.to_i + sum.home_goals.to_i
  end

  def lowest_total_score
    sum = @games.values.min_by { |game| game.away_goals.to_i + game.home_goals.to_i }
    sum.away_goals.to_i + sum.home_goals.to_i
  end

  def group_by_team_id
    @game_teams.values.group_by { |game| game.team_id }
  end

  def goals_scored_from_game_teams
    @game_teams.values.inject(Hash.new(0)) do |goals_by_team, game|
      goals_by_team[game.team_id.to_i] += game.goals.to_i
      goals_by_team
    end
  end

  def all_seasons
    @games.values.map do |game|
      game.season
    end.uniq
  end

  def goals_scored(team_id = "3", the_season = all_seasons)
    @games.values.inject(0) do |goals_scored, game|
      if game.home_team_id == team_id && game.season == the_season
        goals_scored += game.home_goals.to_i
      elsif game.away_team_id == team_id && game.season == the_season
        goals_scored += game.away_goals.to_i
      else
        goals_scored
      end
    end
  end

  def goals_against(team_id = "3", the_season = all_seasons)
    @games.values.inject(0) do |goals_against, game|
      if game.home_team_id == team_id && game.season == the_season
        goals_against += game.away_goals.to_i
      elsif game.away_team_id == team_id && game.season == the_season
        goals_against += game.home_goals.to_i
      else
        goals_against
      end
    end
  end

  def total_wins(team_id = "3", the_season = all_seasons)
    @games.values.inject(0) do |wins, game|
      if game.home_team_id == team_id && game.outcome.include?("home win") && the_season.include?(game.season)
        wins += 1
      elsif game.away_team_id == team_id && game.outcome.include?("away win") && the_season.include?(game.season)
        wins += 1
      else
        wins
      end
    end
  end

  def total_game_count(team_id = "3", the_season = all_seasons)
    @games.values.inject(0) do |total, game|
      if game.home_team_id == team_id && the_season.include?(game.season)
        total += 1
      elsif game.away_team_id == team_id && the_season.include?(game.season)
        total += 1
      end
      total
    end
  end

  def win_percentage_helper(team_id = "3", the_season = all_seasons)
    if total_game_count(team_id, the_season) > 0
      (total_wins(team_id, the_season).to_f / total_game_count(team_id, the_season)).round(2)
    else
      0.0
    end
  end

  def season_summary(team_id = "3", the_season = all_seasons)
summary = {}
seasons = []
seasons << the_season
s = seasons.flatten.sort
s.each do |season|
    @games.values.inject(Hash.new(0)) do |stats, game|
        stats[game.type] = {win_percentage: win_percentage_helper(team_id = "3", season),
                            goals_scored: goals_scored(team_id, season),
                            goals_against: goals_against(team_id, season)
                            }
        summary[season] = stats
      end
    end
    summary
  end

end
