require 'rails_helper'

feature 'Write Answer', %q{
  In order to answer the current question
  As an authenticated user
  I want to be able to write my answer on the current question's page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario "Authenticated user can write the answer on the question's page" do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: answer.body
    click_on 'Publish'

    expect(page).to have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario "Non-authenticated user can't write the answer" do
    answer_body = 'AnswerBody'

    visit question_path(question)
    fill_in 'Body', with: answer_body
    click_on 'Publish'

    expect(question_path(question)).to_not have_content answer_body
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
