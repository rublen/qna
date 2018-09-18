require 'rails_helper'

feature 'Write Answer', %q{
  In order to answer the current question
  As a user
  I want to be able to write my answer on the current question's page
} do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario "User can write the answer on the question's page" do
    visit question_path(question)

    fill_in 'Body', with: answer.body
    click_on 'Publish'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answer.body
  end

end
