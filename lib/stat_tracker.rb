require "csv"
require 'pry'
class StatTracker
  attr_reader
              # :abbreviations

  def initialize
    # @locations = []
    # @abbreviations = []
  end

  def self.from_csv(locations)
    # binding.pry
    abbreviations = []
    lines = CSV.open locations, headers: true, header_converters: :symbol
    lines.each do |line|
      abbreviations.push(line[:abbreviation])
    end
    abbreviations
    #when pry opens in runner.rb, type stat_tracker
    #and you'll see the abbreviations array
  end

end


      # binding.pry
      # @cards << Card.new(row[:question], row[:answer], row[:category].to_sym)
    # end
