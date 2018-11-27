class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook, :twitter]

  def author_of?(item)
    item.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    if email
      user = User.where(email: email).first
      if user
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      else
        password = Devise.friendly_token[0,20]
        user = User.create!(email: email, password: password)
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      end
    else
      email = "oauth-#{User.maximum('id') + 1}@temp-mail.com"
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid, confirmed: false)
    end
    user
  end

  def confirmed?(provider)
    authorizations.find_by(provider: provider).confirmed
  end

  def confirm_email_for_oauth(email)
    transaction do
      update!(email: email)
      authorizations.last.update!(confirmed: true)
    end
  end
end
