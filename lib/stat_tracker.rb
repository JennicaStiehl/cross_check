require "csv"
require 'pry'
require './lib/team'
require './lib/game'
require './lib/team_storage'
require './lib/game_storage'
require './lib/game_stats_module'

class StatTracker

  include GameStats

  attr_reader :teams,
              :games,
              :game_teams
              # :data

  def initialize
    @teams = {}
    # @data = {}
    # @games = {}
    # @game_teams = {}
  end

  def parse_teams(file_path)
    @teams = TeamStorage.new
    CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |team_info|
    @teams.add_team(Team.new({:team_id => team_info[0], :franchiseid => team_info[1], :shortname => (team_info[2]),
          :teamname => team_info[3], :abbreviation => team_info[4], :link => team_info[5]}))
    end
    @teams
  end


  def parse_games(file_path)
    game_storage = GameStorage.new
    CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |game_info|
    game_storage.add_game(Game.new({
                    :game_id => game_info[0],
                    :season => game_info[1],
                    :type => game_info[2],
                    :date_time => game_info[3],
                    :away_team_id => game_info[4],
                    :home_team_id => game_info[5],
                    :away_goals => game_info[6],
                    :home_goals => game_info[7],
                    :outcome => game_info[8],
                    :home_rink_side_start => game_info[9],
                    :venue_time_zone_id => game_info[10],
                    :venue => game_info[11],
                    :venue_link => game_info[12],
                    :venue_time_zone_offset => game_info[13],
                    :venue_time_zone_tz => game_info[14]}))
    end
    game_storage
  end
#
#   def parse_game_teams(file_path)
#   skip_first_line = true
#   CSV.foreach(file_path) do |row|
#       unless skip_first_line
#         @game_teams{
#           :game_id => row[0],# + "_" + row[1]),
#           :team_id => row[1],
#           :HoA => row[2],
#           :won => row[3],
#           :settled_in => row[4],
#           :head_coach => row[5],
#           :goals => row[6],
#           :shots => row[7],
#           :hits => row[8],
#           :pim => row[9],
#           :powerPlayOpportunities => row[10],
#           :powerPlayGoals => row[11],
#           :faceOffWinPercentage => row[12],
#           :giveaways => row[13],
#           :takeaways => row[14]}
#       else
#         skip_first_line = false
#       end
#     end
#     @game_teams
#   end
#
#   CSV.foreach(@file_path, {headers: true, header_converters: :symbol}) do |row|
#       @cards << Card.new(row[:question], row[:answer], row[:category].to_sym)
#     end
#     @team << Team.new(row[:question], row[:answer], row[:category].to_sym)
end
