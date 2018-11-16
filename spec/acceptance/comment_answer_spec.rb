require_relative 'acceptance_helper'

feature 'Comment for the answer', %q{
  In order to react for the answer
  As an authenticated user
  I'd like to be able to write the comment
} do

  given(:user) { create(:user) }
  given (:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe "Authenticated user can:" do
    scenario 'comment the answer', js: true do
      within '.answers' do
        click_on 'Add comment'
        fill_in 'Your comment',  with: "comment answer"
        click_on 'Add comment'
        expect(page).to have_content "comment answer"
      end
    end

    scenario "cancel from the form", js: true do
      within '.answers' do
        click_on 'Add comment'
        fill_in 'Your comment',  with: "comment answer"
        click_on 'Cancel'
        expect(page).to_not have_selector "textarea"
        expect(page).to_not have_link "Cancel"
        expect(page).to_not have_content "comment answer"
      end
    end

    scenario 'author can delete his comment', js: true do
      within '.answers' do
        click_on 'Add comment'
        fill_in 'Your comment',  with: "comment answer"
        click_on 'Add comment'

        expect(page).to have_content "comment answer"
        expect(page).to have_link 'Delete', href: comment_path(Comment.last.id)

        click_on 'Delete'
        expect(page).to_not have_content "comment answer"
      end
    end


    describe "Non authenticated user:" do
      given(:comment) { create(:answer_comment, user: user) }

      before do
        click_on 'Log out'
        visit question_path(question)
      end

      scenario 'can not comment the answer', js: true do
        within('.answers') { click_on 'Add comment' }
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end

      scenario 'can not delete the comment', js: true do
        expect(page).to_not have_link 'Delete', href: comment_path(comment.id)
      end
    end
  end
end
