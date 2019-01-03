# require 'pry'
class GameTeam

  attr_accessor :game_id,
                :team_id,
                :HoA,
                :won,
                :settled_in,
                :head_coach,
                :goals,
                :shots,
                :hits,
                :pim,
                :powerPlayOpportunities,
                :powerPlayGoals,
                :faceOffWinPercentage,
                :giveaways,
                :takeaways

  def initialize(gt_info)
    @game_id = gt_info[:game_id]
    @team_id = gt_info[:team_id]
    @HoA = gt_info[:HoA]
    @won = gt_info[:won]
    @settled_in = gt_info[:settled_in]
    @head_coach = gt_info[:head_coach]
    @goals = gt_info[:goals]
    @shots = gt_info[:shots]
    @hits = gt_info[:hits]
    @pim = gt_info[:pim]
    @powerPlayOpportunities = gt_info[:powerPlayOpportunities]
    @powerPlayGoals = gt_info[:powerPlayGoals]
    @faceOffWinPercentage = gt_info[:faceOffWinPercentage]
    @giveaways = gt_info[:giveaways]
    @takeaways = gt_info[:takeaways]
  end

end
