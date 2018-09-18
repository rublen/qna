require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask and answer questions
  As a user
  I want to be able to register
} do

  scenario 'Registered user tries to sign up' do
    user = create(:user)

    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Non-registered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test_user@mail.com'
    fill_in 'Password', with: 'test_user.password'
    fill_in 'Password confirmation', with: 'test_user.password'
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end

end
