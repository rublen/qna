require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to close the session
  As a signed-in user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Signed-in user logs out' do
    sign_in(user)
    click_on 'Log out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Log in'
  end

end
