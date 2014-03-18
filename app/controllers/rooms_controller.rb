class RoomsController < ApplicationController
  before_action :set_room, only: [:edit, :update, :destroy]
  before_action :require_authentication, only: [:new, :edit, :create, :update, :destroy]

  def index
    # O método #map, de coleções, retornará um novo Array
    # contendo o resultado do bloco. Dessa forma, para cada
    # quarto, retornaremos o presenter equivalente.
    @rooms = Room.most_recent.map do |room|
      # Não exibiremos o formulário na listagem
      RoomPresenter.new(room, self, false)
    end
  end

  def show
    room_model = Room.find(params[:id])
    @room = RoomPresenter.new(room_model, self)
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
    #@room = current_user.rooms.find(params[:id])
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, 
        notice: t('flash.notice.room_created')
    else
      render action: 'new'
    end
  end

  def update
    #@room = current_user.rooms.find(params[:id])

    if @room.update(room_params)
      redirect_to @room, 
        notice: t('flash.notice.room_updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_url
  end

  def my_rooms
    @my_rooms = current_user.rooms.most_recent.map do |room|
      RoomPresenter.new(room, self, true)
    end
  end

  private
    def set_room
        @room = current_user.rooms.find(params[:id])
    end

    def room_params
      params.
        require(:room).
        permit(:title, :location, :description, :state)
    end
end
