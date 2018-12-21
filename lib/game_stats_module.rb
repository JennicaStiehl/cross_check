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

end
