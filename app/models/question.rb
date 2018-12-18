class Question < ApplicationRecord
  include Attachable, Votable, Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, :body, presence: true

  after_create :subscribe

  def best_answer
    answers.find_by(best: true)
  end

  private
  def subscribe
    subscriptions.create(user: author)
  end
end
