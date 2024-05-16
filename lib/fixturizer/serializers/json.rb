# frozen_string_literal: true

module Fixturizer
  module Serializers
    class Json < Template
      def apply
        result = if @options[:raw]
                   @data.to_json
                 else
                   JSON.pretty_generate(@data).concat("\n")
                 end
        return result unless @options[:to_file].is_a?(String)

        write_file(@options[:to_file], result)
      end
    end
  end
end
