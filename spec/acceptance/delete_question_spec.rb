require_relative 'acceptance_helper'

feature 'Delete question', %q{
  In order to manage my questions
  As an author of question
  I want to be able to delete the question
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: author) }


  scenario 'Author deletes question' do
    sign_in(author)
    visit questions_path

    within('.questions') { click_on question.title }
    expect(current_path).to eq question_path(question)

    within('.question') { click_on 'Delete' }
    expect(current_path).to eq questions_path

    expect(page).to_not have_content question.title
    expect(page).to have_content 'Question was deleted successfully.'
  end

  scenario "Not author can't delete question" do
    sign_in(other_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario "Non-authenticated user can't delete question" do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
