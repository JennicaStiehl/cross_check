require './lib/storage'

class TeamStorage < Storage
  attr_reader   :data

  def initialize
    @data = {}
  end

  def add_team(team)
    @data[team.link[-1].to_i] = team
    # binding.pry
    @data
  end

  def all
    @data.values
  end
end
