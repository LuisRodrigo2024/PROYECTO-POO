$(document).ready(function() {
	/*var $imgHolder 	= $('#main-bg-list');
	var $bgBtn 		= $imgHolder.find('.main-chg-bg');
	var $target 	= $('#bg-overlay');

	$bgBtn.on('click', function(e){
		e.preventDefault();
		e.stopPropagation();


		var $el = $(this);
		if ($el.hasClass('active') || $imgHolder.hasClass('disabled'))return;
		if ($el.hasClass('bg-trans')) {
			$target.css('background-image','none');
			$imgHolder.removeClass('disabled');
			$bgBtn.removeClass('active');
			$el.addClass('active');

			return;
		}

		$imgHolder.addClass('disabled');
		var url = $el.data('image');

		$('<img/>').attr('src' , url).load(function(){
			$target.css('background-image', 'url("' + url + '")');
			$imgHolder.removeClass('disabled');
			$bgBtn.removeClass('active');
			$el.addClass('active');

			$(this).remove();
		})

	});
	
	$bgBtn.first().trigger('click');
	*/
	
	$('#loginForm').submit(function(e){
		e.preventDefault();
		$('#loginButton').prop('disabled', true);
		$.post('/usuarios/do_login', $(this).serialize(), function(r){
			$('#loginButton').prop('disabled', false);
			switch(parseInt(r[0])){
				case 1:
					window.location = '/';
				break;

				case 0:
					zk.pageAlert({message: 'Los datos ingresados son incorrectos', type: 'danger', icon: 'remove', container: '.panel'})
					
				break;

				case -1:
					zk.pageAlert({message: 'El usuario no tiene roles definidos', type: 'danger', icon: 'remove', container: '.panel'})
				break;

				case 2:
					selectRoleWindow(r);
				break;

				case -2:
					zk.pageAlert({message: 'El usuario no está activo', type: 'danger', icon: 'remove', container: '.panel'})
				break;

				case -10:
					zk.pageAlert({message: 'El usuario no está activo', type: 'danger', icon: 'remove', container: '.panel'})
				break;

			}
		}, 'json');
	});

});

function selectRoleWindow(r){
	var message = '<div class="form-block">';
	for(i in r.roles){
		message += '<button class="btn btn-block btn-primary" onclick="doLoginToken(\''+ r.roles[i] +'\', \''+ r.token +'\')">'+ r.roles[i] +'</button>';
	}
	message += '</div>';

	bootbox.dialog({
		title: "Seleccione un rol",
		message: message,
		size: 'small'
	});
} 

function doLoginToken(role, token){
	
	$.post('/usuarios/login_token', {role: role, token: token}, function(r){
		switch(parseInt(r[0])){
			case 1:
				window.location = '/';
			break;

			case 0:
				bootbox.hideAll();
				zk.pageAlert({message: 'Los datos ingresados son incorrectos', type: 'danger', icon: 'remove', container: '.panel'})
			break;
		}
	}, 'json');
	
}