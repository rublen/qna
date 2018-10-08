require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistakes
  As an author
  I want to be able to edit my question
} do

  given(:author) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, author: author }

  scenario "Non authenticated user can't edit the question" do
    visit questions_path

    within '.questions' do
      expect(page).to_not have_link('Edit')
    end
  end

  describe 'The author tries to edit his question' do
    before do
      sign_in author
      visit questions_path
    end

    scenario 'Updating the question with valid attributes', js: true do
      within '.questions' do
        expect(page).to have_content(question.title)

        click_on 'Edit'
        fill_in 'Title', with: 'edited q-title'
        fill_in 'Body', with: 'edited q-body'
        click_on 'Publish'

        expect(current_path).to eq questions_path
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content('edited q-title')
        expect(page).to_not have_content(question.title)
      end
    end

    scenario 'Updating the question with invalid attributes', js: true do
      within '.questions' do
        expect(page).to have_content(question.title)

        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Publish'

        expect(current_path).to eq questions_path
        expect(page).to have_selector 'textarea'
        expect(page).to have_content(question.title)
        expect(page).to have_content("Title can't be blank", "Body can't be blank")
      end
    end
  end

  describe 'Not author can not edit the question' do
    before do
      sign_in(other_user)
      visit questions_path
    end

    scenario 'Not author have no Edit link for answer' do
      within '.questions' do
        expect(page).to_not have_link('Edit')
      end
    end
  end
end
