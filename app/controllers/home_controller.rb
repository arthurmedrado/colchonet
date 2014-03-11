class HomeController < ApplicationController
  def index
  	# Busca sem ordem determinada de até 3 quartos
  	@rooms = Room.most_recent.take(3)
  end
end
