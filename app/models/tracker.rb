class Tracker < ActiveRecord::Base
  has_and_belongs_to_many :movies

  def self.last_alives
    Tracker.where("last_alive_at > ?", 1.month.ago).pluck(:url)
  end
end
