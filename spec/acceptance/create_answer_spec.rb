require_relative 'acceptance_helper'

feature 'Create Answer', %q{
  In order to answer the current question
  As an authenticated user
  I want to be able to write my answer on the current question's page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario "Authenticated user can write the answer on the question's page", js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: "answer_body"
    click_on 'Publish'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content "answer_body"
    end
  end

  scenario "Authenticated user can't save the empty answer", js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Publish'

    expect(page).to have_content "Body can't be blank"
  end

  scenario "Non-authenticated user can't write the answer" do
    visit question_path(question)
    fill_in 'Your answer', with: 'answer_body'
    click_on 'Publish'

    expect(current_path).to eq user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'

    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content "answer_body"
    end
  end


  context "Multiple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other_user') do
        sign_in(create(:user))
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer-form' do
          fill_in 'Your answer', with: "answer_body"
          click_on 'add file'
          attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
          click_on 'Publish'
        end
        within('.answers') do
          expect(page).to have_content "answer_body"
          expect(page).to have_link 'spec_helper.rb', href: /\/uploads\/attachment\/file\/\d+\/spec_helper.rb/
        end
      end

      answer = Answer.last

      Capybara.using_session('other_user') do
        within '.answers' do
          expect(page).to have_content "answer_body"
          expect(page).to_not have_link 'Edit'
          expect(page).to_not have_link "Delete", href: "/answers/#{answer.id}"

          expect(page).to have_link 'spec_helper.rb', href: /\/uploads\/attachment\/file\/\d+\/spec_helper.rb/
          expect(page).to_not have_link "Delete", href: "/attachments/#{Attachment.last.id}"

          within '.comments' do
            click_on 'Add comment'
            expect(page).to have_selector 'textarea'
            expect(page).to have_button 'Cancel'
          end
          within '.voting' do
            expect(page).to have_link href: "/answers/#{answer.id}/votes/up"
            expect(page).to have_link href: "/answers/#{answer.id}/votes/down"
            expect(page).to have_content "#{answer.vote_sum}"

            expect { click_link(href: "/answers/#{answer.id}/votes/up") }.to change(answer, :vote_sum).by(1)
            expect(page).to have_content '1'
            expect(page).to have_link href: "/votes/#{answer.votes.last.id}/unvote"
            expect(page).to_not have_link href: "/answers/#{answer.id}/votes/up"
            expect(page).to_not have_link href: "/answers/#{answer.id}/votes/down"

            click_link(href: "/votes/#{answer.votes.last.id}/unvote")
            expect(answer.vote_sum).to eq 0
            expect(page).to have_content '0'

            expect { click_link(href: "/answers/#{answer.id}/votes/down") }.to change(answer, :vote_sum).by(-1)
            expect(page).to have_content '-1'
            expect(page).to have_link href: "/votes/#{answer.votes.last.id}/unvote"
            expect(page).to_not have_link href: "/answers/#{answer.id}/votes/up"
            expect(page).to_not have_link href: "/answers/#{answer.id}/votes/down"
          end
        end
      end
    end

    scenario "answer appears on guest's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer-form' do
          fill_in 'Your answer', with: "answer_body"
          click_on 'Publish'
        end
        within('.answers') { expect(page).to have_content "answer_body" }
      end

      answer = Answer.last

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content "answer_body"
          expect(page).to_not have_link 'Edit'
          expect(page).to_not have_link "Delete", href: "/answers/#{answer.id}"

          expect(page).to have_link 'spec_helper.rb', href: /\/uploads\/attachment\/file\/\d+\/spec_helper.rb/
          expect(page).to_not have_link "Delete", href: "/attachments/#{Attachment.last.id}"

          click_on 'Add comment'
        end
        expect(page).to have_content "You need to sign in or sign up before continuing."
        within '.answers' do
          expect(page).to have_link href="/answers/#{answer.id}/votes/up" # не видит
          expect(page).to have_link href="/answers/#{answer.id}/votes/down"
          expect(page).to have_content "#{answer.vote_sum}"
        end
      end
    end
  end
end
