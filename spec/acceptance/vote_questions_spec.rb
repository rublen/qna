require_relative 'acceptance_helper'

feature 'Vote for the question', %q{
  In order to illustrate usefullness of question
  As an authenticated user
  I'd like to be able to vote
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  given(:upvote_link) { find("a[href='/questions/#{question.id}/votes/up']") }
  given(:downvote_link) { find("a[href='/questions/#{question.id}/votes/down']") }
  given(:unvote_link) { find("a[href='/votes/#{question.votes[0].id}/unvote']") }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe "Authenticated user can" do
    scenario 'upvote for the question', js: true do
      upvote_link.click
      within(".vote-sum") { expect(page).to have_content 1 }
    end

    scenario 'downvote for the question', js: true do
      downvote_link.click
      within(".vote-sum") { expect(page).to have_content -1 }
    end

    scenario 'get back his vote and revote', js: true do
      upvote_link.click
      within(".vote-sum") { expect(page).to have_content 1 }

      unvote_link.click
      within(".vote-sum") { expect(page).to have_content 0 }

      downvote_link.click
      within(".vote-sum") { expect(page).to have_content -1 }
    end
  end


  describe "Links' behavior" do
    scenario "if question is not voted by user: 'upvote' and 'downvote' links work, 'unvote' is hidden", js: true do
      expect(upvote_link).to be_visible
      expect(downvote_link).to be_visible
      expect(page).to_not have_link(class: 'unvote')
    end

    scenario "if user upvote the question: 'upvote' link replaced with 'unvote', 'downvote' is disabled", js: true do
      upvote_link.click
      sleep(2)
      expect(upvote_link).to_not be_visible
      expect(unvote_link).to be_visible
      expect(page).to_not have_link(class: 'downvote')
    end

    scenario "if user downvote the question: 'downvote' link replaced with 'unvote', 'upvote' is disabled", js: true do
      downvote_link.click
      sleep(2)
      expect(downvote_link).to_not be_visible
      expect(unvote_link).to be_visible
      expect(page).to_not have_link(class: 'upvote')
    end
  end

  describe "The author of question" do
    scenario 'have no voting links' do
      click_on('Log out')
      sign_in(question.author)
      visit question_path(question)

      expect(page).to_not have_css('a.upvote')
      expect(page).to_not have_css('a.downvote')
      expect(page).to_not have_css('a.unvote')
    end
  end

  describe "Non authenticated user", js: true do
    scenario "can't vote" do
      click_on('Log out')
      visit question_path(question)

      upvote_link.click
      expect(page).to have_content('You need to sign in or sign up before continuing.')

      downvote_link.click
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
