class CreateRelations < ActiveRecord::Migration
  def change
    create_table 'countries_movies', :id => false do |t|
      t.integer :movie_id
      t.integer :country_id
    end

    create_table 'genres_movies', :id => false do |t|
      t.integer :movie_id
      t.integer :genre_id
    end

    create_table 'directors_movies', :id => false do |t|
      t.integer :movie_id
      t.integer :director_id
    end

    create_table 'movies_trackers', :id => false do |t|
      t.integer :tracker_id
      t.integer :movie_id
    end

    create_table 'movies_trackers', :id => false do |t|
      t.integer :tracker_id
      t.integer :movie_id
    end

  end
end
