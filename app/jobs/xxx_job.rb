class XxxJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.update!(body: answer.body + "♥♥♥")
  end
end
