module Fixturizer
  module Serializers
    class Template
      attr_reader :data

      def initialize(data:, options: nil)
        @data = data
        @options = options
      end

      def apply
        raise "Abstract template, don't use"
      end

      def write_file(file, data)
        File.write(file, data)
      rescue Errno::EACCES => e
        puts "Error: Permission denied to write the file #{file}."
      rescue Errno::ENOSPC => e
        puts 'Error: No space left on the device.'
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |file| require file unless File.basename(file) == 'init.rb' }
