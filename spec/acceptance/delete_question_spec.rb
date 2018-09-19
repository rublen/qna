require 'rails_helper'

feature 'Delete question', %q{
  In order to manage my questions
  As an author of question
  I want to be able to delete the question
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users[0]) }


  scenario 'Author deletes question' do
    sign_in(users[0])

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was deleted successfully.'
    expect(current_path).to eq questions_path
  end

  scenario "Not author can't delete question" do
    sign_in(users[1])
    visit question_path(question)

    expect(page).to_not have_content 'Delete Question'
  end

  scenario "Non-authenticated user can't delete question" do
    visit question_path(question)

    expect(page).to_not have_content 'Delete Question'
  end
end
