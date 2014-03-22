// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function(){
	//Login do usuario com Ajax
	$form = $('.content_login form');

	$form.on('ajax:beforeSend', function() {
		disabledInput($form, true, 'Aguardando..');
	});

	$form.on('ajax:error', function(){
		alert('Email ou Senha Inválida');
		disabledInput($form, false, 'Entrar');
	});

	$form.on('ajax:success', function(){
		$form.find('input:submit').attr('value','Redirecionando..');
		window.location = '/rooms';
	});

	/**
	 * Função para desabilitar os inputs do formulario 
	 * durante a request ajax, trocando o valor do submit..
	 * 
	 * @param  {[type]} elem  Formulario
	 * @param  boolean param 	true ou false
	 * @param  string value 	texto do botao
	 * @return {[type]}       [description]
	 */
	var disabledInput = function(elem, param, value){
		elem.find('input').attr('disabled', param);
		elem.find('input:submit').
						attr('disabled', param).
						attr('value',value);
	}

});