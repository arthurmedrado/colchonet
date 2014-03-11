class Signup < ActionMailer::Base
	default from: 'no-reply@colcho.net'

	def confirm_email(user)
		@user = user

		#link temporario pois a funcionalidade ainda existe
		#@confirmation_link_html = "#{root_url}confirmations/show/token/#{user.confirmation_token}"
		@confirmation_link_html = confirmation_url({
				token: @user.confirmation_token
			})

		mail({
			to: user.email,
			bcc: ['sign ups < signups@colcho.net>'],
			subject: I18n.t('signup.confirm_email.subject')
		})
	end
end