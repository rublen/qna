require_relative 'acceptance_helper'

feature 'Follow/Unfollow the question', %q{
  In order to be informed about a new answer for current question
  As an ordinary user
  I want to be able to subscribe/unsubscribe for the question mailings
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { build(:answer, question: question) }

  context "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "follows/unfollows the question", js: true do
      expect(page).to have_link 'Follow', href: "/questions/#{question.id}/subscriptions"
      click_on 'Follow'
      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link 'Follow'
      expect(page).to have_link 'Unfollow', href: "/subscriptions/#{user.subscriptions.first.id}"
      click_on 'Unfollow'
      expect(page).to_not have_link 'Unfollow'
      expect(page).to have_link 'Follow', href: "/questions/#{question.id}/subscriptions"
    end
  end

  context "None authenticated user" do
    background do
      visit question_path(question)
    end

    scenario "can not follow/unfollow the question", js: true do
      expect(page).to_not have_link 'Unfollow'
      click_on 'Follow'
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end
