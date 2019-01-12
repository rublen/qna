class Question < ApplicationRecord
  include Attachable, Votable, Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, :body, presence: true

  after_create :subscribe_author

  scope :last_day_list, -> { where("created_at > ?", Time.now - 1.day) }

  def best_answer
    answers.find_by(best: true)
  end

  private

  def subscribe_author
    subscriptions.create(user: author)
  end
end
