class ApplicationController < ActionController::Base
	delegate :current_user, :user_signed_in?, to: :user_session

	# transforma os metodos em helpers
	helper_method :current_user, :user_signed_in?, :recent_rooms, :total_rooms

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # antes de cada action define qual locale irá ser setado como padrão
  before_action do
  	I18n.locale = params[:locale] || I18n.default_locale
  end

  # define como padrão a tradução para o pt-BR
  def default_url_options
  	{ locale: I18n.locale }
  end

  # necessario authenticação
  # a nao ser que o usuario esteja logado, redirecione
  def require_authentication
  	unless user_signed_in?
  		redirect_to new_user_sessions_path,
  			alert: t('flash.alert.needs_login')
  	end
  end

	# se ele ja estiver logado, manda ele pra pagina principal,
	# e de a notice, que ja esta logado
  def require_no_authentication
  	if user_signed_in?
  		redirect_to root_path,
  			notice: t('flash.notice.already_logged_in')
  	end
  end

  def user_session
  	UserSession.new(session)  	
  end

  def redirect_root
    redirect_to root_path   
  end

  def recent_rooms
    Room.most_recent.take(3).count
  end

  def total_rooms
    Room.count
  end
end
