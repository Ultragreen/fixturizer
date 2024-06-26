# frozen_string_literal: true

require 'bundler/setup'
require 'fixturizer/rspec/prepare'

Fixturizer::Services.configure do |settings|
  settings.configuration_filename = './config/rules.yml'
  settings.log_target = '/tmp/fixturizer.log'
end

require_relative '../app'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
