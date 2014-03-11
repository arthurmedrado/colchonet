module ApplicationHelper

	# verifica se há um erro no atributo do model, 
	# e cria uma div.error_message
	def error_tag(model, attribute)
			if model.errors.has_key? attribute
				content_tag(
					:div,
					model.errors[attribute].first,
					class: 'error_message'
				)
		end #fim if
	end #fim def
end #fim module
