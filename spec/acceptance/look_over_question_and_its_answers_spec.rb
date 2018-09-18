require 'rails_helper'

feature 'Questions list', %q{
  In order to see what people answered to this question
  As an ordinary user
  I want to be able to look over the list of answers
} do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Every user can see the list of answers for this question' do
    visit question_path(question)

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

end
