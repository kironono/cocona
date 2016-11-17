ENV['RAILS_ENV'] ||= 'test'


require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'minitest/pride'


# Coverage
require "simplecov"
if ENV['CIRCLE_ARTIFACTS']
  coverage_dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
else
  coverage_dir = Rails.root.join("etc", "coverage")
end
SimpleCov.coverage_dir(coverage_dir)
SimpleCov.start 'rails'


# Capybara screenshot
require 'capybara-screenshot/minitest'
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.webkit_options = {
  width: 1280,
  height: 1024
}
if ENV['CIRCLE_ARTIFACTS']
  Capybara.save_path = File.join(ENV['CIRCLE_ARTIFACTS'], "capybara")
else
  Capybara.save_path = Rails.root.join("etc", "capybara")
end


# Capybara
Capybara.javascript_driver = :webkit


DatabaseCleaner.strategy = :transaction


class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Warden::Test::Helpers

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


class Capybara::Rails::TestCase

  self.use_transactional_tests = false

  # Configure the driver using metadata
  before do
    @headless = nil
    @headless = Headless.new(reuse: true, destroy_at_exit: true) unless ENV["CI"].present?

    if metadata[:js] == true
      Capybara.current_driver = Capybara.javascript_driver

      @headless.start unless @headless.nil?

      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    # resque
    Resque.queues.each do |queue|
      Resque.remove_queue(queue)
    end
    Resque::Failure.clear

    DatabaseCleaner.start
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver

    # @headless.destroy unless @headless.nil?

    DatabaseCleaner.clean
  end

end
