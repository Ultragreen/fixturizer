# frozen_string_literal: true

module Fixturizer
  module Engines
    class Dataset
      attr_reader :name, :dataset

      def initialize(dataset:)
        @name = dataset
        @configuration = Fixturizer::Services.get.configuration
        @dataset = dataset.is_a?(Symbol) ? @configuration.datasets[@name] : dataset
        @effectives_rules = @dataset[:rules]
      end

      def generate
        data = @dataset[:definition]
        substitute_values(data)
      end

      private

      def apply_rule(key, value, rule)
        if @effectives_rules.key? key
          value = Fixturizer::Services.get.engine(name: :record, parameters: { value:, rule: }).apply
        end
        value
      end

      def substitute_values(obj)
        return obj.map { |v| substitute_values(v) } if obj.is_a? Array
        return obj unless obj.is_a? Hash

        obj.each_with_object({}) do |(key, value), result|
          result[key] = case value
                        when Hash
                          substitute_values(value)
                        when Array
                          value.map { |v| substitute_values(v) }
                        else
                          @effectives_rules.nil? ? value : apply_rule(key, value, @effectives_rules[key])
                        end
        end
      end
    end
  end
end
