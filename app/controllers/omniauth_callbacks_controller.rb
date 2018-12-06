class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user_for_oauth, only: %i[github facebook]
  before_action :set_user, only: %i[oauth_update_email]

  def facebook
    login_with('Facebook') if @user.persisted?
  end

  def github
    if @user.persisted?
      @user.confirmed?('github') ? login_with('github') : render('oauth_enter_email')
    end
  end

  def oauth_enter_email; end

  def oauth_update_email
    provider = @user.authorizations.last.provider
    uid = @user.authorizations.last.uid
    email = user_params[:email]

    if @user = @user.oauth_confirm_email(provider, uid, email)
      login_with(provider)
    end
  end


  private

  def auth
    request.env['omniauth.auth']
  end

  def set_user_for_oauth
    @user = User.find_for_oauth(auth)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def login_with(provider)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end
end
