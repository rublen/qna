require_relative 'acceptance_helper'

feature 'Search with ThinkingSphinx', %q{
  In order to filter data
  As an ordinary user
  I want to be able to search through search bar
} do

  given!(:user) { create :user, email: 'xxx@mail.com' }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, body: 'xxx a_body' }
  given!(:comment) { create :question_comment, body: 'xxx c_body' }
  given!(:answer_comment) { create :answer_comment, author: user }

  given(:full_search_results) { [question, answer, comment, answer_comment, user] }
  given!(:other_question) { create :question }

  background { index }

  scenario "Search form on the questions page leads to the search page and empty request givs 'Nothing to show'", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path
      expect(page).to have_field(id:'search', type: 'text')
      click_on 'Search'
      expect(current_path).to eq search_path
      expect(page).to have_content "Nothing to show"
    end
  end

  scenario 'Nothing has found', js: true do
    ThinkingSphinx::Test.run do
      visit search_path
      fill_in 'search', with: 'unexist'
      click_on 'Search'
      expect(page).to have_content "Nothing to show"
    end
  end

  scenario 'Full search', js: true do
    ThinkingSphinx::Test.run do
      visit search_path
      fill_in 'search', with: 'xxx'
      click_on 'Search'

      full_search_results.each { |obj| expect(page).to have_content obj.inspect }

      expect(page).to have_link question.title
      expect(page).to have_link answer.question.title
      expect(page).to have_link comment.commentable.title
      expect(page).to have_link answer_comment.commentable.question.title

      expect(page).to_not have_content other_question.inspect
      expect(page).to_not have_link other_question.title
    end
  end

  scenario('Search only in questions', js: true) { search_in 'question' }

  scenario('Search only in answers', js: true) { search_in 'answer' }

  scenario('Search only in comments', js: true) { search_in 'comment' }

  scenario('Search only in user', js: true) { search_in 'user' }

  def search_in(model)
    ThinkingSphinx::Test.run do
      visit search_path
      choose("search_options_" + model)
      fill_in 'search', with: 'xxx'
      click_on 'Search'
      expect(page).to have_content instance_eval(model).inspect
    end
  end
end
