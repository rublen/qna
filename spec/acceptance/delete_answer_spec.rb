require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to manage my answers
  As an author of answer
  I want to be able to delete the answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }

  given(:question) { create(:question, author: other_user) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Author deletes answer' do
    sign_in(author)

    visit question_path(question)
    expect(page).to have_content answer.body
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario "Not author can't delete question" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end

  scenario "Non-authenticated user can't delete question" do
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end

end
