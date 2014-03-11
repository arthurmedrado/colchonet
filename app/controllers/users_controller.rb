class UsersController < ApplicationController
	# set params[:id] nas actions abaixo
	before_action :set_user, only: [:show, :edit, :update]

	# validações para permissão de actions(paginas/rotas)
	## somente o usuario pode editar e atualizar seu perfil
	before_action :can_change, only: [:edit, :update]
	## nao requer autenticação para um novo cadastro
	before_action :require_no_authentication, only: [:new, :create]

	## requer autenticação para atualizar e ver o perfil
	before_action :require_authentication, only: [:update, :show]

	before_action :redirect_root, only: [:index]

	def index
		@user = User.all
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			# se conta criada, envia um email para confirmação
			Signup.confirm_email(@user).deliver

			#flash[:notice] = 'Cadastro criado com sucesso.'
			redirect_to @user, 
				notice: 'Cadastro criado com sucesso, verifique seu email!'
		else
			render :new
		end
	end

	def show
	end

	def edit
	end

	def update
		if @user.update(user_params)
			redirect_to @user, 
				notice: 'Atualizado com sucesso'
		else
			render :edit
		end
	end

	private

	def set_user
		@user ||= User.find(params[:id])
	end

	def user_params
		params.
			require(:user).
			permit(:email, :location, :full_name, :password, :password_confirmation, :bio)
	end

	def can_change
		unless user_signed_in? && current_user == set_user
			redirect_to user_path(params[:id])
		end
	end
end