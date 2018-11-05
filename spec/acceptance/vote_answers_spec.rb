require_relative 'acceptance_helper'

feature 'Vote for the answer', %q{
  In order to illustrate usefullness of answer
  As an authenticated user
  I'd like to be able to vote
} do

  given(:user) { create(:user) }
  given (:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  given(:upvote_link) { find("a[href='/answers/#{answer.id}/votes/up']") }
  given(:downvote_link) { find("a[href='/answers/#{answer.id}/votes/down']") }
  given(:unvote_link) { find("a[href='/votes/#{answer.votes[0].id}/unvote']") }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe "Authenticated user can:" do
    scenario 'upvote for the answer', js: true do
      within '.answers' do
        upvote_link.click
        within(".vote-sum") { expect(page).to have_content 1 }
      end
    end

    scenario 'downvote for the answer', js: true do
      within '.answers' do
        downvote_link.click
        within(".vote-sum") { expect(page).to have_content -1 }
      end
    end

    scenario 'get back his vote and revote', js: true do
      within '.answers' do
        upvote_link.click
        within(".vote-sum") { expect(page).to have_content 1 }

        unvote_link.click
        within(".vote-sum") { expect(page).to have_content 0 }

        downvote_link.click
        within(".vote-sum") { expect(page).to have_content -1 }
      end
    end
  end


  describe "Links' behavior" do
    scenario "if answer is not voted by user: 'upvote' and 'downvote' links work, 'unvote' is hidden", js: true do
      within '.answers' do
        expect(upvote_link).to be_visible
        expect(downvote_link).to be_visible
        expect(page).to_not have_link(class: 'unvote')
      end
    end

    scenario "if user upvote the answer: 'upvote' link replaced with 'unvote', 'downvote' is disabled", js: true do
      within '.answers' do
        upvote_link.click
        sleep(2)
        expect(upvote_link).to_not be_visible
        expect(unvote_link).to be_visible
        expect(page).to_not have_link(class: 'downvote')
      end
    end

    scenario "if user downvote the answer: 'downvote' link replaced with 'unvote', 'upvote' is disabled", js: true do
      within '.answers' do
        downvote_link.click
        sleep(2)
        expect(downvote_link).to_not be_visible
        expect(unvote_link).to be_visible
        expect(page).to_not have_link(class: 'upvote')
      end
    end
  end

  describe "The author of answer" do
    scenario 'have no voting links', js: true do
      click_on('Log out')
      sign_in(answer.author)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_css('a.upvote')
        expect(page).to_not have_css('a.downvote')
        expect(page).to_not have_css('a.unvote')
      end
    end
  end

  describe "Non authenticated user" do
    scenario 'have no voting links', js: true do
      click_on('Log out')
      visit question_path(question)

      within('.answers') { upvote_link.click }
      expect(page).to have_content('You need to sign in or sign up before continuing.')

      within('.answers') { downvote_link.click }
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
