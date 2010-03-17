!#/usr/bin/env ruby

# Applies the log5 formula to determine the odds of one team beating another.
def log5(a, b)
  return a*(1 - b)/(a*(1 - b) + (1 - a)*b)
end

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

# Read in the ratings from Ken Pomeroy's Web site. A data entry avoidance technique.
$teams = {}
File.open("ratings.txt").each do |line|
  fields = line.split(/\s{2,}/)

  team = line.slice(4, 25)
  rating = line.slice(41, 5)
  
  if team && rating
    if rating.to_f > 0
      $teams[team.rstrip] = rating.to_f
    end
  end
end

# Must be in order of seeding.
west = [ "Syracuse", "Kansas St.", "Pittsburgh", "Vanderbilt", "Butler", "Xavier", "Brigham Young", 
  "Gonzaga", "Florida St.", "Florida", "Minnesota", "Texas El Paso", "Murray St.", "Oakland", 
  "North Texas", "Vermont" ]

east = [ "Kentucky", "West Virginia", "New Mexico", "Wisconsin", "Temple", "Marquette", "Clemson",
  "Texas", "Wake Forest", "Missouri", "Washington", "Cornell", "Wofford", "Montana", "East Tennessee St.",
  "Morgan St." ]

midwest = [ "Kansas", "Ohio St.", "Georgetown", "Maryland", "Michigan St.", "Tennessee", "Oklahoma St.", 
  "Nevada Las Vegas", "Northern Iowa", "Georgia Tech", "San Diego St.", "New Mexico St.", "Houston", "Ohio", 
  "UC Santa Barbara",  "Lehigh" ]

play_in_winners = reduce(["Winthrop", "Arkansas Pine Bluff"])

south = [ "Duke", "Villanova", "Baylor", "Purdue", "Texas A&M", "Notre Dame", "Richmond", "California", 
  "Louisville", "St. Mary's", "Old Dominion", "Utah St.", "Siena", "Sam Houston St.", "Robert Morris", play_in_winners[0] ]  

# This order is important so that the proper teams meet in the final four.

regions = [ midwest, east, south, west ]

final_four_teams = []

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
