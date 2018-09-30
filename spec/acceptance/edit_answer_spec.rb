require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistakes
  As an author
  I want to be able to edit my answer on the current question's page
} do

  given(:answer_author) { create :user }
  given(:other_user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question, author: answer_author }

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end

  describe 'The author tries to edit answer' do
    before do
      sign_in answer_author
      visit question_path(question)
    end

    scenario 'Author tries to edit his answer with valid attributes', js: true do
      within '.answers' do
        expect(page).to have_content(answer.body)

        click_on 'Edit'
        fill_in 'Your answer', with: 'edited body'
        click_on 'Publish'

        expect(current_path).to eq question_path(question)
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content('edited body')
        expect(page).to_not have_content(answer.body)
      end
    end

    scenario 'Author tries to edit his answer with invalid attributes', js: true do
      within '.answers' do
        expect(page).to have_content(answer.body)

        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Publish'

        expect(current_path).to eq question_path(question)
        expect(page).to have_selector 'textarea'
        expect(page).to have_content(answer.body)
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe 'Not author can not edit the answer' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'Not author have no Edit link for answer' do
      within '.answers' do
        expect(page).to_not have_link('Edit')
      end
    end
  end
end
