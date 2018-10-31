require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds files when asks the question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add file'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Publish'

    within('.questions') { page.has_selector?('a') }

    visit question_path(Question.last)

    expect(page).to have_link 'spec_helper.rb', href: /\/uploads\/attachment\/file\/\d+\/spec_helper.rb/
    expect(page).to have_link 'rails_helper.rb', href: /\/uploads\/attachment\/file\/\d+\/rails_helper.rb/
  end


  scenario 'User can remove file field when adds files to question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    expect(page).to have_selector('.nested-fields', count: 2)

    within all('.nested-fields').last do
      click_on 'remove file'
    end

    expect(page).to have_selector('.nested-fields', count: 1)
  end


  scenario 'User adds files when edits his question', js: true do
    question
    visit questions_path

    within '.questions' do
      click_on 'Edit'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'add file'
      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Publish'
    end
    sleep(2)

    visit question_path(question)
    sleep(2)
    expect(page).to have_link "rails_helper.rb", href: /\/uploads\/attachment\/file\/\d+\/rails_helper.rb/
    expect(page).to have_link "spec_helper.rb", href: /\/uploads\/attachment\/file\/\d+\/spec_helper.rb/
  end
end
