require_relative 'acceptance_helper'

feature 'The best answer for question', %q{
  In order to rate answers for current question
  As an author of question
  I want to be able to choose the best answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }

  given(:question) { create(:question, author: author) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario "Author can choose the best answer", js: true do
    sign_in(author)
    visit question_path(question)
    save_and_open_page
    within '.answers' do
      click_on 'Mark as the best'
      expect(current_path).to eq question_path(question)
    end
  end

  scenario "Author can change his mind and choose another best answer", js: true do
    sign_in(author)
    visit question_path(question)
  end

  scenario "The best answer is first in the list", js: true do
    sign_in(author)
    visit question_path(question)
  end

  scenario "Not author can't choose the best answer", js: true do
    sign_in(other_user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content 'Mark as the best'
    end
  end
end
