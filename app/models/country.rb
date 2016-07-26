class Country < ActiveRecord::Base
	has_and_belongs_to_many :movies
  has_many :directors, through: :movies

	validates_uniqueness_of :nome
end
