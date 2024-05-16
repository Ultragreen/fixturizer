# frozen_string_literal: true

module Fixturizer
    module Getters
      class Template
        attr_reader :filename, :data
  
        def initialize(filename:, options: nil)
          @filename = filename
          @options = options
        end
  
        def retrieve
          raise "Abstract template, don't use"
        end
  
        def read_file(file)
            return File.readlines(file).join
        rescue Errno::EACCES
          puts "Error: Permission denied to read the file #{file}."
        rescue StandardError => e
          puts "Error: #{e.message}"
        end
      end
    end
  end

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |file| require file unless File.basename(file) == 'init.rb' }
