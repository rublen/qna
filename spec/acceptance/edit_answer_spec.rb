require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistakes
  As an author
  I want to be able to edit my answer on the current question's page
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question, author: user }

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end

  describe 'Authenticate user tries to edit answer' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'Author tries to edit his answer' do
      within '.answers' do
        click_on 'Edit'
        # fill_in 'Your answer'
      end
    end

    scenario 'Not author tries to edit the answer' do
    end

  end
end
