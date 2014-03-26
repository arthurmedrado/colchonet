class Room < ActiveRecord::Base
	extend FriendlyId

	belongs_to :user
	has_many :reviews, dependent: :destroy
	has_many :reviewed_rooms, through: :reviews, source: :room

	scope :most_recent, -> { order('created_at DESC') }
	scope :max_reviews, -> { order('reviews_count DESC') }

	validates_presence_of :title, :location, :description, :state
	validates_length_of :description, :maximum => 1000
	validates_length_of :state, :minimum => 2

	#validar os slugs
	friendly_id :title, use: [:slugged, :history]

	def complete_name
		"#{title}, #{location}"		
	end

	def self.search(query)
		if query.present?
			where(['location LIKE :query OR 
							title LIKE :query OR 
							description LIKE :query  OR
							state LIKE :query', query: "%#{query}%"])
		else
			scoped
		end
	end
end

