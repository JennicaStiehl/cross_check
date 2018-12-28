require 'pry'
require './lib/game_team'
require './lib/game_team_storage'
require './lib/stat_tracker'

module GameStats

  # def search_any_collection_by_id(collection, id)
  #     collection[id]
  # end

  def highest_score
    high = @game_teams.values.max_by { |game| game.goals.to_i }
    high.goals.to_i
  end

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
    #do the math and return it
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

    total_games_by_season = @game_storage.games.values.group_by do |game|
      game.season
    end

    season_with_fewest_games = total_games_by_season.keys.min do |season_1, season_2|
      total_games_by_season[season_1].count <=> total_games_by_season[season_2].count
    end

    return season_with_fewest_games.to_i #two years, 8 digit integer
  end

  def count_of_games_by_season
    count_of_games_by_season = {} #{season (integer): number_of_games (integer)}

    total_games_by_season = @game_storage.games.values.group_by do |game|
      game.season
    end

    total_games_by_season.keys.each do |season|
      count_of_games_by_season.store(season.to_i, total_games_by_season[season].count)
    end
    count_of_games_by_season
  end

  def get_team_name_from_id(team_id)
    name = ""
    @teams.values.each do |team|
      if team.teamid == team_id
      name = team.teamName
      end
    end
    name
  end

  def win_loss(team_id)
    h2h = {}
    w = wins(team_id)
    l = losses(team_id)
    t = get_team_name_from_id(team_id)
    h2h[t] = "#{w}:#{l}"
    h2h
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

end
