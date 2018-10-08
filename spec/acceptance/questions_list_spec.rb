require_relative 'acceptance_helper'

feature 'Questions list', %q{
  In order to see what people used to ask
  As an ordinary user
  I want to be able to look over the list of questions
} do

  given(:user) { create :user }
  given!(:questions) { create_list(:question, 2, author: user ) }

  scenario 'Every user can see the list of question' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end

  scenario "User can click on question's title to visit question's page" do
    questions.each do |question|
      visit questions_path
      click_on question.title
      expect(current_path).to eq question_path(question)
    end
  end

end
