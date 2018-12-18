require "csv"
require 'pry'
require './lib/team'
class StatTracker
  attr_reader :teams

  def initialize
    @teams = {}
  end

  def parse_teams(file_path)
  skip_first_line = true
  CSV.foreach(file_path) do |row|
    unless skip_first_line
      # team = Team.new
      @teams[row[0].to_i] = ([
        # row[0].to_i =>
        # [
        row[1],
        row[2],
        row[3],
        row[4],
        row[5]])
        # ]
        # )
        # binding.pry
    else
      skip_first_line = false
    end

  end
@teams
  end

end
