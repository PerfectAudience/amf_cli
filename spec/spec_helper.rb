# frozen_string_literal: true

# This needs to be set before requires, or we'll use the production DB for tests!
ENV["RACK_ENV"] = "test"

require "bundler/setup"
require "amf"
require "mongoid-rspec"
require "factory_bot"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Mongoid::Matchers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # Suppresses any console messages during test runs
  config.before { allow($stdout).to receive(:puts) }

  # Clean the test DB after all tests run
  config.after(:suite) do
    Mongoid.purge!
  end
end
