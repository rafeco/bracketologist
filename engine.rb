class BracketEngine
  # Applies the log5 formula to determine the odds of one team beating another.
  def self.log5(a, b)
    return a*(1 - b)/(a*(1 - b) + (1 - a)*b)
  end

  # Accepts an array of teams in the order of their seeding (so that the matchups
  # work). Returns an array of the winning teams from the matchup. So for the first
  # round, it takes 16 teams and returns the 8 winners. It figures out the odds of
  # each team winning and determines a winner based on the random number generator.
  def self.reduce(bracket)
    winners = []

    (0 .. ((bracket.length()/2) - 1)).each do |index|
      opponent_a = bracket[index]
      opponent_b = bracket[bracket.length - index - 1]

      puts "Can't find team #{opponent_a}" if (!self.teams.include?(opponent_a))
      puts "Can't find team #{opponent_b}" if (!self.teams.include?(opponent_b))

      winning_pct_for_a = log5(self.teams[opponent_a], self.teams[opponent_b])

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

  def self.play_in_game(game, teams)
    puts "Play-in #{game}"
    BracketEngine.reduce(teams)
  end

  def self.teams
    @@teams ||= {}

    return @@teams if !@@teams.empty?

    # Read in the ratings from Ken Pomeroy's Web site. A data entry avoidance technique,
    # highly brittle. The result is a hash with the names of the schools as keys and
    # a percentage chance of winning as the values. Percentages are versus an average
    # team in Pomeroy's system.
    File.open("ratings.tsv").each do |line|
      fields = line.split(/\t/)

      @@teams[fields[0].rstrip] = fields[1].to_f
    end

    return @@teams
  end
end

class Bracket
  attr_accessor :regions, :final_four_teams, :region_order

  def initialize
    # Must be in order of seeding. Names must match the keys in $teams
    #
    # Pick play-in game winners.
    round_1_g1 = BracketEngine.play_in_game("Game 1", ["North Carolina A&T", "Liberty"])
    round_1_g2 = BracketEngine.play_in_game("Game 2", ["Boise St.", "La Salle"])
    round_1_g3 = BracketEngine.play_in_game("Game 3", ["Long Island", "James Madison"])
    round_1_g4 = BracketEngine.play_in_game("Game 4", ["Middle Tennessee", "St. Mary's"])

    west = [ "Gonzaga", "Ohio St.", "New Mexico", "Kansas St.", "Wisconsin",
      "Arizona", "Notre Dame", "Pittsburgh", "Wichita St.", "Iowa St.",
      "Belmont", "Mississippi", round_1_g2[0], "Harvard",
      "Iona", "Southern" ]

    east = [ "Indiana", "Miami FL", "Marquette", "Syracuse", "Nevada Las Vegas",
      "Butler", "Illinois", "North Carolina St.", "Temple",
      "Colorado", "Bucknell", "California", "Montana", "Davidson",
      "Pacific", round_1_g3[0]]

    midwest = [ "Louisville", "Duke", "Michigan St.", "St. Louis", "Oklahoma St.",
      "Memphis", "Creighton", "Colorado St.", "Missouri", "Cincinnati",
      round_1_g4[0], "Oregon", "New Mexico St.", "Valparaiso",
      "Albany",  round_1_g1[0] ]

    south = [ "Kansas", "Georgetown", "Florida", "Michigan", "Virginia Commonwealth",
      "UCLA", "San Diego St.", "North Carolina", "Villanova", "Oklahoma",
      "Minnesota", "Akron", "South Dakota St.", "Northwestern St.",
      "Florida Gulf Coast", "Western Kentucky" ]

    # This order is important so that the proper teams meet in the final four.
    @regions = { "Midwest" => midwest, "East" => east, "South" => south, "West" => west }

    # BracketEngine.reduce works from outermost pair in towards the middle
    @region_order = [ "West", "Midwest", "East", "South" ]

    @final_four_teams = []
  end
end

