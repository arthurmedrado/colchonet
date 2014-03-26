class RoomPresenter
  delegate :user, :created_at, :updated_at, :description, :location, :title, :state,
    :to => :@room

  def initialize(room, context, show_form=true)
    @context = context
    @room = room
    @show_form = show_form
  end

  def can_review?
    @context.user_signed_in? && show_form?
  end

  def show_form?
    @show_form
  end

  def review
    @review ||= @room.reviews.
      find_or_initialize_by_user_id(@context.current_user.id)
  end

  def review_route
    [@room, review]
  end

  def route
    @room
  end

  def review_points
    Review::POINTS
  end

  def stars
    #calcula a media e arrendonda dos reviews sobre o model
    @room.reviews.stars
  end

  def total_reviews
    # calcula o total de reviews para o model
    @room.reviews.size
  end

  def to_partial_path
    'room'
  end
end