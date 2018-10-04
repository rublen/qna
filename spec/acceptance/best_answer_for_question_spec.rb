require_relative 'acceptance_helper'

feature 'The best answer for question', %q{
  In order to rate answers for current question
  As an author of question
  I want to be able to choose the best answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }

  given(:question) { create(:question, author: author) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  context "The author of question can choose the best answer" do
    given(:id_1) { answers[0].id }
    given(:id_2) { answers[1].id }
    given(:answer_1) { answers[0].body }
    given(:answer_2) { answers[1].body }

    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario "Author can choose the best answer", js: true do
      within ".answers" do
        expect(page).to have_link('Mark as the best')
        expect(page.all('.best-answer').size).to eq question.answers.count # внутри '.best-answer' ссылка 'Mark as the best'

        within("#answer-body-#{id_1}") { click_on 'Mark as the best' } # аналогично
        expect(current_path).to eq question_path(question)
      end
    end


    scenario "The best answer becomes first in the list", js: true do
      within ".answers" do
        expect(page).to have_content("#{answer_1}Mark as the best\n#{answer_2}Mark as the best")

        within("#answer-body-#{id_2}") { click_on 'Mark as the best' }
        expect(page).to have_content("#{answer_2}Mark as the best\n#{answer_1}Mark as the best")
      end
    end


    scenario "After reloading page the best answer is still first in the list :)", js: true do
      within ".answers" do
        expect(page).to have_content("#{answer_1}Mark as the best\n#{answer_2}Mark as the best")

        within("#answer-body-#{id_2}") { click_on 'Mark as the best' }
        expect(page).to have_content("#{answer_2}Mark as the best\n#{answer_1}Mark as the best")

        page.refresh
        expect(page).to have_content("#{answer_2}Mark as the best\n#{answer_1}Mark as the best")
      end
    end


    scenario "Author can change his mind and choose another best answer", js: true do
      within ".answers" do
        within("#answer-body-#{id_2}") { click_on 'Mark as the best' }
        expect(page).to have_content("#{answer_2}Mark as the best\n#{answer_1}Mark as the best")

        within("#answer-body-#{id_1}") { click_on 'Mark as the best' }
        expect(page).to have_content("#{answer_1}Mark as the best\n#{answer_2}Mark as the best")
      end
    end
  end


  scenario "Not author can't choose the best answer", js: true do
    sign_in(other_user)
    visit question_path(question)
    within('.answers') { expect(page).to_not have_content 'Mark as the best' }
  end
end
