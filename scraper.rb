!#/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def fetch_web_content
  url = "http://kenpom.com/index.php?y=2012"

  return Nokogiri::HTML(open(url))
end

def extract_team_ratings(doc)
  ratings = {}
  doc.css("#ratings-table tbody tr").each do |row|
    next if row.children.length < 7
    school = row.children[2].content
    pyth = row.children[8].content

    next if pyth == "Pyth"

    ratings[school] = pyth
  end

  return ratings
end

def write_ratings(ratings)
  File.open("ratings.tsv", 'w') do |f|
    ratings.each { |s, p| f.write(s + "\t" + p + "\n") }
  end
end

doc = fetch_web_content()
ratings = extract_team_ratings(doc)
write_ratings(ratings)
