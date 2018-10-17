require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds files when answers the question', js: true do
    fill_in 'Your answer', with: 'My Answer'

    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Publish'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end


  scenario 'User can remove file field when adds files to answer', js: true do
    fill_in 'Your answer', with: 'My Answer'

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


  scenario 'User adds files when edits the answer', js: true do
    answer
    page.refresh

    within '.answers' do
      click_on 'Edit'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'add file'
      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Publish'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
