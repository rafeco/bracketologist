!#/usr/bin/env ruby

require 'engine'

bracket = Bracket.new
final_four_summary = "South should play against West\nEast should play against Midwest\n";

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

  final_four_summary += " " + region[0].to_s + " from #{name} " + "\n"
  bracket.final_four_teams << region[0]
end

puts "---===> FINAL FOUR <===---"
puts final_four_summary
finalists = BracketEngine.reduce(bracket.final_four_teams)

puts "============ NATIONAL CHAMPION ============"
BracketEngine.reduce(finalists)

