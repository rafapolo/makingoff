class Movie < ActiveRecord::Base
  has_and_belongs_to_many :directors
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :trackers
  has_many :seeds

  scope :vivos, -> {where('count > 0')}
  scope :vermelho, -> {where('count = 0 or count is null')}
  scope :laranja, -> {where('count = 1')}
  scope :amarelo, -> {where('count = 2 or count = 3')}
  scope :verde, -> {where('count > 4')}

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
