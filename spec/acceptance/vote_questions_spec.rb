require_relative 'acceptance_helper'

feature 'Vote for the question', %q{
  In order to illustrate usefullness of question
  As an authenticated user
  I'd like to be able to vote
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  # given(:vote) { create(:vote, user: user)}

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'authenticated user can upvote for the question', js: true do
#       p find_all("a[href='/questions/#{question.id}/votes/up']")
p user, question, question.vote_sum, question.votes, '-----------'
      find("a[href='/questions/#{question.id}/votes/up']").click
      sleep(20)

      # save_and_open_page
      # question.reload
      p question.votes, question.vote_sum

      within(".vote-sum") { expect(page).to have_content 1 }
  end

  scenario 'authenticated user can downvote for the question', js: true do
      find("a[href='/questions/#{question.id}/votes/down']").click
      wait_a_little_bit
      within(".vote-sum") { expect(page).to have_content -1 }
  end

  scenario 'authenticated user can get back his vote (unvote for the question)', js: true do
      vote
      wait_a_little_bit
      find("a[href='/votes/#{vote.id}/unvote']").click
      within(".vote-sum") { expect(page).to have_content 0 }

      find("a[href='/questions/#{question.id}/votes/down']").click
      within(".vote-sum") { expect(page).to have_content -1 }
  end
end
