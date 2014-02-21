class Movie < ActiveRecord::Base
	has_and_belongs_to_many :directors
	has_and_belongs_to_many :genres
	has_and_belongs_to_many :countries

	validates_uniqueness_of :nome

  def torrent
    require "#{Rails.root.to_s}/lib/torrent_info"
    file = Rails.root.join("public/torrents/#{self.id}.torrent")
    return nil unless File.exists?(file)
    TorrentInfo.new file
  end

end


