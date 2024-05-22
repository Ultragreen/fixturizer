# frozen_string_literal: true

namespace :fixturizer do
    namespace :configuration do
      desc 'Check the configuration file'
      task :lint do
        filename = (ENV['FIXTURIZER_CONFIGURATION_FILE'].is_a? String)? 
            ENV['FIXTURIZER_CONFIGURATION_FILE'] : 
            Fixturizer::Services.settings.configuration_filename
        Fixturizer::Services.get.linter(filename: filename).display
      end
  
      
    end
  end