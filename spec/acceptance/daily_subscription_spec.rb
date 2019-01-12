require_relative 'acceptance_helper'

feature 'Daily subscription', %q{
  In order to be informed about a new answer for current question
  As an ordinary user
  I want to be able to subscribe/unsubscribe for the question mailings
} do

  given(:user) { create(:user) }

  context "Authenticated user" do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario "subscribe/unsubscribe for daily mailings", js: true do
      expect(page).to have_link 'Unsubscribe', href: "/subscriptions/#{user.subscriptions.first.id}"
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe', href: "/subscriptions/daily"

      click_on 'Subscribe'
      expect(current_path).to eq questions_path
      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe', href: "/subscriptions/#{user.subscriptions.first.id}"
    end
  end

  context "None authenticated user" do
    background do
      visit questions_path
    end

    scenario "can not subscribe/unsubscribe for daily mailings", js: true do
      expect(page).to_not have_link 'Unsubscribe'

      click_on 'Subscribe'
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end
