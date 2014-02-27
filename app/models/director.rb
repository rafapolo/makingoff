class Director < ActiveRecord::Base
	has_and_belongs_to_many :movies
  has_many :genres, through: :movies

	validates_uniqueness_of :nome

  after_save :log
  def log
    puts "Created #{self.nome}".blue
  end
end
