require 'pry'
require './lib/game'
require './lib/game_storage'
require './lib/stat_tracker'

module GameStats

  def biggest_blowout
    blowout = @games.values.max_by do |game|
      (game.away_goals.to_i - game.home_goals.to_i).abs
    end
    (blowout.away_goals.to_i - blowout.home_goals.to_i).abs
  end

  def biggest_team_blowout(team_id)
    blowout = @games.values.max_by do |game|
      if game.home_team_id == team_id || game.away_team_id == team_id
        (game.away_goals.to_i - game.home_goals.to_i).abs
      end
    end
    (blowout.away_goals.to_i - blowout.home_goals.to_i).abs
  end

  def best_season(collection = @games, team_id)
    wins = wins_by_season(collection = @games, team_id)
    best = wins.max_by do |season, num_wins|
      num_wins
    end
    best = best[1]
    wins.key(best)
  end

  def worst_season(collection = @games, team_id)
    wins = wins_by_season(collection = @games, team_id)
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
    percentage_home_wins = 0
    total_games_played = 0
    total_home_games_won = []
    # find the total games played
    total_games_played = @game_storage.games.keys.count
    # find the total home games played and won
    total_home_games_won = @game_storage.games.values.select do |game|
      game.outcome.include?("home")
    end

    percentage_home_wins = total_home_games_won.count.to_f / total_games_played.to_f

    return percentage_home_wins
  end

  def percentage_visitor_wins
    percentage_visitor_wins = 0
    total_games_played = 0
    total_visitor_games_won = []
    # find the total games played
    total_games_played = @game_storage.games.keys.count
    # find the total visitor games played and won
    total_visitor_games_won = @game_storage.games.values.select do |game|
      game.outcome.include?("away")
    end
    #do the math and return it
    percentage_visitor_wins = total_visitor_games_won.count.to_f / total_games_played.to_f

    return percentage_visitor_wins
  end

  def create_hash_by_season
    total_games_by_season = @game_storage.games.values.group_by do |game|
      game.season
    end
    total_games_by_season
  end

  def season_with_most_games
    season_with_most_games = 0

    season_with_most_games = create_hash_by_season.keys.max do |season_1, season_2|
      create_hash_by_season[season_1].count <=> create_hash_by_season[season_2].count
    end

    return season_with_most_games.to_i
  end

  def season_with_fewest_games
    season_with_fewest_games = 0

    season_with_fewest_games = create_hash_by_season.keys.min do |season_1, season_2|
      create_hash_by_season[season_1].count <=> create_hash_by_season[season_2].count
    end

    return season_with_fewest_games.to_i
  end

  def count_of_games_by_season
    count_of_games_by_season = {}

    total_games_by_season = @game_storage.games.values.group_by do |game|
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

  def sort_teams_by_team_id
    team_id_array =[]
    @game_teams.values.each do |game|
      team_id_array << game.team_id
    end
    team_id_array.uniq
  end

  def create_team_to_goals_hash
    @team_to_goals_hash = {}
      sort_teams_by_team_id.each do |team_id|
        team_to_goals_hash[team_id] = 0
      end
    @team_to_goals_hash
  end

  def add_goals_to_team_to_goals_hash
    create_team_to_goals_hash
    @game_teams.values.each do |game|
      @team_to_goals_hash[game.team_id] += game.goals.to_i
    end
    @team_to_goals_hash
  end

  def create_hash_of_games_played
    @games_played_by_team = {}
    sort_teams_by_team_id.each do |team_id|
      games_played_by_team[team_id] = 0
    end
    @games_played_by_team
  end

  def add_games_to_games_played_by_team
    create_hash_of_games_played
    @game_teams.values.each do |game|
      @games_played_by_team[game.team_id] += 1
    end
    @games_played_by_team
  end

  def average_team_goals_across_all_seasons
    add_goals_to_team_to_goals_hash
    add_games_to_games_played_by_team
    average_team_goals_across_all_seasons = {}
    @team_to_goals_hash.each do |team_id, goals|
      average_team_goals_across_all_seasons[team_id] = (goals / @games_played_by_team[team_id])
    end
    average_team_goals_across_all_seasons
  end

  def best_offense
    name = ""
    team_id = average_team_goals_across_all_seasons.key(average_team_goals_across_all_seasons.values.max)
    @teams.values.each do |team|
      # binding.pry
    if team.teamid == team_id
      name = team.teamName
    end
    end
    name
  end

  def worst_offense
    name = ""
    team_id = average_team_goals_across_all_seasons.key(average_team_goals_across_all_seasons.values.min)
    @teams.values.each do |team|
      # binding.pry
    if team.teamid == team_id
      name = team.teamName
    end
    end
    name
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

  # def goals_scored
  #   @games.inject(Hash.new(0)) do |sum, game|
  #     [game.home_team_id] = game.home_goals
  #     [game.away_team_id] = game.away_goals
  #   end
  # end

  def season_summary(collection = @games, team_id)
summary = {}
    # w = win_percentage(collection = @games, team_id)
    hash_values = @games.values.group_by do |game|
      if game.home_team_id == team_id
        binding.pry
      summary[game.type] = {win_percentage: 1,# if game.outcome.include?("home win"),
                            goals_scored: game.home_goals.to_i,
                            goals_against: game.away_goals.to_i
                            }
      end
    end
    # nc = hash_values.flatten
    # win_percentage(nc, team_id)

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

  # def check_for_pre_and_regular_season_games(season, collection = @games)
  #   teams_in_pre_and_regular_season = []
  #   create_team_id_array(season).each do |team_id|
  #   end
  # end

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

end
