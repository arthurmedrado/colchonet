class Room < ActiveRecord::Base
	belongs_to :user
	has_many :reviews, dependent: :destroy
	has_many :reviewed_rooms, through: :reviews, source: :room

	scope :most_recent, -> { order('created_at DESC') }

	validates_presence_of :title, :location, :description, :state
	validates_length_of :description, :maximum => 1000
	validates_length_of :state, :minimum => 2

	def complete_name
		"#{title}, #{location}"		
	end
end

