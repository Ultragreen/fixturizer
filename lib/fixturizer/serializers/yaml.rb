# frozen_string_literal: true

module Fixturizer
  module Serializers
    class Yaml < Template
      def apply
        result = @data.to_yaml

        return result unless @options[:to_file].is_a?(String)

        write_file(@options[:to_file], result)
      end
    end
  end
end
