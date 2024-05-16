# frozen_string_literal: true

module Fixturizer
  class Settings
    attr_accessor :configuration_filename, :log_target, :verbose

    def initialize
      @configuration_filename = './config/rules.yml'
      @log_target = '/tmp/fixturizer.log'
      @verbose = false
    end
  end
end
