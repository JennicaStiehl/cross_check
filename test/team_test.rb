require './test/test_helper'
require './lib/team'
require './lib/stat_tracker'

class TeamTest < Minitest::Test

  def test_it_exists
    stat_tracker = StatTracker.new
    stat_tracker.parse_teams('./data/sample_team_info.csv')
    team = Team.new({team_id: 1, franchiseid: 23, shortname: "New Jersey",teamname: "Devils", abbreviation: "NJD", link: "/api/v1/teams/1"})

    assert_instance_of Team, team
  end

end
