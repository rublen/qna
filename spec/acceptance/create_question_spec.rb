require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: '12345678'
    click_on 'Publish'

    expect(page).to have_content 'Your question was successfully created'
  end

  scenario 'Authenticated user can not create invalid question', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    click_on 'Publish'

    expect(page).to have_content "Title can't be blank", "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
