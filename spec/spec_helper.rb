ENV['RAILS_ENV'] ||= 'test'

require_relative '../spec/dummy/config/environment'

require 'rspec/rails'
require 'factory_bot'

FactoryBot.find_definitions
ActiveJob::Base.queue_adapter = :test

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
