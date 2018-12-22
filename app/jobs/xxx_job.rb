class XxxJob < ApplicationJob
  queue_as :default

  def perform(id)
    answer = Answer.find(id)
    answer.update!(body: answer.body + "😉")
  end
end
