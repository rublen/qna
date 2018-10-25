class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(item)
    item.user_id == id
  end
end
