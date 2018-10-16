require 'rails_helper'
# require "selenium/webdriver"

# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end

# Capybara.register_driver :headless_chrome do |app|
#   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: { args: %w[headless disable-gpu] })
#   Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
# end

# Capybara.javascript_driver = :selenium_chrome_headless

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
