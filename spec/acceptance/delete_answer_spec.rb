require 'rails_helper'

feature 'Delete answer', %q{
  In order to manage my answers
  As an author of answer
  I want to be able to delete the answer
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, author: users[0]) }
  given!(:answer) { create(:answer, question: question, author: users[1]) }

  scenario 'Author deletes answer' do
    sign_in(users[1])

    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer was deleted successfully.'
    expect(current_path).to eq question_path(question)
  end

  scenario "Not author can't delete question" do
    sign_in(users[0])
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end

end
