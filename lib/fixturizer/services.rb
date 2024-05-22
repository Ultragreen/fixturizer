# frozen_string_literal: true

module Fixturizer
  class Services
    include Singleton
    @@settings = Fixturizer::Settings.new
    def self.settings
      @@settings
    end

    def self.configure
      yield(@@settings)
    end

    attr_reader :configuration, :log

    def initialize
      linter(filename: @@settings.configuration_filename).validate! unless detect_rake_lint
      @configuration = Fixturizer::Configuration.new filename: @@settings.configuration_filename
      @log = Logger.new(Fixturizer::Services.settings.log_target)
      log.info 'Starting new Fixturing'
    end

    def service(type:, name:, parameters: nil)
      service = "Fixturizer::#{type.to_s.capitalize}::#{name.to_s.capitalize}"
      log.info "running Service : #{service}"
      if parameters.nil?
        Object.const_get(service).new
      else
        log.info "  => params : #{parameters}"
        Object.const_get(service).new(**parameters)
      end
    end

    def engine(name:, parameters: nil)
      service(type: :engines, name:, parameters:)
    end

    def getter(name:, parameters: nil)
        service(type: :getters, name:, parameters:)
      end

    def serializer(name:, parameters: nil)
      service(type: :serializers, name:, parameters:)
    end

    def linter(filename: @@settings.configuration_filename)
      Fixturizer::ConfigurationLinter.new filename: filename
    end

    class << self
      alias get instance
      alias init instance
    end

    private 
    
    def detect_rake_lint
      res = false
      if defined?(Rake)
        res = true if Rake.application.top_level_tasks.first == "fixturizer:configuration:lint"
      end
      return res 
    end

  end
end
