!#/usr/bin/env ruby

require 'engine'

bracket = Bracket.new

# Play through all four regionals and come up with a Final Four
bracket.regions.each do |name, region|
  puts "*** REGION: #{name} ***"

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

