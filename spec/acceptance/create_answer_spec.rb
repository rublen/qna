require 'rails_helper'

feature 'Create Answer', %q{
  In order to answer the current question
  As an authenticated user
  I want to be able to write my answer on the current question's page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario "Authenticated user can write the answer on the question's page", js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: "answer_body"
    click_on 'Publish'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content "answer_body"
    end
  end

  scenario "Authenticated user can't save the empty answer", js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Publish'

    # expect(page).to have_content "Body can't be blank"
  end

  scenario "Non-authenticated user can't write the answer" do
    visit question_path(question)
    fill_in 'Your answer', with: 'answer_body'
    click_on 'Publish'

    expect(current_path).to eq user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'

    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content "answer_body"
    end
  end

end
