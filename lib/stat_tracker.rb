require "csv"
require 'pry'
require './lib/team'
require './lib/game'
require './lib/team_storage'

class StatTracker
  attr_reader :teams,
              :games,
              :game_teams
              # :data

  def initialize
    # @data = {}
    # @games = {}
    # @game_teams = {}
  end

  def parse_teams(file_path)
    team_storage = TeamStorage.new
  # skip_first_line = true
  CSV.foreach(file_path, {headers: true, header_converters: :downcase, header_converters: :symbol}) do |team_info|
    team_storage.add_team(Team.new({:team_id => team_info[0].to_i, :franchiseid => team_info[1], :shortname => (team_info[2]),
          :teamname => team_info[3], :abbreviation => team_info[4], :link => team_info[5]}))
      # unless skip_first_line
        # @teams({:teamid => row[0].to_i,
        #         :franchiseId => row[1],
        #         :shortName => row[2],
        #         :teamName => row[3],
        #         :abbreviation => row[4],
        #         :link => row[5]})
      # else
        # skip_first_line = false
      # end
    end
    team_storage
  end
end
#
#   def parse_games(file_path)
#   skip_first_line = true
#   CSV.foreach(file_path) do |row|
#       unless skip_first_line
#         @games[row[0].to_i] = ({
#                     :game_id => row[1],
#                     :season => row[2],
#                     :type => row[3],
#                     :date_time => row[4],
#                     :away_team_id => row[5],
#                     :home_team_id => row[6],
#                     :away_goals => row[7],
#                     :home_goals => row[8],
#                     :outcome => row[9],
#                     :home_rink_side_start => row[10],
#                     :venue_time_zone_id => row[11],
#                     :venue => row[12],
#                     :venue_link => row[13],
#                     :venue_time_zone_offset => row[14],
#                     :venue_time_zone_tz => row[15]})
#       else
#         skip_first_line = false
#       end
#     end
#     @games
#   end
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
# end
