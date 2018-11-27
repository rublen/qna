class OauthMailer < ApplicationMailer
  def confirm_email_for_oauth(user)
    @user = user
    mail to: @user.email, subject: "Confirm this email for authorization with GitHub"
end
