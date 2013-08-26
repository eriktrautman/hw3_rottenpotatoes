# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(
        :title => movie['title'], 
        :rating => movie['rating'], 
        :release_date => movie['release_date'])
  end
  # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.index(e1).should be < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |is_uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  # puts "\n\n\n UNCHECK: #{uncheck}! \n RATINGS: #{rating_list}!\n"
  rating_list.split(/, /).each do |rating|
    # puts "\n\n\n RATING IS: #{rating}!\n\n"
    if is_uncheck == "un"
      uncheck "ratings_#{rating}"
    else
      # debugger
      check "ratings_#{rating}"
    end
  end
end


When /^I press submit$/ do
  click_button("ratings_submit")
end

Then /^I should (not )?see movies rated: (.*)/ do |qualifier, ratings|
  # puts "\n QUALIFIER: #{qualifier}! \n RATINGS: #{ratings}!\n\n"
  ratings.split(/, /).each do |rating|
      movie = Movie.where(:rating => rating).first
      movie ? title = movie.title : title = "N/A"
    step "I should #{qualifier}see \"#{title}\""
  end
end

Then /^I should see (.*) movies/ do |qualifier|
  if qualifier == "all"
    page.all('tr').count.should == Movie.all.count+1
  else
    page.all('tr').count.should == 1
  end
end





