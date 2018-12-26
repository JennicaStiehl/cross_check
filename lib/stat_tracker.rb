require "csv"
require 'pry'
require './lib/team'
require './lib/game'
require './lib/game_team'
require './lib/team_storage'
require './lib/game_storage'
require './lib/game_team_storage'
require './lib/game_stats_module'

class StatTracker

  include GameStats

  attr_accessor :teams,
                :games,
                :game_teams,
                :team_storage,
                :game_storage,
                :game_team_storage

  def initialize
    @team_storage = {}
    @game_storage = {}
    @game_team_storage = {}

  end

  def parse_teams(file_path)
    @team_storage = TeamStorage.new
    CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |team_info|
    @teams = @team_storage.add_team(Team.new({:team_id => team_info[0], :franchiseid => team_info[1], :shortname => (team_info[2]),
          :teamname => team_info[3], :abbreviation => team_info[4], :link => team_info[5]}))
    end
    @teams
  end

  def parse_game_teams(file_path)
  @game_team_storage = GameTeamStorage.new
  CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |gt_info|
        @game_teams = @game_team_storage.add_game_team(GameTeam.new({
          :game_id => gt_info[0],# + "_" + gt_info[1]),
          :team_id => gt_info[1],
          :HoA => gt_info[2],
          :won => gt_info[3],
          :settled_in => gt_info[4],
          :head_coach => gt_info[5],
          :goals => gt_info[6],
          :shots => gt_info[7],
          :hits => gt_info[8],
          :pim => gt_info[9],
          :powerPlayOpportunities => gt_info[10],
          :powerPlayGoals => gt_info[11],
          :faceOffWinPercentage => gt_info[12],
          :giveaways => gt_info[13],
          :takeaways => gt_info[14]}))
    end
    @game_teams
  end

    def parse_games(file_path)
      @game_storage = GameStorage.new
      CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |game_info|
      @games = @game_storage.add_game(Game.new({
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
                      :venue_time_zone_id => game_info[12],
                      :venue => game_info[10],
                      :venue_link => game_info[11],
                      :venue_time_zone_offset => game_info[13],
                      :venue_time_zone_tz => game_info[14]}))
      end
      @games
    end
    # Erin's Iteration 3: League and Season Stats
    def count_of_teams
      total_number_of_teams = 0 #integer

      total_number_of_teams = @team_storage.teams.count

      return total_number_of_teams
    end

    def winningest_team
      team_with_highest_win_percentage_across_all_seasons = ""

      teams_by_id = @game_team_storage.game_teams.values.group_by do |game_team|
        game_team.team_id
      end

      game_win_percentage = {}
      teams_by_id.keys.each do |team_id|
        count = teams_by_id[team_id].count
        wins = teams_by_id[team_id].select do |game|
          game.won == "TRUE"
        end
        game_win_percentage.store(team_id, wins.count.to_f / count.to_f)
      end
      highest_win_percentage = game_win_percentage.keys.max do |team_id_1, team_id_2|
        game_win_percentage[team_id_1] <=> game_win_percentage[team_id_2]
      end

      team_with_highest_win_percentage_across_all_seasons = @team_storage.teams[highest_win_percentage.to_i].teamName

      team_with_highest_win_percentage_across_all_seasons
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

  def head_to_head(team_id, opponent_id)
    head_to_head = {}
    t = win_loss(team_id)
    o = win_loss(opponent_id)
    head_to_head[t.keys] = t.values.flatten
    head_to_head[o.keys] = o.values.flatten
    head_to_head
  end

end
