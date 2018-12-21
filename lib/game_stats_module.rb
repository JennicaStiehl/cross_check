require 'pry'
require './lib/game_team'
require './lib/game_team_storage'
require './lib/stat_tracker'

module GameStats


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
end
