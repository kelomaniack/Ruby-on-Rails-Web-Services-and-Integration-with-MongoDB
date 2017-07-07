json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :type, :rated, :year, :release_date, :runtime, :votes, :countries, :languages, :genres, :filming_locations, :metascore, :simple_plot, :plot, :url_imdb, :url_poster, :directors, :actors
  json.url movie_url(movie, format: :json)
end
