!#/usr/bin/env ruby

# Applies the log5 formula to determine the odds of one team beating another.
def log5(a, b)
  return a*(1 - b)/(a*(1 - b) + (1 - a)*b)
end

# Accepts an array of teams in the order of their seeding (so that the matchups
# work). Returns an array of the winning teams from the matchup. So for the first
# round, it takes 16 teams and returns the 8 winners. It figures out the odds of
# each team winning and determines a winner based on the random number generator.
def reduce(bracket)
  winners = []

  (0 .. ((bracket.length()/2) - 1)).each do |index|
    opponent_a = bracket[index]
    opponent_b = bracket[bracket.length - index - 1]

    puts "Can't find team #{opponent_a}" if (!$teams.include?(opponent_a)) 
    puts "Can't find team #{opponent_b}" if (!$teams.include?(opponent_b)) 

    winning_pct_for_a = log5($teams[opponent_a], $teams[opponent_b])

    puts opponent_a + " has a " + (winning_pct_for_a * 100).round().to_s + "% chance of beating " + opponent_b

    if rand() > winning_pct_for_a 
      puts "Winner: " + opponent_b + "\n\n"
      winners << opponent_b 
    else
      puts "Winner: " + opponent_a + "\n\n"
      winners << opponent_a 
    end
  end

  return winners
end

def play_in_game(game, teams) 
  puts "Play-in #{game}"
  reduce(teams)
end

# Read in the ratings from Ken Pomeroy's Web site. A data entry avoidance technique,
# highly brittle. The result is a hash with the names of the schools as keys and
# a percentage chance of winning as the values. Percentages are versus an average
# team in Pomeroy's system.
$teams = {}
File.open("ratings.tsv").each do |line|
  fields = line.split(/\t/)

  $teams[fields[0].rstrip] = fields[1].to_f
end

# Must be in order of seeding. Names must match the keys in $teams
#
# Pick play-in game winners.
round_1_g1 = play_in_game("Game 1", ["Mississippi Valley St.", "Western Kentucky"])
round_1_g2 = play_in_game("Game 2", ["Brigham Young", "Iona"])
round_1_g3 = play_in_game("Game 3", ["Lamar", "Vermont"])
round_1_g4 = play_in_game("Game 4", ["California", "South Florida"])

west = [ "Michigan St.", "Missouri", "Marquette", "Louisville", "New Mexico", "Murray St.", "Florida", 
  "Memphis", "St. Louis", "Virginia", "Colorado St.", "Long Beach St.", "Davidson", round_1_g2[0],
  "Norfolk St.", "Long Island" ]

east = [ "Syracuse", "Ohio St.", "Florida St.", "Wisconsin", "Vanderbilt", "Cincinnati", "Gonzaga",
  "Kansas St.", "Southern Mississippi", "West Virginia", "Texas", "Harvard", "Montana", "St. Bonaventure", 
  "Loyola MD", "NC Asheville"]

midwest = [ "North Carolina", "Kansas", "Georgetown", "Michigan", "Temple", "San Diego St.", "St. Mary's", 
  "Creighton", "Alabama", "Purdue", "North Carolina St.", round_1_g4[0], "Ohio", "Belmont", 
  "Detroit",  round_1_g3[0] ]

south = [ "Kentucky", "Duke", "Baylor", "Indiana", "Wichita St.", "Nevada Las Vegas", "Notre Dame", "Iowa St.", 
  "Connecticut", "Xavier", "Colorado", "Virginia Commonwealth", "New Mexico St.", "South Dakota St.", "Lehigh", round_1_g1[0] ]  

# This order is important so that the proper teams meet in the final four.
regions = { "Midwest" => midwest, "East" => east, "South" => south, "West" => west }

final_four_teams = []

# Play through all four regionals and come up with a Final Four
regions.each do |name, region|
  puts "*** REGION: #{name} ***"

  rounds = 1

  while region.length() > 1
    puts "ROUND " + rounds.to_s
    region = reduce(region)
    rounds = rounds + 1
  end

  final_four_teams << region[0]
end

puts "---===> FINAL FOUR <===---"
finalists = reduce(final_four_teams)

puts "============ NATIONAL CHAMPION ============"
reduce(finalists)

