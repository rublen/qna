require_relative 'acceptance_helper'

feature 'Comment for the question', %q{
  In order to react for the question
  As an authenticated user
  I'd like to be able to write the comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe "Authenticated user can:" do
    scenario 'comment the question', js: true do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Your comment',  with: "comment question"
        click_on 'Add comment'
        expect(page).to have_content "comment question"
      end
    end

    scenario "cancel from the form", js: true do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Your comment',  with: "comment question"
        click_on 'Cancel'
        expect(page).to_not have_selector "textarea"
        expect(page).to_not have_link "Cancel"
        expect(page).to_not have_content "comment question"
      end
    end

    scenario 'author can delete his comment', js: true do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Your comment',  with: "comment question"
        click_on 'Add comment'

        expect(page).to have_content "comment question"
        expect(page).to have_link 'Delete', href: comment_path(Comment.last.id)

        click_on 'Delete'
        expect(page).to_not have_content "comment question"
      end
    end


    describe "Non authenticated user:" do
      given(:comment) { create(:question_comment, user: user) }

      before do
        click_on 'Log out'
        visit question_path(question)
      end

      scenario 'can not comment the question', js: true do
        within('.question') { click_on 'Add comment' }
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end

      scenario 'can not delete the comment', js: true do
        expect(page).to_not have_link 'Delete', href: comment_path(comment.id)
      end
    end
  end


  context "Multiple sessions" do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          click_on 'Add comment'
          fill_in 'Your comment',  with: "comment question"
          click_on 'Add comment'

          expect(page).to have_content 'comment question'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'comment question'
      end
    end
  end
end
