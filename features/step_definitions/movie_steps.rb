# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  uncheck("ratings_G") 
  uncheck("ratings_PG") 
  uncheck("ratings_R") 
  uncheck("ratings_PG-13") 
  uncheck("ratings_NC-17")
  
  arg1.split(", ").each do |i|
    page.check("ratings_" + i)    
  end
  
  click_button 'Refresh'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    all_ratings = Hash.new
    all_ratings = {"G" => true, "PG" => true, "PG-13" => true, "R" => true, "NC-17" => true}


    arg1.split(", ").each do |i|
       if arg1.split(", ") != "G"
           all_ratings["G"] = false
       elsif arg1.split(", ") != "PG"
           all_ratings["PG"] = false
       elsif arg1.split(", ") != "PG-13"
           all_ratings["PG-13"] = false
       elsif arg1.split(", ") != "R"
           all_ratings = false
       elsif arg1.split(", ") != "NC-17"
           all_ratings = false
       end
    end    
end

Then /^I should see all of the movies$/ do
  value = Movie.all.size
  rows = all("tbody/tr").size
  rows.should == value
end

When /^I follow "(.*?)"$/ do |arg1|
    click_link arg1
end     

Then /^I should see "(.*?)" before "(.*?)"/ do |arg1, arg2|
    page.body.should match /#{arg1}.*#{arg2}/m
end

