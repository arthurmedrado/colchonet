$(function(){
	var $review = $('.review');

	//Antes de enviar
	$review.on('ajax:beforeSend', function() {
		$(this).find('input').attr('disabled', true);
	});

	//Se houver erro na requisição
	$review.on('ajax:error', function() {
		replaceButton(this, 'fa fa-times-circle', '#B94A48');
	});

	//Quando houver sucesso na requisição
	$review.on('ajax:success', function() {
		replaceButton(this, 'fa fa-check', '#468847');
	});

	function replaceButton(container, icon_class, color) {
		$(container).find('input:submit').
									replaceWith($('<i/>').
									addClass(icon_class).
									css('color', color));
	};

});