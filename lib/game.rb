class Game
  attr_accessor   :game_id,
                  :season,
                  :type,
                  :date_time,
                  :away_team_id,
                  :home_team_id,
                  :away_goals,
                  :home_goals,
                  :outcome,
                  :home_rink_side_start,
                  :venue_time_zone_id,
                  :venue,
                  :venue_link,
                  :venue_time_zone_offset,
                  :venue_time_zone_tz

  def initialize(game_info)
    @game_id = game_info[:game_id]
    @season = game_info[:season]
    @type = game_info[:type]
    @date_time = game_info[:date_time]
    @away_team_id = game_info[:away_team_id]
    @home_team_id = game_info[:home_team_id]
    @away_goals = game_info[:away_goals]
    @home_goals = game_info[:home_goals]
    @outcome = game_info[:outcome]
    @home_rink_side_start = game_info[:home_rink_side_start]
    @venue_time_zone_id = game_info[:venue_time_zone_id]
    @venue = game_info[:venue]
    @venue_link = game_info[:venue_link]
    @venue_time_zone_offset = game_info[:venue_time_zone_offset]
    @venue_time_zone_tz = game_info[:venue_time_zone_tz]
  end

  # def game_info(game_id)
  #   @games[game_id]
  # end



end
