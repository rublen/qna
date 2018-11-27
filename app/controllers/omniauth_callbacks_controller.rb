class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user_for_oauth, only: %i[github facebook]
  before_action :set_user, only: %i[oauth_enter_email oauth_update_email]

  def github
    if @user.persisted? && @user.confirmed?(auth.provider)
      login_with('GitHub')
    else
      render 'oauth_enter_email'
    end
  end

  def facebook
    login_with('Facebook') if @user.persisted?
  end

  def oauth_enter_email; end

  def oauth_update_email
    if @user.confirm_email_for_oauth(user_params)
      login_with(@user.authorizations.last.provider)
    end
  end


  private

  def user_params
    params.require(:user).permit(:email)
  end

  def auth
    request.env['omniauth.auth']
  end

  def set_user_for_oauth
    @user = User.find_for_oauth(auth)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def login_with(provider)
    sign_in_and_redirect @user
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end
end
