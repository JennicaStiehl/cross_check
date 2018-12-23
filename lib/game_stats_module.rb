require 'pry'
require './lib/game_team'
require './lib/game_team_storage'
require './lib/stat_tracker'

module GameStats

#@teams, use team_id; @game_teams & @games, use game_id
  def search_any_collection_by_id(collection, id)
      collection[id]
  end

  def highest_score	#Highest sum of the winning and losing teams’ scores
    highest = 0
    @game_teams.values.each do |game|
      if game.goals.to_i > highest
        highest = game.goals.to_i
      end
    end
    highest
  end

  def biggest_blowout	#Highest difference between winner and loser
    blowout = 0
    @games.values.each do |game|
      diff = (game.away_goals.to_i - game.home_goals.to_i).abs
      if diff > blowout
        blowout = diff
      end
    end
    blowout
  end

  def best_season	#Season with the highest win percentage for a team.
  end

  def win_percentage(collection, team_id)
    wins = 0
    total_games = 0
    collection.values.count do |game|
      total_games += 1
      if game.outcome.include?("home win") && game.home_team_id == team_id
        wins += 1
      end
    end
    (wins.to_f / total_games.to_f) * 100
  end

  def find_home_team_goals_from_games(team_id)
    goals = 0
    @games.values.find_all do |game|
      if game.home_team_id == team_id
        goals += game.home_goals.to_i
      end
    end
    goals
  end

end
