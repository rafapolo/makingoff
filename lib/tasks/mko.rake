# extrapolo

namespace :mko do
  desc "Atualiza Movie torrent seeds"
  task :update_seeds => :environment do
    Movie.where('count is null').where('id > 8000').each do |m|
      torrent = m.torrent
      if torrent && m.count == nil
        puts "== Movie #{m.id} =================".blue
        m.update(count: torrent.get_seeds_count)
      end
    end
  end

  desc "Atualiza Movie torrent info"
  task :update_torrent_info => :environment do
    Movie.all.each do |m|
      torrent = m.torrent
      if torrent
        puts "== Movie #{m.id} =================".blue
        m.update(torrent_hash: torrent.hash)
        m.update(torrent_size: torrent.size)
        m.update(torrent_name: torrent.name.force_encoding('iso-8859-1').encode('utf-8'))
      end
    end
  end

  desc "Pega Tudo"
  task :pega => :environment do
      require "#{Rails.root.to_s}/lib/crawler/makingoff.rb"
      Makingoff.crawlear!
  end
end
