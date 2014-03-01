# extrapolo

namespace :mko do
  desc "Atualiza seeds count"
  task :update_seeds => :environment do
    Movie.all.each do |m|
      if m.seeds.size < 2
        PeersWorker.perform_async(m.id)
      end
    end
  end

  task :update_magnets => :environment do
    Movie.all.each do |m|
      if m.torrent && m.torrent.valid?
        puts "Magnetizando #{m.original}".yellow
        m.update(magnet_link: m.torrent.magnet_link)
      end
    end
  end

  desc "Corrige ano pelo IMDB"
  task :fix_ano => :environment do
    require 'open-uri'
    Movie.where('ano < 1890').each do |m| # pois não havia cinema
      title = m.original.empty? ? URI::encode(m.nome) : URI::encode(m.original)
      imdb = JSON.load open("http://www.imdb.com/xml/find?json=1&nr=1&tt=on&q=#{title}")
      info = imdb['title_approx'].first['title_description'] if imdb && imdb['title_approx']
      if info
        ano = info.match(/\d+/)[0]
        puts "#{m.nome} => #{ano}".green
        m.update(ano: ano.to_i)
      else
        puts "#{m.original}".red
      end
    end
  end

  desc "Atualiza Movie torrent info"
  task :update_torrent_info => :environment do
    Movie.where().each do |m|
      torrent = m.torrent
      if torrent && torrent.valid?
        m.update(torrent_hash: torrent.hash)
        m.update(torrent_size: torrent.size)
        m.update(torrent_name: torrent.name.force_encoding('iso-8859-1').encode('utf-8'))
        m.trackers = []
        torrent.announce_list.each do |tracker|
          tracker = TorrentInfo.valid_tracker tracker
          m.trackers << tracker if tracker
        end
        m.save
        puts "== #{m.torrent_name} => #{m.torrent_size} ==".yellow
      end
    end
  end

  desc "Resize all images with more than 1MB to 900px width" # with sips
  task :update_images_size => :environment do
    system "cd #{Rails.root}/public/capas; find . -size +1M | while read file_name; do sips $file_name --resampleWidth 900 ; done"
    # afterall, was better resize all to 185px
  end

  desc "Descompacta anexos em pastas"
  task :unzip => :environment do
      def get_id file
        file.to_s.scan(/\/(\d+)_/)[0][0]
      end
      puts "Uncompacting..."
      Dir.glob("#{Rails.root}/public/files/*.rar") do |rar|
        id = get_id(rar)
        system("unrar x -y \"#{rar}\" public/files/#{id}/")
      end
      Dir.glob("#{Rails.root}/public/files/*.zip") do |zip|
        id = get_id(zip)
        system("unzip -o \"#{zip}\" -d public/files/#{id}/")
      end
  end

  desc "Update Directors"
  task :update_directors => :environment do
    require "#{Rails.root.to_s}/lib/crawler/makingoff.rb"
    browser = Makingoff.autentica!
    ids = Movie.all.pluck(:mko_id)
    ids.each do |id|
      puts "= Movie #{id} ==".yellow
      Makingoff.update_diretores(browser, id)
    end
  end

  desc "Pega Tudo"
  task :pega => :environment do
      require "#{Rails.root.to_s}/lib/crawler/makingoff.rb"
      Makingoff.crawlear!
  end
end
