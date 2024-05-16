module Fixturizer
    class Settings
        attr_accessor :configuration_filename, :log_target
        def initialize
            @configuration_filename = './config/rules.yml'
            @log_target = '/tmp/fixturizer.log'
        end
    end
end