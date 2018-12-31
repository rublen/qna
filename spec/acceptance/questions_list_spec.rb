require_relative 'acceptance_helper'

feature 'Questions list', %q{
  In order to see what people used to ask
  As an ordinary user
  I want to be able to search or look over the list of questions
} do

  given!(:questions) { create_list(:question, 2 ) }

  background { ThinkingSphinx::Test.index 'question_core' }

  scenario 'Every user can see the clickable list of all questions', js: true do
    ThinkingSphinx::Test.run do
      questions.each do |question|
        visit questions_path
        click_on question.title
        expect(current_path).to eq question_path(question)
      end
    end
  end

  scenario 'Every user can search an appropriate question', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path
      fill_in 'question_search', with: questions.first.title
      click_on 'Find question'
      expect(page).to have_link questions.first.title
    end
  end
end
