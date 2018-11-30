class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

  def author_of?(item)
    item.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first if email

    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      return user
    end

    if email
      user = User.create!(email: email, password: Devise.friendly_token[0,20])
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      email = "oauth-#{User.maximum('id').to_i + 1}@temp-mail.com"
      user = User.create!(email: email, password: Devise.friendly_token[0,20])
      user.authorizations.create(provider: auth.provider, uid: auth.uid, confirmed: false)
    end
    user
  end

  def confirmed?(provider)
    authorizations.find_by(provider: provider).confirmed
  end

  # если пользователь с таким емейлом существует, то фейкового пользователя удаляем, если нет - обновляем реальным емейлом
  def oauth_confirm_email(provider, uid, email)
    if user = User.find_by(email: email)
      destroy
      user.authorizations.create(provider: provider, uid: uid)
      user
    else
      transaction do
        update!(email: email)
        authorizations.where(provider: provider).last.update!(confirmed: true)
      end
      self
    end
  end
end
