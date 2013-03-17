*Ratings and tournament bracket are updated for 2013*

This script generates a plausible set of NCAA Tournament predictions.
It uses [Ken Pomeroy's College Basketball Ratings](http://kenpom.com/)
for team strengths, and Bill James' [log5 method](http://www.tangotiger.net/wiki/index.php?title=Log5)
to predict which team will win each game. The result is a bracket where
the better team is the predicted winner most of the time, but some
upsets will occur due to randomness.

This method is no more likely to generate a winning pool entry than most
others, but it does save you from your biases or from pretending that
you have some special insight into the NCAA tournament field. Run the
script and copy the results into your bracket. That's it.

It needs to be updated each year with the updated Pomeroy ratings and
the tournament field. The names of the teams in the picker script also
need to match the ones in Pomeroy's ratings perfectly or the script
won't work. The `scraper.rb` script tries to scrape the ratings from Ken
Pomeroy's site, but it will break if he makes any serious changes to
the markup for the page.

The teams for 2013 are all entered and the final ratings are included,
so there's no reason to run the scraper. See sample-results.txt for sample
output.

