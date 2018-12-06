require_relative 'acceptance_helper'

feature 'User signs in with facebook', %q{
  In order to be able to sign in with facebook
  As a user
  I want to be able to sign in using my facebook accaunt
} do

  given(:user) { create(:user) }

  describe "Facebook oauth" do
    scenario "existing user always signs in with Facebook account (already has authorization)" do
      user.authorizations.create(provider: 'facebook', uid: '123456')
      visit '/'
      mock_auth_hash('facebook', user.email)
      click_on "Log in"
      click_on "Sign in with Facebook"
      expect(page).to have_content "Welcome, #{user.email}"
      expect(page).to have_content "Log out"
    end

    scenario "existing user signs in with Facebook account first time (hasn't authorization)" do
      visit '/'
      mock_auth_hash('facebook', user.email)
      click_on "Log in"
      click_on "Sign in with Facebook"
      expect(page).to have_content "Welcome, #{user.email}"
      expect(page).to have_content "Log out"
    end

    scenario "unexisting user signs in with Facebook account" do
      visit '/'
      new_user_email = 'new_user@mail.com'
      mock_auth_hash('facebook', new_user_email)
      click_on "Log in"
      click_on "Sign in with Facebook"
      expect(User.last.email).to eq new_user_email
      expect(page).to have_content "Welcome, #{new_user_email}"
      expect(page).to have_content "Log out"
    end
  end

  describe "GitHub oauth" do
    scenario "existing user always signs in with GitHub account (already has authorization)" do
      user.authorizations.create!(provider: 'github', uid: '123456')
      visit '/'
      mock_auth_hash('github')
      click_on "Log in"
      click_on "Sign in with GitHub"
      expect(page).to have_content "Welcome, #{user.email}"
      expect(page).to have_content "Log out"
    end

    scenario "existing user signs in with GitHub account first time (hasn't authorization)" do
      visit '/'
      mock_auth_hash('github')
      click_on "Log in"
      click_on "Sign in with GitHub"
      fill_in "Email", with: user.email
      click_on "Submit"
      expect(page).to have_content "Welcome, #{user.email}"
      expect(page).to have_content "Log out"
    end

    scenario "unexisting user signs in with GitHub account" do
      visit '/'
      new_user_email = 'new_user@mail.com'
      mock_auth_hash('github')
      click_on "Log in"
      click_on "Sign in with GitHub"
      fill_in "Email", with: new_user_email
      click_on "Submit"
      expect(User.last.email).to eq new_user_email
      expect(page).to have_content "Welcome, #{new_user_email}"
      expect(page).to have_content "Log out"
    end
  end
end
