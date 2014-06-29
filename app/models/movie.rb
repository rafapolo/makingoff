class Movie < ActiveRecord::Base
	has_and_belongs_to_many :directors
	has_and_belongs_to_many :genres
	has_and_belongs_to_many :countries
  has_and_belongs_to_many :trackers
  has_many :seeds

  scope :vivos, -> {where('count > 0')}
  scope :preto, -> {where('torrent_hash is null')}
  scope :vermelho, -> {where('count = 0')}
  scope :laranja, -> {where('count = 1')}
  scope :amarelo, -> {where('count BETWEEN 2 AND 6')}
  scope :verde, -> {where('count > 6')}

  validates_uniqueness_of :nome

  def torrent
    require "#{Rails.root.to_s}/lib/torrent_info"
    file = Rails.root.join("public/torrents/#{self.id}.torrent")
    TorrentInfo.new file
  end

  before_save :urlize
  def urlize
    self.urlized = self.nome.urlize
  end

end
