require "csv"
require 'pry'
require './lib/team'
require './lib/game'

class StatTracker
  attr_reader :teams,
              :games

  def initialize
    @teams = {}
    @games = {}
  end

  def parse_teams(file_path)
  skip_first_line = true
  CSV.foreach(file_path) do |row|
      unless skip_first_line
        @teams[row[0].to_i] = ([
          row[1],
          row[2],
          row[3],
          row[4],
          row[5]])
      else
        skip_first_line = false
      end
    end
    @teams
  end
#"game_id","season","type","date_time","away_team_id","home_team_id",
#{}"away_goals","home_goals","outcome","home_rink_side_start","venue",
#{}"venue_link","venue_time_zone_id","venue_time_zone_offset",
#{}"venue_time_zone_tz"
  def parse_games(file_path)
  skip_first_line = true
  CSV.foreach(file_path) do |row|
      unless skip_first_line
        @games[row[0].to_i] = ([
          row[1],
          row[2],
          row[3],
          row[4],
          row[5],
          row[6],
          row[7],
          row[8],
          row[9],
          row[10],
          row[11],
          row[12],
          row[13],
          row[14],
          row[15]])
      else
        skip_first_line = false
      end
    end
    @games
  end
end
