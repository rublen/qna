require_relative 'acceptance_helper'

feature 'Question and its answers', %q{
  In order to see what people answered to this question
  As an ordinary user
  I want to be able to look over the list of answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Every user can see title and body of question' do
    visit question_path(question)

    expect(page).to have_content question.title, question.body
  end

  scenario 'Every user can see the list of answers for this question' do
    visit question_path(question)

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

end
