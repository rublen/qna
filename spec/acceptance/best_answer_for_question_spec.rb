require_relative 'acceptance_helper'

feature 'The best answer for question', %q{
  In order to rate answers for current question
  As an author of question
  I want to be able to choose the best answer
} do

  given!(:author) { create(:user) }
  given(:other_user) { create(:user) }

  given(:question) { create(:question, author: author) }
  given!(:answer1) { create(:answer, question: question, best: true) }
  given!(:answer2) { create(:answer, question: question) }

  context "The author of question can choose the best answer" do
    given(:answer_1) { answer1.body }
    given(:answer_2) { answer2.body }

    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario "There are so many links 'Mark as the best' as answers minus 1, link doesn't redirect to another page", js: true do
      within ".answers" do
        expect(page.all('a', text: 'Mark as the best').size).to eq(question.answers.count - 1)
        click_on 'Mark as the best'
        expect(current_path).to eq question_path(question)
      end
    end


    scenario "The best answer becomes first in the list", js: true do
      within ".answers" do
        within(all(".row").first) { expect(page).to have_content("#{answer_1}") }
        click_on "Mark as the best"
        sleep(1)
        within(all(".row").first) { expect(page).to have_content("#{answer_2}") }
      end
    end


    scenario "After reloading page the best answer is still first in the list", js: true do
      within ".answers" do
        click_on "Mark as the best"
        sleep(1)
        within(all(".row").first) { expect(page).to have_content("#{answer_2}") }
        page.refresh
        sleep(1)
        within(all(".row").first) { expect(page).to have_content("#{answer_2}") }
      end
    end


    scenario "Author can change his mind and choose another best answer", js: true do
      within ".answers" do
        within(all(".row").first) { expect(page).to have_content("#{answer_1}") }

        click_on 'Mark as the best'
        sleep(1)
        within(all(".row").first) { expect(page).to have_content("#{answer_2}") }

        click_on 'Mark as the best'
        sleep(1)
        within(all(".row").first) { expect(page).to have_content("#{answer_1}") }
      end
    end
  end


  scenario "Not author can't choose the best answer" do
    sign_in(other_user)
    visit question_path(question)
    within('.answers') { expect(page).to_not have_content 'Mark as the best' }
  end
end
