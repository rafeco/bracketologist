#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "engine")

bracket = Bracket.new

# Play through all four regionals and come up with a Final Four
bracket.region_order.each do |name|
  puts "*** REGION: #{name} ***"

  region = bracket.regions[name]

  rounds = 1

  while region.length() > 1
    puts "ROUND " + rounds.to_s
    region = BracketEngine.reduce(region)
    rounds = rounds + 1
  end

  bracket.final_four_teams << region[0]
end

puts "---===> FINAL FOUR <===---"
finalists = BracketEngine.reduce(bracket.final_four_teams)

puts "============ NATIONAL CHAMPION ============"
BracketEngine.reduce(finalists)

