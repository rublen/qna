require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  In order to change my answer
  As an answer author
  I'd like to be able to delete files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'User deletes file from answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'rails_helper.rb'
    click_on 'del'
    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'Not author can not delete the file' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_button 'del'
  end
end
