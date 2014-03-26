class User < ActiveRecord::Base
	extend FriendlyId

	# relacionamento um-para-muitos com a tabela quartos(rooms)
	has_many :rooms, dependent: :destroy
	has_many :reviews, dependent: :destroy

	# escopos nomeados || named scopes
	scope :most_recent, -> { order('created_at DESC') }
	scope :confirmed, -> { where.not(confirmed_at: nil) }
	scope :not_confirmed, -> { where('confirmed_at IS NULL') }

	# expressão regular para validação de email básica.
	EMAIL_REGEX = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

	validates_presence_of	:full_name, :location, :email
	validates_length_of :bio, :minimum => 30, allow_blank: false
	validates_format_of :email, :with => EMAIL_REGEX
	validates_uniqueness_of :email

	#validar os slugs
	friendly_id :full_name, use: [:slugged, :history]

	#valicação e encripitação bcrypt
	#cria dois campos virtuais password & password_confirmation
	has_secure_password

	# geração do campo user#confirmation_token
	before_create do |user|
		user.confirmation_token = SecureRandom.urlsafe_base64
	end

	before_update do |user|
		user.slug = user.full_name.parameterize
	end

	# verifica se o campo user#confirmed está preenchido,
	# depois limpa o campo de token e coloca a data atual no campo confirmed_at
	# então atualiza o banco de dados do usuarios
	def confirm!
		return if confirmed?

		self.confirmed_at = Time.current
		self.confirmation_token = ''
		save!
	end

	def confirmed?
		confirmed_at.present?
	end

	# Metodo para verificar se os dados do usuario
	# conferem com os dados no banco de dados
	# utilizando try() para acelerar o procedure
	def self.authenticate(email, password)
		user = confirmed.
						find_by(email: email).
						try(:authenticate, password)
	end
end