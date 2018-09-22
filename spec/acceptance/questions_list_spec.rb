require 'rails_helper'

feature 'Questions list', %q{
  In order to see what people used to ask
  As an ordinary user
  I want to be able to look over the list of questions
} do

  given(:user) { create :user }
  given!(:questions) { create_list(:question, 2, author: user ) }

  scenario 'Every user can see the list of question' do
    visit questions_path

    questions.each { |quest| expect(page).to have_content quest.title }
  end

end
