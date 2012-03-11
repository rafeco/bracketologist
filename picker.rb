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
west = [ "Syracuse", "Kansas St.", "Pittsburgh", "Vanderbilt", "Butler", "Xavier", "Brigham Young", 
  "Gonzaga", "Florida St.", "Florida", "Minnesota", "Texas El Paso", "Murray St.", "Oakland", 
  "North Texas", "Vermont" ]

east = [ "Kentucky", "West Virginia", "New Mexico", "Wisconsin", "Temple", "Marquette", "Clemson",
  "Texas", "Wake Forest", "Missouri", "Washington", "Cornell", "Wofford", "Montana", "East Tennessee St.",
  "Morgan St." ]

midwest = [ "Kansas", "Ohio St.", "Georgetown", "Maryland", "Michigan St.", "Tennessee", "Oklahoma St.", 
  "Nevada Las Vegas", "Northern Iowa", "Georgia Tech", "San Diego St.", "New Mexico St.", "Houston", "Ohio", 
  "UC Santa Barbara",  "Lehigh" ]

# Pick a winner of the play-in game.
play_in_winners = reduce(["Winthrop", "Arkansas Pine Bluff"])

south = [ "Duke", "Villanova", "Baylor", "Purdue", "Texas A&M", "Notre Dame", "Richmond", "California", 
  "Louisville", "St. Mary's", "Old Dominion", "Utah St.", "Siena", "Sam Houston St.", "Robert Morris", play_in_winners[0] ]  

# This order is important so that the proper teams meet in the final four.
regions = [ midwest, east, south, west ]

final_four_teams = []

# Play through all four regionals and come up with a Final Four
regions.each do |region|
  rounds = 1

  while region.length() > 1
    puts "ROUND " + rounds.to_s
    region = reduce(region)
    rounds = rounds + 1
  end
  
  final_four_teams << region[0]
end

puts "FINAL FOUR"
finalists = reduce(final_four_teams)

puts "NATIONAL CHAMPION" 
reduce(finalists)
