class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_in_tmdb(movie)
    Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
    
    movie_match = Tmdb::Movie.find(movie)
    movie_arr = Array.new
    
    
    if !movie_match.nil?!
        movie_match.each do |m|
           hash = Hash.new
           hash[:title] = m.title
           hash[:id] = m.id
           hash[:release_date] = m.release_date
           movie_arr.push(hash)
        end   
    else
        movie_arr = []
        return movie_arr
    end 
    
    return movie_arr

  end
  
  def self.create_from_tmdb(id)
    Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
    movie_details = Tmdb::Movie.detail(id)
    
    t = movie_details["title"]
    rd = movie_details["release_date"]
    ov = movie_details["overview"]
    r = movie_details["rating"]
    new_movie = {"title" => t, "rating" => r, "release_date" => rd, "description" => ov}
      
    Movie.create!(new_movie)
  end  
end
