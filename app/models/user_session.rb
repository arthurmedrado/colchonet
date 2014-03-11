class UserSession
	# incluid a biblioteca Model na class atual
	include ActiveModel::Model

	# valição para entrada de dados
	attr_accessor :email, :password
	validates_presence_of :email, :password

	# encapsulamento das variaveis
	def initialize(session, attributes={})
		@session = session
		@email = attributes[:email]
		@password = attributes[:password]
	end

	# se a authenticação for bem sucedida,
	# grava os dados do usuario na session
	def authenticate!
		user = User.authenticate(@email, @password)

		if user.present?
			store(user)
		else
			errors.add(:base, :invalid_login)
			false
		end		
	end

	# grava o id do usuario na sessão
	def store(user)
		@session[:user_id] = user.id
	end

	# utilizado para verificar os dados do usuario da session ativa 
	def current_user
		User.find(@session[:user_id])
	end

	# utilizando para verificar se existe a presença de um user_id na session
	def user_signed_in?
		@session[:user_id].present?
	end

	# limpa a session#user_id
	def destroy
		@session[:user_id] = nil
	end
end