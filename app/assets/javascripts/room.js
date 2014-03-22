$(function(){
	var $review = $('.review');

	//Antes de enviar
	$review.on('ajax:beforeSend', function() {
		$(this).find('input').attr('disabled', true);
	});

	//Se houver erro na requisição
	$review.on('ajax:error', function() {
		replaceButton(this, 'fa fa-times-circle', '#B94A48');

		alert('Houve um erro na requisição ajax dos Reviews');

		setTimeout(function(){
			window.location = '/';
		}, 1000)
	});

	//Quando houver sucesso na requisição
	$review.on('ajax:success', function() {
		replaceButton(this, 'fa fa-check', '#468847');

		// setTimeout(function(){
		// 	window.location = '/rooms';
		// },3000)
	});

	function replaceButton(container, icon_class, color) {
		$(container).find('input:submit').
									replaceWith($('<i/>').
									addClass(icon_class).
									css('color', color));
	};

	/**
	 * Mudar a cor das estrelas nos reviews
	 * @param  {[type]} elem alvo
	 * @return {[type]}      mudar a cor
	 */
	function highlightStars(elem){
		elem.parent().children('label').removeClass('toggled');
		elem.addClass('toggled').prevAll('label').addClass('toggled');
	};

	highlightStars($('.review input:checked + label'))

	var $stars = $('.review input:enabled ~ label');

	$stars.on({
		mouseenter: function(){
			highlightStars($(this));
		},

		mouseleave: function(){
			highlightStars($('.review input:checked + label'));
		}
	});

	// Desativa os Event Handlers
	$('.review input').on('change', function() {
		$stars.off('mouseenter').off('mouseleave').off('click').off('touch');
		$(this).parent('form').submit();
	});

});