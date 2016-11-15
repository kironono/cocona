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


DatabaseCleaner.strategy = :transaction


class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
