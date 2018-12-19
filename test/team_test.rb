require './test/test_helper'
require './lib/team'
require './lib/stat_tracker'

class TeamTest < Minitest::Test

  def test_it_exists
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')
    team = Team.new(stat_tracker.teams)
    assert_instance_of Team, team
  end

  def test_it_can_print_team_info
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')
    team = Team.new(stat_tracker.teams)

    expected = ({1=>["23", "New Jersey", "Devils", "NJD", "/api/v1/teams/1"]})
    assert_equal expected, team.team_info(1)
  end
end
