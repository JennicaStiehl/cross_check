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

end
