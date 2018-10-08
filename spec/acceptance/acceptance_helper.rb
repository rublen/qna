require 'rails_helper'

RSpec.configure do |config|
  # setting different from Selenium js-driver
  Capybara.javascript_driver = :webkit

  # spec/support/acceptance_helper.rb
  config.include AcceptanceHelper, type: :feature

  #turn off transactional fixtures to be able to use other strategies for cleaning test DB
  config.use_transactional_fixtures = false

  # DatabaseCleaner settings
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
