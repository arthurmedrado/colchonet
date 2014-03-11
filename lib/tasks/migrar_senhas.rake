# encoding: utf-8

namespace :app do

	desc "Encripta todas as senhas que ainda não foram processadas no banco de dados"
	
	task migrar_senhas: :environment do
		unless User.attribute_names.include? "password"
			puts "As senhas já foram todas migradas, terminando..."
			return			
		end

		# find_each percorre de 1000 em 1000 para não gerar uma busca no banco todo, 
		# evitando sobrecarga no servidor
		User.find_each do |user|
			puts "Migrando usúario ##{user.id} ##{user.full_name}"
			unencripted_password = user.attributes["password"]

			user.password = unencripted_password
			user.password_confirmation = unencripted_password
			user.save!
		end
	end
end