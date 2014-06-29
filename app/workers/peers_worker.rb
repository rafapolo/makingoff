class PeersWorker
  include Sidekiq::Worker

  def perform(movie_id)
    movie = Movie.find(movie_id)
    torrent = movie.torrent
    if torrent.valid?
      puts "== Movie #{movie.id} =================".blue
      last_count = torrent.get_seeds_count
      Seed.create(movie_id: movie.id, count: last_count)
      movie.update(count: last_count)
    else
      movie.update(count: nil)
      puts "== Movie #{movie.id} sem torrent =================".red
    end
  end
end
