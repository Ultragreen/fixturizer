module Fixturizer
  module Engines
    class Record
      def initialize(value:, rule:)
        # @configuration = Fixturizer::Configuration::new filename: './config/rules.yml'
        @configuration = Fixturizer::Services.get.configuration
        @rules = @configuration.rules
        @record = value
        @rule = rule.is_a?(Symbol) ? @rules[rule] : rule
      end

      def apply
        result = @record
        return result if @rule.nil?

        result = eval("lambda { #{@rule[:proc]} } ").call unless @rule.dig(:preserve) == true and !@record.nil?
        result
      end
    end
  end
end
