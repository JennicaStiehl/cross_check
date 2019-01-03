# require 'pry'
require_relative './game'
require_relative './game_storage'
require_relative './stat_tracker'

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
    (total_home_games_won.count.to_f / total_games_played.to_f).round(2)
  end

  def percentage_visitor_wins
    total_games_played = @games.keys.count
    total_visitor_games_won = @games.values.select do |game|
      game.outcome.include?("away")
    end
    (total_visitor_games_won.count.to_f / total_games_played.to_f).round(2)
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
      # binding.pry
    end
    venues
  end

#needed to set up most/least popular venue
  def order_games_by_venue
    most_popular_venue = Hash.new(0)
    sort_games_by_venue.each do |venue|
      most_popular_venue[venue] += 1
    end
    # binding.pry
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
    unpopular_venue_array = order_games_by_venue.min_by do |key, value|
      # binding.pry
      value
    end
    # binding.pry
    unpopular_venue_array[0]
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
#season_summary	A hash with two keys
#(:preseason, and :regular_season) each pointing to a hash with the keys
#:win_percentage, :goals_scored, and :goals_against
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

  def average_goals_per_game_per_season
    average_goals_per_game_per_season = {}
    @games.values.each do |game|
      average_goals_per_game_per_season[game.season] = 0
    end
    @games.values.each do |game|
      average_goals_per_game_per_season[game.season] += game.home_goals.to_i + game.away_goals.to_i
    end
    average_goals_per_game_per_season
  end

  def average_goals_by_season
    average_goals_by_season = {}
    count_of_games_by_season.each do |season, count|
      average_goals_by_season[season] = (average_goals_per_game_per_season[season.to_s] / count)
    end
    average_goals_by_season
  end

  def preseason_game_hash(collection, season)
    preseason_game_hash = collection.to_h
    array_of_preseason_games = []
    collection.to_h.values.each do |game|
      if game.type == "P" && game.season == season
        array_of_preseason_games << game
      end
    end
    preseason_game_hash.values.each do |game|
      if array_of_preseason_games.include?(game) == false
        preseason_game_hash.delete(preseason_game_hash.key(game))
      end
    end
    preseason_game_hash
  end

  def regular_season_game_hash(collection, season)
    regular_season_game_hash = collection.to_h
    regular_season_game_hash.delete_if do |game_id, game|
      game.type == "P" || game.season != season
    end
    regular_season_game_hash
  end

  def create_team_id_array(collection, season)
    team_id_array = []
    collection.to_h.each do |game_id, game|
      if game.season == season
      team_id_array << game.home_team_id
      team_id_array << game.away_team_id
      end
    end
    team_id_array.uniq
  end

  def biggest_bust(season)
    collection = @games.to_a
    regular_season_game_hash(collection, season)
    preseason_game_hash(collection, season)
    win_percentage_by_team_and_season = {}
    create_team_id_array(collection, season).each do |team_id|
      win_percentage_by_team_and_season[team_id] = win_percentage(preseason_game_hash(collection, season), team_id) - win_percentage(regular_season_game_hash(collection, season), team_id)
    end
    biggest_decrease = win_percentage_by_team_and_season.max_by do |team_id, win|
      win
    end
    name_of_team_with_biggest_bust = ""
    @teams.values.each do |team|
      if team.teamid == biggest_decrease[0]
        name_of_team_with_biggest_bust = team.teamName
      end
    end
    name_of_team_with_biggest_bust
  end

  def biggest_surprise(season)
    collection = @games.to_a
    regular_season_game_hash(collection, season)
    preseason_game_hash(collection, season)
    win_percentage_by_team_and_season = {}
    create_team_id_array(collection, season).each do |team_id|
      win_percentage_by_team_and_season[team_id] = win_percentage(regular_season_game_hash(collection, season), team_id) - win_percentage(preseason_game_hash(collection, season), team_id)
    end
    biggest_increase = win_percentage_by_team_and_season.max_by do |team_id, win|
      win
    end
    name_of_team_with_biggest_surprise = ""
    @teams.values.each do |team|
      if team.teamid == biggest_increase[0]
        name_of_team_with_biggest_surprise = team.teamName
      end
    end
    name_of_team_with_biggest_surprise
  end

  def team_id_from_team_name(name)
    team_id = ""
    @teams.values.each do |team|
      if team.teamName == name
        team_id = team.teamid
      end
    end
    team_id
  end

  def array_of_losses(collection = @games, team_id)
    losses = []
    collection.values.each do |game|
      if (game.outcome.start_with?("away win") && game.home_team_id == team_id) || (game.outcome.start_with?("home win") && game.away_team_id == team_id)
        losses << game
      end
    end
    losses
  end

  def array_of_opponents(collection = @games, teamid, input)
    array_of_opponents = []
    # binding.pry
    input.each do |game|
      if game.home_team_id == teamid
        array_of_opponents << game.away_team_id.to_i
      elsif game.away_team_id == teamid
        array_of_opponents << game.home_team_id.to_i
      end
    end
    array_of_opponents
  end

  def rival(teamname)
    team_id_from_team_name(teamname)
    input = array_of_losses(team_id_from_team_name(teamname))
    rival_team_id_hash = Hash.new(0)
    array_of_opponents(team_id_from_team_name(teamname), input).each do |opponent|
      rival_team_id_hash[opponent] += 1
    end
    rival_team_id_hash_value = rival_team_id_hash.values.max
    rival_team_id = rival_team_id_hash.key(rival_team_id_hash_value).to_s
    rival_team_name = ""
    # binding.pry
    @teams.values.each do |team|
      if team.teamid == rival_team_id
        rival_team_name = team.teamName
      end
    end
    rival_team_name
  end

  def array_of_wins(collection = @games, team_id)
    wins = []
    collection.values.each do |game|
      if (game.outcome.start_with?("away win") && game.away_team_id == team_id) || (game.outcome.start_with?("home win") && game.home_team_id == team_id)
        wins << game
      end
    end
    wins
  end

  def favorite_opponent(teamname)
    team_id_from_team_name(teamname)
    input = array_of_wins(team_id_from_team_name(teamname))
    favorite_opponent_team_id_hash = Hash.new(0)
    array_of_opponents(team_id_from_team_name(teamname), input).each do |opponent|
      favorite_opponent_team_id_hash[opponent] += 1
    end
    favorite_opponent_team_id_hash_value = favorite_opponent_team_id_hash.values.max
    favorite_opponent_team_id = favorite_opponent_team_id_hash.key(favorite_opponent_team_id_hash_value).to_s
    favorite_opponent = ""
    @teams.values.each do |team|
      if team.teamid == favorite_opponent_team_id
        favorite_opponent = team.teamName
      end
    end
    favorite_opponent
  end

end
