module Fixturizer
    class Services
        include Singleton
        @@settings = Fixturizer::Settings::new
        def self.settings
            @@settings
        end 

        def self.configure
            yield(@@settings)
        end

        attr_reader :configuration, :log

        def initialize
            @configuration = Fixturizer::Configuration::new filename: @@settings.configuration_filename
            @log = Logger::new(Fixturizer::Services.settings.log_target)
            #@log = Logger::new(STDOUT)

        end

        def engine(name: , parameters: nil)
            engine = "Fixturizer::Engines::#{name.to_s.capitalize}"
            log.info "running Service : #{engine}"
            if parameters.nil? then
                return Object.const_get(engine)::new
            else
                log.info "  => params : #{parameters}"
                return Object.const_get(engine)::new **parameters
            end
        end


        class << self
            alias get instance
            alias init instance
        end

    end

end
